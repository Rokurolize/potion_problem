# coupon collector capacity解

この解では、coupon collector風に「まだ容量が残っている回」を集めて数える。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。通常のcoupon collectorとは違い、ここで集めるのは種類ではなく、容量`1`の中にまだ収まっているprefixである。`n`回目まで集められる条件は

```text
S_n<=1.
```

したがって

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

固定した`n`では、`S_n<=1`の領域は標準単体であり、

```text
P(S_n<=1)=1/n!.
```

よって

```text
E[tau]=sum_{n>=0} 1/n! = e.
```

この比喩では、couponを集めるたびに残り容量が削られていく。全ての収集可能prefixの質量が、指数級数そのものになる。
