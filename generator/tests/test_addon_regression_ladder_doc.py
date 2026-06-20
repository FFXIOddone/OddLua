from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GUIDE = ROOT / "docs" / "superpowers" / "guides" / "oddlua-addon-regression-ladder.md"
README = ROOT / "README.md"


def test_addon_regression_ladder_guide_exists_with_workflow_contract() -> None:
    text = GUIDE.read_text(encoding="utf-8")

    required_phrases = (
        "Addon Regression Ladder",
        "observe -> trace -> contract -> red -> green -> sync -> verify -> record",
        "source generator, generated dist profile, and live install",
        "single process first, varied batch later",
        "installed LuAshitacast profile",
        "Build-OddLuaPack.ps1",
        "Apply-OddLuaAllJobs.ps1",
        "SHA-256",
        "focused regression",
        "LuaJIT syntax",
    )

    for phrase in required_phrases:
        assert phrase in text


def test_readme_points_addon_bugs_to_regression_ladder() -> None:
    text = README.read_text(encoding="utf-8")

    assert "docs/superpowers/guides/oddlua-addon-regression-ladder.md" in text
    assert "Addon Regression Ladder" in text
