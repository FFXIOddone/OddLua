from __future__ import annotations

from dataclasses import dataclass
from typing import Mapping


_PREFIX = "catseye_provenance_"


@dataclass(frozen=True)
class GitSourceProvenance:
    repo_path: str
    remote_name: str
    remote_url: str
    branch: str
    upstream_ref: str
    commit_sha: str
    dirty: bool

    def to_manifest(self) -> dict[str, object]:
        return {
            "repoPath": self.repo_path,
            "remoteName": self.remote_name,
            "remoteUrl": self.remote_url,
            "branch": self.branch,
            "upstreamRef": self.upstream_ref,
            "commitSha": self.commit_sha,
            "dirty": self.dirty,
        }


@dataclass(frozen=True)
class LauncherSourceProvenance:
    launcher_root: str
    active_build_tag: str
    game_state_path: str
    game_state_sha256: str

    def to_manifest(self) -> dict[str, object]:
        return {
            "launcherRoot": self.launcher_root,
            "activeBuildTag": self.active_build_tag,
            "gameStatePath": self.game_state_path,
            "gameStateSha256": self.game_state_sha256,
        }


@dataclass(frozen=True)
class CatseyeProvenance:
    git: GitSourceProvenance | None = None
    launcher: LauncherSourceProvenance | None = None
    verified: bool = False
    verification_note: str = ""

    def to_manifest(self) -> dict[str, object]:
        return {
            "git": self.git.to_manifest() if self.git else None,
            "launcher": self.launcher.to_manifest() if self.launcher else None,
            "verified": self.verified,
            "verificationNote": self.verification_note,
        }


def metadata_entries_for_provenance(provenance: CatseyeProvenance) -> tuple[tuple[str, str], ...]:
    entries: list[tuple[str, str]] = [
        (_PREFIX + "verified", "1" if provenance.verified else "0"),
        (_PREFIX + "verification_note", provenance.verification_note),
    ]
    if provenance.git is not None:
        entries.extend(
            (
                (_PREFIX + "git_repo_path", provenance.git.repo_path),
                (_PREFIX + "git_remote_name", provenance.git.remote_name),
                (_PREFIX + "git_remote_url", provenance.git.remote_url),
                (_PREFIX + "git_branch", provenance.git.branch),
                (_PREFIX + "git_upstream_ref", provenance.git.upstream_ref),
                (_PREFIX + "git_commit_sha", provenance.git.commit_sha),
                (_PREFIX + "git_dirty", "1" if provenance.git.dirty else "0"),
            )
        )
    if provenance.launcher is not None:
        entries.extend(
            (
                (_PREFIX + "launcher_root", provenance.launcher.launcher_root),
                (_PREFIX + "launcher_active_build_tag", provenance.launcher.active_build_tag),
                (_PREFIX + "launcher_game_state_path", provenance.launcher.game_state_path),
                (_PREFIX + "launcher_game_state_sha256", provenance.launcher.game_state_sha256),
            )
        )
    return tuple(entries)


def provenance_from_metadata(metadata: Mapping[str, str]) -> CatseyeProvenance:
    git = None
    if metadata.get(_PREFIX + "git_repo_path"):
        git = GitSourceProvenance(
            repo_path=metadata.get(_PREFIX + "git_repo_path", ""),
            remote_name=metadata.get(_PREFIX + "git_remote_name", ""),
            remote_url=metadata.get(_PREFIX + "git_remote_url", ""),
            branch=metadata.get(_PREFIX + "git_branch", ""),
            upstream_ref=metadata.get(_PREFIX + "git_upstream_ref", ""),
            commit_sha=metadata.get(_PREFIX + "git_commit_sha", ""),
            dirty=metadata.get(_PREFIX + "git_dirty", "0") == "1",
        )

    launcher = None
    if metadata.get(_PREFIX + "launcher_root"):
        launcher = LauncherSourceProvenance(
            launcher_root=metadata.get(_PREFIX + "launcher_root", ""),
            active_build_tag=metadata.get(_PREFIX + "launcher_active_build_tag", ""),
            game_state_path=metadata.get(_PREFIX + "launcher_game_state_path", ""),
            game_state_sha256=metadata.get(_PREFIX + "launcher_game_state_sha256", ""),
        )

    return CatseyeProvenance(
        git=git,
        launcher=launcher,
        verified=metadata.get(_PREFIX + "verified", "0") == "1",
        verification_note=metadata.get(_PREFIX + "verification_note", ""),
    )
