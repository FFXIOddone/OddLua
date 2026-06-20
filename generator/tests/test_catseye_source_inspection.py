from pathlib import Path
import subprocess
import sys


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.sources.catseye_git import inspect_git_checkout
from oddlua.sources.catseye_launcher import inspect_launcher


def test_inspect_launcher_reads_latest_active_build_tag_and_state_hash(tmp_path: Path) -> None:
    launcher = tmp_path / "CatsEyeXI"
    builds = launcher / "builds"
    builds.mkdir(parents=True)
    (launcher / "cexi.log").write_text(
        "Active build tag: stable\nOther line\nActive build tag: main\n",
        encoding="utf-8",
    )
    state = builds / "state_main_game.txt"
    state.write_text("file-a|hash-a\nfile-b|hash-b\n", encoding="utf-8")

    provenance = inspect_launcher(launcher)

    assert provenance.active_build_tag == "main"
    assert provenance.game_state_path == str(state)
    assert len(provenance.game_state_sha256) == 64


def test_inspect_git_checkout_uses_local_git_without_fetch(monkeypatch, tmp_path: Path) -> None:
    calls: list[tuple[str, ...]] = []

    def fake_run(argv, *, cwd, capture_output, text, check):
        calls.append(tuple(argv))
        command = tuple(argv[1:])
        stdout_by_command = {
            ("rev-parse", "--show-toplevel"): str(tmp_path),
            ("rev-parse", "--abbrev-ref", "HEAD"): "catseye-production",
            ("rev-parse", "HEAD"): "abc123",
            ("config", "--get", "remote.catseye.url"): "https://github.com/CatsAndBoats/catseyexi.git",
            ("rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}"): "catseye/base",
            ("status", "--porcelain"): "",
        }
        return subprocess.CompletedProcess(argv, 0, stdout=stdout_by_command[command] + "\n", stderr="")

    monkeypatch.setattr("oddlua.sources.catseye_git.subprocess.run", fake_run)

    provenance = inspect_git_checkout(tmp_path, remote_name="catseye")

    assert provenance.repo_path == str(tmp_path)
    assert provenance.remote_name == "catseye"
    assert provenance.branch == "catseye-production"
    assert provenance.upstream_ref == "catseye/base"
    assert provenance.commit_sha == "abc123"
    assert provenance.dirty is False
    assert not any("fetch" in call for call in calls)
