from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from audit_oddorg_namespace import audit_oddorg_namespace


def test_oddorg_namespace_audit_fails_oddlua_oddorg_module_path(tmp_path: Path) -> None:
    forbidden = tmp_path / "src" / "oddlua" / "oddorg.py"
    forbidden.parent.mkdir(parents=True)
    forbidden.write_text("class MoveCommand: pass\n", encoding="utf-8")

    report = audit_oddorg_namespace(tmp_path)

    assert report["failureCount"] == 1
    assert report["failures"] == [
        {
            "path": str(forbidden),
            "reason": "forbiddenOddLuaModulePath",
        }
    ]


def test_oddorg_namespace_audit_fails_oddlua_source_reference(tmp_path: Path) -> None:
    source = tmp_path / "src" / "oddlua" / "builder.py"
    source.parent.mkdir(parents=True)
    source.write_text("from oddlua.oddorg import MoveCommand\n", encoding="utf-8")

    report = audit_oddorg_namespace(tmp_path)

    assert report["failureCount"] == 1
    assert report["failures"] == [
        {
            "path": str(source),
            "reason": "forbiddenOddOrgReference",
            "line": 1,
            "text": "from oddlua.oddorg import MoveCommand",
        }
    ]


def test_oddorg_namespace_audit_allows_standalone_package(tmp_path: Path) -> None:
    oddlua_source = tmp_path / "src" / "oddlua" / "builder.py"
    oddlua_source.parent.mkdir(parents=True)
    oddlua_source.write_text("def build():\n    return 'ok'\n", encoding="utf-8")
    standalone = tmp_path / "src" / "oddorg" / "__init__.py"
    standalone.parent.mkdir(parents=True)
    standalone.write_text("class MoveCommand: pass\n", encoding="utf-8")

    report = audit_oddorg_namespace(tmp_path)

    assert report["failureCount"] == 0
    assert report["failures"] == []
