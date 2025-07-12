# プロジェクト国際化問題分析

**作成日時**: 2025-07-13-02-10-00  
**分析者**: 多言語対応アストルフォ  
**課題**: 日本語名称による英語圏アストルフォへの障壁

---

## 🌍 言語バリア問題の深刻度

### 現在の日本語名称とその問題

| 現在のファイル名 | 英語圏での理解度 | 推測可能性 | 問題レベル |
|-----------------|------------------|------------|------------|
| `Biyaku*.lean` | **0%** | 全く不明 | 🚨 Critical |
| `BiyakuCore.lean` | 10% | Coreは分かる | 🚨 Critical |
| `BiyakuComplete.lean` | 20% | Completeは分かる | ⚠️ High |
| `BiyakuProof.lean` | 30% | Proofは分かる | ⚠️ High |

### 語学的分析

#### 1. "Biyaku"の問題点
- **日本語**: 媚薬 (びやく)
- **英語圏の認識**: 完全に謎の単語
- **音韻的類推**: 不可能
- **専門用語性**: 日本語固有の概念

#### 2. 英語での適切な表現
- **学術的**: "Aphrodisiac" 
- **数学的**: "Sensitivity Enhancement"
- **確率論的**: "Threshold Hitting Time"
- **一般的**: "Potion Problem"

## 🎯 推奨命名戦略

### Phase 1: 即座に理解可能な英語名
```
Biyaku*.lean → AphrodisiacProblem*.lean
または
Biyaku*.lean → PotionProblem*.lean
```

### Phase 2: 機能的な英語名
```
BiyakuCore.lean → ThresholdTheory.lean
BiyakuProof.lean → HittingTimeProof.lean  
BiyakuComplete.lean → ExpectedValueComplete.lean
BiyakuHelper.lean → ProbabilityHelpers.lean
```

### Phase 3: 数学的厳密性重視
```
BiyakuCore.lean → IrwinHallDistribution.lean
BiyakuProof.lean → StoppingTimeExpectation.lean
BiyakuComplete.lean → TelescopingSeriesProof.lean
```

## 📚 国際的な数学命名規約

### 確率論の標準用語 (英語)
- **Hitting Time**: τ (停止時間)
- **Expected Value**: E[τ] (期待値)
- **Uniform Distribution**: U[0,1) (一様分布)
- **Stopping Time**: 停止時間
- **Irwin-Hall Distribution**: 一様分布の和の分布

### 多言語コメント戦略
```lean
/-- 
Aphrodisiac Problem: Expected hitting time calculation
媚薬問題: 期待停止時間の計算

The expected number of trials until sensitivity reaches threshold 2
感度が閾値2に達するまでの期待試行回数
-/
```

## 🚀 実装提案

### Option A: Conservative (保守的)
- 現在の`Biyaku`を`AphrodisiacProblem`に統一
- 日本語コメントは併記で維持
- 既存構造を最小限変更

### Option B: Professional (専門的)  
- 数学的に正確な英語名に完全移行
- `StoppingTime`, `HittingTime`, `ExpectedValue`等
- 国際的な数学論文スタイル

### Option C: Hybrid (混合)
- メインは英語、日本語は別名/エイリアス
- `namespace AphrodisiacProblem -- 媚薬問題`
- バイリンガルドキュメント

## 🌟 推奨アプローチ

**Option B (Professional)** を推奨！

### 理由:
1. **学術的正確性**: 国際的な確率論用語を使用
2. **将来性**: 英語圏のアストルフォが貢献可能
3. **可読性**: コードが自己説明的になる
4. **専門性**: 数学的厳密性が名前から伝わる

### 具体的リネーミング案:
```
PotionProblem/
├── StoppingTime/
│   ├── Basic.lean              (基本定義)
│   ├── IrwinHall.lean         (Irwin-Hall分布)
│   ├── ExpectedValue.lean     (期待値計算)
│   ├── TelescopingProof.lean  (テレスコーピング証明)
│   └── NumericalVerification.lean (数値検証)
└── README.md                   (英日バイリンガル)
```

---

**結論**: "Biyaku"は英語圏アストルフォには完全に不透明。数学的に正確で国際的に通用する英語名への移行が急務！

マスター、どのオプションがお好みですか？♡