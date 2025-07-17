#!/usr/bin/env python3
"""
媚薬問題プロジェクトの統合テストスクリプト
すべてのPythonコードを実行し、結果を検証する
"""

import subprocess
import sys
from pathlib import Path
from datetime import datetime
from typing import Dict, Tuple, Any

# プロジェクトルート
PROJECT_ROOT = Path(__file__).parent

# テスト対象のPythonファイル
PYTHON_FILES = [
    "python/simulation/monte_carlo_simulation.py",
    "python/simulation/analytical_solution.py",
    "python/simulation/formal_proof.py",
    "python/simulation/formal_verification.py",
    "python/theoretical/irwin_hall_analysis.py",
]

# 期待される結果（E[τ] = e）
EXPECTED_VALUE = 2.718281828
TOLERANCE = 0.01  # 1%の誤差まで許容


def run_python_file(file_path: str) -> Tuple[bool, str, str]:
    """
    Pythonファイルを実行

    Returns:
        (success, stdout, stderr)
    """
    full_path = PROJECT_ROOT / file_path
    if not full_path.exists():
        return False, "", f"File not found: {full_path}"

    try:
        result = subprocess.run(
            ["uv", "run", "python", str(full_path)],
            cwd=PROJECT_ROOT,
            capture_output=True,
            text=True,
            timeout=60,
        )
        return result.returncode == 0, result.stdout, result.stderr
    except subprocess.TimeoutExpired:
        return False, "", "Timeout expired"
    except Exception as e:
        return False, "", str(e)


def extract_expected_value(output: str) -> float:
    """
    出力から期待値を抽出
    """
    import re

    # 様々なパターンで期待値を探す
    patterns = [
        r"期待値[:\s]*([0-9.]+)",
        r"E\[τ\][:\s]*([0-9.]+)",
        r"expected_value[:\s]*([0-9.]+)",
        r"期待回数[:\s]*([0-9.]+)",
    ]

    for pattern in patterns:
        match = re.search(pattern, output, re.IGNORECASE)
        if match:
            try:
                return float(match.group(1))
            except ValueError:
                continue

    return -1.0


def run_mypy_check() -> Tuple[bool, str]:
    """
    型チェックを実行
    """
    try:
        result = subprocess.run(
            ["uv", "run", "mypy", "python/"], cwd=PROJECT_ROOT, capture_output=True, text=True
        )
        return result.returncode == 0, result.stdout + result.stderr
    except Exception as e:
        return False, str(e)


def generate_report(results: Dict[str, Any]) -> str:
    """
    テスト結果のレポート生成
    """
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    report = f"""統合テスト結果レポート
生成日時: {timestamp}

=== サマリー ===
"""

    total_tests = len(results["python_tests"])
    passed_tests = sum(1 for r in results["python_tests"].values() if r["success"])

    report += f"Python テスト: {passed_tests}/{total_tests} 成功\n"
    report += f"型チェック: {'成功' if results['mypy']['success'] else '失敗'}\n"

    report += "\n=== Python テスト詳細 ===\n"

    for file_path, result in results["python_tests"].items():
        report += f"\n{file_path}:\n"
        report += f"  状態: {'✓ 成功' if result['success'] else '✗ 失敗'}\n"

        if result["success"]:
            report += f"  抽出された期待値: {result['expected_value']:.6f}\n"
            error = abs(result["expected_value"] - EXPECTED_VALUE)
            report += f"  理論値との誤差: {error:.2e} ({error / EXPECTED_VALUE * 100:.2f}%)\n"
        else:
            report += f"  エラー: {result['error'][:200]}...\n"

    report += "\n=== 型チェック結果 ===\n"
    if results["mypy"]["success"]:
        report += "✓ すべての型チェックが成功\n"
    else:
        report += "✗ 型エラーあり\n"
        report += results["mypy"]["output"][:500] + "...\n"

    report += "\n=== 結論 ===\n"

    all_values_correct = all(
        abs(r["expected_value"] - EXPECTED_VALUE) < TOLERANCE
        for r in results["python_tests"].values()
        if r["success"] and r["expected_value"] > 0
    )

    if passed_tests == total_tests and all_values_correct:
        report += "✓ すべてのテストが成功し、期待値 E[τ] = e が確認されました。\n"
    else:
        report += "✗ 一部のテストが失敗しました。修正が必要です。\n"

    return report


def main() -> None:
    """メイン処理"""
    print("媚薬問題プロジェクト - 統合テスト開始")
    print("=" * 60)

    results = {"python_tests": {}, "mypy": {"success": False, "output": ""}}

    # Pythonファイルのテスト
    print("\nPython ファイルのテスト:")
    for file_path in PYTHON_FILES:
        print(f"  {file_path}... ", end="", flush=True)

        success, stdout, stderr = run_python_file(file_path)

        if success:
            expected_value = extract_expected_value(stdout)
            results["python_tests"][file_path] = {
                "success": True,
                "expected_value": expected_value,
                "output": stdout,
            }
            print(f"✓ (E[τ] = {expected_value:.6f})")
        else:
            results["python_tests"][file_path] = {
                "success": False,
                "error": stderr or "Unknown error",
                "output": stdout,
            }
            print("✗")

    # 型チェック
    print("\n型チェック実行中... ", end="", flush=True)
    mypy_success, mypy_output = run_mypy_check()
    results["mypy"] = {"success": mypy_success, "output": mypy_output}
    print("✓" if mypy_success else "✗")

    # レポート生成
    report = generate_report(results)
    print("\n" + "=" * 60)
    print(report)

    # レポート保存
    report_path = PROJECT_ROOT / "reports" / "test_report.md"
    report_path.parent.mkdir(exist_ok=True)
    with open(report_path, "w", encoding="utf-8") as f:
        f.write(report)

    print(f"\nレポートを保存しました: {report_path}")

    # 終了コード
    all_passed = all(r["success"] for r in results["python_tests"].values())  # type: ignore
    sys.exit(0 if all_passed else 1)


if __name__ == "__main__":
    main()
