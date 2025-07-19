# 媚薬問題（Potion Problem）- 形式証明の試み

**問題**: 女騎士が媚薬を飲む回数の期待値は？（連続一様分布の和が初めて1を超えるまでの試行回数）

**数学的答え**: E[τ] = e ≈ 2.718281828（ネイピア数）

## ⚠️ 重要な注意事項

**本プロジェクトは未完成です。** 形式証明には3つの`sorry`（証明未完了）が残っており、完全な証明には至っていません。

## 未完成の証明構造

```
主定理: E[τ] = e
    ├── 依存: TelescopingSeries.factorial_telescoping_sum_one
    │   └── sorry (L107) - 証明未完了
    ├── 依存: TelescopingSeries.telescoping_series_sum_v4_12_0
    │   └── sorry (L62) - 証明未完了
    └── 依存: TelescopingSeries.summable_factorial_diff
        └── sorry (L121) - 証明未完了
```

## プロジェクト概要

このプロジェクトは、媚薬問題の期待値E[τ] = eを形式的に証明しようとする**試み**です：

- **Lean 4での形式証明** - 部分的に実装、sorryを含む
- **Pythonによる数値検証** - 完全に動作、高精度検証済み
- **理論的解析** - Irwin-Hall分布を用いた数学的証明

## ビルドとテスト

### Lean 4（v4.21.0）
```bash
lake build
```
注意: ビルドは成功しますが、証明は未完成です。

### Python解析
```bash
uv sync
uv run python test_all.py
```

## 技術的詳細

### 完成部分
- 基本的な定理の枠組み
- Irwin-Hall分布の性質（P(S_n < 1) = 1/n!）
- 階乗級数の収束性
- Python数値シミュレーション（誤差 < 0.01%）

### 未完成部分（sorry使用箇所）
1. **telescoping_series_sum_v4_12_0** - 無限級数の極限定理
2. **factorial_telescoping_sum_one** - 階乗telescoping級数の和=1の証明
3. **summable_factorial_diff** - 階乗差分級数の収束性証明

## 数学的背景

証明の核心：
- P(τ = n) = (n-1)/n! for n ≥ 2
- E[τ] = ∑_{n=2}^∞ n·P(τ=n) = ∑_{n=2}^∞ 1/(n-1)! = e

この美しい結果は数学的には正しいですが、Lean 4での完全な形式証明には至っていません。

## ライセンス

MIT License - 詳細はLICENSEファイルを参照してください。

---

**開発チーム**: Astolfo & Contributors  
**プロジェクトステータス**: 形式証明の試み（未完成）