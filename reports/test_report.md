統合テスト結果レポート
生成日時: 2025-07-19 13:31:54

=== サマリー ===
Python テスト: 0/5 成功
型チェック: 失敗

=== Python テスト詳細 ===

python/simulation/monte_carlo_simulation.py:
  状態: ✗ 失敗
  エラー: File not found: /home/ubuntu/workbench/projects/potion_problem/python/simulation/monte_carlo_simulation.py...

python/simulation/analytical_solution.py:
  状態: ✗ 失敗
  エラー: Traceback (most recent call last):
  File "/home/ubuntu/workbench/projects/potion_problem/python/simulation/analytical_solution.py", line 202, in <module>
    main()
  File "/home/ubuntu/workbench/pro...

python/simulation/formal_proof.py:
  状態: ✗ 失敗
  エラー: 2025-07-19 13:31:46,513 - 形式的証明開始
2025-07-19 13:31:46,513 - 方法1: モンテカルロシミュレーション開始
2025-07-19 13:31:50,367 - シミュレーション完了: 3.85秒
2025-07-19 13:31:50,380 - 方法2: 更新過程の理論による計算
2025-07-19 13:31:50,380 - 方法3:...

python/simulation/formal_verification.py:
  状態: ✗ 失敗
  エラー: 2025-07-19 13:31:53,772 - === 形式的検証開始 ===
2025-07-19 13:31:53,772 - 定理1: 確率分布の厳密な導出
2025-07-19 13:31:53,772 - 定理2: シンボリック計算による証明
2025-07-19 13:31:53,773 - 定理3: 母関数を用いた証明
2025-07-19 13:31:53,929 - 定理4:...

python/theoretical/irwin_hall_analysis.py:
  状態: ✗ 失敗
  エラー: 2025-07-19 13:31:54,457 - Hitting time の理論的解析開始
Traceback (most recent call last):
  File "/home/ubuntu/workbench/projects/potion_problem/python/theoretical/irwin_hall_analysis.py", line 302, in <modu...

=== 型チェック結果 ===
✗ 型エラーあり
/home/ubuntu/workbench/projects/potion_problem/.venv/bin/python3: No module named mypy
...

=== 結論 ===
✗ 一部のテストが失敗しました。修正が必要です。
