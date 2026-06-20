from pathlib import Path
import sqlite3
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from oddlua.catseye_equipment_audit import audit_catseye_equipment_catalog, parse_wiki_stat_mods
from oddlua.catseye_wiki_stats import parse_wiki_conditional_stat_mods
from audit_catseye_equipment_catalog import catalog_budget_failures


def test_parse_wiki_stat_mods_extracts_somnia_hidden_effects_and_ignores_augments() -> None:
    stats = """
    DMG:42 Delay:201
    Accuracy+15
    Occasionally attacks twice
    Increases "Double Attack" damage
    Hidden Effect: All elements affinity +2
    Image: AugRank.png Accuracy+0~8
    Image: AugRank.png Haste+0~3%
    """

    mods = parse_wiki_stat_mods(stats)

    assert mods["ACC"] == 15
    assert mods["FIRE_STAFF_BONUS"] == 2
    assert mods["LIGHT_STAFF_BONUS"] == 2
    assert mods["DARK_STAFF_BONUS"] == 2
    assert mods["MYTHIC_OCC_ATT_TWICE"] == 1
    assert mods["DOUBLE_ATTACK_DMG"] == 3
    assert "HASTE_GEAR" not in mods


def test_parse_wiki_stat_mods_ignores_hidden_crafting_skill_direct_mods() -> None:
    stats = "MP+6 INT+1 Hidden Effect: Alchemy Skill+1 Cooking Skill+1"

    mods = parse_wiki_stat_mods(stats)

    assert mods == {"MP": 6, "INT": 1}


def test_catalog_budget_failures_report_structural_mismatch_overages() -> None:
    summary = {
        "equipment_mismatches": 1,
        "weapon_mismatches": 2,
        "stat_mismatches": 999,
    }

    assert catalog_budget_failures(summary, max_equipment_mismatches=0, max_weapon_mismatches=1) == (
        "equipment_mismatches 1 exceeds max 0",
        "weapon_mismatches 2 exceeds max 1",
    )


def test_parse_wiki_stat_mods_extracts_catseye_occ_attacks_ranges() -> None:
    mods = parse_wiki_stat_mods("DMG:11 Delay:264 Occasionally attacks 2-4")

    assert mods["MAX_SWINGS"] == 4
    assert "MYTHIC_OCC_ATT_TWICE" not in mods


def test_parse_wiki_stat_mods_extracts_enhances_double_attack_parenthetical() -> None:
    mods = parse_wiki_stat_mods(
        'Enhances "Double Attack" effect (+6%) "Store TP"+2 (Cannot equip with NQ)'
    )

    assert mods["DOUBLE_ATTACK"] == 6
    assert mods["STORETP"] == 2


def test_parse_wiki_stat_mods_keeps_base_stats_before_latent_clause_on_same_line() -> None:
    stats = """
    DMG:36 Delay:224 INT+5 MND+5 Haste+2% Enfeebling magic skill +5 Cure potency +10% Latent effect: DMG:38
    (Latent Activation: Level 60+)
    """

    mods = parse_wiki_stat_mods(stats)

    assert mods["INT"] == 5
    assert mods["MND"] == 5
    assert mods["HASTE_GEAR"] == 200
    assert mods["CURE_POTENCY"] == 10


def test_parse_wiki_stat_mods_accepts_quoted_spell_and_spaced_magic_accuracy_text() -> None:
    stats = 'DMG:31 Delay:216 INT+3 MND+3 "Magic Atk. Bonus"+5 Magic Accuracy +2 "Cure" potency +10%'

    mods = parse_wiki_stat_mods(stats)

    assert mods["INT"] == 3
    assert mods["MND"] == 3
    assert mods["MATT"] == 5
    assert mods["MACC"] == 2
    assert mods["CURE_POTENCY"] == 10


def test_parse_wiki_stat_mods_extracts_erudite_cure_cast_and_ignores_augment_ranges() -> None:
    stats = (
        'DEF:25 MP+30 VIT+3 INT+5 Magic Accuracy+5 "Cure" spellcasting time -5% '
        "MND+0~5 Enmity-0~5 Fast Cast+0~2%"
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["DEF"] == 25
    assert mods["MP"] == 30
    assert mods["VIT"] == 3
    assert mods["INT"] == 5
    assert mods["MACC"] == 5
    assert mods["CURE_CAST_TIME"] == -5
    assert "MND" not in mods
    assert "ENMITY" not in mods
    assert "FASTCAST" not in mods


def test_parse_wiki_stat_mods_extracts_common_catseye_visible_direct_stats() -> None:
    stats = (
        'HP+3% MP+2% Evasion+5 Magic Evasion+4 Magic Def. Bonus+3 '
        'HP recovered while healing +2 MP recovered while healing+3 "Store TP"+4 '
        '"Subtle Blow"+5 "Counter"+2 Dual Wield+3 Healing magic skill +9 '
        'Parrying skill +10 Snapshot+7 Rapid Shot+8 Cure potency II +10% '
        'Cure received+5% Waltz Potency+3% Waltz delay -2 TP Bonus+500'
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["HPP"] == 3
    assert mods["MPP"] == 2
    assert mods["EVA"] == 5
    assert mods["MEVA"] == 4
    assert mods["MDEF"] == 3
    assert mods["HPHEAL"] == 2
    assert mods["MPHEAL"] == 3
    assert mods["STORETP"] == 4
    assert mods["SUBTLE_BLOW"] == 5
    assert mods["COUNTER"] == 2
    assert mods["DUAL_WIELD"] == 3
    assert mods["HEALING"] == 9
    assert mods["PARRY"] == 10
    assert mods["SNAPSHOT"] == 7
    assert mods["RAPID_SHOT"] == 8
    assert mods["CURE_POTENCY_II"] == 10
    assert mods["CURE_POTENCY_RCVD"] == 5
    assert mods["WALTZ_POTENCY"] == 3
    assert mods["WALTZ_DELAY"] == -2
    assert mods["TP_BONUS"] == 500


def test_parse_wiki_stat_mods_extracts_quoted_snapshot_aliases() -> None:
    mods = parse_wiki_stat_mods('"Snapshot" -3 "Snapshot"+2 Snapshot+7 Snapshot +0~3')

    assert mods["SNAPSHOT"] == 6


def test_parse_wiki_stat_mods_extracts_direct_killer_effects() -> None:
    stats = 'Demon Killer+2 "Bird Killer"+3 Empty Killer+4 "Vermin Killer"+5'

    mods = parse_wiki_stat_mods(stats)

    assert mods["DEMON_KILLER"] == 2
    assert mods["BIRD_KILLER"] == 3
    assert mods["EMPTY_KILLER"] == 4
    assert mods["VERMIN_KILLER"] == 5


def test_parse_wiki_stat_mods_extracts_successful_block_rate() -> None:
    mods = parse_wiki_stat_mods("Chance of successful block +3 Chance of successful block+5")

    assert mods["SHIELDBLOCKRATE"] == 8


def test_parse_wiki_stat_mods_extracts_swordplay_but_not_trait_tier_names() -> None:
    mods = parse_wiki_stat_mods(
        "Swordplay +3 Fencer+1 Magic skill+3 Synthesis skill +2"
    )

    assert mods == {"SWORDPLAY": 3}


def test_parse_wiki_stat_mods_extracts_crafting_success_and_blood_boon() -> None:
    mods = parse_wiki_stat_mods(
        'Synthesis Success Rate +5% " Blood Boon "+5 "Blood Boon"+3'
    )

    assert mods == {
        "BLOOD_BOON": 8,
        "SYNTH_SUCCESS_RATE": 5,
    }


def test_parse_wiki_stat_mods_extracts_drain_aspir_potency() -> None:
    stats = (
        'Drain/Aspir +20 Drain/Aspir+21 "Drain" and "Aspir" Potency+5 '
        '"Drain" and "Aspir" potency +5 Enhances "Drain" and "Aspir" (+15)'
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["ENH_DRAIN_ASPIR"] == 66


def test_parse_wiki_stat_mods_extracts_quoted_combat_and_burst_aliases() -> None:
    stats = (
        '"Conserve MP"+2 "Zanshin"+3 "Rapid Shot"+4 Fast Cast+2 '
        '"Kick Attacks"+5 Skillchain Bonus+4 Magic burst damage +3'
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["CONSERVE_MP"] == 2
    assert mods["ZANSHIN"] == 3
    assert mods["RAPID_SHOT"] == 4
    assert mods["FASTCAST"] == 2
    assert mods["KICK_ATTACK_RATE"] == 5
    assert mods["SKILLCHAINBONUS"] == 4
    assert mods["MAGIC_BURST_BONUS_CAPPED"] == 3


def test_parse_wiki_stat_mods_extracts_explicit_enhances_effect_bonuses() -> None:
    stats = (
        'Enhances "Dual Wield" effect +3% Enhances "Dual Wield" effect (+2%) '
        'Enhances "Fast Cast" effect (+1%) Enhances Fast Cast effect +10 '
        'Enhances "Fast Cast" effect (Fast Cast: +5%)'
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["DUAL_WIELD"] == 5
    assert mods["FASTCAST"] == 16


def test_parse_wiki_stat_mods_extracts_high_confidence_catseye_effect_aliases() -> None:
    stats = (
        "Atack+8 Parry Skill+3 Parrying rate +5% Recycle+5 Steal+1 "
        "Treasure Hunter+2 Reduces enmity loss -10% All elemental resistances+5 "
        'All songs +1 March+2 Geomancy +2 Slow+13% "Slow"+4%'
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["ATT"] == 8
    assert mods["PARRY"] == 3
    assert mods["INQUARTATA"] == 5
    assert mods["RECYCLE"] == 5
    assert mods["STEAL"] == 1
    assert mods["TREASURE_HUNTER"] == 2
    assert mods["ENMITY_LOSS_REDUCTION"] == 10
    assert mods["FIRE_MEVA"] == 5
    assert mods["DARK_MEVA"] == 5
    assert mods["ALL_SONGS_EFFECT"] == 1
    assert mods["MARCH_EFFECT"] == 2
    assert mods["GEOMANCY_BONUS"] == 2
    assert mods["HASTE_GEAR"] == -1700


def test_parse_wiki_stat_mods_extracts_summoner_delay_and_perpetuation_reductions() -> None:
    stats = (
        "MP+45 Blood Pact ability delay -4 Avatar perpetuation cost -1 "
        "Avatar Perpetuation-2 Avatar Perpetuation -3"
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["MP"] == 45
    assert mods["BP_DELAY"] == 4
    assert mods["PERPETUATION_REDUCTION"] == 6
    assert "AVATAR_PERPETUATION" not in mods


def test_parse_wiki_stat_mods_extracts_quoted_catseye_job_ability_mods() -> None:
    stats = (
        '"Blood Pact" ability delay-2 "Blood Pact" recast time II-2 '
        '" Sic " and " Ready " ability delay-2 "Barrage"+1 "Dead Aim"+5 '
        '"Berserk/Aggressor" effect duration+10 "Berserk" effect duration+15'
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["BP_DELAY"] == 2
    assert mods["BP_DELAY_II"] == 2
    assert mods["SIC_READY_RECAST"] == 2
    assert mods["BARRAGE_COUNT"] == 1
    assert mods["DEAD_AIM_EFFECT"] == 5
    assert mods["BERSERK_DURATION"] == 25
    assert mods["AGGRESSOR_DURATION"] == 10


def test_parse_wiki_stat_mods_extracts_quote_wrapped_catseye_passive_mods() -> None:
    stats = (
        '"Magic Attack Bonus"+6 "Ninja Tool Expertise"+5 "Occult Acumen"+20 '
        '"Paeon"+3 "Pflug"+10 "Recycle"+5 "Regen" Duration+20 '
        '"Requiem"+2 "Resist Bind"+3 "Samba" Duration+20 "Steal"+1 '
        '"Tandem Blow" effect+6 "Tandem Strike" effect+6 "Triple Atk."+3% '
        '"Vivacious Pulse" potency+10% Indicolure spell duration+12'
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["MATT"] == 6
    assert mods["NINJA_TOOL"] == 5
    assert mods["OCCULT_ACUMEN"] == 20
    assert mods["PAEON_EFFECT"] == 3
    assert mods["PFLUG"] == 10
    assert mods["RECYCLE"] == 5
    assert mods["REGEN_DURATION"] == 20
    assert mods["REQUIEM_EFFECT"] == 2
    assert mods["BINDRES"] == 3
    assert mods["SAMBA_DURATION"] == 20
    assert mods["STEAL"] == 1
    assert mods["TANDEM_BLOW_POWER"] == 6
    assert mods["TANDEM_STRIKE_POWER"] == 6
    assert mods["TRIPLE_ATTACK"] == 3
    assert mods["VIVACIOUS_PULSE_POTENCY"] == 10
    assert mods["INDI_DURATION"] == 12


def test_parse_wiki_stat_mods_extracts_one_off_server_backed_effects() -> None:
    stats = (
        "Amnesia Resistance+15 Blood Pact damage+3% Breath damage dealt+10 "
        "Cooking Skill+1 Dark Skill+12 Dbl. Atk+2% "
        "Decreases likelihood of synthesis material loss+2%"
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["AMNESIARES"] == 15
    assert mods["BP_DAMAGE"] == 3
    assert mods["BREATH_DMG_DEALT"] == 10
    assert mods["COOK"] == 1
    assert mods["DARK"] == 12
    assert mods["DOUBLE_ATTACK"] == 2
    assert mods["SYNTH_MATERIAL_LOSS"] == 2


def test_parse_wiki_stat_mods_extracts_unsigned_synthesis_material_loss() -> None:
    mods = parse_wiki_stat_mods("Decreases likelihood of synthesis material loss 5%")

    assert mods["SYNTH_MATERIAL_LOSS"] == 5


def test_parse_wiki_stat_mods_extracts_catseye_typo_aliases() -> None:
    stats = (
        "Enmity Loss reduction-20 Enmity Loss Reduction+30 Enspell Damage Bonus+15 "
        "Elemental Skill+15 Guard skill+5 NinjutsuSkill+10 "
        "Occult Acument+5 Occult Occument+30 Ranged Atttack+8 "
        "Magic Def. Bonus-3%"
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["ENMITY_LOSS_REDUCTION"] == 50
    assert mods["ENSPELL_DMG_BONUS"] == 15
    assert mods["ELEM"] == 15
    assert mods["GUARD"] == 5
    assert mods["NINJUTSU"] == 10
    assert mods["OCCULT_ACUMEN"] == 35
    assert mods["RATT"] == 8
    assert mods["MDEF"] == -3


def test_parse_wiki_stat_mods_extracts_server_backed_catseye_aliases() -> None:
    stats = (
        "Rapid Shot+5% Rapidshot+5 Ranged delay -3% Jig Duration+20 "
        "Lullaby+3 Magic crit. hit rate+5 Magical Critical Hit Dmg+5% "
        "Maximum Finishing Moves+1 Repair Potency+10% "
        "Magic Damage Taken II -5% Physical Damage taken II -10% "
        "Phys. dmg. taken II-10%"
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["RAPID_SHOT"] == 10
    assert mods["RANGED_DELAYP"] == -3
    assert mods["JIG_DURATION"] == 20
    assert mods["LULLABY_EFFECT"] == 3
    assert mods["MAGIC_CRITHITRATE"] == 5
    assert mods["MAGIC_CRIT_DMG_INCREASE"] == 5
    assert mods["MAX_FINISHING_MOVE_BONUS"] == 1
    assert mods["REPAIR_POTENCY"] == 10
    assert mods["DMGMAGIC_II"] == -500
    assert mods["DMGPHYS_II"] == -2000
    assert "CRITHITRATE" not in mods


def test_parse_wiki_stat_mods_extracts_unquantified_dancer_duration_effects() -> None:
    stats = 'Increases "Jig" duration Increases "Samba" duration'

    mods = parse_wiki_stat_mods(stats)

    assert mods["JIG_DURATION"] == 25
    assert mods["SAMBA_DURATION"] == 30


def test_parse_wiki_stat_mods_extracts_server_backed_catseye_utility_effects() -> None:
    stats = (
        'Increases "Phantom Roll" area of effect+2 '
        "Grimoire: Spellcasting time-8% "
        '"Dark Arts"+17 "Light Arts"+17 '
        'Adds "Regen" effect Life Cycle+3 '
        'Adds "Regen" effect Utsusemi+1 '
        "Ironskin (Stoneskin+10 "
        "Elemental Debuff Potency+4"
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["ROLL_RANGE"] == 2
    assert mods["GRIMOIRE_SPELLCASTING"] == -8
    assert mods["DARK_ARTS_EFFECT"] == 17
    assert mods["LIGHT_ARTS_EFFECT"] == 17
    assert mods["LIFE_CYCLE_EFFECT"] == 3
    assert mods["UTSUSEMI_BONUS"] == 1
    assert mods["STONESKIN_BONUS_HP"] == 10
    assert mods["ELEMENTAL_DEBUFF_EFFECT"] == 4


def test_parse_wiki_stat_mods_extracts_catseye_resist_and_cast_aliases() -> None:
    stats = (
        "Elemental casting time -6% Elemental magic casting time-8% "
        'Resist Charm+15 Potency of "Cure" effect received+5% '
        'Potency of "Cure" received+15% Light Resist+13 Resist All Elements+10'
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["ELEMENTAL_CELERITY"] == 14
    assert mods["CHARMRES"] == 15
    assert mods["CURE_POTENCY_RCVD"] == 20
    assert mods["FIRE_MEVA"] == 10
    assert mods["ICE_MEVA"] == 10
    assert mods["WIND_MEVA"] == 10
    assert mods["EARTH_MEVA"] == 10
    assert mods["THUNDER_MEVA"] == 10
    assert mods["WATER_MEVA"] == 10
    assert mods["LIGHT_MEVA"] == 23
    assert mods["DARK_MEVA"] == 10


def test_parse_wiki_stat_mods_extracts_remaining_server_backed_aliases() -> None:
    stats = (
        "Resist Blind+3 Resist Petrify+15 Resist Silence+3 Resist Sleep+3 "
        "Silence Resistance+15 String Skill+8 Summoning skill+8 "
        "Song Duration Bonus+25 Subtle Blow II+6 "
        "Spell Interrupt-20% Spell Interruption Rate-15% "
        "Spell Interruption Rate Down+5%"
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["BLINDRES"] == 3
    assert mods["PETRIFYRES"] == 15
    assert mods["SILENCERES"] == 18
    assert mods["SLEEPRES"] == 3
    assert mods["STRING"] == 8
    assert mods["SUMMONING"] == 8
    assert mods["SONG_DURATION_BONUS"] == 25
    assert mods["SUBTLE_BLOW_II"] == 6
    assert mods["SPELLINTERRUPT"] == -30


def test_parse_wiki_stat_mods_extracts_high_confidence_catseye_utility_effects() -> None:
    stats = (
        'SP Ability delay -5 Resist "Death"+3 Resist Death+10 Fishing skill +2 '
        'Retaliation+3% Retaliation+5 Tactical Parry+10 "Daken"+3 Daken+5'
    )

    mods = parse_wiki_stat_mods(stats)

    assert mods["ONE_HOUR_RECAST"] == 5
    assert mods["DEATHRES"] == 13
    assert mods["FISH"] == 2
    assert mods["RETALIATION"] == 8
    assert mods["TACTICAL_PARRY"] == 10
    assert mods["DAKEN"] == 8


def test_parse_wiki_stat_mods_does_not_parse_percent_hp_and_mp_as_flat_values() -> None:
    mods = parse_wiki_stat_mods("HP+3% MP+2% HP+10% MP+12% HP+30 MP+20")

    assert mods["HPP"] == 13
    assert mods["MPP"] == 14
    assert mods["HP"] == 30
    assert mods["MP"] == 20


def test_parse_wiki_stat_mods_does_not_parse_multi_digit_ranges_as_partial_values() -> None:
    mods = parse_wiki_stat_mods("Accuracy+10~20 Attack+12~30 HP+30")

    assert mods == {"HP": 30}


def test_parse_wiki_stat_mods_does_not_fold_elemental_def_into_base_def() -> None:
    mods = parse_wiki_stat_mods(
        "DEF:33 HP+30 Enmity-5 "
        "Luzaf's Curse (Fire Def-20, Ice Def+15, Light Def-20, Dark Def+15, Regen+1)"
    )

    assert mods["DEF"] == 33
    assert mods["HP"] == 30
    assert mods["ENMITY"] == -5


def test_parse_wiki_stat_mods_does_not_parse_mp_conversion_as_flat_mp() -> None:
    mods = parse_wiki_stat_mods(
        'DEF:25 MP+15 Royal Knight\'s Pledge (Absorb Dmg to MP+2) "Conserve MP"+5'
    )

    assert mods["MP"] == 15
    assert mods["CONSERVE_MP"] == 5


def test_parse_wiki_stat_mods_keeps_base_stats_before_trailing_latent_activation() -> None:
    mods = parse_wiki_stat_mods(
        "DMG:40 Delay:276 Attack+15 Physical damage taken -10% Occasionally attacks twice "
        "Pet: Attack+15 Accuracy+10 (Latent Activation: Level 60+)"
    )

    assert mods["ATT"] == 15
    assert mods["DMGPHYS"] == -1000
    assert "DMG" not in mods


def test_parse_wiki_stat_mods_dedupes_repeated_damage_taken_wording() -> None:
    mods = parse_wiki_stat_mods(
        'DEF:42 Magic damage taken -2% STR+3 "Magic Damage Taken"-2%'
    )

    assert mods["DMGMAGIC"] == -200
    assert "DMG" not in mods


def test_parse_wiki_stat_mods_dedupes_repeated_negative_base_penalties() -> None:
    mods = parse_wiki_stat_mods(
        "DEF:46 HP+25 STR+3 DEX-3 VIT+3 AGI-3 INT-3 MND-3 CHR-3 "
        "Attack+20 STR+3 DEX-3 AGI-3 Attack+5 Double Attack+1%"
    )

    assert mods["STR"] == 6
    assert mods["ATT"] == 25
    assert mods["DEX"] == -3
    assert mods["AGI"] == -3


def test_parse_wiki_stat_mods_extracts_combined_accuracy_magic_accuracy_labels() -> None:
    mods = parse_wiki_stat_mods(
        'DEF:8 "Tandem Strike" effect +6 (Acc/M.Acc +6) '
        '"Tandem Blow" effect +6 (Subtle Blow II +6)'
    )

    assert mods["ACC"] == 6
    assert mods["MACC"] == 6


def test_parse_wiki_stat_mods_keeps_fixed_stats_when_augments_share_the_line() -> None:
    stats = 'DEF:35 DEX+2 AGI+9 Evasion+11 Haste+2% "Triple Attack"+2% DEX+0~5 Attack+0~5'

    mods = parse_wiki_stat_mods(stats)

    assert mods["DEF"] == 35
    assert mods["DEX"] == 2
    assert mods["AGI"] == 9
    assert mods["EVA"] == 11
    assert mods["HASTE_GEAR"] == 200
    assert mods["TRIPLE_ATTACK"] == 2
    assert "ATT" not in mods


def test_parse_wiki_stat_mods_accepts_negative_direct_stats() -> None:
    stats = 'Attack-6 Accuracy-3 HP-5 MP-5 Magic Accuracy-2 "Magic Atk. Bonus"-5'

    mods = parse_wiki_stat_mods(stats)

    assert mods["ATT"] == -6
    assert mods["ACC"] == -3
    assert mods["HP"] == -5
    assert mods["MP"] == -5
    assert mods["MACC"] == -2
    assert mods["MATT"] == -5


def test_parse_wiki_stat_mods_excludes_status_prefixed_stats_from_direct_mods() -> None:
    mods = parse_wiki_stat_mods("DEX+3 Paralysis: Accuracy+20")

    assert mods == {"DEX": 3}


def test_parse_wiki_conditional_stat_mods_extracts_latent_status_and_level_clauses() -> None:
    mods = parse_wiki_conditional_stat_mods(
        """
        DEF:15 HP+10
        Latent Effect (under Lv.31): DEX+1 Accuracy+50
        Latent Effect (Poisoned): Attack+7
        Latent effect: Enhancing magic duration+5% (when having Ice Spikes active)
        """
    )

    assert {
        (mod.mod_name, mod.value, mod.condition_type, mod.condition_name)
        for mod in mods
    } == {
        ("DEX", 1, "level_lt", "31"),
        ("ACC", 50, "level_lt", "31"),
        ("ATT", 7, "status", "poison"),
        ("ENH_MAGIC_DURATION", 5, "status", "ice_spikes"),
    }


def test_parse_wiki_conditional_stat_mods_extracts_poisoned_critical_hit_rate() -> None:
    mods = parse_wiki_conditional_stat_mods(
        """
        DEF:14 DEX+3 Haste+2%
        Latent Effect (Poisoned): Critical Hit Rate +3%
        Pet: Accuracy+5
        """
    )

    assert {
        (mod.mod_name, mod.value, mod.condition_type, mod.condition_name)
        for mod in mods
    } == {
        ("CRITHITRATE", 3, "status", "poison"),
    }


def test_parse_wiki_conditional_stat_mods_extracts_unknown_latent_stats() -> None:
    stats = 'DEF:18 Latent effect: Attack+10 Haste+2% "Double Attack"+3%'

    direct_mods = parse_wiki_stat_mods(stats)
    conditional_mods = parse_wiki_conditional_stat_mods(stats)

    assert "ATT" not in direct_mods
    assert "HASTE_GEAR" not in direct_mods
    assert "DOUBLE_ATTACK" not in direct_mods
    assert {
        (mod.mod_name, mod.value, mod.condition_type, mod.condition_name)
        for mod in conditional_mods
    } == {
        ("ATT", 10, "latent_unknown", "unspecified"),
        ("DOUBLE_ATTACK", 3, "latent_unknown", "unspecified"),
        ("HASTE_GEAR", 200, "latent_unknown", "unspecified"),
    }


def test_parse_wiki_conditional_stat_mods_extracts_set_bonus_critical_hit_rate() -> None:
    stats = "DEF:40 Set Bonus: Increases Rate of Critical Hits+5%"

    direct_mods = parse_wiki_stat_mods(stats)
    conditional_mods = parse_wiki_conditional_stat_mods(stats)

    assert "CRITHITRATE" not in direct_mods
    assert {
        (mod.mod_name, mod.value, mod.condition_type, mod.condition_name)
        for mod in conditional_mods
    } == {
        ("CRITHITRATE", 5, "set_bonus", "set"),
    }


def test_parse_wiki_stat_mods_moves_right_ear_skill_stats_to_conditionals() -> None:
    stats = (
        'MP+10 "Empty Killer"+5 Right ear: Magic skills +3 '
        "(incl. Blue, Geomancy, Handbell) Right ear: Evasion skill +3 Shield skill +3 "
        "Right ear: Parrying skill +3 Guarding skill +3"
    )

    direct_mods = parse_wiki_stat_mods(stats)
    conditional_mods = parse_wiki_conditional_stat_mods(stats)

    assert direct_mods == {"MP": 10, "EMPTY_KILLER": 5}
    assert {
        (mod.mod_name, mod.value, mod.condition_type, mod.condition_name)
        for mod in conditional_mods
    } == {
        ("EVASION", 3, "slot_side", "right_ear"),
        ("GUARD", 3, "slot_side", "right_ear"),
        ("PARRY", 3, "slot_side", "right_ear"),
        ("SHIELD", 3, "slot_side", "right_ear"),
    }


def test_parse_wiki_stat_mods_extracts_oboro_caster_staff_server_changes() -> None:
    stats = """
    DMG:58 Delay:366 MP+20 All Stats+6 All elemental resistances+20 "Iridescence" (10%)
    Elemental magic casting time-8% Occult Acumen+50
    Hidden Effect: All elements: Magic Potency+15%, Magic Accuracy+30
    """

    mods = parse_wiki_stat_mods(stats)

    for mod_name in ("STR", "DEX", "VIT", "AGI", "INT", "MND", "CHR"):
        assert mods[mod_name] == 6
    assert mods["MP"] == 20
    assert mods["OCCULT_ACUMEN"] == 50
    assert mods["IRIDESCENCE"] == 2
    assert mods["FIRE_STAFF_BONUS"] == 3
    assert mods["DARK_STAFF_BONUS"] == 3


def test_parse_wiki_stat_mods_extracts_quoted_iridescence_percentage() -> None:
    stats = 'MP+35 INT+6 MND+6 Accuracy+8 Enmity-4 "Iridescence" (15%)'

    mods = parse_wiki_stat_mods(stats)

    assert mods["IRIDESCENCE"] == 3


def test_parse_wiki_stat_mods_keeps_conserve_mp_separate_from_mp() -> None:
    stats = 'MP+40 INT+8 Enmity-4 "Iridescence" (10%) Grimoire: Spellcasting time -8% "Regen" Duration +20 Conserve MP +8'

    mods = parse_wiki_stat_mods(stats)

    assert mods["MP"] == 40
    assert mods["CONSERVE_MP"] == 8


def test_parse_wiki_stat_mods_does_not_count_pet_stats_as_player_stats() -> None:
    stats = 'DMG:+20 Delay:+84 HP+20 DEX+4 AGI+4 Accuracy+8 Evasion+5 Enmity-4 Pet: Accuracy+8 Double Attack +3%'

    mods = parse_wiki_stat_mods(stats)

    assert mods["ACC"] == 8
    assert "DOUBLE_ATTACK" not in mods


def test_parse_wiki_stat_mods_accepts_abbreviated_accuracy_labels() -> None:
    stats = 'Acc.+30 Magic Acc.+10 "Magic Atk. Bonus"+20'

    mods = parse_wiki_stat_mods(stats)

    assert mods["ACC"] == 30
    assert mods["MACC"] == 10
    assert mods["MATT"] == 20


def test_audit_reports_stale_retail_mods_when_wiki_record_is_authoritative(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Sword.txt").write_text(
        "\n".join(
            (
                "Somnia Melodiam",
                "[Sword]All Races",
                "DMG:42 Delay:201",
                "Accuracy+15",
                "Occasionally attacks twice",
                'Increases "Double Attack" damage',
                "Hidden Effect: All elements affinity +2",
                "Lv.75 RDM, BRD",
                "Dropped by Absolute Virtue.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert result.summary["records"] == 1
    assert result.summary["matched"] == 1
    assert result.summary["stat_mismatches"] >= 3
    messages = {finding.message for finding in result.findings}
    assert "Wiki stat is missing from item_mods." in messages
    assert "item_mods contains a comparable direct stat not present in the wiki record." in messages
    assert "Wiki weapon stat differs from item_weapon." in messages


def test_audit_uses_selected_duplicate_wiki_record_for_equipment_comparison(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.execute(
            "insert into items values (28201, 0, 'xux_trousers', 'xux_trousers', 'Armor', 1, '', '', 0)"
        )
        db.execute(
            "insert into item_equipment values (28201, 'Acrobat''s Breeches', 70, 0, 2593826, 0, 0, 0, 128, 0, 0, 0)"
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Acrobat's Breeches",
                "[Head]All Races",
                "DEF:28 Accuracy-10 Haste+6%",
                "Lv.75 MNK, THF, BST, RNG, NIN, BLU, COR, PUP, DNC, RUN",
                "Dropped in Dynamis 2.0.",
            )
        ),
        encoding="utf-8",
    )
    (wiki_pages / "CatsEyeXI_Content_Equipment_Legs.txt").write_text(
        "\n".join(
            (
                "Acrobat's Breeches",
                "[Legs]All Races",
                "DEF:35 DEX+2 AGI+9 Haste+2%",
                "Lv.70 MNK, THF, RNG, NIN, BLU, COR, PUP, DNC, RUN",
                "Dropped by Midgardsormr.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert result.summary["records"] == 2
    assert result.summary["matched"] == 2
    assert result.summary["equipment_mismatches"] == 0
    assert not [finding for finding in result.findings if finding.kind == "equipment_mismatch"]


def test_audit_trusts_name_consistent_db_slot_when_source_page_slot_conflicts(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.execute("insert into items values (27047, 0, 'taeon_gloves', 'taeon_gloves', 'Armor', 1, '', '', 0)")
        db.execute(
            "insert into item_equipment values (27047, 'Taeon Gloves', 75, 0, 4194303, 0, 0, 0, 64, 0, 0, 0)"
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Taeon Gloves",
                "[Head]All Races",
                "DEF:23 Haste+1%",
                "Lv.75 All Jobs",
                "Obtained via Incursion.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert result.summary["equipment_mismatches"] == 0
    assert not [finding for finding in result.findings if finding.kind == "equipment_mismatch"]


def test_audit_does_not_treat_non_weapon_dmg_delay_text_as_weapon_mismatch(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.execute("insert into items values (28400, 0, 'wyrt_gorget', 'wyrt_gorget', 'Armor', 1, '', '', 0)")
        db.execute(
            "insert into item_equipment values (28400, 'Wyrt Gorget', 50, 0, 516982, 0, 0, 0, 512, 0, 0, 0)"
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Neck.txt").write_text(
        "\n".join(
            (
                "Wyrt Gorget",
                "[Neck]All Races",
                "DMG:35 Delay:548 DEF:4 STR+4 VIT+4 Accuracy+0~3 Attack+0~3",
                "Lv.50 WAR, PLD, DRK, SAM, DRG, RUN",
                "Dropped by Wyrm.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert result.summary["weapon_mismatches"] == 0
    assert not [finding for finding in result.findings if finding.kind == "weapon_stat_mismatch"]


def test_audit_resolves_ambiguous_name_when_equipment_and_weapon_stats_identify_one_candidate(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.executemany(
            "insert into items values (?, 0, 'idris', 'idris', 'Weapon', 1, '', '', 0)",
            [(21070,), (21080,)],
        )
        db.executemany(
            "insert into item_equipment values (?, 'Idris', ?, 0, 1048576, 0, 0, 0, 3, 0, 0, 0)",
            [(21070, 75), (21080, 99)],
        )
        db.executemany(
            "insert into item_weapon values (?, 'Idris', 11, 0, 0, 0, 0, 0, 1, 280, ?, 0)",
            [(21070, 52), (21080, 175)],
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Club.txt").write_text(
        "\n".join(
            (
                "Idris",
                "[Club]All Races",
                'DMG:52 Delay:280 Magic Accuracy+10 "Magic Atk. Bonus"+10',
                "Lv.75 GEO",
                "Mythic weapon.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert result.summary["matched"] == 1
    assert result.summary["ambiguous"] == 0
    assert not [finding for finding in result.findings if finding.kind == "ambiguous_name"]


def test_audit_treats_race_duplicate_equipment_rows_as_resolved(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.executemany(
            "insert into items values (?, 0, 'dancers_tiara_p1', 'dancers_tiara_p1', 'Armor', 1, '', '', 0)",
            [(11475,), (11476,)],
        )
        db.executemany(
            "insert into item_equipment values (?, 'Dancer''s Tiara +1', 74, 0, 262144, 0, 0, 0, 16, 0, 0, 0)",
            [(11475,), (11476,)],
        )
        db.executemany(
            "insert into item_mods values (?, ?, ?, ?)",
            [
                (11475, 1, "DEF", 19),
                (11475, 2, "HP", 15),
                (11475, 9, "DEX", 4),
                (11475, 14, "CHR", 4),
                (11475, 27, "ENMITY", -2),
                (11475, 997, "EQUIPMENT_ONLY_RACE", 149),
                (11476, 1, "DEF", 19),
                (11476, 2, "HP", 15),
                (11476, 9, "DEX", 4),
                (11476, 14, "CHR", 4),
                (11476, 27, "ENMITY", -2),
                (11476, 997, "EQUIPMENT_ONLY_RACE", 106),
            ],
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Dancer's Tiara +1",
                "[Head]All Races",
                "DEF:19 HP+15 DEX+4 CHR+4 Enmity-2",
                "Lv.74 DNC",
                "Artifact armor.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert result.summary["matched"] == 1
    assert result.summary["ambiguous"] == 0
    assert result.summary["stat_mismatches"] == 0
    assert not [finding for finding in result.findings if finding.kind == "ambiguous_name"]


def test_audit_treats_augment_path_effect_tags_as_manual_coverage(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.execute("insert into items values (12560, 0, 'scale_mail', 'scale_mail', 'Armor', 1, '', '', 0)")
        db.execute(
            "insert into item_equipment values (12560, 'Scale Mail', 10, 0, 2141649, 0, 0, 0, 32, 0, 0, 0)"
        )
        db.execute(
            """
            create table catseye_equipment_effect_tags (
                item_id integer not null,
                effect_tag text not null,
                status text not null,
                target text not null,
                source_path text not null,
                source_text text not null,
                note text not null,
                mod_name text,
                value integer
            )
            """
        )
        db.execute(
            """
            insert into catseye_equipment_effect_tags values
            (
                12560,
                'novice_trial_path_def_hp_augments',
                'manual_review',
                'augment_path',
                'pages/CatsEyeXI_Content_Equipment_Body.txt',
                'Scale Mail (Novice Trial Path): DEF+3 HP+10',
                'Catseye augment path on the base Scale Mail item.',
                null,
                null
            )
            """
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Scale Mail (Novice Trial Path)",
                "[Body]All Races",
                "DEF:11 DEF+3 HP+10",
                "Lv.10 WAR, RDM, PLD, DRK, BST, RNG, SAM, DRG, BLU, RUN",
                "Augmented through Novice Trials",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert result.summary["unmatched"] == 0
    assert result.summary["manual_coverage"] == 1
    assert {
        finding.kind
        for finding in result.findings
    } == {"manual_coverage_augment_path"}


def test_audit_resolves_ultimate_weapon_base_and_completed_tie_to_completed_script_row(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.executemany(
            "insert into items values (?, 0, ?, 'laevateinn', 'Weapon', 1, '', '', 0)",
            [(18974, "laevateinn_base"), (18994, "laevateinn_75")],
        )
        db.executemany(
            "insert into item_equipment values (?, 'Laevateinn', 75, 0, 8, 0, 0, ?, 1, 0, 0, 0)",
            [(18974, 0), (18994, 1)],
        )
        db.executemany(
            "insert into item_weapon values (?, 'Laevateinn', 12, 0, 0, 0, 0, 0, 1, 402, 62, 0)",
            [(18974,), (18994,)],
        )
        db.executemany(
            "insert into item_mods values (?, ?, ?, ?)",
            [
                (18994, 25, "ACC", 30),
                (18994, 30, "MACC", 10),
                (18994, 28, "MATT", 20),
                (18994, 566, "IRIDESCENCE", 2),
            ],
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Staff.txt").write_text(
        "\n".join(
            (
                "Laevateinn",
                "[Staff]All Races",
                'DMG:62 Delay:402 Accuracy+30 Magic Accuracy+10 "Magic Atk. Bonus"+20 "Iridescence"',
                "Lv.75 BLM",
                "Mythic weapon.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert result.summary["matched"] == 1
    assert result.summary["ambiguous"] == 0
    assert result.summary["stat_mismatches"] == 0
    assert not [finding for finding in result.findings if finding.kind == "ambiguous_name"]


def test_audit_reports_stale_visible_direct_mods_absent_from_catseye_record(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.execute(
            "insert into items values (27767, 0, 'buremte_hat', 'Erudite Cap', 'Armor', 1, '', '', 0)"
        )
        db.execute(
            "insert into item_equipment values (27767, 'Erudite Cap', 70, 0, 1589788, 0, 0, 0, 16, 0, 0, 0)"
        )
        db.executemany(
            "insert into item_mods values (?, ?, ?, ?)",
            [
                (27767, 1, "DEF", 25),
                (27767, 5, "MP", 30),
                (27767, 10, "VIT", 3),
                (27767, 12, "INT", 5),
                (27767, 29, "MDEF", 4),
                (27767, 30, "MACC", 5),
                (27767, 31, "MEVA", 65),
                (27767, 68, "EVA", 28),
            ],
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Erudite Cap",
                "[Head]All Races",
                'DEF:25 MP+30 VIT+3 INT+5 Magic Accuracy+5 "Cure" spellcasting time -5%',
                "Lv.70 WHM, BLM, RDM, BRD, SMN, SCH",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    direct_extra_fields = {
        finding.field
        for finding in result.findings
        if finding.kind == "db_extra_direct_mod" and finding.item_id == 27767
    }
    missing_fields = {
        finding.field
        for finding in result.findings
        if finding.kind == "item_mod_mismatch" and finding.item_id == 27767
    }

    assert direct_extra_fields == {"MDEF", "MEVA", "EVA"}
    assert missing_fields == {"CURE_CAST_TIME"}


def test_audit_accepts_stronger_server_authority_direct_mods(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.execute(
            "insert into items values (27016, 0, 'bagua_mitaines', 'Bagua Mitaines', 'Armor', 1, '', '', 0)"
        )
        db.execute(
            "insert into item_equipment values (27016, 'Bagua Mitaines', 75, 0, 4194303, 0, 0, 0, 64, 0, 0, 0)"
        )
        db.executemany(
            "insert into item_mods values (?, ?, ?, ?)",
            [
                (27016, 1, "DEF", 17),
                (27016, 5, "MP", 21),
                (27016, 901, "ELEMENTAL_CELERITY", 11),
            ],
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Hands.txt").write_text(
        "\n".join(
            (
                "Bagua Mitaines",
                "[Hands]All Races",
                "DEF:17 MP+21 Refresh +1 Elemental casting time -6%",
                "Lv.75 GEO",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert not [
        finding
        for finding in result.findings
        if finding.kind == "item_mod_mismatch" and finding.field == "ELEMENTAL_CELERITY"
    ]
    assert {
        finding.kind
        for finding in result.findings
        if finding.item_id == 27016 and finding.field == "ELEMENTAL_CELERITY"
    } == {"manual_coverage_server_authority_mod"}


def test_audit_accepts_db_extra_direct_mods_covered_by_scored_effect_tags(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.execute(
            """
            create table catseye_equipment_effect_tags (
                item_id integer not null,
                effect_tag text not null,
                status text not null,
                target text not null,
                source_path text not null,
                source_text text not null,
                note text not null,
                mod_name text,
                value integer
            )
            """
        )
        db.execute(
            "insert into items values (23995, 0, 'pincer_mantle', 'Pincer Mantle', 'Armor', 1, '', '', 0)"
        )
        db.execute(
            "insert into item_equipment values (23995, 'Pincer Mantle', 75, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0)"
        )
        db.executemany(
            "insert into item_mods values (?, ?, ?, ?)",
            [
                (23995, 1, "DEF", 8),
                (23995, 25, "ACC", 6),
            ],
        )
        db.execute(
            """
            insert into catseye_equipment_effect_tags values
            (23995, 'tandem_strike_accuracy', 'scored', 'player',
             'pages/CatsEyeXI_Content_Equipment_Back.txt', 'Acc/M.Acc +6',
             'Scored Catseye effect covers the server-backed direct stat.', 'ACC', 6)
            """
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Back.txt").write_text(
        "\n".join(
            (
                "Pincer Mantle",
                "[Back]All Races",
                'DEF:8 "Tandem" bonuses are granted to both player and pet.',
                "Lv.75 All Jobs",
                "Dropped by test fixture.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert not [
        finding
        for finding in result.findings
        if finding.kind == "db_extra_direct_mod" and finding.item_id == 23995 and finding.field == "ACC"
    ]
    assert {
        finding.kind
        for finding in result.findings
        if finding.item_id == 23995 and finding.field == "ACC"
    } == {"manual_coverage_scored_effect_mod"}


def test_audit_treats_known_club_page_effects_as_covered(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.executemany(
            "insert into items values (?, 0, ?, ?, 'Weapon', 1, '', '', 0)",
            [
                (17069, "moepapa_mace", "Moepapa Mace"),
                (18324, "mjollnir", "Mjollnir"),
                (21102, "moblin_mallet", "Moblin Mallet"),
                (21109, "stoutheart_+1", "Stoutheart +1"),
                (21125, "tamaxchi", "Tamaxchi"),
                (21129, "starfall", "Starfall"),
                (21130, "starfall_+1", "Starfall +1"),
                (22006, "stoutheart", "Stoutheart"),
            ],
        )
        db.executemany(
            "insert into item_equipment values (?, ?, 75, 0, 4194303, 0, 0, 0, 3, 0, 0, 0)",
            [
                (17069, "Moepapa Mace"),
                (18324, "Mjollnir"),
                (21102, "Moblin Mallet"),
                (21109, "Stoutheart +1"),
                (21125, "Tamaxchi"),
                (21129, "Starfall"),
                (21130, "Starfall +1"),
                (22006, "Stoutheart"),
            ],
        )
        db.executemany(
            "insert into item_weapon values (?, ?, 11, 0, 0, 0, 0, 0, 1, ?, ?, 0)",
            [
                (17069, "Moepapa Mace", 300, 45),
                (18324, "Mjollnir", 308, 57),
                (21102, "Moblin Mallet", 340, 9),
                (21109, "Stoutheart +1", 340, 36),
                (21125, "Tamaxchi", 216, 31),
                (21129, "Starfall", 340, 49),
                (21130, "Starfall +1", 334, 50),
                (22006, "Stoutheart", 340, 22),
            ],
        )
        db.executemany(
            "insert into item_mods values (?, ?, ?, ?)",
            [
                (17069, 13, "MND", 8),
                (17069, 25, "ACC", 8),
                (18324, 23, "ATT", 20),
                (21102, 2, "HP", 50),
                (21102, 243, "VERMIN_KILLER", 5),
                (21102, 978, "MAX_SWINGS", 4),
                (21109, 8, "STR", 5),
                (21109, 13, "MND", 5),
                (21109, 71, "MPHEAL", 10),
                (21109, 374, "CURE_POTENCY", 10),
                (21109, 369, "REFRESH", 1),
                (21125, 12, "INT", 3),
                (21125, 13, "MND", 3),
                (21125, 28, "MATT", 5),
                (21125, 30, "MACC", 2),
                (21125, 90, "CLUB", 3),
                (21125, 374, "CURE_POTENCY", 10),
                (21129, 5, "MP", 25),
                (21129, 8, "STR", 5),
                (21129, 13, "MND", 5),
                (21129, 23, "ATT", 10),
                (21130, 5, "MP", 25),
                (21130, 8, "STR", 6),
                (21130, 13, "MND", 6),
                (21130, 23, "ATT", 15),
                (22006, 13, "MND", 3),
                (22006, 23, "ATT", 7),
                (22006, 71, "MPHEAL", 5),
                (22006, 374, "CURE_POTENCY", 5),
            ],
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Club.txt").write_text(
        "\n".join(
            (
                "Moepapa Mace",
                "[Club]All Races",
                "DMG:45 Delay:300 +30 MND+8 Accuracy+8 Additional effect: Flash",
                "Lv.75 All Jobs",
                "Mjollnir",
                "[Club]All Races",
                'DMG:57 Delay:308 Attack+20 "Randgrith" Additional effect: Recover MP',
                "Lv.75 All Jobs",
                "Moblin Mallet",
                "[Club]All Races",
                'DMG:9 Delay:340 HP+50 Occasionally attacks 2-4 times (Hidden Effect: "Vermin Killer"+5) STR+0~4 Club skill+0~4',
                "Lv.75 All Jobs",
                "Stoutheart +1",
                "[Club]All Races",
                'DMG:36 Delay:340 STR+5 MND+5 MP recovered while healing +10 Cure potency +10% "Refresh"+1 Latent effect: DMG:42 (Latent Activation: Level 60+)',
                "Lv.75 All Jobs",
                "Tamaxchi",
                "[Club]All Races",
                'DMG:31 Delay:216 INT+3 MND+3 +20 "Magic Atk. Bonus"+5 Club skill +3 Magic Accuracy +2 "Cure" potency +10% "Domain Incursion"',
                "Lv.75 All Jobs",
                "Starfall",
                "[Club]All Races",
                "DMG:49 Delay:340 MP+25 STR+5 MND+5 Attack+10 (Hidden effect: Deals piercing damage)",
                "Lv.75 All Jobs",
                "Starfall +1",
                "[Club]All Races",
                "DMG:50 Delay:334 MP+25 STR+6 MND+6 Attack+15 (Hidden effect: Deals piercing damage)",
                "Lv.75 All Jobs",
                "Stoutheart",
                "[Club]All Races",
                "DMG:22 Delay:340 MND+3 Attack+7 MP recovered while healing +5 Cure potency +5% Latent effect: DMG:30 (Latent Activation: Level 30+)",
                "Lv.75 All Jobs",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert result.summary["manual_review"] == 0
    assert not [
        finding
        for finding in result.findings
        if finding.kind == "manual_review_effect"
        and finding.item_name
        in {
            "Moblin Mallet",
            "Moepapa Mace",
            "Mjollnir",
            "Stoutheart",
            "Stoutheart +1",
            "Tamaxchi",
            "Starfall",
            "Starfall +1",
        }
    ]


def test_audit_treats_remaining_named_effect_patterns_as_covered(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.execute(
            "insert into items values (39010, 0, 'remaining_manual_harness', 'Remaining Manual Harness', 'Armor', 1, '', '', 0)"
        )
        db.execute(
            "insert into item_equipment values (39010, 'Remaining Manual Harness', 75, 0, 4194303, 0, 0, 0, 32, 0, 0, 0)"
        )
        db.execute("insert into item_mods values (39010, 1, 'DEF', 5)")
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Remaining Manual Harness",
                "[Body]All Races",
                'DEF:5 Enhances "Resist Silence" effect Enhances effect of "Cursna" received '
                'Enhances monster correlation effects Enhances avatar attack (+10) Enhances Battuta '
                'Adds "Refresh" effect Converts 50 HP to MP Occ. Quickens Spellcasting +3% '
                'Additional effect: Water Hidden effect: Blunt damage Grants "Tactical Parry" '
                'Grants "Magic Burst Bonus" Augments "Third Eye" Wyvern uses breaths more effectively '
                'Latent effect: STR+4',
                "Lv.75 All Jobs",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert not [
        finding
        for finding in result.findings
        if finding.kind == "manual_review_effect" and finding.item_id == 39010
    ]


def test_audit_treats_parsed_latent_conditionals_as_covered(tmp_path: Path) -> None:
    db_path = tmp_path / "stats.sqlite"
    _write_minimal_db(db_path)
    db = sqlite3.connect(db_path)
    try:
        db.execute(
            "insert into items values (39011, 0, 'latent_manual_harness', 'Latent Manual Harness', 'Armor', 1, '', '', 0)"
        )
        db.execute(
            "insert into item_equipment values (39011, 'Latent Manual Harness', 75, 0, 4194303, 0, 0, 0, 32, 0, 0, 0)"
        )
        db.executemany(
            "insert into item_mods values (?, ?, ?, ?)",
            [
                (39011, 1, "DEF", 5),
                (39011, 8, "STR", 4),
            ],
        )
        db.commit()
    finally:
        db.close()

    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Body.txt").write_text(
        "\n".join(
            (
                "Latent Manual Harness",
                "[Body]All Races",
                "DEF:5 Latent effect: STR+4",
                "Lv.75 All Jobs",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_equipment_catalog(
        db_path=db_path,
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert not [
        finding
        for finding in result.findings
        if finding.kind == "manual_review_effect" and finding.item_id == 39011
    ]


def _write_minimal_db(path: Path) -> None:
    db = sqlite3.connect(path)
    try:
        db.executescript(
            """
            create table items (
                item_id integer primary key,
                sub_id integer not null,
                name text not null,
                sort_name text not null,
                item_type text not null,
                stack_size integer not null,
                flags text not null,
                auction_house text not null,
                base_sell integer not null
            );
            create table item_equipment (
                item_id integer primary key,
                name text not null,
                level integer not null,
                ilevel integer not null,
                jobs integer not null,
                model_id integer not null,
                shield_size integer not null,
                script_type integer not null,
                slot integer not null,
                rslot integer not null,
                rslot_look integer not null,
                su_level integer not null
            );
            create table item_weapon (
                item_id integer primary key,
                name text not null,
                skill integer not null,
                subskill integer not null,
                ilvl_skill integer not null,
                ilvl_parry integer not null,
                ilvl_magic_accuracy integer not null,
                damage_type integer not null,
                hit integer not null,
                delay integer not null,
                damage integer not null,
                unlock_points integer not null
            );
            create table item_mods (
                item_id integer not null,
                mod_id integer not null,
                mod_name text not null,
                value integer not null
            );
            """
        )
        db.execute(
            "insert into items values (18904, 0, 'ephemeron', 'ephemeron', 'Weapon', 1, '', '', 0)"
        )
        db.execute(
            """
            insert into item_equipment values
            (18904, 'ephemeron', 75, 0, 528, 0, 0, 0, 3, 0, 0, 0)
            """
        )
        db.execute(
            """
            insert into item_weapon values
            (18904, 'ephemeron', 3, 0, 0, 0, 0, 0, 1, 213, 58, 0)
            """
        )
        db.executemany(
            "insert into item_mods values (?, ?, ?, ?)",
            [
                (18904, 11, "AGI", 15),
                (18904, 25, "ACC", 15),
                (18904, 384, "HASTE_GEAR", 300),
            ],
        )
        db.commit()
    finally:
        db.close()
