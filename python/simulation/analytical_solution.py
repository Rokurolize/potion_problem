#!/usr/bin/env python3
"""
媚薬問題の解析的解法
正確な期待値 E[τ] = e を導出する
"""

import numpy as np
from typing import List, Tuple
import matplotlib.pyplot as plt
import math


def compute_exact_probabilities(max_n: int = 20) -> Tuple[float, List[float], float]:
    """
    正確な確率と期待値を計算

    問題設定:
    - 初期感度: 1
    - 各回の増加: X_i ~ U[0,1)
    - 目標: 感度が2以上 (つまり増加量の合計が1以上)

    τ = min{n: X_1 + ... + X_n >= 1}

    Returns:
        expected_value: 期待値 E[τ]
        probabilities: 各nに対するP(τ=n)
        cumulative_prob: 累積確率
    """

    probabilities = []
    expected_value = 0.0

    # P(S_n < 1) = 1/n! を使用
    prev_prob_less_than_1 = 1.0  # P(S_0 < 1) = 1

    for n in range(1, max_n + 1):
        # P(S_n < 1) = 1/n!
        prob_less_than_1 = 1.0 / math.factorial(n)

        # P(τ = n) = P(S_{n-1} < 1) - P(S_n < 1)
        prob_n = prev_prob_less_than_1 - prob_less_than_1

        probabilities.append(prob_n)
        expected_value += n * prob_n

        prev_prob_less_than_1 = prob_less_than_1

        # 収束チェック
        if prob_less_than_1 < 1e-10:
            break

    cumulative_prob = sum(probabilities)

    return expected_value, probabilities, cumulative_prob


def verify_e_convergence() -> None:
    """
    E[τ] = e への収束を確認

    E[τ] = Σ_{n=1}^∞ n * P(τ=n)
         = Σ_{n=1}^∞ n * (1/(n-1)! - 1/n!)
         = Σ_{n=1}^∞ 1/(n-1)!
         = e
    """
    print("E[τ] = e の理論的証明:")
    print("-" * 50)

    # 部分和を計算
    partial_sums = []
    terms = []

    for n in range(20):
        term = 1.0 / math.factorial(n)
        terms.append(term)
        partial_sum = sum(terms)
        partial_sums.append(partial_sum)

        if n < 10:
            print(f"n={n}: 1/{n}! = {term:.10f}, 部分和 = {partial_sum:.10f}")

    print(f"\ne = {math.e:.10f}")
    print(f"最終部分和 = {partial_sums[-1]:.10f}")
    print(f"差 = {abs(math.e - partial_sums[-1]):.2e}")


def theoretical_analysis() -> Tuple[float, List[float]]:
    """理論的分析とまとめ"""
    print("\n媚薬問題の理論的分析:")
    print("=" * 50)

    # 基本的な事実
    print("\n基本的事実:")
    print("- 初期感度: 1")
    print("- 各回の増加: X_i ~ U[0,1)")
    print("- 目標: 感度が2以上 (増加量の合計が1以上)")
    print("- X ~ U[0,1) の期待値: E[X] = 1/2")
    print("- X ~ U[0,1) の分散: Var[X] = 1/12")

    # 重要な定理
    print("\n重要な定理:")
    print("- S_n = X_1 + ... + X_n とする")
    print("- P(S_n < 1) = 1/n! (Irwin-Hall分布の性質)")
    print("- P(τ = n) = P(S_{n-1} < 1) - P(S_n < 1)")
    print("          = 1/(n-1)! - 1/n!")
    print("          = (n-1)/n!")

    # 期待値の計算
    print("\n期待値の導出:")
    print("E[τ] = Σ_{n=1}^∞ n * P(τ=n)")
    print("     = Σ_{n=1}^∞ n * [(n-1)/n!]")
    print("     = Σ_{n=1}^∞ 1/(n-1)!")
    print("     = 1/0! + 1/1! + 1/2! + ...")
    print("     = e")

    # 数値計算
    exact_e, probs, cum = compute_exact_probabilities()
    print(f"\n数値計算による期待値: {exact_e:.10f}")
    print(f"理論値 e: {math.e:.10f}")
    print(f"誤差: {abs(exact_e - math.e):.2e}")
    print(f"累積確率: {cum:.10f}")

    # 最初の数項の確率
    print("\n確率分布 P(τ=n):")
    for i, p in enumerate(probs[:10], 1):
        print(f"P(τ={i}) = {p:.8f} = {i - 1}/{i}!")

    return exact_e, probs


def plot_analysis(probabilities: List[float]) -> None:
    """結果の可視化"""
    fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(12, 10))

    # 確率質量関数
    n_values = list(range(1, len(probabilities) + 1))
    ax1.bar(n_values, probabilities, alpha=0.7, color="blue")
    ax1.set_xlabel("Number of doses (n)")
    ax1.set_ylabel("Probability P(τ=n)")
    ax1.set_title("Probability Mass Function")
    ax1.grid(True, alpha=0.3)

    # 累積分布関数
    cumulative = np.cumsum(probabilities)
    ax2.plot(n_values, cumulative, "b-", linewidth=2)
    ax2.set_xlabel("Number of doses (n)")
    ax2.set_ylabel("Cumulative Probability")
    ax2.set_title("Cumulative Distribution Function")
    ax2.grid(True, alpha=0.3)
    ax2.axhline(y=1, color="r", linestyle="--", alpha=0.5)

    # 期待値への寄与
    contributions = [n * p for n, p in zip(n_values, probabilities)]
    ax3.bar(n_values, contributions, alpha=0.7, color="green")
    ax3.set_xlabel("Number of doses (n)")
    ax3.set_ylabel("n × P(τ=n)")
    ax3.set_title("Contribution to Expected Value")
    ax3.grid(True, alpha=0.3)

    # e への収束
    partial_sums = []
    for i in range(len(probabilities)):
        partial_sum = sum(contributions[: i + 1])
        partial_sums.append(partial_sum)

    ax4.plot(n_values, partial_sums, "r-", linewidth=2, label="Partial sum")
    ax4.axhline(y=math.e, color="black", linestyle="--", alpha=0.5, label=f"e = {math.e:.6f}")
    ax4.set_xlabel("Number of terms")
    ax4.set_ylabel("Partial sum of E[τ]")
    ax4.set_title("Convergence to e")
    ax4.legend()
    ax4.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(
        "/home/ubuntu/workbench/potion_problem/reports/visualization/analytical-solution.png",
        dpi=300,
    )
    plt.close()


def main() -> None:
    """メイン処理"""
    print("媚薬問題の解析的解法")
    print("=" * 70)

    # e への収束を確認
    verify_e_convergence()

    # 理論的分析
    exact_value, probabilities = theoretical_analysis()

    # 可視化
    plot_analysis(probabilities)

    print("\n" + "=" * 70)
    print(f"結論: 感度が2倍になるまでの期待回数は E[τ] = e ≈ {math.e:.6f} 回")
    print("=" * 70)


if __name__ == "__main__":
    main()
