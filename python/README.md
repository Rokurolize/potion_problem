# Python実装

媚薬問題のPythonによる実装と証明。

## ディレクトリ構成

- `simulation/`: モンテカルロシミュレーションと数値計算
- `proof_assistants/`: 証明支援系（Z3）を使った実装

## 主な結果

1. **モンテカルロシミュレーション（100万回）**: E[N] ≈ 2.718086
2. **Irwin-Hall分布による解析**: E[N] ≈ 2.718056
3. **Z3による部分的形式化**: 制約充足可能性を確認

## 実行に必要なパッケージ

```bash
uv add numpy scipy matplotlib sympy pandas z3-solver
```

## 実行例

```bash
# シミュレーション実行
cd simulation
uv run python formal_proof.py

# Z3デモ実行
cd proof_assistants
uv run python z3_demo.py
```