# Euler-Maclaurin prefix解

この解では、有限格子上のprefix和をEuler-Maclaurin的に連続極限へ送る。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。境界`x`までのprefix総量を

```text
F(x)=sum_{n>=0} P(S_n<=x)
```

と置く。

境界を幅`h`の格子で近似し、`F_h(kh)`を格子境界までのprefix総量とする。一段境界を進めたとき、新しいprefixは既存prefixに最後の一口が新しい薄い区間へ入る場合だけなので

```text
F_h((k+1)h)-F_h(kh)=h F_h(kh)+O(h^2).
```

Euler-Maclaurinの補正は、境界が滑らかで密度が一定`1`であるため、極限では一次項だけを残す。したがって

```text
F'(x)=F(x),  F(0)=1.
```

よって

```text
F(x)=e^x,
E[tau]=F(1)=e.
```

この証明では、格子再帰の和をEuler-Maclaurinで連続の境界方程式へ戻し、補正項が極限で消えることだけを見る。
