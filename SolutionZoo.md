# Potion problem solution zoo

This file implements the six intentionally extreme presentations requested for
the repository.  The Lean hooks live in
[`PotionProblem/SolutionZoo.lean`](PotionProblem/SolutionZoo.lean).

All six paths still point to the same mathematical value:

```text
E[tau] = e.
```

The point of the zoo is not to pretend these are unrelated theorems.  It is to
make six radically different explanations available from the same verified
library.

## 1. どの既存の解法よりも面白い解法

名前: Yule分枝のmany-to-one証明

面白さの核: 1本の足し算の停止時刻の期待値を、時刻1のYule純出生過程の平均個体数として読む。`e`は級数を計算して出るのではなく、分枝集団の平均成長`m'=m`から出る。

```text
tau = sum_{n>=0} 1_{S_n <= 1}.
```

累積和` t_i = S_i `へ変数変換すると、生存事象は

```text
0 < t_1 < ... < t_n <= 1.
```

この順序列を「根から第`n`世代個体までの出生時刻列」と見る。全ての世代の出生鎖を足した質量は、Yule過程の時刻1における平均個体数の影になる。平均個体数`m(t)`は

```text
m(0) = 1,
m'(t) = m(t)
```

なので`m(1)=e`。

同じ順序配置をPoisson Janossy密度で読むと`exp(-1)`の逆数として`e`が出る。Yule版はそこからさらに「個体数が指数成長する」という絵に変える。

Lean hook:

```lean
mostInterestingYuleBranchingSolution
yuleExpectedPopulation_eq_exp
```

## 2. どの既存の解法よりもクソつまらん解法

名前: 既存定理を別名で呼ぶだけ証明

つまらなさの核: 数学をしない。`main_theorem`がもう証明済みなので、別名を付けて返すだけ。

```text
E[tau] = e    -- already main_theorem
```

これは解法というより再掲で、だから一番つまらない。少しだけ数学らしい退屈版として、PMF表計算`mostBoringPmfSeriesSolution`も残してある。

Lean hook:

```lean
mostBoringAliasSolution
```

## 3. どの既存の解法よりもエレガントな解法

名前: Green質量証明

エレガンスの核: 値関数を逐次計算せず、殺された遷移のGreen核の全質量だけを見る。

残り距離`r`に対して

```text
(Kf)(r) = int_0^r f(t) dt.
```

`h(r)=exp(r)`は

```text
h(r) - Kh(r) = 1
```

を満たす。したがって初期距離`1`の期待寿命は`h(1)=e`。

Lean hook:

```lean
mostElegantGreenSolution
```

## 4. どの既存の解法よりも短い解法

名前: 分配関数1行

短さの核: 生存prefixの総質量を名前にしてしまえば、証明は1行になる。

```text
Z = sum_{n>=0} 1/n!
Z = exp(1).
```

もちろん裏には配置空間の同一視がある。短さだけに振るなら、説明を削ってこの恒等式だけを見る。

Lean hook:

```lean
shortestPartitionFunctionSolution
```

## 5. どの既存の解法よりも人間の頭が混乱する解法

名前: 初期上昇ランへの変装

混乱の核: 足し算の停止時刻を、別の独立一様列の「最初に下降する位置」と同じ尾分布にしてしまう。

別に`V_1,V_2,...`を独立一様に取り、初期上昇ラン長を

```text
R = max { n : V_1 < ... < V_n }.
```

とする。すると

```text
P(R >= n) = P(V_1 < ... < V_n) = 1/n!.
```

一方、`S_n <= 1`も累積和変換で同じ順序chamberへ行くので

```text
P(tau - 1 >= n) = 1/n!.
```

よって`tau-1`と`R`は尾分布が一致する。足し算の問題が「列がいつ下降するか」に化けるので、見た目はかなり混乱する。

Lean hook:

```lean
mostConfusingFirstAscentShadow
```

## 6. どの既存の解法よりもゴリ押しの解法

名前: 反復積分全展開

ゴリ押しの核: 分布名、幾何、Green核、Janossyを使わない。`n`個の一様乱数が生き残る範囲だけを、そのまま反復積分する。

```text
B_0(x) = 1,
B_{n+1}(x) = int_0^x B_n(x-u) du.
```

帰納法で

```text
B_n(x) = x^n / n!,
B_n(1) = 1/n!.
```

最後に全て足す。

```text
E[tau] = sum_{n>=0} B_n(1) = sum_{n>=0} 1/n! = e.
```

計算量の感触は最もゴリ押しだが、各段階は完全に明示的。

Lean hook:

```lean
bruteForceTailMass_eq_pow_div_factorial
mostBruteForceIteratedIntegralSolution
```

## Subagent team plan

| 担当 | 採用した核 | 実装先 |
| --- | --- | --- |
| interesting | Yule分枝の平均個体数 | `mostInterestingYuleBranchingSolution` |
| boring | 既存定理を別名で呼ぶだけ | `mostBoringAliasSolution` |
| elegant | Volterra値方程式/Green核の質量 | `mostElegantVolterraValueEquation`, `mostElegantGreenSolution` |
| short | 分配関数を1行で評価 | `shortestPartitionFunctionSolution` |
| confusing | 初期上昇ランの尾分布 | `mostConfusingFirstAscentShadow` |
| bruteforce | 反復積分全展開 | `mostBruteForceIteratedIntegralSolution` |

The final Lean cross-check is:

```lean
solutionZoo_mainValue
janossyPartitionFunction_eq_expectedHittingTime
yuleExpectedPopulation_eq_expectedHittingTime
```
