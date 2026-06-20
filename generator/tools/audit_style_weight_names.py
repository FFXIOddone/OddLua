from __future__ import annotations

import argparse
import json
from collections.abc import Mapping
from pathlib import Path
import sys


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ODDLUA_ROOT / "src"))

from oddlua.builder import CONDITIONAL_STYLE_MOD_WEIGHTS, STYLE_MOD_WEIGHTS  # noqa: E402
from oddlua.catseye_wiki_stats import STAT_MOD_IDS  # noqa: E402
from oddlua.itemstats import MOD_NAMES, ROLE_MOD_NAMES  # noqa: E402
from oddlua.mechanics import PET_WEIGHT_ALIASES  # noqa: E402


# Names below are not direct item_mods constants. They are intentionally produced by
# Catseye wiki parsing, mechanics projection, or profile-only synthetic scoring.
SYNTHETIC_WEIGHT_NAMES = frozenset(
    {
        "BLOOD_BOON",
        "BLUE_MAGIC_SKILL",
        "BP_DAMAGE",
        "ITEM_ADDEFFECT_CHANCE",
        "ITEM_ADDEFFECT_DMG",
        "ITEM_ADDEFFECT_DURATION",
        "ITEM_ADDEFFECT_POWER",
        "MEDITATE_DURATION",
        "RATTP",
        "SHIELDBLOCKRATE",
        "STRING_INSTRUMENT",
        "SUMMONING_MAGIC",
        "THIRD_EYE_COUNTER_RATE",
        "UDMGPHYS",
        "WIND_INSTRUMENT",
        "WSDMG",
    }
)


def audit_style_weight_names(
    *,
    style_weights: Mapping[str, Mapping[str, int]] | None = None,
    conditional_style_weights: Mapping[str, Mapping[str, int]] | None = None,
) -> dict[str, object]:
    if style_weights is None:
        style_weights = STYLE_MOD_WEIGHTS
    if conditional_style_weights is None:
        conditional_style_weights = CONDITIONAL_STYLE_MOD_WEIGHTS
    known_names = _known_weight_names()
    unknown_by_name: dict[str, set[str]] = {}

    for style_name, weights in {**style_weights, **conditional_style_weights}.items():
        for weight_name in weights:
            if weight_name not in known_names:
                unknown_by_name.setdefault(weight_name, set()).add(style_name)

    failures = [
        {
            "weightName": weight_name,
            "styles": sorted(styles),
        }
        for weight_name, styles in sorted(unknown_by_name.items())
    ]
    return {
        "knownWeightNameCount": len(known_names),
        "unknownWeightNames": [failure["weightName"] for failure in failures],
        "failureCount": len(failures),
        "failures": failures,
    }


def _known_weight_names() -> set[str]:
    role_mod_names = {
        name
        for names in ROLE_MOD_NAMES.values()
        for name in names
    }
    return (
        set(MOD_NAMES.values())
        | set(STAT_MOD_IDS)
        | role_mod_names
        | set(PET_WEIGHT_ALIASES)
        | set(PET_WEIGHT_ALIASES.values())
        | set(SYNTHETIC_WEIGHT_NAMES)
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Audit style scoring weight names against server/Catseye sources.")
    parser.add_argument("--json", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    report = audit_style_weight_names()
    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(
            "Style weight-name audit: "
            f"known={report['knownWeightNameCount']} "
            f"failures={report['failureCount']}"
        )
        for failure in report["failures"]:
            print(f"  {failure['weightName']}: {', '.join(failure['styles'])}")
    return 1 if int(report["failureCount"]) else 0


if __name__ == "__main__":
    raise SystemExit(main())
