# 自己完結型 Lean 4 実装プロンプト

## 📋 ミッション：媚薬問題 E[τ] = e の完全形式化

あなたは**第N回目の実装者**です。前任者たちによる大量の試行の結果、現在は高度に進歩した状態にあります。

### 🎯 問題定義
**媚薬問題**: E[τ] = e を証明する
- τ = min{n ≥ 1 : ∑ᵢ₌₁ⁿ Uᵢ ≥ 1}
- Uᵢ ~ Uniform[0,1) (独立同分布)
- 証明: E[τ] = e ≈ 2.718281828

### 📊 現在の正確な状況 (2025年7月15日時点)

**作業環境:**
- ディレクトリ: `/home/ubuntu/workbench/projects/potion_problem/`
- ブランチ: refactoring-safety
- Lean 4 v4.12.0 + Mathlib4 v4.12.0

**✅ 完全動作モジュール (sorry: 0):**
1. `UniformHittingTime.FactorialSeries` - 階乗級数の収束証明
2. `UniformHittingTime.IrwinHall` - Irwin-Hall分布の性質
3. `UniformHittingTime.StoppingTimeBasic` - 停止時刻の基本定義
4. `UniformHittingTime.HittingTime` - 停止時刻の確率質量関数

**🔧 部分動作モジュール:**
5. `UniformHittingTime.SeriesReindexing` - ビルド成功, sorry: 6

**❌ 問題のあるモジュール:**
6. `UniformHittingTime.TelescopingSeries` - 複数エラー, sorry: 1
7. `UniformHittingTime.UniformSumHittingTime` - メイン定理, sorry: 5

**📁 利用可能リソース:**
- 26個の試行ファイル (ActuallyWorking.lean, MinimalWorking.lean等)
- 30個以上のレポートファイル
- 過去の成功例と失敗パターン

### 🎯 あなたの今回タスク (以下から1つ選択)

#### A. TelescopingSeries.lean 修復
**現在のエラー:**
- `Nat.strong_induction_on₂` 未定義
- 型の不一致多数  
- タイムアウトエラー

**アプローチ:**
1. API v4.12.0 互換性の修正
2. 型エラーの段階的解決
3. 試行ファイル (TelescopingSeriesWorking.lean等) からの学習

#### B. UniformSumHittingTime.lean 完成
**残り sorry: 5**
- メイン定理 E[τ] = e の最終証明
- 各sorry の具体的解決

#### C. 試行ファイルの統合
**目的:** 最も進んだ試行ファイルから成果を本流に統合
- sorry数0のファイルから学習
- 動作する証明の特定と統合

### 🔧 実行手順

#### 1. 現状確認
```bash
cd /home/ubuntu/workbench/projects/potion_problem
# 最新状態の確認
cat docs/state/current-state.md
# ビルド状態確認
lake build UniformHittingTime.TelescopingSeries 2>&1 | head -20
```

#### 2. 作業実行
- 選択したタスクに集中
- 小さく確実な前進を心がける
- ビルド成功を維持しながら改善

#### 3. 成果記録とコミット
```bash
# 作業内容の記録
echo "## 第N回実装 ($(date))" >> docs/state/iteration-history.md
echo "- 担当者: [あなたの識別子]" >> docs/state/iteration-history.md
echo "- 実施内容: [具体的達成内容]" >> docs/state/iteration-history.md
echo "- 解決したsorry: [ファイル名:行数]" >> docs/state/iteration-history.md
echo "- 数学的洞察: [発見事実]" >> docs/state/iteration-history.md
echo "- ビルド状態: [結果]" >> docs/state/iteration-history.md
echo "" >> docs/state/iteration-history.md

# 必須コミット
git add -A
git commit -m "Lean実装第N回: [具体的な達成内容]

- 解決したsorry: [ファイル名:行数]
- 修正したエラー: [エラーの種類]
- 新たな洞察: [発見した数学的構造]
- ビルド状態: [成功/失敗の詳細]

次回優先: [最重要な次のタスク]"
```

### 📚 重要なリソース

**数学的背景:**
- 媚薬問題は停止時刻理論の教育的例題
- E[τ] = e は ∑_{n=0}^∞ 1/n! = e との美しい対応
- 証明の核心: P(τ = n) = (n-1)/n! for n ≥ 2

**技術的制約:**
- mathlib4 v4.12.0 の API制限を認識
- タイムアウト回避のため簡潔な証明を優先
- 型の明示的注釈でエラー回避

**利用可能な試行ファイル:**
```
ActuallyWorking.lean          TelescopingSeriesMinimal.lean
WorkingCore.lean              TelescopingSeriesWorking.lean
MinimalWorking.lean           [他20個以上のファイル]
```

### ⚠️ 重要な注意

1. **時間軸ジャンプ対応**: あなたが思っている試行回数より実際は進んでいる可能性
2. **Git Diff 評価**: あなたの変更は厳密に評価される
3. **成果の必須記録**: 「改善した」主張と実際の変更の一致が必要
4. **数学的正しさ最優先**: ビルド成功より数学的妥当性を重視

### 🎉 期待される成果

- 1個のsorryの解決 OR 1個のエラーの修正
- 数学的洞察の記録
- 次回実装者への明確な引き継ぎ
- git diffで確認可能な具体的前進

---

**あなたは第何回目の実装者ですか？どのタスクに取り組みますか？**