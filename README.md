# OddLua

OddLua is a CatseyeXI-focused LuAshitacast profile generator and current profile release for the FFXIOddone characters.

This release is intentionally practical rather than final. The melee jobs and melee-style sets are the current reliable path. Several caster, pet, ranged, and support jobs are generated from the same owned-gear and server-stat pipeline, but they still need live tuning and should be treated as starting points rather than finished best-in-slot profiles.

## Release Contents

- `profiles/` - generated LuAshitacast profiles for the current Aahtacos and Oddone snapshots.
- `runtime/luashitacast/common/scale.lua` - shared resolver required by the generated profiles.
- `generator/` - OddLua generator source, job contracts, stats database builder, and apply script.

Generated profile coverage:

- `Aahtacos_30102`: `WAR`, `MNK`, `WHM`, `BLM`, `RDM`, `THF`, `PLD`, `SAM`, `NIN`
- `Oddone_29938`: `WAR`, `MNK`, `WHM`, `BLM`, `RDM`, `THF`, `DRK`, `BST`, `BRD`, `SAM`, `NIN`, `SMN`, `BLU`, `COR`, `PUP`, `DNC`, `SCH`, `GEO`

Jobs at level 0 in the current snapshots were not generated.

## Install Notes

Back up your LuAshitacast profiles before copying anything into a live Ashita install.

Copy `runtime/luashitacast/common/scale.lua` to:

```text
Ashita/config/addons/luashitacast/common/scale.lua
```

Copy the profile files you want from `profiles/<Character>_<Id>/<JOB>/<JOB>.lua` to one or both LuAshitacast load paths:

```text
Ashita/config/addons/luashitacast/<Character>_<Id>/<JOB>.lua
Ashita/config/addons/luashitacast/<Character>_<JOB>.lua
```

The generator also includes `generator/Apply-OddLuaAllJobs.ps1`, which backs up existing installed profiles and applies all positive-level jobs from local Catseye gearexport snapshots.

## Generator

From a local checkout with Catseye server SQL and item scripts available:

```powershell
powershell -ExecutionPolicy Bypass -File .\generator\Build-OddLuaStatsDb.ps1
powershell -ExecutionPolicy Bypass -File .\generator\Build-OddLuaPack.ps1 -Job THF
```

The builder scores owned gear using imported server item stats, weapon stats, food effects, merits, augments, and mob resistance data where available. It hard-excludes utility, fishing, crafting, wrong-job, and wrong-level items from combat sets.

## Status

See `KNOWN_ISSUES.md` before relying on non-melee jobs live.

No open-source license has been selected yet. Public visibility does not grant reuse rights beyond GitHub's normal viewing and forking behavior.
