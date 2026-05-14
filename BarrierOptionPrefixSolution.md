# barrier option prefix解

この解では、停止前prefixを上方barrierを越えていない経路のpayoffとして読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。barrierを`1`に置くと、時刻`n`でまだknock outしていない条件は

```text
S_n<=1
```

である。停止時刻は、knock out前に支払われる単位couponの総数と同じなので

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

固定した`n`では、barrier内に残る増分列の領域は

```text
{u_i>=0, u_1+...+u_n<=1}
```

という標準単体であり、体積は`1/n!`である。したがって

```text
E[tau]=sum_{n>=0} 1/n! = e.
```

barrier optionの言葉では、価格は各時刻の生存デジタルpayoffを全部足したものになっている。
