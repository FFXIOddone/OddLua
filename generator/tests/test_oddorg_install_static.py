from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
INSTALLER = REPO_ROOT / "Install-OddOrg.ps1"


def test_installer_copies_source_addon_and_creates_config_dir() -> None:
    text = INSTALLER.read_text(encoding="utf-8")

    assert "..\\client\\Ashita\\addons\\oddorg" in text
    assert "C:\\Games\\CatsEyeXI\\catseyexi-client\\Ashita" in text
    assert "addons\\oddorg" in text
    assert "config\\addons\\oddorg" in text
    assert "Get-FileHash" in text
    assert "Remove-Item" not in text
