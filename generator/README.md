# OddLua

OddLua is the project folder for downloadable personalized LuAshitacast Lua packs.

The first target is Aahtacos THF, built from the current Catseye `gearexport` data, the local character snapshot, and a generated SQLite stats database sourced from Catseye server SQL plus food item scripts. OddLua now has contracts for all 22 jobs, with generated packs gated by the job levels in the selected character snapshot. Future packs should use the same path: current owned gear plus authoritative server stats in, personalized job pack out.

Build the stats database from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\OddLua\Build-OddLuaStatsDb.ps1
```

That command writes `OddLua\data\oddlua_stats.sqlite` with gear modifiers, conditional item latents, pet gear modifiers, weapon damage/delay, augments, merits, traits, abilities, spells, status effects, weapon skills, usable item data, mob resist/profile tables, and food stat boosts parsed from `server\scripts\items`. The builder scores eligible owned gear from those stats and records the mechanics surfaces used by each playstyle; hard-coded item preferences are not used for combat set selection.

If the running Catseye client has produced a `*_client_items.json` dump with `/gearexport resources`, the stats builder also imports the newest dump under `C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport`. Client resource data is used as the authoritative Catseye source for item level, job mask, slot mask, and basic weapon damage/delay. Server SQL remains the default source for item mods, food effects, augments, merits, traits, and scripts, but explicit Catseye wiki equipment stat overrides are imported from broad page scans when the page text gives a concrete stat value for an exact item-name match.

Generated Lua profiles also include a level-37 subjob model for every viable subjob on that main job. The profile exports `profile.Subjobs`, `profile.HasSubjobCapability(...)`, and `/lac fwd subjob`, `/lac fwd subjob traits`, `/lac fwd subjob spells`, and `/lac fwd subjob abilities` so live testing can confirm things like `/NIN` shadows, Dual Wield ranks, `/DNC` waltzes, `/WAR` Provoke, or `/SCH` stratagems from the Catseye stats database.

Build the first pack from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\OddLua\Build-OddLuaPack.ps1
```

Use `-Job PLD`, `-Job SCH`, or any other supported job abbreviation listed in `contracts\ALL_JOBS.md`. Target-aware scoring is available when the target exists in the imported mobdb tables:

```powershell
powershell -ExecutionPolicy Bypass -File .\OddLua\Build-OddLuaPack.ps1 -Job PLD -TargetName Skeleton
```

The command writes generated output under `OddLua\dist` only. It does not modify the live Catseye install.

Apply generated profiles to the live LuAshitacast install from the current character snapshots:

```powershell
powershell -ExecutionPolicy Bypass -File .\OddLua\Apply-OddLuaAllJobs.ps1 -DryRun
powershell -ExecutionPolicy Bypass -File .\OddLua\Apply-OddLuaAllJobs.ps1
```

The apply command discovers Catseye `gearexport` character snapshots, builds only jobs with a positive level in each character snapshot, backs up every existing LuAshitacast profile before overwrite under `OddLua\backups\luashitacast\<timestamp>`, then writes both profile forms LuAshitacast can load: `<Character>_<Id>\<JOB>.lua` and `<Character>_<JOB>.lua`. Level-0 jobs are skipped and left untouched.
