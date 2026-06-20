from __future__ import annotations

import argparse
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
from typing import Callable


ODDLUA_ROOT = Path(__file__).resolve().parents[1]
Compiler = Callable[[Path, Path], tuple[int, str]]


def check_lua_syntax(
    *,
    root: Path | str,
    luajit_path: Path | str | None = None,
    compiler: Compiler | None = None,
    min_file_count: int = 0,
) -> dict[str, object]:
    root = Path(root)
    resolved_luajit = _resolve_luajit(luajit_path)
    files = tuple(sorted(root.rglob("*.lua")))
    failures: list[dict[str, str]] = []
    gate_failures: list[str] = []
    compiler = compiler or _compile_with_luajit(resolved_luajit)

    with tempfile.TemporaryDirectory(prefix="oddlua-luajit-") as temp_dir:
        output_path = Path(temp_dir) / "check.luac"
        for lua_file in files:
            exit_code, output = compiler(lua_file, output_path)
            if exit_code != 0:
                failures.append(
                    {
                        "path": str(lua_file),
                        "error": output,
                    }
                )

    if len(files) < min_file_count:
        gate_failures.append(f"checked {len(files)} below min {min_file_count}")

    return {
        "root": str(root),
        "luajitPath": str(resolved_luajit),
        "minimumFileCount": min_file_count,
        "checked": len(files),
        "passed": len(files) - len(failures),
        "failed": len(failures),
        "failures": failures,
        "gateFailures": gate_failures,
        "exitCode": 1 if failures or gate_failures else 0,
    }


def _resolve_luajit(luajit_path: Path | str | None) -> Path:
    if luajit_path:
        path = Path(luajit_path)
        if path.exists():
            return path
    found = shutil.which("luajit.exe") or shutil.which("luajit")
    if not found:
        raise FileNotFoundError("luajit executable not found on PATH; pass --luajit")
    return Path(found)


def _compile_with_luajit(luajit_path: Path) -> Compiler:
    def compile_file(lua_file: Path, output_path: Path) -> tuple[int, str]:
        completed = subprocess.run(
            [str(luajit_path), "-b", str(lua_file), str(output_path)],
            capture_output=True,
            text=True,
            check=False,
        )
        output = "\n".join(part for part in (completed.stdout, completed.stderr) if part)
        return completed.returncode, output.strip()

    return compile_file


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Byte-compile generated OddLua Lua files with LuaJIT."
    )
    parser.add_argument("--root", default=ODDLUA_ROOT / "dist" / "packs", type=Path)
    parser.add_argument("--luajit", default=None, type=Path)
    parser.add_argument("--min-files", default=0, type=int)
    parser.add_argument("--json", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        report = check_lua_syntax(root=args.root, luajit_path=args.luajit, min_file_count=args.min_files)
    except FileNotFoundError as exc:
        print(str(exc), file=sys.stderr)
        return 2

    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(
            "LuaJIT byte-compile: checked={checked}; passed={passed}; failed={failed}".format(
                **report
            )
        )
        for failure in report["failures"]:
            assert isinstance(failure, dict)
            print(f"{failure['path']}: {failure['error']}")
        for failure in report["gateFailures"]:
            print(f"Gate failed: {failure}", file=sys.stderr)
    return int(report["exitCode"])


if __name__ == "__main__":
    raise SystemExit(main())
