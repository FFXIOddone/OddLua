from pathlib import Path

import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.catseye_skipped_effects_audit import (
    audit_catseye_skipped_effects,
    skipped_effect_fragments_for_text,
)


def test_skipped_effect_fragments_excludes_parsed_erudite_stats_and_augments() -> None:
    fragments = skipped_effect_fragments_for_text(
        'DEF:25 MP+30 VIT+3 INT+5 Magic Accuracy+5 "Cure" spellcasting time -5% '
        "MND+0~5 Enmity-0~5 Fast Cast+0~2% Movement speed +18% "
        "Blood Pact ability delay -4 Avatar Perpetuation-2 Avatar perpetuation cost -1 "
        'SP Ability delay -5 Resist "Death"+3 Fishing skill +2 Retaliation+3% '
        'Tactical Parry+10 "Daken"+5 '
        "Pet: Accuracy+9"
    )

    assert fragments == ()


def test_skipped_effect_fragments_reports_unparsed_visible_effects() -> None:
    fragments = skipped_effect_fragments_for_text(
        'DEF:40 Slow+13% SP Ability delay -5 '
        '"Unmapped Example" rate-5 "Cure" spellcasting time -5%'
    )

    assert {
        (label, fragment)
        for label, fragment in fragments
    } == {
        ('"Unmapped Example" rate', '"Unmapped Example" rate-5'),
    }


def test_skipped_effect_fragments_excludes_unlabeled_signed_values() -> None:
    fragments = skipped_effect_fragments_for_text("DEF:5 +5 DEX+2")

    assert fragments == ()


def test_skipped_effect_fragments_excludes_tagged_catseye_utility_passives() -> None:
    fragments = skipped_effect_fragments_for_text(
        "Fishing skill +1 Expert Angler+1 "
        "(Fatigue limit +10%, Golden Arrow Rate+1%) "
        "Surveyor+2"
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_tagged_magic_potency_named_effect() -> None:
    fragments = skipped_effect_fragments_for_text("Magic Potency+15% Magic Accuracy+30")

    assert fragments == ()


def test_skipped_effect_fragments_excludes_tagged_right_ear_magic_skills() -> None:
    fragments = skipped_effect_fragments_for_text(
        'MP+10 "Empty Killer"+5 Right ear: Magic skills +3 '
        "(incl. Blue, Geomancy, Handbell) Right ear: Evasion skill +3 Shield skill +3 "
        "Right ear: Parrying skill +3 Guarding skill +3"
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_parsed_unknown_latent_stats() -> None:
    fragments = skipped_effect_fragments_for_text(
        'DEF:18 Latent effect: Attack+10 Haste+2% "Double Attack"+3%'
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_parsed_quoted_catseye_job_ability_mods() -> None:
    fragments = skipped_effect_fragments_for_text(
        '"Blood Pact" ability delay-2 "Blood Pact" recast time II-2 '
        '" Sic " and " Ready " ability delay-2 "Barrage"+1 "Dead Aim"+5 '
        '"Berserk/Aggressor" effect duration+10 "Berserk" effect duration+15'
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_parsed_quote_wrapped_passive_mods() -> None:
    fragments = skipped_effect_fragments_for_text(
        '"Magic Attack Bonus"+6 "Ninja Tool Expertise"+5 "Occult Acumen"+20 '
        '"Paeon"+3 "Pflug"+10 "Recycle"+5 "Regen" Duration+20 '
        '"Requiem"+2 "Resist Bind"+3 "Samba" Duration+20 "Steal"+1 '
        '"Tandem Blow" effect+6 "Tandem Strike" effect+6 "Triple Atk."+3% '
        '"Vivacious Pulse" potency+10% Indicolure spell duration+12'
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_parsed_one_off_server_backed_effects() -> None:
    fragments = skipped_effect_fragments_for_text(
        "Amnesia Resistance+15 Blood Pact damage+3% Breath damage dealt+10 "
        "Cooking Skill+1 Dark Skill+12 Dbl. Atk+2% "
        "Decreases likelihood of synthesis material loss+2%"
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_parsed_catseye_typo_aliases() -> None:
    fragments = skipped_effect_fragments_for_text(
        "Enmity Loss reduction-20 Enmity Loss Reduction+30 Enspell Damage Bonus+15 "
        "Elemental Skill+15 Guard skill+5 NinjutsuSkill+10 "
        "Occult Acument+5 Occult Occument+30 Ranged Atttack+8 "
        "Magic Def. Bonus-3%"
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_parsed_server_backed_catseye_aliases() -> None:
    fragments = skipped_effect_fragments_for_text(
        "Rapid Shot+5% Rapidshot+5 Ranged delay -3% Jig Duration+20 "
        "Lullaby+3 Magic crit. hit rate+5 Magical Critical Hit Dmg+5% "
        "Maximum Finishing Moves+1 Repair Potency+10% "
        "Magic Damage Taken II -5% Physical Damage taken II -10% "
        "Phys. dmg. taken II-10%"
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_parsed_server_backed_utility_effects() -> None:
    fragments = skipped_effect_fragments_for_text(
        'Increases "Phantom Roll" area of effect+2 '
        "Grimoire: Spellcasting time-8% "
        '"Dark Arts"+17 "Light Arts"+17 '
        'Adds "Regen" effect Life Cycle+3 '
        'Adds "Regen" effect Utsusemi+1 '
        "Ironskin (Stoneskin+10 "
        "Elemental Debuff Potency+4"
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_parsed_resist_and_cast_aliases() -> None:
    fragments = skipped_effect_fragments_for_text(
        "Elemental casting time -6% Elemental magic casting time-8% "
        'Resist Charm+15 Potency of "Cure" effect received+5% '
        'Potency of "Cure" received+15% Light Resist+13 Resist All Elements+10'
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_remaining_server_backed_aliases() -> None:
    fragments = skipped_effect_fragments_for_text(
        "Resist Blind+3 Resist Petrify+15 Resist Silence+3 Resist Sleep+3 "
        "Silence Resistance+15 String Skill+8 Summoning skill+8 "
        "Song Duration Bonus+25 Subtle Blow II+6 "
        "Spell Interrupt-20% Spell Interruption Rate-15% "
        "Spell Interruption Rate Down+5%"
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_tagged_named_manual_review_effects() -> None:
    fragments = skipped_effect_fragments_for_text(
        "Fencer+1 Magic skill+3 Synthesis skill +2 Swordplay +3"
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_unlabeled_source_anomalies() -> None:
    fragments = skipped_effect_fragments_for_text("DEF:5 +5 DEX+2 DMG+3")

    assert fragments == ()


def test_skipped_effect_fragments_excludes_tagged_manual_review_mechanics() -> None:
    fragments = skipped_effect_fragments_for_text(
        '"Overload" rate-5 Resist DEATH/DMG+3 Healing magic casting time-3% '
        'Weapon skill damage+15% Latent effect: Weapon skill damage+1 Latent effect: DMG+14 '
        'Augments "Reward" Charm+6 Enhances "Reward" effect Charm+2 '
        'Augments "Call Beast" Charm+4 Improves "Tame" success rate Charm+4 '
        'Vs. Lizards: "Charm"+5 "Charm"+3 '
        'Automaton: Magic Skills+9 Automaton: Skills+5 Avatar elemental resistance+25 '
        'Combat skills+8 Magic skills+8 Hidden Effect: Alchemy Skill+1 '
        'Shield Bash+10 Weapon Bash+10 Third Eye+15 Reward+15 '
        '"Angon": Drains movement speed "Angon": Duration+30 '
        'Tomahawk: Grants "Potency" Tomahawk: Duration+30 '
        '"Lunge"+5 Accomplice/Collaborator Effect+15 '
        'Furnace blessing (Regen Potency+1 '
        'Handbell) MP not depleted when magic used+1% '
        'Potency of "Banish" vs. undead+5 Item Add Effect Type+10 '
        '"Feral Heart" (Killer Effects+5% Killer Effects+2 NT+3 '
        'Oggbi\'s Wisdom (Guard+5% '
        '"Wings-Era Warriors: ": Enchantment: "Recollection" "Treasure Hunter"+1 '
        'Elemental Resistance spells+22 Latent Effect (Cursed): "Conserve MP"+5 '
        'Poison effect+5 Step TP consumed-30 Step TP Consumed-50 '
        'times (Hidden effect: "Tactical Parry"+5%'
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_tagged_named_passive_mechanics() -> None:
    fragments = skipped_effect_fragments_for_text(
        'Absorb Damage to MP+5 Absorb Dmg to MP+2 '
        'Enhances "Snapshot" effect Grants "Rapid Shot" II '
        "Royal Knight's Pledge (Light Def+15 Dark Def-20, Regen+1, Absorb Dmg to MP+2) "
        "Luzaf's Curse (Fire Def-20, Ice Def+15, Light Def-20, Dark Def+15, Regen+1)"
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_remaining_named_effect_patterns() -> None:
    fragments = skipped_effect_fragments_for_text(
        'Enhances "Resist Silence" effect Enhances effect of "Cursna" received '
        'Enhances monster correlation effects Enhances avatar attack (+10) Enhances Battuta '
        'Adds "Refresh" effect Adds "Regen" effect Converts 50 HP to MP '
        'Occ. Quickens Spellcasting +3% Additional effect: Water Additional effect: TP Drain '
        'Hidden effect: Blunt damage Grants "Tactical Parry" Grants "Magic Burst Bonus" '
        'Augments "Third Eye" Wyvern uses breaths more effectively '
        "Latent effect: Bonus to Magic Accuracy+1~4 "
        "Latent effect: Increases critical hit damage "
        "Additional effect: Ice damage Additional effect with wind fan equipped: Wind damage "
        "Additional effect: Poison, Paralysis, or Bind Additional effect: HP Drain "
        "Hidden Effect: Slashing damage Hidden Effect: Pet: Ranged Acccuracy+8 "
        "Hidden Effect: All elements: Magic Potency+15%, Magic Accuracy+30 "
        'Physical damage: "Shock Spikes" effect'
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_parsed_occasionally_attacks_ranges() -> None:
    fragments = skipped_effect_fragments_for_text("DMG:11 Delay:264 Occasionally attacks 2-4")

    assert fragments == ()


def test_skipped_effect_fragments_excludes_signed_weapon_stat_deltas() -> None:
    fragments = skipped_effect_fragments_for_text(
        "DMG:16 Delay:150 DMG:+4 Delay:-10 DEX+2"
    )

    assert fragments == ()


def test_skipped_effect_fragments_excludes_parsed_set_bonus_critical_rate() -> None:
    fragments = skipped_effect_fragments_for_text(
        "DEF:40 Set Bonus: Increases Rate of Critical Hits+5%"
    )

    assert fragments == ()


def test_audit_catseye_skipped_effects_groups_fixture_pages(tmp_path: Path) -> None:
    wiki_pages = tmp_path / "wiki" / "pages"
    wiki_pages.mkdir(parents=True)
    (wiki_pages / "CatsEyeXI_Content_Equipment_Head.txt").write_text(
        "\n".join(
            (
                "Erudite Cap",
                "[Head]All Races",
                'DEF:25 MP+30 VIT+3 INT+5 Magic Accuracy+5 "Cure" spellcasting time -5%',
                "Lv.70 WHM, BLM, RDM, BRD, SMN, SCH",
                "Dropped by a Catseye source.",
                "Apex Togi",
                "[Body]All Races",
                "DEF:50 STR+10 SP Ability delay -5 Slow+13%",
                "Lv.75 MNK",
                "Dropped by a Catseye source.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_skipped_effects(
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    assert result.summary == {
        "records": 2,
        "fragment_groups": 0,
        "fragments": 0,
    }
    assert [(group.label, group.count) for group in result.groups] == []
