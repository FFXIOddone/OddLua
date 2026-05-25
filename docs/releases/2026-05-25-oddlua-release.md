# OddLua Release - 2026-05-25

Release tag: `oddlua-2026.05.25`

Release scope:
- Generates LuAshitacast profiles for all supported jobs available in each Catseye character snapshot.
- Applies generated profiles to both LuAshitacast load paths, backing up existing profiles first.
- Uses the OddLua stats database built from Catseye/server item data, mechanics data, food effects, augments, merits, abilities, spells, traits, mobdb data, and Catseye equipment overrides.
- Includes semantic routing for idle, resting, movement, precast, midcast, aftercast, elemental/day/weather, job ability, weapon skill, pet, ranged, cure, enfeeble, enhancing, and related job sets.
- Includes per-job `/lac fwd warp` Warp Ring handling with Ring2 lock, a real 9-second Ashita task delay, and 30-second cleanup.
- Rejects multi-slot movement overlays from automatic movement sets using server `rslot` data, so Kupo Suit is not selected by generated movement sets.

Install/apply evidence:
- Latest apply report: `reports/apply/oddlua-apply-all-jobs-20260525-073948.json`
- Characters discovered: 2
- Jobs built: 27
- Installed LuAshitacast targets: 54
- Backups created: 54

Verification:
- `python -m pytest -q`: 44 passed
- LuaJIT syntax check: 54 installed profiles checked, 0 failures
- `Kupo Suit` references in `dist\packs`: 0
- `Kupo Suit` references in active Catseye LuAshitacast profiles: 0

Known limitations:
- Live testing remains the source of truth for route quality and best-in-slot quality.
- Melee jobs are the strongest validated slice so far.
- Some caster, pet, and utility-heavy jobs may still need live tuning after runtime observation.
- Generated sets intentionally leave missing semantic sets as clear remove/debug sets rather than silently falling back to unrelated gear.
