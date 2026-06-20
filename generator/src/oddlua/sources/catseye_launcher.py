from __future__ import annotations

import hashlib
from pathlib import Path
import re

from oddlua.manifests.provenance import LauncherSourceProvenance


_ACTIVE_BUILD_RE = re.compile(r"Active build tag:\s*(?P<tag>[A-Za-z0-9_.-]+)")


def inspect_launcher(launcher_root: Path | str) -> LauncherSourceProvenance:
    root = Path(launcher_root)
    build_tag = _latest_active_build_tag(root / "cexi.log")
    state_path = root / "builds" / f"state_{build_tag}_game.txt" if build_tag else None
    return LauncherSourceProvenance(
        launcher_root=str(root),
        active_build_tag=build_tag,
        game_state_path=str(state_path) if state_path is not None and state_path.exists() else "",
        game_state_sha256=_sha256(state_path) if state_path is not None and state_path.exists() else "",
    )


def _latest_active_build_tag(log_path: Path) -> str:
    if not log_path.exists():
        return ""
    matches = [
        match.group("tag")
        for match in _ACTIVE_BUILD_RE.finditer(log_path.read_text(encoding="utf-8", errors="replace"))
    ]
    return matches[-1] if matches else ""


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()
