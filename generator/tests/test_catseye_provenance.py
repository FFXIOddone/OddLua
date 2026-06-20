from pathlib import Path
import sys


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.manifests.provenance import (
    CatseyeProvenance,
    GitSourceProvenance,
    LauncherSourceProvenance,
    metadata_entries_for_provenance,
    provenance_from_metadata,
)


def test_catseye_provenance_serializes_git_and_launcher_evidence() -> None:
    provenance = CatseyeProvenance(
        git=GitSourceProvenance(
            repo_path="C:/Users/jakeb/Projects/FFXI Personal Server/server",
            remote_name="catseye",
            remote_url="https://github.com/CatsAndBoats/catseyexi.git",
            branch="catseye-production",
            upstream_ref="catseye/base",
            commit_sha="abc123",
            dirty=False,
        ),
        launcher=LauncherSourceProvenance(
            launcher_root="C:/Games/CatsEyeXI",
            active_build_tag="main",
            game_state_path="C:/Games/CatsEyeXI/builds/state_main_game.txt",
            game_state_sha256="00" * 32,
        ),
    )

    manifest = provenance.to_manifest()

    assert manifest["git"]["remoteName"] == "catseye"
    assert manifest["git"]["upstreamRef"] == "catseye/base"
    assert manifest["launcher"]["activeBuildTag"] == "main"
    assert manifest["verified"] is False


def test_metadata_entries_round_trip_catseye_provenance() -> None:
    provenance = CatseyeProvenance(
        git=GitSourceProvenance(
            repo_path="repo",
            remote_name="catseye",
            remote_url="url",
            branch="catseye-production",
            upstream_ref="catseye/base",
            commit_sha="abc123",
            dirty=True,
        ),
        launcher=LauncherSourceProvenance(
            launcher_root="launcher",
            active_build_tag="main",
            game_state_path="state_main_game.txt",
            game_state_sha256="11" * 32,
        ),
        verified=True,
        verification_note="manual confirmation from launcher production build",
    )

    metadata = dict(metadata_entries_for_provenance(provenance))
    restored = provenance_from_metadata(metadata)

    assert restored.to_manifest() == provenance.to_manifest()
