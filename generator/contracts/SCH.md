# SCH Contract

Default playstyle: `Nuke`.

The SCH pack is built from the current Catseye gear export and the character snapshot's SCH level. Aahtacos' current snapshot reports SCH as level 0, so Aahtacos SCH is intentionally not generated. Oddone's current snapshot resolves to `SCH75/WHM37`, so OddLua emits the generated Oddone SCH pack under `OddLua/dist/packs/Oddone_29938/SCH/`.

SCH playstyles:

- `Nuke`: elemental damage set. Prioritizes magic attack, magic damage, INT, and enough magic accuracy to land.
- `MagicAccuracy`: resist-sensitive casting set for hard targets, enfeebles, and dark/elemental accuracy needs.
- `FastCast`: spell-start and recast set. Prioritizes FASTCAST, UFASTCAST, QUICK_MAGIC, haste, and MP support.
- `IdleRefresh`: downtime sustain set. Prioritizes REFRESH, MP recovery, conserve MP, MP, and defensive damage-taken stats.

Weapon constraints:

- Current SCH styles favor staff main plus grip sub.
- The generator intentionally avoids staff-plus-shield combinations in this first slice.
- Utility, fishing, crafting, wrong-job, wrong-level, and wrong-family items remain hard exclusions.
