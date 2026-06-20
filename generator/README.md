# OddLua

OddLua is the project folder for downloadable personalized LuAshitacast Lua packs.

The first target is Aahtacos THF, built from the current Catseye `gearexport` data, the local character snapshot, and a generated SQLite stats database sourced from Catseye server SQL plus food item scripts. OddLua now has contracts for all 22 jobs, with generated packs gated by the job levels in the selected character snapshot. Future packs should use the same path: current owned gear plus authoritative server stats in, personalized job pack out.

For addon bugs or live profile behavior, start with the Addon Regression Ladder:

```text
docs/superpowers/guides/oddlua-addon-regression-ladder.md
```

That guide defines the OddLua workflow for tracing installed LuAshitacast behavior back through generated `dist` output and source, adding a focused regression, rebuilding/applying, and hash-verifying live profiles.

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

Generated manifests include a mechanics swap planner that explains HP/MP bridge transitions, negative tick avoidance candidates, and transitions intentionally skipped as utility sets. The generated Lua exposes this as a probe-only surface; mechanics execution remains disabled by default. In game, use:

```text
/lac fwd mechanics status
/lac fwd mechanics list
/lac fwd mechanics warnings
/lac fwd mechanics skipped
/lac fwd mechanics plan <set>
/lac fwd mechanics probes on
/lac fwd mechanics probe <set>
```

Audit planner coverage after generation:

```powershell
python .\OddLua\tools\audit_mechanics_planner.py --fail-on-missing --fail-on-malformed --fail-on-unloaded --min-profile-count 1 --min-loaded-profile-count 20 --min-planner-version 2
python .\OddLua\tools\audit_mechanics_planner.py --compact --fail-on-missing --fail-on-malformed --fail-on-unloaded --min-profile-count 1 --min-loaded-profile-count 20 --min-planner-version 2
python .\OddLua\tools\audit_mechanics_planner.py --no-write --max-warning-count 4340 --max-warning-type final_hp_pool_lower=2125 --max-skipped-transition-count 139 --max-skipped-reason utility_set=137
python .\OddLua\tools\check_lua_syntax.py --root .\OddLua\dist\packs
```

Use the audit report under `OddLua\reports\mechanics-planner` to review planner versions, warning counts, and skipped-transition reasons before promoting any mechanics behavior beyond probes.

Generated Lua profiles also include live reconciliation snapshots. The Python generator still owns the expected gear calculation; the generated Lua records what actually appeared in game after each named set equip. Reconciliation is enabled by default and writes compact JSONL lines under the Ashita `logs` folder. In game, use:

```text
/lac fwd reconcile status
/lac fwd reconcile last
/lac fwd reconcile off
/lac fwd reconcile on
```

Summarize a live snapshot log into a reviewable Markdown report:

```powershell
python .\OddLua\tools\report_live_reconciliation.py C:\Games\CatsEyeXI\catseyexi-client\Ashita\logs\oddlua-reconcile-Aahtacos_30102-THF.jsonl --output .\OddLua\reports\live-reconciliation\Aahtacos_30102-THF.md
```

Run the full local release gate from the repository root:

```powershell
python .\OddLua\tools\release_check.py
python .\OddLua\tools\release_check.py --skip-generation
python .\OddLua\tools\release_check.py --skip-generation --json
python .\OddLua\tools\release_check.py --skip-generation --write-report
python .\OddLua\tools\release_check.py --skip-generation --include-gear-audit
```

This runs tests, dry-run generation, weapon-skill coverage, Catseye catalog and inconsistency gates, manifest item-ambiguity checks, planner coverage budgets, current warning/skipped-transition budgets, and LuaJIT byte-compile checks. The command prints per-step durations; `--write-report` saves JSON evidence under `OddLua\reports\release-check`.
Use `--skip-generation` only when intentionally checking the current generated `dist` output.
Use `--include-gear-audit` when scorer or gear-selection changes need the heavier selected-vs-best audit. That gate fails on non-best selected gear statuses and on manual-review tag counts above the current reviewed budgets.

Apply generated profiles to the live LuAshitacast install from the current character snapshots:

```powershell
powershell -ExecutionPolicy Bypass -File .\OddLua\Apply-OddLuaAllJobs.ps1 -DryRun
powershell -ExecutionPolicy Bypass -File .\OddLua\Apply-OddLuaAllJobs.ps1
```

The apply command discovers Catseye `gearexport` character snapshots, builds only jobs with a positive level in each character snapshot, backs up every existing LuAshitacast profile before overwrite under `OddLua\backups\luashitacast\<timestamp>`, then writes both profile forms LuAshitacast can load: `<Character>_<Id>\<JOB>.lua` and `<Character>_<JOB>.lua`. Level-0 jobs are skipped and left untouched.

Generated profiles can also trigger the same refresh from inside LuAshitacast:

```text
/lac fwd refreshgear
/lac fwd refreshgear resources
/lac fwd refreshgear status
```

`refreshgear` queues `/gearexport full`, waits briefly for the dump to land, launches `Run-OddLuaGameRefresh.cmd`, polls `reports\game-refresh\latest-status.json`, and queues `/lac reload` when the rebuild/apply script reports success. The `resources` variant also queues `/gearexport resources` before launching the rebuild.
