# Mittag-Leffler次数1解

この解では、停止前prefix列をMittag-Leffler関数の次数1の場合として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めると

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

境界`x`までの総量を

```text
M(x)=sum_{n>=0} P(S_n<=x)
```

と置く。一口追加はVolterra積分であり、`0<=x<=1`では

```text
M(x)=1+int_0^x M(t) dt.
```

これはRiemann-Liouville積分の次数`1`による再帰で、解はMittag-Leffler関数

```text
E_1(x)=sum_{n>=0} x^n/Gamma(n+1)
```

である。次数`1`では

```text
E_1(x)=exp(x).
```

したがって

```text
E[tau]=M(1)=E_1(1)=e.
```

この証明では、各`P(S_n<=1)`を個別に求めない。停止前prefixのVolterra再帰を、次数1のMittag-Leffler関数として読む。`e`は、その次数1特殊化である。
