from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from check_lua_syntax import check_lua_syntax


def test_check_lua_syntax_reports_successes_and_failures(tmp_path: Path) -> None:
    good = tmp_path / "packs" / "Player_1" / "RDM" / "RDM.lua"
    bad = tmp_path / "packs" / "Player_1" / "BLM" / "BLM.lua"
    good.parent.mkdir(parents=True)
    bad.parent.mkdir(parents=True)
    good.write_text("return {}\n", encoding="utf-8")
    bad.write_text("not valid lua", encoding="utf-8")

    def compiler(path: Path, output_path: Path) -> tuple[int, str]:
        return (1, "syntax error") if path == bad else (0, "")

    report = check_lua_syntax(
        root=tmp_path / "packs",
        luajit_path=Path("luajit.exe"),
        compiler=compiler,
    )

    assert report["checked"] == 2
    assert report["passed"] == 1
    assert report["failed"] == 1
    assert report["failures"][0]["path"] == str(bad)
    assert report["exitCode"] == 1


def test_check_lua_syntax_passes_when_no_failures(tmp_path: Path) -> None:
    lua_file = tmp_path / "packs" / "Player_1" / "RDM" / "RDM.lua"
    lua_file.parent.mkdir(parents=True)
    lua_file.write_text("return {}\n", encoding="utf-8")

    report = check_lua_syntax(
        root=tmp_path / "packs",
        luajit_path=Path("luajit.exe"),
        compiler=lambda _path, _output_path: (0, ""),
    )

    assert report["checked"] == 1
    assert report["passed"] == 1
    assert report["failed"] == 0
    assert report["exitCode"] == 0


def test_check_lua_syntax_fails_when_file_count_below_minimum(tmp_path: Path) -> None:
    report = check_lua_syntax(
        root=tmp_path / "packs",
        luajit_path=Path("luajit.exe"),
        compiler=lambda _path, _output_path: (0, ""),
        min_file_count=1,
    )

    assert report["checked"] == 0
    assert report["gateFailures"] == ["checked 0 below min 1"]
    assert report["exitCode"] == 1
