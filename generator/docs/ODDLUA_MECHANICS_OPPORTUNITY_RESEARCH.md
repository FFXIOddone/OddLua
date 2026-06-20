# OddLua Mechanics Opportunity Research

Date: 2026-05-31

Purpose: identify gear-swap mechanics where OddLua can improve real outputs by timing gear around server formula checkpoints instead of only building static "best stat" sets.

## Ground Rule

HP and MP pool gear does not create permanent over-cap HP/MP on this server. `CBattleEntity::UpdateHealth()` recalculates max HP/MP and clamps current HP/MP after equip changes. The useful space is:

- bridge swaps that avoid transient HP/MP clamp loss
- action snapshots where gear is only needed at formula resolution
- tick pulses where gear is only needed at server tick
- threshold control for latents and AI/cure behavior
- breakpoint solving for TP, haste, recast, and resource cycles
- avoiding negative latents outside the exact window they are worth wearing

## Additional Methods To Research And Model

These extend the first HP/MP ideas and cover other jobs, weapons, and action types.

1. Fast Cast split sets: equip Fast Cast and interruption gear for precast, then swap to potency/accuracy/duration for midcast.
2. Spell recast compression: value recast reduction separately from cast speed when repeated spell loops matter.
3. Enhancing duration snapshots: Haste, Refresh, Regen, Barspells, Phalanx, Stoneskin, and Enspells can each need different potency or duration gear at landing.
4. Enfeebling accuracy vs duration routing: high-resist targets need magic accuracy; low-resist targets can favor duration, potency, or recast.
5. Elemental nuke routing: choose element-specific staff/affinity/day/weather/obi/magic-burst gear only for the spell being cast.
6. Divine/Dark/Ninjutsu spell routing: direct damage and drain/aspir families need their own magic accuracy, skill, affinity, and cost models.
7. Weapon skill WSC snapshots: STR/DEX/VIT/AGI/INT/MND/CHR weights should come from the exact WS script, not generic WS gear.
8. Weapon skill TP bonus snapshots: TP Bonus gear matters at WS resolution but can be poor in TP sets.
9. Critical WS snapshots: critical rate and critical damage should only dominate for WS scripts that can crit or force crits.
10. Multi-hit WS snapshots: Double Attack, multi-hit, accuracy, and WSD value depend on whether extra hits can land and whether accuracy is capped.
11. Ranged preshot/midshot split: Snapshot/Rapid Shot belong in preshot; ranged attack, ranged accuracy, store TP, and True Shot-like modifiers belong in midshot.
12. Ammo conservation logic: Recycle/Scavenge-related value and expensive ammo rules should alter ranged set decisions.
13. Store TP breakpoint solving: Store TP should be valued by rounds-to-WS changes, not linear stat weight.
14. Dual Wield overcap avoidance: Dual Wield value depends on current magic/gear/ability haste and TP return; excess DW can hurt TP cycles.
15. Martial Arts breakpoint solving: H2H delay reductions need TP-return-aware scoring, especially at delay caps.
16. Subtle Blow tanking: when reducing enemy TP feed matters, Subtle Blow and Inhibit TP can beat raw DPS stats.
17. Enmity action snapshots: Provoke, Flash, cures, PLD JAs, and tank spells can use enmity spike sets, then return to damage taken gear.
18. Shield block sets: shield size, shield skill, block rate, and block damage reduction should be modeled for PLD and RUN defensive sets.
19. Cover-to-MP and damage-to-MP windows: Ochain, Cover, Ethereal-style gear, and absorb-to-MP mods only need to be worn for expected hit windows.
20. Waltz snapshots: DNC Waltz potency, CHR/VIT, TP cost, recast, and enmity need a separate healing model from Cure spells.
21. Step and Flourish snapshots: Step accuracy, debuff potency, finishing move generation, and Flourish damage should be routed separately.
22. Samba windows: Samba duration and melee follow-up value should be separated from ordinary TP gear.
23. Quick Draw snapshots: COR Quick Draw needs magic accuracy, magic damage, elemental affinity, card/ammo handling, and recast.
24. Phantom Roll snapshots: roll potency, duration, job bonus, bust risk, and recast gear should be action-specific.
25. Song split sets: BRD needs song count/instrument, song duration, song casting time, and magic accuracy for debuffs as separate surfaces.
26. Geomancy split sets: GEO needs geomancy/handbell skill, luopan survivability, refresh/perp-like sustain, and enfeebling accuracy surfaces.
27. Avatar perpetuation vs Blood Pact split: SMN idle perp/refresh is different from BP Rage damage, BP Ward duration, and summoning skill.
28. Pet master tradeoff sets: BST/PUP/SMN gear can improve pet output while weakening master survival; score by current job action, not global preference.
29. Automaton-specific snapshots: PUP needs pet accuracy, pet magic accuracy, pet haste, pet DT, maneuver/attachment context, and overload risk.
30. Ready/Sic pet action snapshots: BST pet physical and magical actions need pet attack/accuracy/MAB/MACC routing.
31. Wyvern breath thresholds: DRG can manipulate player HP thresholds and breath potency windows without wearing unsafe HP gear permanently.
32. Blue Magic split routing: BLU physical spells, magical spells, breath spells, healing spells, and trait/set-point outcomes need separate scoring.
33. Ninjutsu split routing: Utsusemi recast/interruption gear is different from elemental wheel magic accuracy/damage gear.
34. Rune Fencer elemental defense windows: Vallation/Valiance, Liement, Pflug, runes, and elemental resistance gear need incoming-damage context.
35. Treasure Hunter tagging: TH gear should be used for claim/proc windows, then dropped if DPS or survival is the desired output.
36. Movement latent routing: city, night, dusk-to-dawn, mount, and quickening movement gear should not pollute combat or idle scoring.
37. Food and consumable optimization: food should be scored against caps and current stats; duration gear or food duration mods change long-session value.
38. Cure AI and trust targeting control: max HP/HPP swaps can influence external cure thresholds and avoid HP-volatile behavior.
39. Negative latent avoidance: rune weapons, Sacrifice Torque, and weapon-drawn MP drains should be removed before tick unless the action window pays for them.
40. Skill-up and proc sets: low-output gear can still be optimal when the desired output is skill gain, proc rate, or objective completion.

## Research Plan

### Server Mechanics Sources

Inspect and tag these local files first:

- `server/src/map/entities/battleentity.cpp`: HP/MP recalculation, delay, TP, damage application, absorb-to-MP.
- `server/src/map/utils/charutils.cpp`: equip order, modifier application, latent retriggering.
- `server/src/map/packets/c2s/0x050_equip_set.cpp` and `0x051_equipset_set.cpp`: equip packet validation and ordered equipset processing.
- `server/src/map/status_effect_container.cpp`: Refresh, Regen, poison, regain, perpetuation, tick timing.
- `server/src/map/utils/battleutils.cpp`: spell cost, physical damage, pDIF hooks, damage-to-MP, defensive checks.
- `server/scripts/globals/spells/*.lua`: spell family final power and duration.
- `server/scripts/actions/spells/**`: action-specific Cure, nuke, enfeeble, drain, blue, and ninjutsu behavior.
- `server/scripts/globals/job_utils/*.lua`: job ability formulas.
- `server/scripts/globals/weaponskills.lua` and `server/scripts/actions/weaponskills/*.lua`: WS WSC, fTP, hit count, crit, magical flags.
- `server/sql/item_mods.sql`, `item_latents.sql`, `item_mods_pet.sql`, `abilities.sql`, `spell_list.sql`, `traits.sql`, `merits.sql`, `weapon_skills.sql`.

### OddLua Data Work

1. Keep importing raw server data into SQLite.
2. Add a mechanics opportunity catalog that maps server mods/latents/pet mods to action-window opportunities.
3. Add formula-specific calculators in small slices: HP/MP bridge planner, spell snapshot planner, WS planner, ranged planner, pet planner, defensive planner.
4. Add manifest evidence for every generated set: which mechanic was optimized, which server rows supported it, and which risks were avoided.
5. Add probes in generated Lua before enabling live automation: current HP/MP/max pools, selected phase, equipped bridge items, expected tick/action window, and before/after observed values.

### Live Probe Order

1. Non-combat HP/MP bridge swaps in a Mog House or safe zone.
2. Resting tick pulse with hMP/hHP gear.
3. Refresh/Regen tick timing with harmless gear.
4. Stoneskin snapshot value before and after removing bonus gear.
5. Cure-to-MP and no-MP-cost proc observation.
6. Negative Refresh latent avoidance with weapon drawn and sheathed.
7. Ranged preshot/midshot packet timing.
8. WS snapshot gear timing with a controlled target.
9. Pet action snapshot timing.
10. Tank hit-window absorption and shield/block observations.

### Implementation Order

1. Catalog and manifest: detect possible opportunities from local data.
2. Audit report: list owned gear and server gear that can support each opportunity.
3. Planner: build safe ordered swaps for HP/MP bridges and negative latent avoidance.
4. Formula slices: add one action family at a time with tests and live probes.
5. Profile integration: only enable automated swaps when probes prove timing and safety.
