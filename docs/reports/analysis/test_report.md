統合テスト結果レポート
生成日時: 2025-07-10 02:33:28

=== サマリー ===
Python テスト: 4/5 成功
型チェック: 失敗

=== Python テスト詳細 ===

python/simulation/monte_carlo_simulation.py:
  状態: ✗ 失敗
  エラー: File not found: /home/ubuntu/workbench/potion_problem/python/simulation/monte_carlo_simulation.py...

python/simulation/analytical_solution.py:
  状態: ✓ 成功
  抽出された期待値: 2.718282
  理論値との誤差: 3.00e-10 (0.00%)

python/simulation/formal_proof.py:
  状態: ✓ 成功
  抽出された期待値: 2.717911
  理論値との誤差: 3.71e-04 (0.01%)

python/simulation/formal_verification.py:
  状態: ✓ 成功
  抽出された期待値: 2.718282
  理論値との誤差: 4.59e-10 (0.00%)

python/theoretical/irwin_hall_analysis.py:
  状態: ✓ 成功
  抽出された期待値: 2.718282
  理論値との誤差: 4.59e-10 (0.00%)

=== 型チェック結果 ===
✗ 型エラーあり
python/proof_assistants/z3_demo.py:49: error: Function is missing a type annotation  [no-untyped-def]
python/proof_assistants/z3_demo.py:57: error: Call to untyped function "prove" in typed context  [no-untyped-call]
python/theoretical/exact_expectation_proof.py:9: error: Skipping analyzing "sympy": module is installed, but missing library stubs or py.typed marker  [import-untyped]
python/theoretical/exact_expectation_proof.py:9: note: See https://mypy.readthedocs.io/en/stable/running_mypy.html#...

=== 結論 ===
✗ 一部のテストが失敗しました。修正が必要です。
