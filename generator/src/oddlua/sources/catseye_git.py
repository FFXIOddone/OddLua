from __future__ import annotations

from pathlib import Path
import subprocess

from oddlua.manifests.provenance import GitSourceProvenance


def inspect_git_checkout(repo_root: Path | str, *, remote_name: str = "catseye") -> GitSourceProvenance:
    root = Path(repo_root)
    top_level = _git(root, "rev-parse", "--show-toplevel")
    branch = _git(root, "rev-parse", "--abbrev-ref", "HEAD")
    commit_sha = _git(root, "rev-parse", "HEAD")
    remote_url = _git(root, "config", "--get", f"remote.{remote_name}.url")
    upstream_ref = _git_optional(root, "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}")
    dirty = bool(_git_optional(root, "status", "--porcelain"))
    return GitSourceProvenance(
        repo_path=top_level,
        remote_name=remote_name,
        remote_url=remote_url,
        branch=branch,
        upstream_ref=upstream_ref,
        commit_sha=commit_sha,
        dirty=dirty,
    )


def _git(cwd: Path, *args: str) -> str:
    completed = subprocess.run(
        ["git", *args],
        cwd=cwd,
        capture_output=True,
        text=True,
        check=False,
    )
    if completed.returncode != 0:
        raise RuntimeError(completed.stderr.strip() or f"git {' '.join(args)} failed")
    return completed.stdout.strip()


def _git_optional(cwd: Path, *args: str) -> str:
    completed = subprocess.run(
        ["git", *args],
        cwd=cwd,
        capture_output=True,
        text=True,
        check=False,
    )
    return completed.stdout.strip() if completed.returncode == 0 else ""
