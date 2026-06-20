from pathlib import Path
import importlib
import sys


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))


def test_attempt2_foundation_packages_are_importable() -> None:
    for module_name in (
        "oddlua.config",
        "oddlua.app",
        "oddlua.sources",
        "oddlua.manifests",
        "oddlua.planning",
        "oddlua.rendering",
    ):
        module = importlib.import_module(module_name)
        assert module.__name__ == module_name
