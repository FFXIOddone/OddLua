# PLD Contract

Default playstyle: `Tank`.

The PLD pack is built from the current Catseye gear export and the character snapshot's PLD level. For Aahtacos, the available snapshot resolves PLD to level 75. Gear scoring is sourced from `OddLua/data/oddlua_stats.sqlite`, including item modifiers, weapon damage/delay, and optional mobdb target resist data.

PLD playstyles:

- `Tank`: shield tank set for engaged combat. Prioritizes shield, defense, HP, VIT, enmity, and damage-taken stats.
- `Enmity`: hate spike set for actions like Provoke, Flash, Sentinel, and Cover. Prioritizes ENMITY, HP, shield safety, and fast-cast style support.
- `Damage`: lower-risk melee set. Allows sword or club in main hand so mobdb physical SDT can favor impact damage where appropriate.
- `MagicDefense`: magic-heavy target set. Prioritizes MDEF, magic damage taken, HP, elemental magic evasion, and durable armor.

Weapon constraints:

- `Sub` is constrained to shield for all PLD styles.
- `Damage.Main` may choose sword or club from owned, eligible gear.
- Utility, fishing, crafting, wrong-job, wrong-level, and wrong-family items remain hard exclusions.
