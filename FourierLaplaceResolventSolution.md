# Fourier-Laplace resolvent解

この解では、一口追加核をFourier-Laplace記号に移し、局所的なresolventを境界`1`で読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。境界`x<=1`までのprefix総量を

```text
F(x)=sum_{n>=0} P(S_n<=x)
```

と置く。`0<=x<=1`では、一様分布の右端は畳み込みの途中で見えず、一口追加核は半直線上の定数密度の局所芽として働く。

半直線積分作用素`I`を

```text
(If)(x)=int_0^x f(y) dy
```

とすれば

```text
F=(I+I^1+I^2+...)1.
```

Laplace記号では`I`は乗法`1/s`なので、resolventは

```text
1/(1-1/s)=s/(s-1)
```

である。これを定数関数の側へ戻すと、微分方程式

```text
F'(x)=F(x),  F(0)=1
```

を得る。したがって

```text
F(x)=e^x,
E[tau]=F(1)=e.
```

この証明では、Irwin-Hall分布全体をFourier側で計算しない。境界`1`までに見える局所核のresolventだけで指数関数が決まる。
