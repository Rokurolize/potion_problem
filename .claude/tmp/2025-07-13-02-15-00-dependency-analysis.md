# リネーミング影響範囲分析: 依存関係の全体像

**作成日時**: 2025-07-13-02-15-00  
**分析者**: 依存関係分析アストルフォ  
**重要度**: 🚨 Critical - リネーミング前に必読

---

## 🎯 マスターの指摘の正確性

**YES！** リネームは氷山の一角です。実際には以下の**大規模修正作業**が必要：

## 📊 影響範囲の完全マップ

### 1. Lean 4ファイル内の依存関係

#### A. 直接import参照 (最重要)
```lean
-- /lean4/PotionProblem/PotionProblem.lean
import PotionProblem.BiyakuSimple     →  StoppingTimeBasic
import PotionProblem.BiyakuCore       →  IrwinHallDistribution  
import PotionProblem.BiyakuComplete   →  TelescopingSeriesProof
```

#### B. 内部namespace参照
各ファイル内で:
```lean
namespace PotionProblem.Biyaku  →  PotionProblem.StoppingTime
open PotionProblem.BiyakuCore   →  PotionProblem.IrwinHall
```

#### C. 関数・定理の相互参照
```lean
-- BiyakuComplete.lean内で
core_theorem (from BiyakuCore)  →  irwin_hall_theorem
prob_hitting_time (from Biyaku) →  hitting_time_pmf
```

### 2. ビルドシステムへの影響

#### lakefile.toml
```toml
[[lean_lib]]
name = "PotionProblem"  →  "StoppingTimeProblem"
```

#### ディレクトリ構造
```
lean4/PotionProblem/  →  lean4/StoppingTimeProblem/
```

### 3. ドキュメント内の参照

#### 影響を受けるファイル (10個以上):
- `FINAL_REPORT.md`: BiyakuComplete.leanへの参照
- `PROOF_STATUS.md`: 各Biyakuファイルの状態記録
- `reports/analysis/*.md`: ファイル名の具体的言及
- `reports/summary/*.md`: 証明ファイルパス参照

### 4. 外部からの参照

#### Python側 (現在は無いが要注意)
- Lean 4実行スクリプト
- 自動テストシステム
- ビルド検証スクリプト

## ⚠️ 修正が必要な具体的項目

### Immediate (即座に必要)
1. **import文の一括更新** (8箇所)
2. **namespace宣言の変更** (各ファイル内)
3. **lakefile.tomlの調整**
4. **ディレクトリ名変更**

### Secondary (二次的に必要)  
1. **関数名の参照更新** (ファイル間参照)
2. **コメント内のファイル名言及**
3. **ドキュメントの参照リンク** (10+ファイル)
4. **エラーメッセージの更新**

### Hidden (隠れた依存)
1. **VSCode設定** (.vscode/settings.json)
2. **Git履歴の整合性**
3. **外部ツールの設定**
4. **CI/CDスクリプト** (存在する場合)

## 🚀 正しいリネーミング戦略

### Phase 1: 依存関係マッピング
1. すべてのimport文をリスト化
2. namespace使用箇所の特定  
3. 相互参照の詳細分析

### Phase 2: 段階的リネーミング
1. **最下位依存から開始** (Basic.lean等)
2. **中間層の更新** (Core, Helper)
3. **最上位の統合** (Complete, Main)

### Phase 3: 一貫性チェック
1. ビルド成功確認
2. すべての参照の動作確認
3. ドキュメントの整合性確認

## 💡 推奨実装順序

```
1. Basic.lean → StoppingTimeBasic.lean
2. BiyakuCore.lean → IrwinHallDistribution.lean  
3. BiyakuHelper.lean → ProbabilityHelpers.lean
4. BiyakuProof.lean → HittingTimeProof.lean
5. BiyakuComplete.lean → TelescopingSeriesProof.lean
6. PotionProblem.lean → 全import文更新
7. lakefile.toml → ライブラリ名更新
8. ドキュメント一括更新
```

## 🔥 Critical Warning

**絶対にやってはいけないこと:**
- ❌ ファイル名だけ変更してcommit
- ❌ 一部だけ更新して放置  
- ❌ importエラーを無視
- ❌ ドキュメントの更新を忘れる

**必須事項:**
- ✅ 全依存関係の事前マッピング
- ✅ 段階的・原子的操作
- ✅ 各段階でのビルド確認
- ✅ 完全性チェック

---

**結論**: マスターの指摘通り、これは**システム全体の構造的変更**です。単純なリネームではなく、**依存関係工学**の領域ですね！

準備完了次第、段階的実行に移れます♡