# digital payoff tail解

この解では、各時刻の生存事象をdigital payoffとして足し上げる。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。時刻`n`のdigital payoffを

```text
D_n=1_{S_n<=1}
```

と置く。停止前にいる時刻だけ`1`が支払われるので

```text
tau=sum_{n>=0} D_n.
```

期待値を取れば

```text
E[tau]=sum_{n>=0} E[D_n]
      =sum_{n>=0} P(S_n<=1).
```

`S_n<=1`の領域は標準単体で、体積は

```text
1/n!.
```

よって

```text
E[tau]=sum_{n>=0} 1/n! = e.
```

digital payoffとして見ると、停止時刻の期待値は一つの複雑なpayoffではなく、生存デジタルの価格列の総和である。
