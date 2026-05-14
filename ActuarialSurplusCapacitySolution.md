# actuarial surplus capacity解

この解では、停止前prefixをsurplusが非負で残る請求列として数える。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。surplusを

```text
X_n=1-S_n
```

と置く。`n`件処理後にもsurplusが非負である条件は

```text
X_n>=0
```

すなわち`S_n<=1`である。したがって

```text
E[tau]=sum_{n>=0} P(X_n>=0).
```

固定した`n`で、`X_n>=0`を満たす請求額列は標準単体

```text
{u_i>=0, u_1+...+u_n<=1}
```

を作る。この体積は`1/n!`なので

```text
E[tau]=sum_{n>=0} 1/n! = e.
```

surplus過程として見ると、停止時刻の期待値は非負surplusを保つ全prefixの質量である。
