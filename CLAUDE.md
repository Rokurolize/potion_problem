# CLAUDE.md - 媚薬問題 Lean 4 形式化プロジェクト

## 🚀 次の反復を実行する方法

**マスターが「次の反復を実行。」と指示した場合、以下を実行:**

### 1. 即座実行コマンド
Taskツールを使用し、以下のプロンプトを実行:

### 2. 実行用プロンプト (コピー&ペースト用)

```
# 自己完結型 Lean 4 実装プロンプト

## 📋 ミッション：媚薬問題 E[τ] = e の完全形式化

あなたは**Lean 4実装者**です。前任者たちによる大量の試行の結果、現在は高度に進歩した状態にあります。

### 🎯 問題定義
**媚薬問題**: E[τ] = e を証明する
- τ = min{n ≥ 1 : ∑ᵢ₌₁ⁿ Uᵢ ≥ 1}
- Uᵢ ~ Uniform[0,1) (独立同分布)
- 証明: E[τ] = e ≈ 2.718281828

### 📊 現在の正確な状況 (2025年7月16日時点)

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
6. `UniformHittingTime.TelescopingSeriesFixed` - ビルド成功, sorry: 1

**❌ 最優先課題:**
7. `UniformHittingTime.UniformSumHittingTime` - メイン定理, sorry: 4

**📁 利用可能リソース:**
- 26個の試行ファイル (ActuallyWorking.lean, MinimalWorking.lean等)
- 30個以上のレポートファイル
- 過去の成功例と失敗パターン

### 🎯 あなたの今回タスク (以下から1つ選択)

#### A. UniformSumHittingTime.lean 完成 (推奨)
**残り sorry: 4**
- メイン定理 E[τ] = e の最終証明
- 各sorry の具体的解決

#### B. TelescopingSeriesFixed.lean 完成
**残り sorry: 1**
- 望遠鏡級数の完全な証明

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
lake build UniformHittingTime.UniformSumHittingTime 2>&1 | head -20
```

#### 2. 作業実行
- 選択したタスクに集中
- 小さく確実な前進を心がける
- ビルド成功を維持しながら改善

#### 3. 成果記録とコミット
```bash
# 作業内容の記録
echo "## 実装記録 ($(date))" >> docs/state/iteration-history.md
echo "- 担当者: [あなたの識別子]" >> docs/state/iteration-history.md
echo "- 実施内容: [具体的達成内容]" >> docs/state/iteration-history.md
echo "- 解決したsorry: [ファイル名:行数]" >> docs/state/iteration-history.md
echo "- 数学的洞察: [発見事実]" >> docs/state/iteration-history.md
echo "- ビルド状態: [結果]" >> docs/state/iteration-history.md
echo "" >> docs/state/iteration-history.md

# 必須コミット
git add -A
git commit -m "Lean実装: [具体的な達成内容]

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

**現在のプロジェクト状況を確認し、最も重要なタスクを選択してください。**
```

### 3. 技術的実行方法

**Taskツールの使用方法:**
1. 上記のプロンプトを全文コピー
2. Taskツールを呼び出し、description に "Execute Lean 4 implementation task"
3. prompt パラメータに上記プロンプトを貼り付け

**注意:** 現在のTaskツールAPI仕様に合わせて調整が必要な場合があります。

---

## 📋 プロジェクト概要

### 問題の出典

**作者**: suamax (@suamax_scp)  
**投稿日**: 2025年7月9日  
**URL**: https://x.com/suamax_scp/status/1942902598203322849

**原文**:
```
女騎士「私に何を飲ませた！」
オーク「飲む前の感度をn倍とした時に、感度をn+m倍(m:[0,1)、毎回の摂取ごとに独立して判定される)まで引き上げる薬だ。通常時の感度を1倍として、お前の感度が2倍になるまでこれを飲ませる」
女騎士「私が媚薬を飲む回数の期待値はどれくらいになるんだ……？」
```

### 数学的背景

**証明の核心構造:**
1. **基本恒等式**: ∑_{n=0}^∞ 1/n! = e
2. **確率質量関数**: P(τ = n) = (n-1)/n! for n ≥ 2
3. **期待値計算**: E[τ] = ∑_{n=1}^∞ n · P(τ = n) = e

**形式化の課題:**
- **API制約**: mathlib4 v4.12.0での無限級数操作の制限
- **型システム**: 確率論の厳密な型付け
- **性能制約**: 複雑な証明でのタイムアウト回避

### 重要な原則

**開発哲学:**
- **小さく確実に**: 1回の実装で1つの具体的改善
- **数学的正しさ最優先**: ビルド成功より数学的妥当性
- **継続可能性**: 長期的な開発に耐える設計

**品質保証:**
- **Git記録必須**: 全ての変更をコミットで追跡
- **ビルド検証**: 変更後は必ずビルド状態を確認
- **記録の正確性**: 報告と実際の変更の一致を保証

### 継続的改善システム

- **時間軸ジャンプ対応**: 非線形な時間軸でも現状把握可能
- **Git Diff評価**: 「言うだけならタダ」問題の完全回避
- **累積学習**: 成功/失敗パターンの蓄積と活用

### 重要な文書

**状態管理システム:**
- `docs/state/current-state.md` - 現在の正確な状況
- `docs/state/iteration-history.md` - 累積試行記録
- `docs/state/self-contained-prompt.md` - 自己完結実装プロンプト
- `docs/state/session-restoration.md` - セッション復元手順

**論文とドキュメント:**
- `2025-07-15-02-00-00-aphrodisiac-problem-MIT-thesis.md` - MIT水準の数学論文
- `docs/problem-statement-japanese.md` - 日本語原文
- `docs/problem-statement-context.md` - 英語圏向け解釈

---

**注記**: このプロジェクトは数学の絶対性と形式検証の厳密性を組み合わせた、真の数学的価値を追求する取り組みです。マスターが「次の反復を実行。」と指示した場合、このファイルの最初のセクションの手順に従って即座に実行してください。