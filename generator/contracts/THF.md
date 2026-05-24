# THF Contract

Default playstyle: `Melt`.

The first THF pack is calibrated for Aahtacos from the Catseye export snapshot dated `2026-05-24`. The live gear export says the character is currently on `SAM75/WAR37`, but OddLua uses the character snapshot's THF level for THF eligibility. For this slice, Aahtacos is treated as `THF58`. Gear stat roles and scores are sourced from `OddLua/data/oddlua_stats.sqlite` when that generated database is available. That database is built from server SQL plus food item scripts, including gear modifiers, weapon damage/delay, augments, merits, traits, weapon skills, usable item data, and food stat boosts. Exact item-name hints are only a fallback for environments without server stats.

Catseye THF facts used by this builder:

- THF has Dual Wield I at level 20.
- THF has Dual Wield II at level 40.
- THF has Assassin at level 50.
- THF has Bully at level 60, so Aahtacos at THF58 does not yet receive Bully assumptions.
- Viper Bite is available early enough to matter for dagger mode.
- Wasp Sting and Viper Bite have Catseye-specific increased damage.
- Treasure Hunter has Catseye-specific caps and proc behavior, but Treasure mode should not replace the kill-speed baseline when no useful TH gear is owned and eligible.

Aahtacos THF assumptions for this snapshot:

- `Melt` may choose the best eligible raw weapon pairing even if the main-hand weapon is a sword.
- `Dagger` must keep dagger-family weapons in main and sub when eligible.
- `Safe` prefers evasion and defensive pieces while remaining a combat set.
- `Treasure` falls back to `Melt` when no useful eligible Treasure Hunter gear exists.
- `Craft` is non-engaged only and is not a combat fallback.
- Combat sets are calculated from weighted server stats and weapon damage/delay; the previous named preference lists are not part of combat selection.
- `Gemini Subligar` is policy-excluded for this THF pack after live testing; the older broad name-token classifier overvalued it as DEX gear, while server `item_mods` only show `DEF` and `RACC`.

Known Task 3 anchor choices:

- `Melt.Main`: `Bloody Blade`
- `Melt.Sub`: `Corrosive Kukri`
- `Melt.Legs`: `Garrison Hose`
- `Dagger.Main`: `Corrosive Kukri`
- `Dagger.Sub`: `Acid Kukri`
- `Dagger.Legs`: `Garrison Hose`
- `Safe.Legs`: `Crow Hose`
- `Treasure.Legs`: `Garrison Hose`
