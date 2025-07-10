# 媚薬問題（Sensitivity Potion Problem）

女騎士の感度が2倍になるまでに必要な媚薬の回数の期待値を求める問題の、数学的・形式的証明プロジェクト。

## 問題設定

- 各媚薬の効果: U[0,1) の一様分布に従う独立な確率変数
- 目標: 累積効果が初めて1以上になる時刻τ（hitting time）の期待値E[τ]を求める
- 数学的定式化: τ = inf{n : S_n ≥ 1}, where S_n = Σ_{i=1}^n X_i, X_i ~ U[0,1)

## 結論

**E[τ] = e ≈ 2.71828...**

この美しい結果は、P(S_n < 1) = 1/n! という性質とテレスコーピング級数から導かれる。

### 重要な注意
初期の解析では E[τ] = 2 という誤った結論を出していたが、これは単純な更新定理の適用によるもので、オーバーシュートを考慮していなかった。正しい答えは E[τ] = e である。

## プロジェクト構造

```
potion_problem/
├── python/              # Python実装
│   ├── simulation/      # モンテカルロシミュレーションと数値計算
│   │   ├── formal_proof.py         # 100万回シミュレーション
│   │   ├── analytical_solution.py  # Irwin-Hall分布による解析
│   │   └── formal_verification.py  # 複数手法による検証
│   └── proof_assistants/
│       └── z3_demo.py              # Z3 SMTソルバーによる部分的証明
│
├── lean4/               # Lean 4による形式的証明
│   └── PotionProblem/   # hitting timeの形式化（部分的に完成）
│
└── reports/             # 分析結果とレポート
    ├── analysis/        # 詳細な分析レポート
    ├── visualization/   # グラフと可視化
    └── summary/         # まとめ
```

## 実行方法

### Pythonシミュレーション

```bash
cd python/simulation
uv run python formal_proof.py           # 形式的証明（5つの手法）
uv run python analytical_solution.py    # 解析的解法
uv run python formal_verification.py    # 検証プログラム
```

### Z3証明支援系デモ

```bash
cd python/proof_assistants
uv run python z3_demo.py
```

### Lean 4形式的証明

```bash
cd lean4/PotionProblem
lake build
```

**注意**: 現在、`exp(1) = Σ(1/n!)` の部分は証明済みだが、核心となる `P(S_n < 1) = 1/n!` の証明は未完成。完全な証明は作業中。

## 数学的背景

この問題はhitting time問題の典型例であり、以下の重要な性質を持つ：

1. **Irwin-Hall分布**: n個のU[0,1)の和S_nの分布
2. **核心的公式**: P(S_n < 1) = 1/n!
3. **期待値の導出**: E[τ] = Σ_{n=0}^∞ P(τ > n) = Σ_{n=0}^∞ P(S_n < 1) = Σ_{n=0}^∞ 1/n! = e
4. **オーバーシュート**: S_τは1を超えるため、単純な更新定理では正確な値が得られない

## 技術スタック

- **Python**: NumPy, SciPy, SymPy, matplotlib, z3-solver
- **証明支援系**: Z3 SMT Solver, Lean 4 + mathlib4
- **パッケージ管理**: uv（Python）, lake（Lean 4）
- **Python版**: 3.12+
- **Lean版**: 4.22.0-rc3

## プロジェクトの現状と今後

### 完成している部分
- ✅ 数学的な理論解析（E[τ] = e の導出）
- ✅ モンテカルロシミュレーション（誤差0.008%）
- ✅ Python実装（exact_expectation_proof.py）
- ✅ 基本的なLean 4構造

### 未完成の部分
- ❌ P(S_n < 1) = 1/n! のLean 4での証明
- ❌ hitting timeの期待値計算のLean 4実装
- ❌ 一部のPythonファイルの問題設定の誤り

### 今後の展望
- Lean 4による完全な形式的証明の完成
- mathlib4への貢献（hitting time理論の拡張）
- より一般的な確率分布への拡張

## 作者

アストルフォ（マスターのサーヴァント）♡