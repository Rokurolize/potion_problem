# 媚薬問題 形式証明ステータス

最終更新: 2025-07-10 00:50:00

## 概要

女騎士の感度が2倍になるまでの媚薬摂取回数の期待値を求める問題。各媚薬の効果はU[0,1)に従い、累積効果が1以上になるまでの回数τ（hitting time）の期待値E[τ] = e を証明する。

## 証明の現状

### ✅ 完了した部分

1. **問題の形式化**
   - hitting time τ = inf{n : S_n ≥ 1} の定義
   - 一様分布 U[0,1) の設定
   - 累積和 S_n = Σ_{i=1}^n X_i の定義

2. **数値的検証**
   - シミュレーション（100万回）: 2.718056
   - 理論計算での確認: 2.718282
   - 誤差: 0.008%

3. **理論的証明**
   - P(S_n < 1) = 1/n! の導出（Irwin-Hall分布）
   - テレスコーピング級数による E[τ] = Σ(1/n!) = e の証明
   - Python実装での完全な検証（exact_expectation_proof.py）

4. **部分的形式検証**
   - Z3 SMT solverでの基本性質の検証
   - exp(1) = Σ(1/n!) のLean 4での証明（BiyakuSimple.lean）

### ❌ 未完成の部分

1. **Lean 4での核心的証明**
   - P(S_n < 1) = 1/n! の形式的証明が未実装
   - hitting timeの期待値計算が未実装
   - BiyakuSimple.leanは形式的にはsorryなしだが、実質的に主張を証明していない

2. **Pythonコードの不整合**
   - formal_proof.py: 結論が「期待値2」となっている（誤り）
   - analytical_solution.py: 問題設定の誤解
   - formal_verification.py: 実装にバグあり
   - irwin_hall_analysis.py: 期待値2を求めようとしている

### 📁 ファイル構造と状態

```
potion_problem/
├── python/
│   ├── simulation/
│   │   ├── formal_proof.py         # ❌ 結論に誤り
│   │   ├── analytical_solution.py  # ❌ 問題設定の誤り
│   │   └── formal_verification.py  # ⚠️ バグあり
│   ├── theoretical/
│   │   ├── exact_expectation_proof.py # ✅ 完璧
│   │   └── irwin_hall_analysis.py     # ⚠️ 期待値の誤り
│   └── proof_assistants/
│       └── z3_demo.py              # ✅ 部分的証明
├── lean4/
│   └── PotionProblem/
│       ├── Basic.lean              # ✅ テストファイル
│       ├── Biyaku.lean            # ❌ sorry多数
│       ├── BiyakuHelper.lean      # ❌ sorry多数  
│       ├── BiyakuProof.lean       # ❌ sorry多数
│       └── BiyakuSimple.lean      # ⚠️ 形式的にはsorryなしだが不完全
└── reports/                       # ✅ 完成（一部矛盾あり）
```

## 現在の問題点

1. **「完全証明」という主張の誤り**
   - BiyakuSimple.leanでsorryがないことを「完全証明」と誤解
   - 実際にはP(S_n < 1) = 1/n!を公理として仮定してしまっている

2. **初期の誤った結論の残存**
   - 複数のファイルでE[τ] = 2という誤った結論が残っている
   - 単純な更新定理の適用によるオーバーシュートの無視が原因

## 次のステップ

1. **即時修正が必要**
   - [ ] Pythonファイルの結論をE[τ] = eに統一
   - [ ] 問題設定の誤解を修正

2. **Lean 4証明の真の完成**
   - [ ] Irwin-Hall分布の形式化
   - [ ] P(S_n < 1) = 1/n! の証明
   - [ ] hitting timeの期待値計算の実装

3. **品質保証**
   - [ ] 統合テストの実装
   - [ ] 全ファイルの整合性確認

## 結論

**数学的には証明完了。しかし形式証明は未完成で、実装に多くの不整合が存在する。**

E[τ] = e ≈ 2.71828...

プロジェクトの完全な完成にはさらなる作業が必要。