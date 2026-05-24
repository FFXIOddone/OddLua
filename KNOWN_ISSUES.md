# Known Issues

This release is melee-first.

Current confidence:

- Melee jobs and melee-style sets are the most reliable output from the current pipeline.
- THF, SAM, WAR, MNK, NIN, DNC, DRK, and other physical styles are the best candidates for live use.
- PLD melee/tank output is useful, but still needs more live tank-action tuning.

Still needs live tuning:

- Caster jobs can produce reasonable nuke, magic accuracy, fast cast, and idle sets, but spell-specific behavior is not finished.
- Pet jobs generate master and pet-oriented styles, but pet action timing and job-specific swaps are not fully proven live.
- BRD, COR, GEO, SMN, SCH, WHM, BLM, and BLU should be treated as generated starter profiles until manually tested.
- Ranged and ammunition behavior should be checked live before relying on it for expensive ammo or ranged weapon swaps.

Generator limitations:

- The calculator uses owned gear plus server stats, not a full combat simulator.
- Action-specific swaps are still broad style sets, not complete per-spell or per-ability systems.
- Target-aware scoring currently helps physical weapon-family choices when mobdb data is available, but it does not fully model every job's damage formula.
- Food data is imported into the stats database, but food selection is not yet a complete per-job recommendation engine.

Deployment notes:

- These profiles were generated from current Aahtacos and Oddone snapshots.
- Regenerate from your own Catseye gearexport snapshots before using this for different characters.
- Always back up existing LuAshitacast profiles before applying generated profiles.
