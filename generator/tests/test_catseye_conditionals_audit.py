from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from oddlua.catseye_conditionals_audit import audit_catseye_conditionals


def test_conditionals_audit_reports_parsed_and_deferred_conditions(tmp_path: Path) -> None:
    pages = tmp_path / "wiki" / "pages"
    pages.mkdir(parents=True)
    (pages / "CatsEyeXI_Content_Equipment_Neck.txt").write_text(
        "\n".join(
            (
                "Halting Stole",
                "[Neck]All Races",
                "DEX+3 Paralysis: Accuracy+20",
                "Lv.75 All Jobs",
                "Dropped in Dynamis 2.0.",
                "Nyx Gorget",
                "[Neck]All Races",
                'DEF:2 Latent effect: Accuracy+12 (Latent Activation: Arcane Circle active)',
                "Lv.75 DRK",
                "Dropped by an NM.",
            )
        ),
        encoding="utf-8",
    )
    (pages / "CatsEyeXI_Content_Equipment_Back.txt").write_text(
        "\n".join(
            (
                "Malphas Cape",
                "[Back]All Races",
                "Haste+1% Accuracy-3 Set: Accuracy+10",
                "Lv.75 All Jobs",
                "Dropped by an NM.",
                "Bond Cape",
                "[Back]All Races",
                "DEF:7 Latent effect: Magic Accuracy+4 (Latent Activation: Party of 3-6 members)",
                "Lv.75 All Jobs",
                "Dropped by an NM.",
            )
        ),
        encoding="utf-8",
    )

    result = audit_catseye_conditionals(
        catseye_wiki_root=tmp_path / "wiki",
        output_root=tmp_path / "reports",
        write_files=False,
    )

    parsed = {
        (entry.item_name, entry.condition_type, entry.condition_name)
        for entry in result.parsed
    }
    deferred = {
        (entry.item_name, entry.reason)
        for entry in result.deferred
    }

    assert result.summary["records"] == 4
    assert result.summary["parsed_records"] == 3
    assert result.summary["parsed_mods"] == 3
    assert result.summary["runtime_supported_parsed"] == 2
    assert result.summary["runtime_deferred_parsed"] == 1
    assert ("Halting Stole", "status", "paralysis") in parsed
    assert ("Nyx Gorget", "status", "arcane_circle") in parsed
    assert ("Malphas Cape", "set_bonus", "set") in parsed
    assert ("Malphas Cape", "runtime_unsupported_condition") in deferred
    assert ("Bond Cape", "unparsed_latent_condition") in deferred
