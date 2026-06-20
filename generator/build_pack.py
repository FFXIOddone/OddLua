from __future__ import annotations

import argparse
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parent
DEFAULT_PLAYER = "Aahtacos"
DEFAULT_PLAYER_ID = "30102"
DEFAULT_JOB = "THF"
DEFAULT_GEAR_PATH = Path(
    r"C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport\Aahtacos_30102_gear.lua"
)
DEFAULT_CHARACTER_PATH = Path(
    r"C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport\Aahtacos_30102\Aahtacos_30102_character.json"
)
DEFAULT_OUTPUT_ROOT = ODDLUA_ROOT / "dist"

sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.app.build_pack import build_pack  # noqa: E402


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build an OddLua personalized Catseye LuAshitacast pack."
    )
    parser.add_argument("--player", default=DEFAULT_PLAYER)
    parser.add_argument("--player-id", default=DEFAULT_PLAYER_ID)
    parser.add_argument("--job", default=DEFAULT_JOB)
    parser.add_argument("--gear-path", default=DEFAULT_GEAR_PATH, type=Path)
    parser.add_argument("--character-path", default=DEFAULT_CHARACTER_PATH, type=Path)
    parser.add_argument("--output-root", default=DEFAULT_OUTPUT_ROOT, type=Path)
    parser.add_argument("--stats-db-path", default=None, type=Path)
    parser.add_argument("--target-name", default=None)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    result = build_pack(
        player=args.player,
        player_id=args.player_id,
        job=args.job.upper(),
        gear_path=args.gear_path,
        character_path=args.character_path,
        output_root=args.output_root,
        stats_db_path=args.stats_db_path,
        target_name=args.target_name,
    )
    print(f"Wrote {result.profile_path}")
    print(f"Wrote {result.manifest_path}")
    print(f"Wrote {result.keybindings_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
