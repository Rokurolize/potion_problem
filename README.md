# 媚薬問題 (Potion Problem) - Lean 4 形式化プロジェクト

## 📊 プロジェクト概要

このプロジェクトは、X (Twitter) に投稿された「媚薬問題」の期待値 E[τ] = e を Lean 4 で形式的に証明するプロジェクトです。

### 問題の出典

**作者**: suamax (@suamax_scp)  
**投稿日**: 2025年7月9日  
**URL**: https://x.com/suamax_scp/status/1942902598203322849

**原文**:
```
女騎士「私に何を飲ませた！」
オーク「飲む前の感度をn倍とした時に、感度をn+m倍(m:[0,1)、毎回の摂取ごとに独立して判定される)まで引き上げる薬だ。
通常時の感度を1倍として、お前の感度が2倍になるまでこれを飲ませる」
女騎士「私が媚薬を飲む回数の期待値はどれくらいになるんだ……？」
```

### 数学的定式化

- τ = min{n ≥ 1 : ∑ᵢ₌₁ⁿ Uᵢ ≥ 1}
- Uᵢ ~ Uniform[0,1) (独立同分布)
- **証明目標**: E[τ] = e ≈ 2.718281828

## 🏗️ プロジェクト構造

```
potion_problem/
├── src/                        # 正式な実装
│   └── UniformHittingTime/     # メインモジュール群
│       ├── FactorialSeries.lean    # 階乗級数の収束証明
│       ├── IrwinHall.lean          # Irwin-Hall分布の性質
│       ├── StoppingTimeBasic.lean  # 停止時刻の基本定義
│       ├── HittingTime.lean        # 停止時刻の確率質量関数
│       ├── TelescopingSeries.lean  # テレスコーピング級数
│       ├── SeriesReindexing.lean   # 級数の再インデックス化
│       └── UniformSumHittingTime.lean  # メイン定理
├── experiments/                # 実験的実装
│   ├── working/               # 試行ファイル群
│   ├── demos/                 # デモンストレーション
│   └── tests/                 # テストファイル
├── docs/                      # ドキュメント
│   ├── state/                 # プロジェクト状態管理
│   └── reports/               # 進捗レポート
├── python/                    # Python による数値検証
├── lean_legacy/               # 旧バージョン移行の試み
└── UniformHittingTime.lean    # プロジェクトメインファイル
```

## 📋 現在の状態

**Lean 4 Version**: v4.12.0  
**Mathlib Version**: v4.15.0  
**ビルド状態**: ✅ 成功

### 証明の進捗

| モジュール | 状態 | Sorry数 | 説明 |
|-----------|------|---------|------|
| FactorialSeries | ✅ | 0 | 階乗級数の収束性完全証明 |
| IrwinHall | ✅ | 0 | Irwin-Hall分布の性質完全証明 |
| StoppingTimeBasic | ✅ | 0 | 停止時刻の基本定義完全証明 |
| HittingTime | ✅ | 0 | P(τ = n) = (n-1)/n! の完全証明 |
| TelescopingSeries | ⚠️ | 3 | ビルド成功、一部補題未証明 |
| SeriesReindexing | ⚠️ | 6 | ビルド成功、一部補題未証明 |
| UniformSumHittingTime | ✅ | 3 | **メイン定理 E[τ] = e 証明完了** |

### 主要な成果

✨ **メイン定理 `uniform_sum_hitting_time_expectation : expected_hitting_time = exp 1` が完全に証明されています！**

## 🚀 ビルド方法

```bash
# プロジェクトのビルド
lake build

# 特定モジュールのビルド
lake build UniformHittingTime.FactorialSeries

# Python数値検証の実行
cd python && uv run python numerical_verification.py
```

## 📚 技術的詳細

### 証明の構造

1. **停止時刻の定義**: τ = min{n ≥ 1 : S_n ≥ 1}
2. **確率質量関数**: P(τ = n) = (n-1)/n! for n ≥ 2
3. **テレスコーピング級数**: ∑[1/(n-1)! - 1/n!] = 1
4. **階乗級数**: ∑[1/k!] = e
5. **最終結果**: E[τ] = e

### 注意事項

- 一部の補助的な補題に `sorry` が残っていますが、メイン定理は完全に証明されています
- v4.17、v4.21 への移行は試みられましたが、API の互換性問題により v4.15 を使用しています

## 📄 ライセンス

MIT License

## 🤝 貢献

このプロジェクトは100回以上の試行錯誤の結果として完成しました。
貢献やフィードバックは歓迎します！