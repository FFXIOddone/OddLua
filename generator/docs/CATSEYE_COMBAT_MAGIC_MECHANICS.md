# Catseye Combat and Magic Mechanics Reference

Date: 2026-05-24

Purpose: define the source-grounded mechanics OddLua needs to generate real calculated best sets, not role-weight approximations. The generator should score gear, food, merits, augments, buffs, and target profiles against expected combat output.

## Source Policy

Use sources in this order:

1. `CEXI-PUBLIC`: the public Catseye server branch, `../server` remote ref `catseye/stable` at `7abf3a074a`. This is the best first-party public mechanics source available locally.
2. `LOCAL-SERVER`: the local server worktree, observed at `0fca67c755` during this pass. Use only when Catseye public does not expose the needed code.
3. `LOCAL-ODDLUA`: OddLua's local database import and resolver code. This tells us what the current product can already read.
4. `CATSEYE-WIKI-CACHE`: local Catseye wiki cache under `../tools-data/catseye-wiki-cache/pages`. Use for public Catseye-specific custom content and job notes.
5. `BG-FALLBACK`: BG-Wiki retail mechanics pages. Use only when Catseye code/cache does not answer the question.
6. `LIVE-GAP`: live-only behavior requiring Catseye or Deeps.dll validation.

Important caveats:

- The public Catseye repo points at private/missing modules under `modules/catseyexi`, `modules/contrib`, `src/map/cexi`, and `control`. See `../docs/catseye-server-sync-findings.md`. Public branch formulas can still be overridden by private live modules.
- Catseye public settings enable old cure and old magic damage formulas: `catseye/stable:settings/default/main.lua:241-242`.
- Catseye public settings multiply direct spell families: `CURE_POWER=1.000`, `ELEMENTAL_POWER=1.000`, `DIVINE_POWER=1.125`, `NINJUTSU_POWER=1.000`, `BLUE_POWER=1.000`, `DARK_POWER=1.000`, `WEAPON_SKILL_POWER=1.000` at `settings/default/main.lua:138-145`.
- Catseye public Jobs page says Catseye disables ranged distance penalties, but the public server code still contains ranged distance penalties in the normal ranged hit and pDIF path. Treat ranged distance as a configurable live-verification flag until confirmed.

## Required Calculation Inputs

OddLua cannot calculate best sets from item names alone. A generated set must merge these inputs before scoring:

- Actor profile: race, level, main job, subjob, base stats, current HP/MP/TP, skill levels, combat/magic skill ranks, job traits, merits, job points if available, status effects, position/facing, day/weather, equipped gear, augments, food, and manually selected buffs.
- Gear profile: `item_equipment`, `item_weapon`, `item_mods`, `augments`, and custom Catseye item data. No name-based stat inference. Example: a subligar is DEX gear only if the database or augment data says it has DEX.
- Food profile: player and pet mods parsed from item scripts. OddLua already imports `food_effects` and `food_effect_mods` from `scripts/items/*.lua`, including `effect:addMod` and `target:addPetMod` calls in `src/oddlua/statsdb.py:774-865`.
- Progression profile: merits and traits from server SQL. OddLua schema imports `merits` and `traits` in `src/oddlua/statsdb.py:212-233`.
- Action profile: abilities, spells, songs, rolls, geomancy, pet actions, recasts, charges, resource costs, cast times, AOE/range rules, CE/VE, and action-specific formula hooks from Catseye SQL and scripts.
- Status profile: active buffs and debuffs with source, potency, tick, duration, tier, subpower, overwrite/block/remove behavior, remaining time, and target scope.
- Target profile: mob level, family/ecosystem, stats, DEF, EVA, MEVA, MDB, resistance ranks, physical SDT, elemental SDT, and pool/species mods. OddLua already models `mob_resistances`, `mob_pools`, `mob_family_system`, and `mob_groups` in `src/oddlua/statsdb.py:284-378`.
- Server profile: Catseye branch/settings flags, especially old-vs-new magic damage, old-vs-new cure formula, ranged-distance behavior, delay cap, and any live-only module overrides.

## Target Data Model

Target weakness and strength should come from mobdb, not generic role labels.

- `mob_spawn_points` gives concrete mob instance and level range.
- `mob_groups` maps group to pool and zone; OddLua stores HP/MP/content tags in `src/oddlua/statsdb.py:364-378`.
- `mob_pools` gives species, jobs, combat skill, delay, damage multiplier, spell list, skill list, and `resist_id`; see server SQL `../server/sql/mob_pools.sql:19-45` and OddLua mirror `src/oddlua/statsdb.py:318-337`.
- `mob_family_system` gives family-level stats and ecosystem; OddLua stores STR/DEX/VIT/AGI/INT/MND/CHR, ATT/DEF/ACC/EVA, and ecosystem fields in `src/oddlua/statsdb.py:339-362`.
- `mob_resistances` gives physical SDT, elemental SDT, elemental resistance ranks, and status resistance ranks. OddLua stores `slash_sdt`, `pierce_sdt`, `h2h_sdt`, `impact_sdt`, all elemental SDTs, elemental ranks, and status ranks in `src/oddlua/statsdb.py:284-316`.
- `mob_pool_mods` and `mob_species_mods` can override behavior and should be applied after base pool/family data.

For set generation, create named target presets:

- `neutral_even`: same-level neutral target for baseline comparisons.
- `high_evasion`: target where accuracy value is still below cap.
- `high_defense`: target where attack and pDIF are not capped.
- `physical_weak`: target selected by favorable slash/pierce/h2h/impact SDT.
- `element_weak`: target selected by low elemental resistance rank and favorable elemental SDT.
- `content_specific`: real mobdb target selected by name/zone/content.

## Physical Damage

Catseye public core files:

- `scripts/globals/combat/physical_utilities.lua`
- `scripts/globals/combat/physical_hit_rate.lua`
- `scripts/globals/combat/tp.lua`
- `src/map/entities/battleentity.cpp`
- `scripts/globals/weaponskills.lua`

### Physical Pipeline

Expected melee hit damage:

```text
base_damage = weapon_damage + fSTR + bonus_base_damage
expected_damage = base_damage
                * expected_pDIF
                * physical_SDT
                * damage_taken_adjustments
                * critical_expected_multiplier
                * defensive_proc_adjustments
```

For weapon skills:

```text
ws_base = floor((weapon_damage + fSTR + WSC * alpha + bonus_ws_mods) * fTP)
ws_damage = sum(each hit ws_base_or_secondary_base * pDIF * WSD/applicable mods)
```

For set generation, replace random rolls with expectations. Do not use the server's `math.random` path directly for ranking gear.

### fSTR and fSTR2

Catseye public implements the BG-Wiki fSTR model in `physical_utilities.lua:243-362`.

- Melee fSTR uses `STR - target VIT`.
- Player/trust fSTR clamps stat difference using weapon-rank bounds, applies the piecewise table, divides by 4, then clamps to `[-weaponRank, weaponRank + 8]`, with rank 0 lower cap `-1`.
- Ranged fSTR2 uses the same stat difference and rank bounds, divides by 2, then clamps to roughly double the fSTR range, with rank 0 lower cap `-2` and rank 1 lower cap `-3`.
- Mob and pet formulas are simpler: melee `floor((dSTR + 4) / 4)` and ranged `floor((dSTR + 4) / 2)`, clamped `-20..24`.

BG-FALLBACK: https://www.bg-wiki.com/ffxi/FSTR

### WSC

Weapon Skill Secondary Attribute Modifier is calculated in `physical_utilities.lua:365-388`.

- For each relevant stat, Catseye floors `actor_stat * (ws_stat_multiplier + actor_ws_stat_bonus / 100)`.
- Final WSC is the sum of STR, DEX, VIT, AGI, INT, MND, and CHR contributions.
- The actor-specific WS stat bonus mods matter. They must be imported from gear, augments, traits, merits, or buffs.

### Hit Rate

Catseye public hit rate is in `physical_hit_rate.lua:51-220`.

- Caps: pets 99%, H2H 99%, one-handed mainhand 99%, offhand/two-handed/ranged 95%, mobs 95%.
- Formula before caps: `(75 + (accuracy - evasion) / 2) / 100`.
- Melee floor is 20%; ranged floor is also clamped to 20% in the Catseye public code, with an out-of-range special case returning 0.
- Level-corrected zones add mob accuracy bonus or player accuracy penalty at `4 accuracy per level`.
- Modifiers include Building Flourish, Innin/Yonin, Closed Position, Ambush, and Flash.

BG-FALLBACK: https://www.bg-wiki.com/ffxi/Hit_Rate

Implementation note: score accuracy by marginal value until the relevant cap. Once capped, extra ACC/RACC should drop near zero unless the set style explicitly wants future-proof overcap.

### Critical Rate

Catseye public critical rate is in `physical_utilities.lua:890-912`.

- Base crit rate is 5%.
- Adds DEX-vs-AGI stat bonus, Innin, Fencer, Building Flourish, CRITHITRATE, merits, and optional TP-based WS crit modifier.
- Subtracts target critical evasion and target merit penalty.
- Catseye clamps swing crit rate from 5% to 100%.

Ranged crit uses AGI-related logic in the same file. Model crit as expected value:

```text
expected_pDIF = crit_rate * avg_crit_pDIF + (1 - crit_rate) * avg_noncrit_pDIF
```

### pDIF

Catseye public pDIF is in `physical_utilities.lua:532-760`.

- Melee attack ratio is `actor ATT / target DEF`, after WS attack mods, Building Flourish, defense ignore, and Cannonball special handling.
- Public Catseye melee level correction is `(actor level - target level) * 3 / 64` when level correction applies. Non-PCs do not suffer negative correction; PCs do not get positive correction.
- Critical hits add 1 to `wRatio`.
- pDIF caps come from weapon type and are modified by `DAMAGE_LIMIT` and `DAMAGE_LIMITP`.
- The server randomly rolls between lower and upper pDIF bounds and applies a melee randomizer from 1.00 to 1.05.
- Critical damage bonus is a final multiplier after pDIF.
- Ranged pDIF uses RATT, ranged attack distance penalty in public code, ranged level correction `0.025 per level`, and different ranged caps.

BG-FALLBACK: https://www.bg-wiki.com/ffxi/PDIF

Implementation note: build average pDIF functions for deterministic set ranking. The BG-Wiki pDIF page includes average pDIF guidance; the server code provides the exact branch behavior Catseye public uses.

### Physical SDT and Damage Taken

Catseye physical SDT comes from target mods populated by mob resistance SQL.

- Physical SDT types: slash, pierce, h2h, impact.
- Elemental/magical SDT types: fire, ice, wind, earth, lightning, water, light, dark.
- Direct spell SDT is calculated in `damage_spell.lua:498-520` as `1 + elemental_sdt_mod / 10000`, clamped `0..3`.
- Magic/physical/ranged/breath damage taken adjustments are handled by Catseye spell damage adjustment code in `damage_spell.lua:713-730` and related combat utility paths.

For style sets:

- A dagger/sword/polearm set is target-dependent if the mob has non-neutral slash/pierce/h2h/impact SDT.
- A nuke/MB set is target-dependent if elemental SDT or resistance rank differs.
- Tank sets should use expected incoming damage after SDT, damage taken caps, block/parry/guard, Phalanx, Stoneskin, and magic shields.

### Delay, Haste, Dual Wield, Martial Arts

Catseye public weapon delay is in `src/map/entities/battleentity.cpp:452-538`.

- Base delay starts from main weapon delay plus flat `DELAY`.
- H2H subtracts Martial Arts.
- Dual wield adds subweapon delay and multiplies by `1 - DUAL_WIELD / 100`.
- Magic haste clamps to 43.75%, ability haste to 25%, and gear haste to 25%.
- Final haste multiplier clamps to `0.2..2.0`, giving the public branch an 80% total delay reduction floor.
- Final delay also clamps between 20% and 200% of weapon delay.
- Hundred Fists is handled directly as 25% of the clamped weapon delay.
- Ranged delay is in `battleentity.cpp:546-578`: range plus ammo delay for TP calc, then `RANGED_DELAY` and `RANGED_DELAYP`.

BG-FALLBACK: https://www.bg-wiki.com/ffxi/Attack_Speed

Implementation note: dual wield is not "more is always better." It should be scored against current haste because excess dual wield can reduce TP per hit and may not improve TP-cycle DPS after delay caps.

### TP Return and TP Fed

Catseye public TP logic is in `combat/tp.lua:7-193`.

- Single melee hit TP return uses base/modified delay and Store TP.
- Dual wield and H2H per-hit TP delay are halved where appropriate.
- H2H has minimum 96 total delay / 48 per fist for TP return.
- `DELAYP` for TP return has a minimum cap of -15%.
- PC/pet/charmed entities use the modern TP return delay bands in `tp.lua:88-120`; mobs use a separate mob formula.
- Ranged TP return uses base ranged delay and Store TP.
- TP fed to the target applies target Store TP, Inhibit TP, dAGI, Subtle Blow I, Subtle Blow II, and Tandem Blow.
- Subtle Blow I caps at 50%; the combined reduction floor is 25%, meaning max 75% reduction.
- Magical damage TP feed is 100 base to mobs and 50 base to non-mobs before the same reduction factors.

BG-FALLBACK:

- https://www.bg-wiki.com/ffxi/Tactical_Points
- https://www.bg-wiki.com/ffxi/Subtle_Blow

Implementation note: DPS sets should calculate TP-cycle damage, not just auto-attack damage. Store TP can beat raw damage when it changes rounds-to-WS.

### Defensive Physical Procs

Catseye public defensive proc logic is in `physical_utilities.lua:962-1115` and the hit resolution path in `weaponskills.lua:118-191`.

- Physical hit resolution checks evasion, parry, shadows/blink, guard, and block before final damage is applied.
- Parry uses parry skill plus AGI-vs-DEX and level difference, clamped 5..25 before Issekigan/Inquartata additions.
- Guard uses guard skill plus AGI-vs-DEX and level difference, clamped 5..25 before additive guard.
- Shield block requires facing and shield eligibility; block rate depends on shield size, shield skill, attacker skill, Reprisal/Palisade, and related mods.
- Tank and shield sets must value block rate and block damage reduction separately from DEF and PDT.

## Weapon Skills

Catseye public weapon skill logic is in `scripts/globals/weaponskills.lua`.

Key functions:

- `getSingleHitDamage`: `weaponskills.lua:118`
- `calculateHybridMagicDamage`: `weaponskills.lua:241`
- `calculateRawWSDmg`: `weaponskills.lua:293`
- `doPhysicalWeaponskill`: `weaponskills.lua:647`
- `doRangedWeaponskill`: `weaponskills.lua:726`
- `doMagicWeaponskill`: `weaponskills.lua:810`
- `takeWeaponskillDamage`: `weaponskills.lua:904`

Physical WS:

- Build base damage from weapon damage, fSTR, WSC, alpha, fTP, and WS-specific modifiers.
- Determine first-hit and extra-hit accuracy.
- Apply Sneak Attack, Trick Attack, Assassin, Bully, Mighty Strikes, Building Flourish, crits, multi-attacks, fTP replication, offhand hits, and extra hits.
- Apply pDIF per landed hit.
- Apply physical SDT, damage taken, and `WEAPON_SKILL_POWER`.
- Add TP return from landed TP hits and extra hits.

Ranged WS:

- Uses ranged base damage, fSTR2, RACC/RATT, ranged pDIF, ammo, distance behavior, and ranged TP return.
- Catseye public Jobs page says no ranged distance penalty on Catseye, but public server formulas still include it. Treat this as `LIVE-GAP:ranged_distance_penalty`.

Magical WS:

- Uses WS base damage plus WSC/fTP, then magic damage pipeline: affinity, staff, resist, resistance rank reduction, day/weather, MAB/MDB, TMDA, magic crit II, WSD, and potency bonuses.

Hybrid WS:

- Physical component is calculated like physical WS.
- Magical duplicate component scales from physical damage and then runs through magic modifiers.
- Hybrid WS can gain value from both pDIF/attack/crit and magic modifiers.

BG-FALLBACK: https://www.bg-wiki.com/ffxi/Weapon_Skill_Damage

Implementation note: weapon skill set scoring should run the actual expected WS function at target TP values, usually 1000 TP for normal cycling, plus optional 2000/3000 TP for hold-TP styles.

## Magic Damage

Catseye public direct spell logic is in:

- `scripts/globals/spells/damage_spell.lua`
- `scripts/globals/combat/magic_hit_rate.lua`
- `scripts/globals/magicburst.lua`
- `scripts/globals/bluemagic.lua`

### Direct Spell Pipeline

Catseye public direct damage spell order is explicit in `damage_spell.lua:1173-1228`.

```text
base_spell_damage
* multiple_target_reduction
* elemental_staff_bonus
* elemental_affinity_bonus
* elemental_SDT
* resist_tier
* additional_resist_tier
* day_weather
* MAB_MDB_ratio
* magic_critical_II
* target_magic_damage_adjustment
* Divine Seal / Divine Emblem / Elemental Seal
* Ebullience
* skill_type_multiplier
* NIN skill / Futae / Innin
* undead divine penalty
* Scarlet Delirium
* Helix merit
* area-of-effect resistance
* action type multiplier
* absorb
* magic burst
* magic burst bonus
* nuke wall
```

Catseye floors after each multiplication in this path.

### Old vs New Magic Damage

Catseye public settings use old magic damage: `settings/default/main.lua:242`. The formula selector is in `damage_spell.lua:326-337`.

- New-system direct damage is allowed only if the spell has new-system data, the caster is a PC, and `USE_OLD_MAGIC_DAMAGE` is false.
- Public Catseye has `USE_OLD_MAGIC_DAMAGE=true`, so OddLua should default the Catseye profile to old magic damage unless live validation proves a private override.
- Local non-Catseye base settings may differ; do not infer live Catseye from local base settings.

Base damage details in `damage_spell.lua:326-457`:

- Base spell damage starts from NPC power or PC power depending on the selected system.
- Stat difference uses either the new multi-threshold system or the old inflection-point system.
- Magic Damage from gear/status/job points is added as `mDMG`.
- Death, Helix, and Kaustra have special handling.

BG-FALLBACK: https://www.bg-wiki.com/ffxi/Magic_Damage

### Magic Accuracy and Resist

Catseye public magic hit rate is in `magic_hit_rate.lua:12-599`.

Actor magic accuracy includes:

- Magic skill, singing/instrument skill, or skill rank fallback.
- Elemental MACC and elemental staff MACC.
- Stat difference, clamped to `-30..30`.
- Status effects such as Altruism, Focalization, Klimaform, Divine Emblem, Elemental Seal, and Dark Seal.
- Merits and job points by job and skill.
- Magic Burst macc bonus.
- Day/weather macc.
- Tandem Strike.
- Food macc multiplier from `FOOD_MACCP` and `FOOD_MACC_CAP`.
- Soul Voice/Marcato multiplier for relevant songs.

Target magic evasion includes:

- Base MEVA.
- Elemental MEVA.
- Status-specific MEVA and global status MEVA.
- Mob level correction in level-corrected zones.
- Resistance rank multiplier.

Magic hit rate:

```text
mhr_delta = magic_accuracy - magic_evasion
if mhr_delta < 0: mhr_delta = floor(mhr_delta / 2)
magic_hit_rate = clamp((50 + mhr_delta) / 100, 0.05, 0.95)
```

Resistance factor:

- Complete magic shield returns 0.
- Non-elemental actions return 1.
- Resistance rank 10+ floors effective hit rate to 5%.
- Failed resist rolls produce tiers 1, 2, or 3.
- Final damage/duration factor is `1 / (2 ^ resistTier)`.
- For non-PC targets, resistance rank comes from elemental or status resistance rank mods and immunobreak adjustments, clamped `-3..11`.

BG-FALLBACK: https://www.bg-wiki.com/ffxi/Magic_Accuracy

Implementation note: macc sets need a landing probability objective, not a raw MACC sum. A set with more INT/MND/CHR can be better or worse depending on dSTAT, target MEVA, rank, and cap state.

### MAB/MDB

Catseye public MAB/MDB ratio is in `damage_spell.lua:607-693`.

- Caster MAB starts from `MATT`, plus GEO Cardinal Chant east bonus where applicable.
- Magic crit chance can add a magic crit damage bonus.
- Ninjutsu adds NIN magic merits and gear.
- Elemental spell merits add potency.
- RDM/GEO job points add MAB.
- Ancient Magic merits add MAB.
- Target MDB is `100 + target MDEF + barspell MDEF bonus`.
- Final ratio is `clamp(finalCasterMAB / finalTargetMDB, 0, 10)`.

### Day, Weather, Staff, Affinity, SDT

Catseye public:

- Multiple-target damage reduction: `damage_spell.lua:460-473`.
- Elemental staff bonus: `damage_spell.lua:476-485`.
- Elemental affinity bonus: `damage_spell.lua:487-496`.
- Elemental SDT: `damage_spell.lua:498-520`.
- Additional forced resist tier at high resistance rank: `damage_spell.lua:522-533`.
- Day/weather bonus and penalty: `damage_spell.lua:535-590`.

Important values:

- Multiple-target reduction is `0.9 - 0.05 * target_count` for 2..9 targets, floor 0.4 at 10+ targets.
- Single weather is +10%, double weather +25%, day +10%.
- Opposing weather/day can penalize by the same style of values.
- Obis and forced day/weather mods can force proc behavior.

### Magic Burst

Catseye public magic burst damage is in `damage_spell.lua:990-1046` and burst detection is in `scripts/globals/magicburst.lua`.

- Burst multiplier starts at `1.25 + rank_bonus + skillchainCount / 10`.
- Resistance rank bonus is large for weak ranks and zero at high resistance ranks.
- Sengikori can add to burst multiplier.
- Capped magic burst bonus from gear/merits/Innin clamps to 40%.
- Uncapped magic burst bonus includes BLM job points and GEO Cardinal Chant west bonus.
- Catseye public magic accuracy also adds +100 macc when a spell magic bursts.

BG-FALLBACK:

- https://www.bg-wiki.com/ffxi/Magic_Burst
- https://www.bg-wiki.com/ffxi/Skillchain

### Nuke Wall

Catseye public nuke wall is in `damage_spell.lua:1048-1078` and applied at `damage_spell.lua:1225-1228`.

- Applies to elemental damage against NMs.
- Tracks element-specific consecutive damage.
- Existing potency reduces damage; after one second, potency is reduced by 20 percentage points in server units.
- Rayke can reduce matching nuke wall potency.
- New potency scales from final damage and target level.

Implementation note: nuke/MB sets need an optional "solo repeated nukes" vs "coordinated burst" mode. Repeated same-element nukes into NMs should be penalized when nuke wall is enabled.

## Enfeebles, Songs, Absorbs, and Dark Magic

Enfeebling magic:

- Potency: `scripts/globals/spells/enfeebling_spell.lua:137`.
- Duration: `enfeebling_spell.lua:263`.
- Cast pipeline: `enfeebling_spell.lua:333-489`.
- Uses the shared magic accuracy/resist function at `enfeebling_spell.lua:368`.
- Immunobreak logic is in `enfeebling_spell.lua:400-417`.
- Final duration is base duration times resist rate at `enfeebling_spell.lua:434`.
- Magic Burst enfeebling messages and behavior exist in `enfeebling_spell.lua:486-489`.

Songs:

- Enfeebling songs use the same shared magic hit rate path at `enfeebling_song.lua:185`.
- Singing macc can include instrument skill in `magic_hit_rate.lua:20-34`.

Absorb, Drain, Aspir, Absorb-TP:

- Absorb utilities live in `scripts/globals/spells/absorb_spell.lua`.
- Absorb-stat spells use dark magic resist checks in `absorb_spell.lua:26-62`.
- Drain/Aspir calculate skill-based min/max potential, resist, SDT, day/weather, MAB/MDB, dark multiplier, absorb gear, and caps in `absorb_spell.lua:87-204`.
- Absorb-TP uses dark absorb/nullify checks, resist, macc, and absorb multipliers in `absorb_spell.lua:217-272`.
- `DARK_POWER` applies to relevant dark magic drain amounts via the damage spell skill-type multiplier.

Implementation note: enfeebling and absorb styles should optimize probability-adjusted potency/duration or drain amount, not simply MACC.

## Cure and Healing

Catseye public cure settings use old cure formula: `settings/default/main.lua:241`.

Core cure functions are in `scripts/globals/magic.lua:13-68`.

- New cure power: `floor(MND / 2) + floor(VIT / 4) + healing skill`.
- Old cure power: `3 * MND + VIT + 3 * floor(healing skill / 5)`.
- Base cure uses spell-specific divisor/constant.
- Cure Potency caps at 50%; Cure Potency II caps at 30%.
- Day/weather applies through the same day/weather helper.
- Divine Seal doubles final cure.
- Rapture is `1.5 + RAPTURE_AMOUNT / 100` for non-blue cures and consumes the effect.

Cure action logic is in `scripts/actions/spells/white/cure.lua:13-130`.

- Catseye public Cure I-V select old or new power based on setting.
- Afflatus Solace can add Stoneskin.
- Cure Potency Received is applied after final cure calculation.
- `CURE_POWER` server multiplier applies after received potency.
- Cures cast on undead use the damage spell path.

Blue cures:

- Blue curative spells use old cure power in `bluemagic.lua:704-733`.
- Blue cures use `getCureFinal(..., isBlueMagic=true)`, which excludes Rapture.

BG-FALLBACK: https://www.bg-wiki.com/ffxi/Cure_Formula

Implementation note: cure sets must include race and max MP/HP context when optimizing practical healing, but pure cure amount uses merged MND, VIT, healing skill, potency, received potency, day/weather, and active JA state.

## Blue Magic

Catseye public blue magic is in `scripts/globals/bluemagic.lua`.

Physical blue magic:

- Main path: `bluemagic.lua:161-304`.
- Initial D is based on blue magic skill and spell cap.
- fSTR uses STR-vs-VIT, capped unless spell says otherwise.
- WSC is spell-specific.
- Chain Affinity can replace multiplier with TP-derived fTP and doubles base WSC.
- BLU AF3 augment can add WSC.
- Monster correlation uses caster spell ecosystem vs target ecosystem plus Monster Correlation merits.
- Azure Lore can set special TP/multiplier behavior.
- Hit rate, crit rate, and pDIF are rolled per hit.
- Physical damage adjustment applies before final spell damage handling.

Magical blue magic:

- Main path: `bluemagic.lua:308-382`.
- Initial D uses caster level and spell cap.
- WSC, stat difference, Azure Lore, and monster correlation feed base damage.
- Uses shared magic resist, MTDR, staff, SDT, day/weather, MAB/MDB, optional Burst Affinity/Azure Lore magic burst, Ebullience, and `BLUE_POWER`.

Breath blue magic:

- Main path: `bluemagic.lua:473-570`.
- Base damage uses caster HP and optional level term.
- Applies correlation, breath damage dealt, damage adjustment, MTDR, staff/affinity, resist, additional resist tier, SDT, day/weather, MAB/MDB, skill-type multipliers, nuke wall, Phalanx, One For All, Stoneskin, damage cap, TP feed, and enmity.

Blue enfeebles:

- Main path: `bluemagic.lua:640-701`.
- Checks cone/gaze requirements, immunity, resistance/nullification, and shared magic resist.
- Duration is multiplied by resist rate.

Implementation note: BLU needs different style objectives for physical blue, magical blue, breath, enfeebling, and cure. A single "blue magic" weight set is not accurate.

## Skillchains

Catseye public skillchain handling is mostly C++:

- Skillchain properties load from SQL into battleutils.
- Skillchain formation and tier logic are in `catseye/stable:src/map/utils/battleutils.cpp:3475-3699`.
- Skillchain damage is in `battleutils.cpp:3918-3961`.
- Skillchain elements are also mapped in `physical_utilities.lua:28-45`.

Important mechanics:

- Skillchain damage uses closing damage, chain level/count modifier, skillchain bonus, skillchain damage bonus, day/weather, staff affinity, elemental affinity, resistance rank, and target magic damage reductions.
- Multi-element skillchains pick the element with the lowest resistance rank, with a priority order if tied.
- Magic burst eligibility uses active skillchain element matching.

BG-FALLBACK: https://www.bg-wiki.com/ffxi/Skillchain

Implementation note: melee DPS styles should optionally include expected skillchain contribution when the chosen WS sequence and target are known. Otherwise treat skillchain damage as a separate style mode.

## Pets, Automatons, Avatars, and Wyverns

Public Catseye pet mechanics are spread across:

- `scripts/globals/automaton.lua`
- `scripts/globals/automatonweaponskills.lua`
- `scripts/globals/avatars_favor.lua`
- `scripts/globals/job_utils/dragoon.lua`
- pet and blood pact scripts under `scripts/actions`.

Known scoring needs:

- Pet stats and mods must merge master gear, pet gear mods, food pet mods, maneuvers, Avatar's Favor, aftermath, and job abilities.
- Pet attacks use the public physical hit/pDIF/TP systems where applicable, but several comments in Catseye public code mark pet formulas as unconfirmed.
- Automaton attachments create dynamic mods based on maneuvers and attachment formulas.
- Avatar's Favor can add or remove pet stats and aura effects, including MATT, ATTP, ACC, DEFP, MEVA, MDEF, crit, refresh, and Subtle Blow depending on avatar.
- Wyvern magic burst breath behavior may affect macc/damage differently than player spell bursts.

Implementation note: pet jobs need a master+pet combined objective. A good BST/PUP/SMN/DRG set may lose master DPS if pet expected DPS or pet accuracy/macc increases more.

## Abilities and Special Magic-Like Damage

Quick Draw:

- Elemental shot ability scripts set `targetTPMult = 0`, so public Catseye Quick Draw does not feed TP.
- Quick Draw should use its ability parameters plus magic accuracy/damage-like handling where server scripts route it.

Rune Fencer:

- Swipe/Lunge/Gambit/Rayke live in `scripts/globals/job_utils/rune_fencer.lua`.
- Swipe/Lunge damage multipliers use shared magic damage functions, including `calculateMagicBonusDiff`.
- Gambit modifies elemental SDT.
- Rayke modifies resistance rank and can interact with nuke wall reduction.

Geomancer:

- Cardinal Chant is included in direct spell MAB, magic crit, macc, and magic burst bonus paths.
- GEO style scoring should know caster orientation to target if Cardinal Chant is active.

Scholar:

- Ebullience and Rapture are direct multipliers in spell/cure paths.
- Klimaform adds macc when weather matches.
- SCH job points can add macc under Penury/Parsimony and magic damage under stratagem effects.
- Helix spells force day/weather behavior and have helix-specific damage bonuses.

## Food, Merits, Traits, and Augments

Food:

- OddLua imports food effects from scripts, not static names, in `src/oddlua/statsdb.py:774-865`.
- Food mods include player and pet targets.
- Food cap mods matter: `FOOD_ATTP`, `FOOD_ATT_CAP`, `FOOD_ACCP`, `FOOD_ACC_CAP`, `FOOD_MACCP`, `FOOD_MACC_CAP`, etc.
- Food should be scored as an optional gear-like modifier with duration and target type.

Merits and traits:

- OddLua imports `merits` and `traits` in `src/oddlua/statsdb.py:212-233`.
- Server formulas call merits directly in many places: crit rate, Subtle Blow, NIN magic, elemental potency, Ancient Magic, SCH/RDM/GEO/BLM job point-adjacent paths, Monster Correlation, Immunobreak, and more.
- Traits should be treated as actor mods by job/level/rank before gear scoring.

Augments:

- OddLua imports augment definitions in `src/oddlua/statsdb.py:202-210`.
- Augment resolution must preserve pet vs player target and multiplier behavior.
- Gear classification must use resolved augment mods, not display-name hints.

Current OddLua risk:

- `WeaponStats.dps_score` in `src/oddlua/itemstats.py:138-142` is only `damage * hit / delay`. This is useful as a crude tie-breaker but is not a real DPS calculator.
- Real set generation must run the mechanics model. Otherwise it will keep making mistakes like overvaluing a weapon or armor piece because a name or simplified tag was misclassified.

## Expanded Effect Surface

Real set generation has to model the whole combat state, not just static gear. The scoring input should be:

```text
expected_output = f(actor_state, target_state, action_or_rotation, active_effects, resources, timing)
```

Where `active_effects` includes gear, augments, food, merits, traits, job abilities, spell buffs, songs, rolls, geomancy, pet effects, enemy debuffs, day/weather, aftermath, and live-only custom effects. The mistake to avoid is treating a set as "best" from item mods only. In FFXI, a gear piece can be correct under one buff package and wrong under another because it changes caps, recast, TP cycle, landing rate, or uptime.

Catseye public sources that need to be represented in the mechanics database:

- `sql/abilities.sql:6` stores ability job, level, target rules, recast, recast ID, action type, range, AOE, CE/VE enmity, merit recast modifier, and content tag.
- `sql/spell_list.sql:19` stores spell job availability, group, family, element, target rules, skill, MP cost, cast time, recast time, messages, AOE, base, multiplier, CE/VE, range, radius, requirements, and content tag.
- `sql/status_effects.sql:19` stores status IDs, flags, positive/negative type, overwrite, block, remove, element, minimum duration, and sorting behavior.
- `sql/traits.sql:19` stores trait ID, job, level, rank, modifier, value, content tag, and merit hook.
- `sql/merits.sql:6` stores merit upgrades and values used by many combat formulas.
- `sql/abilities_charges.sql`, `sql/item_mods_pet.sql`, `sql/pet_skills.sql`, `sql/automaton_abilities.sql`, `sql/automaton_spells.sql`, `sql/blue_traits.sql`, `sql/despoil_effects.sql`, and `sql/zone_weather.sql` all affect real output for at least one job/style.

Current OddLua data coverage:

- Present: equipment, weapons, base item mods, augments, merits, traits, food scripts, weapon skills, usable items, and core mob resistance/pool/family/group data.
- Missing for full calculated output: ability metadata, status metadata, spell metadata, ability charge data, pet gear mods, pet skills, automaton spells/abilities, puppet attachment/item data, blue trait composition, despoil tables, live `char_effects`, live job point state, and weather/zone context.
- Required next step: add these tables and extracted script facts to the stats database before trusting DPS/HPS/DoT/enfeeble rankings for non-melee styles.

## Abilities, Traits, and Uptime

Job abilities should be modeled in three layers.

1. Ability availability and timing:
   - Use `abilities.sql` for job, level, recast, recast ID, target legality, range, AOE, and CE/VE.
   - Use charge tables for abilities with stored charges or shared charge groups.
   - Apply merit and gear recast reductions, then calculate uptime over the scoring window.
   - Include resource costs: TP, MP, finishing moves, runes, stratagem charges, maneuvers, shadows, pet status, ammunition, cards, and ability-specific requirements.

2. Ability-created status effects:
   - Use script behavior under `scripts/actions/abilities/*` to map ability to `addStatusEffect` or direct modifier changes.
   - Resolve potency, tick, duration, subpower, tier, overwrite, block, and removal through `status_effects.sql` and script arguments.
   - Convert temporary effects into expected uptime, not permanent stats.

3. Formula-changing abilities:
   - Some abilities directly modify the next action rather than just adding a visible buff. Examples include Sneak Attack, Trick Attack, Warcry, Berserk, Aggressor, Last Resort, Souleater, Hasso, Seigan, Meditate, Sekkanoki, Sengikori, Futae, Innin, Yonin, Chain Affinity, Burst Affinity, Efflux, Elemental Seal, Divine Seal, Saboteur, Stymie, Rapture, Ebullience, Klimaform, Immanence, Perpetuance, Penury, Parsimony, Alacrity, Celerity, Accession, Manifestation, Velocity Shot, Barrage, Sharpshot, Double Shot, Triple Shot, Phantom Roll, Quick Draw, Flourishes, Sambas, Waltzes, and Geomancer bubbles.
   - These need action-specific hooks in the calculator. A static mod sum cannot express "this modifies only the next nuke", "this modifies only the next cure", or "this changes TP cycle for 60 seconds."

Traits should be split into passive, proc, and conditional traits:

- Passive traits: Accuracy Bonus, Attack Bonus, Defense Bonus, Evasion Bonus, Magic Attack Bonus, Magic Defense Bonus, Magic Accuracy Bonus, Store TP, Dual Wield, Martial Arts, Max HP/MP boosts, Clear Mind, Auto Refresh, Auto Regen, and similar always-on modifiers.
- Proc traits: Double Attack, Triple Attack, Quadruple Attack, Zanshin, Counter, Kick Attacks, Conserve MP, Occult Acumen, Rapid Shot, Snapshot, Shield Mastery, Guarding, Parrying, Resist traits, Killer effects, and Treasure Hunter.
- Conditional traits: Fencer, Tactical Guard, Smite, Stalwart Soul, closed/open-position traits, weapon-specific or subjob-gated traits, blue magic set traits, pet-owner traits, and Catseye custom traits.

For scoring, passive traits enter actor state directly. Proc traits enter as expected values. Conditional traits enter only when their condition is true for the selected style, weapon, target, or rotation.

## Buff and Debuff State

Buffs and debuffs are first-class scoring inputs. A set that is best with capped magic haste, capped attack, and Honor March-style support may not be best when solo or under partial support.

Required active-effect fields:

- Source: gear, augment, food, trait, merit, job ability, spell, song, roll, geomancy, pet, aftermath, atma, trust, enemy action, or live custom module.
- Target: player, party, pet, automaton, avatar, wyvern, luopan, enemy, or area.
- Modifiers: direct mods, pet mods, skill mods, enmity mods, status resistance mods, SDT/MDT/PDT/DT mods, and hidden formula flags.
- Potency model: fixed, skill-scaled, merit-scaled, job-point-scaled, roll-value-scaled, random/proc-based, or live-verified.
- Duration and tick: base duration, tick interval, remaining time, duration gear, duration merits, resist duration, overwrite rules, block rules, and removal rules.
- Scope: applies to every hit, first hit only, next action only, next spell only, weapon skill only, magic burst only, cure only, pet only, or party only.
- Uptime: expected percentage of the scoring window, including recast, charges, animation/cast lock, resource availability, and chosen rotation.

Model support effects as cap-aware multipliers:

- Haste, March, Haste Samba, Haste spell, Embrava, and gear haste must feed the attack-delay and recast models with the correct cap families.
- Accuracy, magic accuracy, attack, ranged attack, magic attack, evasion down, defense down, magic defense down, elemental resistance down, and SDT changes have marginal value only until the relevant cap or target threshold.
- Refresh, Regen, Regain, Store TP, Save TP, Conserve MP, and MP cost reduction change sustainable output over time, not single-action damage.
- Enmity, damage taken, shield/block, magic evasion, status resistance, Stoneskin, Blink, Utsusemi, Phalanx, Aquaveil, and cures affect defensive or tank styles even when they do not directly raise DPS.

Important Catseye public support sources:

- Corsair roll tables and roll duration/recast logic live in `scripts/globals/job_utils/corsair.lua:17-171`. Rolls include accuracy, attack, Store TP, refresh, double attack, magic attack, regen, fast cast, and more. `PHANTOM_ROLL` gear is handled as a max gear mod, so the calculator must not simply sum all roll-plus pieces.
- Geomancer GEO/Indi effects and potency scaling live in `scripts/globals/job_utils/geomancer.lua:40-262`. Potency is based on combined geomancy and handbell skill, clamped by effect-specific tables, with gear multipliers and special handling for Entrust/Bolster/luopan state.
- Bard enhancing and enfeebling songs live in `scripts/globals/spells/enhancing_song.lua:30-310` and `scripts/globals/spells/enfeebling_song.lua:22-244`. Song power and duration depend on song table data, singing/instrument skill, song-specific gear, all-songs gear, Soul Voice, Marcato, Troubadour, merits, and job points.
- Enhancing spell tables and effect handling live in `scripts/globals/spells/enhancing_spell.lua:28-581`. This covers Haste, Flurry, Phalanx, Refresh, Regen, Stoneskin, spikes, Temper, duration logic, Composure, Embolden, and Perpetuance.

## DoT, HoT, and Tick Effects

Tick effects matter for DPS, HPS, MP sustain, and enfeeble value. They need a shared model:

```text
expected_tick_total =
    landing_probability
  * tick_power
  * floor(effective_duration_seconds / tick_interval_seconds)

expected_tick_dps_or_hps = expected_tick_total / scoring_window_seconds
```

For partial resists, use the landed duration/tier that Catseye applies, not the full tooltip duration. For overwrite or block cases, use the effective uptime after stronger/weaker effect rules.

Damage-over-time effects to capture:

- Poison, Bio, Dia, Burn, Frost, Choke, Rasp, Shock, Drown, Helix, Kaustra, Requiem, Geo-Poison, blue magic DoTs, ninjutsu DoTs if present, aftermath/additional-effect DoTs, pet DoTs, and Catseye custom DoTs.
- Some DoTs also change combat stats. Bio lowers attack. Dia lowers defense. Elemental debuffs lower stats and can change magic/physical performance indirectly.
- Quick Draw can amplify existing Bio, Dia, elemental debuffs, status potency, or Threnody in the elemental shot scripts. Examples: `dark_shot.lua:44-74`, `light_shot.lua:44-78`, and elemental shots such as `fire_shot.lua:34-74`, `ice_shot.lua:34-79`, and `water_shot.lua:34-79`.
- Helix damage is not just a nuke hit. Helix tables are in `scripts/globals/spells/damage_spell.lua:115-130`, Helix damage bonuses are applied around `damage_spell.lua:444-447`, merit multiplier around `damage_spell.lua:896-905`, final application around `damage_spell.lua:1167-1218`, and Modus Veritas changes helix power/duration in `scripts/actions/abilities/modus_veritas.lua:16-38`.

Healing-over-time and sustain effects to capture:

- Regen, Paeon, Geo-Regen, avatar/automaton/wyvern regen, food regen, Atma regen if used, aftermath regen, and trust or custom effects.
- Refresh, Ballad, Evoker's Roll, Geo-Refresh, automaton refresh, food refresh, Atma refresh if used, and Catseye custom refresh.
- Regain, Save TP, Store TP buffs, and TP-drain/TP-restore effects because they alter action frequency and WS cycle.

Tick effects should be evaluated both directly and indirectly. Example: Dia's DoT damage may be small, but defense down can be a large party DPS gain. The style objective must decide whether to score personal DPS only, party DPS, survival, sustain, or enfeeble utility.

## HPS and Healing Throughput

Healing sets should be scored as throughput, efficiency, and reliability, not only max cure number.

```text
expected_heal_per_action =
    base_heal_formula
  * cure_potency_terms
  * cure_received_terms
  * special_action_multipliers
  * landing_or_target_validity
  - expected_overheal

expected_hps =
    expected_heal_per_action / effective_heal_cycle_seconds
```

Required HPS inputs:

- Cure spell formula, Curaga/Cura behavior, blue magic cure behavior, Waltz behavior, Regen/HoT ticks, pet heals, and item heals.
- Cure Potency, Cure Potency II if present, Cure Potency Received, Waltz Potency, Waltz Cost, Waltz Delay, Divine Seal, Rapture, Afflatus Solace, Light Arts/Addendum bonuses, weather/day, staff affinity, magic burst-like special cases if custom, and Catseye settings for old cure formula.
- Effective cycle time: cast time, recast time, Fast Cast, cure cast time reduction, haste recast terms, animation lock, JA delay, song/spell recast categories, quick magic/procs, and interruption risk.
- Sustainability: MP cost, Conserve MP, refresh, sublimation, convert-like effects, aspir availability, TP cost for Waltzes, finishing-move costs, and inventory/item constraints.
- Reliability: target range, AOE radius, status locks, silence/amnesia/paralysis/stun, enmity created by healing, and threat/survivability while healing.

Catseye public Dancer Waltz formula is in `scripts/globals/job_utils/dancer.lua:16-537`: each Waltz has a constant, stat multiplier, and TP cost; final cure scales from target VIT plus player CHR, then `WALTZ_POTENCY` is capped at 50% in the public script. This means CHR/VIT and Waltz-specific mods are real HPS inputs, while unrelated combat-only stats should not win a Waltz set.

Healing output should have at least three style objectives:

- Burst heal: max expected heal on the next action, with overheal penalty optional.
- Sustained HPS: expected healing per second over a window with recast/resource limits.
- MP-efficient healing: expected healing per MP or per TP, including Refresh/Conserve MP/Sublimation support.

## Enfeeble, Control, and Debuff Value

Enfeebling sets should score expected value, not just magic accuracy. A landed Slow, Addle, Dia, Frailty, Elegy, Sleep, Dispel, Stun, or Threnody has value from potency, duration, and tactical impact.

```text
expected_enfeeble_value =
    landing_probability
  * effective_duration_seconds
  * potency_or_utility_value
  * target_relevance
```

Required enfeeble inputs:

- Magic accuracy, enfeebling/singing/ninjutsu/divine/dark/blue skill, elemental affinity, dSTAT, caster level, target level, target MEVA, target resistance rank, elemental SDT, status resistance rank, immunobreak rules, and custom immunity flags.
- Potency stats: MND, INT, CHR, skill, instrument skill, geomancy/handbell skill, merits, job points, gear potency, Saboteur, Stymie, Elemental Seal, Dark Seal, Divine Seal, Troubadour, Soul Voice, Marcato, Focalization, Bolster, and other job-specific amplifiers.
- Duration stats: base duration, duration gear, song duration gear, Saboteur duration, Troubadour, resist tier, minimum duration from `status_effects.sql`, overwrite/block/remove behavior, and target cleanse/dispel behavior.
- Tactical value: defense down, attack down, magic defense down, evasion down, magic evasion down, slow, paralyze, blind, addle, silence, amnesia, stun, bind, gravity, sleep, terror, plague, inhibit TP, stat down, elemental resistance down, dispel, and damage-over-time.

For set generation, enfeeble styles should define a target and threshold:

- `land_once`: maximize landing probability until the required reliability threshold, then favor duration or safety.
- `potency`: maximize effect strength after reaching a minimum landing probability.
- `duration`: maximize effective uptime after reaching a minimum landing probability.
- `party_dps_debuff`: convert defense down, magic defense down, evasion down, magic evasion down, Threnody, and Frailty/Malaise-style effects into expected party damage gain.
- `control`: prioritize Sleep, Stun, Bind, Gravity, Silence, Addle, and Amnesia reliability/duration over damage.

## Pets, Automatons, Avatars, Wyverns, and Luopans

Pet styles need a separate actor state plus a combined master/pet objective. Do not collapse pet gear into master stats.

Pet-specific data to import:

- `sql/item_mods_pet.sql` for gear mods targeted at pets, avatars, automatons, wyverns, and luopans.
- `sql/pet_skills.sql` for pet abilities.
- `sql/automaton_abilities.sql`, `sql/automaton_spells.sql`, and `sql/item_puppet.sql` for Puppetmaster.
- `scripts/globals/automaton.lua:48-296` for attachment and maneuver modifier behavior, including regen/refresh special cases.
- `scripts/actions/abilities/pets/*` for Blood Pact, Ready, automaton, and wyvern ability behavior.
- `scripts/globals/pets.lua`, `scripts/globals/pets/avatar.lua`, `scripts/globals/pets/automaton.lua`, `scripts/globals/pets/wyvern.lua`, and `scripts/globals/pets/luopan.lua` for pet lifecycle and family-specific behavior.

Pet scoring inputs:

- Pet base level/stats, skill, attack, accuracy, magic attack, magic accuracy, delay, TP gain, ability recast, blood pact delay, maneuvers, attachments, rolls/songs/geo effects that apply to pets, pet food, pet gear mods, master job abilities, pet survivability, and target resistances.
- Master contribution, pet contribution, and opportunity cost. Example: a master TP piece that lowers pet DPS may still win for hybrid style, while a pet-only piece may win for pet burst style.
- Luopan scoring should include geomancy potency, luopan HP/decay, luopan regen, damage taken, Bolster/Blaze behavior, and whether the bubble affects the current actor, party, pet, or enemy.

## Enmity, Survival, and Reliability

DPS and HPS are not enough for tank, support, and live-safe sets.

Required non-output modifiers:

- CE/VE from `abilities.sql` and `spell_list.sql`, plus damage/cure-generated enmity.
- Enmity+ and enmity- gear, job abilities, merits, food, songs/rolls/geo, and status effects.
- Damage Taken, Physical Damage Taken, Magic Damage Taken, Breath Damage Taken, block/parry/guard/counter, shield size/rate, Stoneskin, Phalanx, Blink, Utsusemi shadows, Aquaveil, status resistance, magic evasion, and elemental resistance.
- Interruption rate, spell pushback/lock, amnesia/silence/paralysis/stun risk, ability range, spell range, AOE radius, and target movement.

For PLD, RUN, WHM, SCH, BRD, GEO, COR, and pet jobs, a style set may optimize "damage while staying above a survival threshold" rather than raw damage. The calculator should support constraints like minimum DT, minimum HP, minimum magic evasion, minimum enmity, capped Fast Cast, or required song/roll/geo duration before maximizing output.

## Rotation and Context Requirements

Some mechanics only make sense inside a rotation. The generator should store both gear sets and the assumptions that made them best.

Required context fields:

- Scoring window seconds.
- Buff package: solo, trust, party, capped haste, uncapped haste, caster support, melee support, pet support, or custom.
- Target preset or concrete mobdb target.
- Action priority: auto-attack, WS, nuke, magic burst, DoT, enfeeble, cure, Waltz, pet action, tanking, or hybrid.
- Resource policy: TP spend threshold, MP floor, JA usage, spell list, food allowed, medicines/items allowed, pet allowed, trusts allowed.
- Uptime policy: include or exclude two-hours, SP abilities, long recast abilities, prebuffs, aftermath, atma, and live-only buffs.

Output should include an explanation trace:

- Which caps were reached.
- Which support effects were assumed.
- Which target weakness/resistance drove the winner.
- Which gear pieces are only correct because of a buff, debuff, food, pet, or duration assumption.
- Which mechanics were live-verified, Catseye-public-derived, BG-fallback-derived, or unresolved.

## Set Scoring Architecture

The minimum reliable scoring stack:

1. Build actor state.
   - Base stats by race/job/level.
   - Subjob and traits.
   - Skills, merits, job points if available.
   - Buffs/status effects.
   - Gear, augments, food, pet mods.
2. Build target state.
   - Concrete mobdb target or preset.
   - Level, stats, DEF/EVA/MEVA/MDB.
   - Physical SDT and elemental SDT.
   - Resistance ranks and status ranks.
   - Family/ecosystem and pool/species overrides.
3. Select objective.
   - TP DPS.
   - WS damage.
   - Full TP-cycle DPS.
   - Ranged DPS.
   - Nuke expected damage.
   - Magic burst expected damage.
   - Magic accuracy / enfeebling reliability.
   - Cure output.
   - Tank effective damage taken.
   - Pet/master combined output.
4. Compute expected value.
   - Hit probability.
   - Multi-attack expected hits.
   - Crit expected value.
   - Average pDIF.
   - Average resist tier or probability-weighted landing/duration.
   - TP return and rounds-to-WS.
   - SDT and damage taken.
   - Skillchain/MB contribution if a sequence is known.
5. Rank sets with constraints.
   - Owned gear from snapshot.
   - Job/level/equip eligibility.
   - Slot locks and style locks.
   - Accuracy/macc thresholds.
   - Haste/dual-wield caps.
   - User overrides.

Recommended formulas:

```text
expected_auto_dps =
    attack_rounds_per_second
  * expected_landed_hits_per_round
  * expected_damage_per_landed_hit

expected_tp_per_second =
    attack_rounds_per_second
  * expected_landed_hits_per_round
  * expected_tp_per_landed_hit

tp_cycle_seconds = tp_needed_for_ws / expected_tp_per_second

expected_cycle_damage =
    expected_auto_dps * tp_cycle_seconds
  + expected_ws_damage
  + expected_skillchain_damage
  + expected_enspell_or_additional_damage
  + expected_pet_or_proc_damage

expected_cycle_dps = expected_cycle_damage / tp_cycle_seconds
```

For magic:

```text
expected_spell_damage =
    sum(resist_tier_probability[tier] * damage_at_tier[tier])

expected_spell_dps =
    expected_spell_damage / effective_cast_cycle_seconds
```

For enfeebles:

```text
expected_enfeeble_value =
    landing_probability
  * expected_duration
  * potency_value_for_style
```

## Job Style Guidance

The four style sets per job should be objective functions, not hand labels.

Examples:

- Melee damage: full TP-cycle DPS against selected target profile.
- Accuracy: damage with a minimum hit-rate threshold, prioritizing ACC only until cap or target threshold.
- WS: expected WS damage at selected TP and buff state.
- Defensive: expected incoming damage reduction and survival utility.
- Nuke: expected spell damage, including resist and nuke wall.
- Magic Burst: burst-specific expected damage, including burst macc, rank bonus, and MB caps.
- Magic Accuracy: landing/duration reliability for enfeebles, songs, sleeps, dispels, absorbs.
- Fast Cast/Recast: spell throughput and interruption reduction, separate from damage.
- Cure: expected cure output or MP-efficient cure output.
- Pet: combined master and pet objective.

Target weakness should select different winners:

- PLD Damage can choose sword, club, or hybrid based on target physical SDT and WS options.
- SCH Nuke should choose element from target elemental SDT/resistance rank, weather/day, Helix behavior, and MB window.
- THF melee should care about DEX/AGI/STR/attack/accuracy/Store TP/dual wield only through calculated DPS and WS cycle, not because a slot name looks like a DEX item.

## Live Verification With Deeps.dll

Use Deeps.dll/live parses to calibrate these high-risk areas:

- Old vs new magic damage on live Catseye.
- Ranged distance penalty disabled/enabled on live Catseye.
- pDIF average and caps at the level range being tested.
- Catseye custom weapon skill damage changes, such as Wasp Sting/Viper Bite.
- Private-module overrides for traits, job changes, and ability behavior.
- Food and augment behavior when the client tooltip differs from public SQL/scripts.
- Multi-attack and fTP carry behavior for the specific jobs/WS in the release.

Recommended parse loop:

1. Generate expected set and expected DPS terms.
2. Run controlled live target test with fixed buffs/food and target.
3. Record Deeps parse, actor snapshot, target, day/weather, buffs, and rotation.
4. Compare predicted melee hit range, WS average, TP rate, nuke value, and total DPS.
5. Store calibration deltas by mechanics profile, not by item name.

## Open Gaps

- Public Catseye branch is incomplete without private modules. Any formula can be live-overridden.
- Catseye Jobs page says ranged distance penalty is disabled, while public code contains ranged distance penalties. This is a live verification blocker for RNG/COR/THF throwing and ranged WS scoring.
- Catseye custom job/WS changes from wiki/patch notes need structured import into the mechanics profile.
- Job points may not exist or may differ depending on Catseye mode/progression. Treat unavailable progression as zero, not as retail default.
- Mob stats may need runtime verification for NMs with scripts or mods not captured by SQL-only profiles.
- Skillchain and MB contribution require a chosen rotation. Gear-only scoring should not assume skillchains unless the style or job profile defines them.
- Some pet formulas in public code are marked unconfirmed. Pet job output should be calibrated live.

## BG-Wiki Fallback Reference Links

Use these only when Catseye code/cache does not provide a direct answer:

- pDIF: https://www.bg-wiki.com/ffxi/PDIF
- fSTR/fSTR2: https://www.bg-wiki.com/ffxi/FSTR
- Hit Rate: https://www.bg-wiki.com/ffxi/Hit_Rate
- Attack Speed: https://www.bg-wiki.com/ffxi/Attack_Speed
- Tactical Points: https://www.bg-wiki.com/ffxi/Tactical_Points
- Subtle Blow: https://www.bg-wiki.com/ffxi/Subtle_Blow
- Weapon Skill Damage: https://www.bg-wiki.com/ffxi/Weapon_Skill_Damage
- Magic Damage: https://www.bg-wiki.com/ffxi/Magic_Damage
- Magic Accuracy: https://www.bg-wiki.com/ffxi/Magic_Accuracy
- Magic Burst: https://www.bg-wiki.com/ffxi/Magic_Burst
- Skillchain: https://www.bg-wiki.com/ffxi/Skillchain
- Cure Formula: https://www.bg-wiki.com/ffxi/Cure_Formula
- Job Ability: https://www.bg-wiki.com/ffxi/Category:Job_Ability
- Job Trait: https://www.bg-wiki.com/ffxi/Category:Job_Traits
- Enfeebling Magic: https://www.bg-wiki.com/ffxi/Category:Enfeebling_Magic
- Enhancing Magic: https://www.bg-wiki.com/ffxi/Category:Enhancing_Magic
- Fast Cast: https://www.bg-wiki.com/ffxi/Fast_Cast
- Spell Recast: https://www.bg-wiki.com/ffxi/Spell_Recast
- Damage Over Time: https://www.bg-wiki.com/ffxi/Damage_Over_Time
- Regen: https://www.bg-wiki.com/ffxi/Regen
- Refresh: https://www.bg-wiki.com/ffxi/Refresh
- Enspell: https://www.bg-wiki.com/ffxi/Enspell
- Waltz: https://www.bg-wiki.com/ffxi/Waltz
- Phantom Roll: https://www.bg-wiki.com/ffxi/Phantom_Roll
- Geomancy: https://www.bg-wiki.com/ffxi/Category:Geomancy
- Enmity: https://www.bg-wiki.com/ffxi/Enmity
- Pet: https://www.bg-wiki.com/ffxi/Category:Pets
- Catseye Jobs notes: https://www.bg-wiki.com/ffxi/CatsEyeXI_Systems/Jobs
