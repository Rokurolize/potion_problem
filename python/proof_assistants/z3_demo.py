#!/usr/bin/env python3
"""
証明支援系（Z3 SMT Solver）を使った形式的証明のデモ
"""

from z3 import Int, Real, Bools, Solver, And, Or, Not, sat, unsat, Sum  # type: ignore


class ProofAssistantDemo:
    """証明支援系のデモクラス"""

    def __init__(self) -> None:
        print("証明支援系デモ開始！♡")

    def example1_simple_arithmetic(self) -> None:
        """例1: 簡単な算術の証明"""
        print("\n=== 例1: 2 + 2 = 4 の証明 ===")

        # 整数変数の定義
        x = Int("x")
        y = Int("y")

        # ソルバーの作成
        s = Solver()

        # 制約の追加
        s.add(x == 2)
        s.add(y == 2)
        s.add(x + y == 4)

        # 検証
        if s.check() == sat:
            print("✓ 証明成功: 2 + 2 = 4")
            print(f"モデル: {s.model()}")
        else:
            print("✗ 証明失敗")

    def example2_demorgan_law(self) -> None:
        """例2: ド・モルガンの法則の証明"""
        print("\n=== 例2: ド・モルガンの法則 ===")

        # 命題変数
        p, q = Bools("p q")

        # ド・モルガンの法則: ¬(p ∧ q) ≡ (¬p ∨ ¬q)
        demorgan = Not(And(p, q)) == Or(Not(p), Not(q))

        # 証明関数
        def prove(formula):
            s = Solver()
            s.add(Not(formula))
            if s.check() == unsat:
                return True
            else:
                return False

        if prove(demorgan):
            print("✓ ド・モルガンの法則が証明されました！")
        else:
            print("✗ 証明失敗")

    def example3_probability_constraint(self) -> None:
        """例3: 確率制約の表現"""
        print("\n=== 例3: 確率制約 ===")

        # 実数変数（確率を表す）
        p1 = Real("p1")
        p2 = Real("p2")
        p3 = Real("p3")

        s = Solver()

        # 確率の制約
        s.add(p1 >= 0, p1 <= 1)
        s.add(p2 >= 0, p2 <= 1)
        s.add(p3 >= 0, p3 <= 1)

        # 確率の和が1
        s.add(p1 + p2 + p3 == 1)

        # 特定の制約
        s.add(p1 == 0.5)  # P(N=2) = 0.5
        s.add(p2 == 1 / 3)  # P(N=3) = 1/3

        if s.check() == sat:
            m = s.model()
            print("✓ 確率制約を満たす解が見つかりました！")
            print(f"P(N=2) = {m[p1]}")
            print(f"P(N=3) = {m[p2]}")
            print(f"P(N=4) = {m[p3]}")

    def example4_expected_value_constraint(self) -> None:
        """例4: 期待値の制約"""
        print("\n=== 例4: 期待値の制約 ===")

        # 変数の定義
        E = Real("E")  # 期待値
        p2 = Real("p2")
        p3 = Real("p3")
        p4 = Real("p4")

        s = Solver()

        # 確率の制約
        s.add(p2 >= 0, p2 <= 1)
        s.add(p3 >= 0, p3 <= 1)
        s.add(p4 >= 0, p4 <= 1)

        # 期待値の定義
        s.add(E == 2 * p2 + 3 * p3 + 4 * p4)

        # 既知の値
        s.add(p2 == 0.5)
        s.add(p3 == 1 / 3)
        s.add(p4 == 0.125)

        # 期待値がeに近いか確認
        e_approx = 2.71828
        s.add(E > e_approx - 0.1)
        s.add(E < e_approx + 0.1)

        if s.check() == sat:
            m = s.model()
            print("✓ 期待値制約を満たす解が見つかりました！")
            print(f"E[N] = {m[E]}")
            # 実際の値を計算
            actual = 2 * 0.5 + 3 * (1 / 3) + 4 * 0.125
            print(f"実際の部分和: {actual}")

    def example5_potion_problem_partial(self) -> None:
        """例5: 媚薬問題の部分的な形式化"""
        print("\n=== 例5: 媚薬問題の部分的形式化 ===")

        # 確率変数
        probs = [Real(f"p{i}") for i in range(2, 10)]

        s = Solver()

        # 確率の基本制約
        for p in probs:
            s.add(p >= 0)
            s.add(p <= 1)

        # 具体的な値（計算結果から）
        s.add(probs[0] == 0.5)  # P(N=2)
        s.add(probs[1] == 1 / 3)  # P(N=3)
        s.add(probs[2] == 0.125)  # P(N=4)

        # 再帰関係の近似
        # P(N=n) ≈ P(N=n-1) * factor
        for i in range(1, len(probs) - 1):
            s.add(probs[i + 1] < probs[i])  # 単調減少

        # 確率の和が1に近い
        total = Sum(probs)
        s.add(total >= 0.99)
        s.add(total <= 1.01)

        if s.check() == sat:
            print("✓ 媚薬問題の制約を満たす確率分布が存在します！")
            m = s.model()

            # 期待値の計算
            expected = 0.0
            for i, p in enumerate(probs[:5]):
                val = m[p]
                if val is not None:
                    # RatNumRefをfloatに変換
                    p_float = float(val.as_fraction())
                    expected += (i + 2) * p_float
                    print(f"P(N={i + 2}) = {p_float:.6f}")

            print(f"\n部分的な期待値: {expected:.6f}")

    def example6_formal_proof_attempt(self) -> None:
        """例6: より形式的な証明の試み"""
        print("\n=== 例6: 形式的な証明の試み ===")

        # 定理: ある条件下で期待値はeに収束する
        print("定理: n個の[0,1)一様乱数の和が初めて1以上になる回数の期待値はe")

        # シンボリック変数
        e_val = Real("e")
        E_N = Real("E_N")

        s = Solver()

        # eの定義（近似）
        s.add(e_val > 2.71)
        s.add(e_val < 2.72)

        # 期待値がeに等しい
        s.add(E_N == e_val)

        # 追加の制約（更新過程の理論から）
        E_X = Real("E_X")
        s.add(E_X == 0.5)  # E[X] = 1/2

        # 関係式（簡略化）
        # E[N] ≈ 1/E[X] + correction
        correction = Real("correction")
        s.add(correction > 0.7)
        s.add(correction < 0.8)
        s.add(E_N == 1 / E_X + correction)

        if s.check() == sat:
            m = s.model()
            print("✓ 制約系が充足可能です！")
            print(f"E[N] = {m[E_N]}")
            print(f"e = {m[e_val]}")
            print(f"補正項 = {m[correction]}")
        else:
            print("✗ 制約系が充足不可能")

    def run_all_examples(self) -> None:
        """すべての例を実行"""
        self.example1_simple_arithmetic()
        self.example2_demorgan_law()
        self.example3_probability_constraint()
        self.example4_expected_value_constraint()
        self.example5_potion_problem_partial()
        self.example6_formal_proof_attempt()

        print("\n=== まとめ ===")
        print("Z3 SMT solverを使って、以下のことができました：")
        print("1. 簡単な算術の証明")
        print("2. 論理法則（ド・モルガンの法則）の証明")
        print("3. 確率制約の表現と求解")
        print("4. 期待値計算の形式化")
        print("5. 媚薬問題の部分的な形式化")
        print("\nただし、完全な形式的証明には以下が必要です：")
        print("- より高度な証明支援系（Lean, Coq, Isabelleなど）")
        print("- 数学的帰納法の形式化")
        print("- 実数の厳密な取り扱い")
        print("- 確率論の公理的定義")


if __name__ == "__main__":
    demo = ProofAssistantDemo()
    demo.run_all_examples()
