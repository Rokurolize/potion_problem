# Meijer G核解

この解では、prefix生成核をMellin側で見て、Meijer G表示が指数核へ退化することを読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めれば

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

境界`x`までの全prefix質量を

```text
G(x)=sum_{n>=0} P(S_n<=x)
```

と置く。`0<=x<=1`では一様密度の右端は働かず、一口追加核は半直線の単位Volterra核として振る舞う。Mellin側でこの核を反復すると、Gamma因子`Gamma(n+1)`が分母に現れる。

したがってMeijer G型の核表示は、この局所窓では

```text
sum_{n>=0} x^n/Gamma(n+1)
```

へ退化する。これは

```text
exp(x)
```

である。よって

```text
E[tau]=G(1)=e.
```

この証明では、Meijer Gの一般論を展開しない。Mellin側のGamma因子が、境界`1`までの局所窓では指数核に退化することだけを見る。`e`は、その退化核の値である。
