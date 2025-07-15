# セッション復元手順

## 🚀 新セッション開始時の完全復元ガイド

このファイルは、時間軸のジャンプや長期間の中断後に、媚薬問題プロジェクトの正確な現状を把握するためのものです。

### 📖 復元手順 (順番厳守)

#### ステップ1: 基本状況確認
```bash
cd /home/ubuntu/workbench/projects/potion_problem
pwd
git branch  # refactoring-safety ブランチか確認
git status  # 作業ディレクトリの状態確認
```

#### ステップ2: 最新状態ファイル読み取り
```bash
# 現在の状況を完全把握
cat docs/state/current-state.md

# 試行履歴の確認
cat docs/state/iteration-history.md

# 最新の自己完結プロンプト確認
cat docs/state/self-contained-prompt.md
```

#### ステップ3: プロジェクト構造確認
```bash
# Leanファイルの存在確認
ls -la UniformHittingTime/
wc -l UniformHittingTime/*.lean  # ファイルサイズ確認

# 試行ファイル数確認
ls UniformHittingTime/ | grep -E "(Working|Minimal|Actually)" | wc -l
```

#### ステップ4: ビルド状態の迅速確認
```bash
# 成功が期待される基本モジュール
timeout 15 lake build UniformHittingTime.FactorialSeries
timeout 15 lake build UniformHittingTime.IrwinHall
timeout 15 lake build UniformHittingTime.HittingTime

# 問題のあるモジュール (エラー内容確認用)
timeout 10 lake build UniformHittingTime.TelescopingSeries 2>&1 | head -10
```

#### ステップ5: Sorry数の現状確認
```bash
# 全ファイルのsorry数を確認
for file in UniformHittingTime/*.lean; do 
  echo -n "$(basename "$file"): "; 
  grep -c "sorry" "$file" 2>/dev/null || echo "0"; 
done | sort -t':' -k2 -n
```

### 🎯 復元完了の判定基準

以下の情報を確認できれば復元完了:

1. **✅ 現在の試行回数**: 何回目の実装者か
2. **✅ ビルド状況**: どのモジュールが動作/失敗しているか  
3. **✅ 残り課題**: 最優先で取り組むべきsorryまたはエラー
4. **✅ 利用可能リソース**: 試行ファイルと成功例
5. **✅ 次のアクション**: 具体的な作業内容

### 🔧 サブエージェント実行準備

復元が完了したら、以下でサブエージェントを実行:

```
プロンプトファイル: docs/state/self-contained-prompt.md の内容を使用
```

**重要**: このプロンプトは完全に自己完結しており、追加の文脈説明は不要です。

### 📊 現状把握チェックリスト

#### 基本情報
- [ ] 作業ディレクトリの確認
- [ ] Gitブランチの確認 (refactoring-safety)
- [ ] 最新状態ファイルの内容把握

#### 技術状況  
- [ ] FactorialSeries.lean: ビルド成功確認
- [ ] IrwinHall.lean: ビルド成功確認
- [ ] HittingTime.lean: ビルド成功確認
- [ ] TelescopingSeries.lean: エラー内容確認
- [ ] UniformSumHittingTime.lean: sorry数確認

#### 戦略状況
- [ ] 最優先課題の特定
- [ ] 利用可能な試行ファイルの確認
- [ ] 次の具体的アクションの決定

### ⚠️ 時間軸ジャンプ対応

この復元手順は以下の状況に対応しています:

- **非線形時間**: 「n回目」と思っていても実際は「n+100回目」の可能性
- **セッション断絶**: 前回の会話履歴が利用できない
- **状況の複雑化**: 大量の試行ファイルによる混乱
- **現実と記録の乖離**: 過去の「成功」報告と実際の状況の差

### 🎉 復元成功の確認

以下を1文で答えられれば復元成功:

1. **現在何回目の試行か？**
2. **最優先で解決すべき課題は？**  
3. **次に使用すべきLeanファイルは？**
4. **期待される成果は？**

---

**この手順により、どんな時間軸ジャンプが発生しても、迅速かつ正確な現状把握が可能です。**