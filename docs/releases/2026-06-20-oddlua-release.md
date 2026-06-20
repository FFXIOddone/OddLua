# OddLua Release - 2026-06-20

Release tag: `oddlua-2026.06.20`

Release scope:
- Generates a per-profile raw number-row palette for `1` through `=`.
- Binds profile-local commands for style previous/next, style list, Warp Ring, lockstyle, status, craft utility, movement utility, and job-specific auto/action slots where available.
- Adds a compact guarded ImGui overlay showing the loaded OddLua profile and number-row actions.
- Adds universal utility fallback routing for craft and movement commands; missing utility gear reports `Not Applicable / Missing Equipment`.
- Replaces the old two-press Warp Ring UX with a one-press Ring2 equip, Ring2 lock, 10-second use, and 10-second unlock/cleanup flow.
- Stabilizes profile-health reconciliation report selection when filesystem timestamps tie.

Install/apply evidence:
- Latest live apply report: `reports/apply/oddlua-apply-all-jobs-20260620-191739.json`
- Characters discovered: 3
- Jobs built: 36
- Installed LuAshitacast targets: 72
- Backups created: 72

Verification:
- Focused overlay/palette/Warp tests: 59 passed
- Full pytest suite: 499 passed
- Release check report: `reports/release-check/release-check-20260620-192317.json`
- Release check: 12/12 steps passed
- LuaJIT syntax check: 36 generated profiles checked, 0 failures
- Hash parity confirmed for `Oddone_29938/RDM.lua` and `Pleasebanme_48997/SAM.lua` between `dist` and live CatsEyeXI install.

Known limitations:
- Live client behavior remains the final source of truth for keybind interaction with other Ashita addons.
- Overlay rendering is guarded and only appears when Ashita ImGui is available.
- Generic non-SAM job auto slots intentionally report missing equipment/action until job-specific palette actions are added.
