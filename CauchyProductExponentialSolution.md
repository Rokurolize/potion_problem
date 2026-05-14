# Cauchy product指数解

この解では、生存体積列がCauchy積で指数列を強制することを見る。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。`0<=x<=1`について

```text
A_n(x)=P(S_n<=x)
```

と置く。最後の増分を`u`として分けると

```text
A_n(x)=int_0^x A_{n-1}(x-u) du,
A_0(x)=1.
```

ここで母関数

```text
F(x,z)=sum_{n>=0} A_n(x) z^n
```

を作る。上の再帰を足し合わせると

```text
F(x,z)=1+z int_0^x F(t,z) dt.
```

したがって

```text
partial_x F(x,z)=z F(x,z),  F(0,z)=1,
```

なので

```text
F(x,z)=exp(zx).
```

`z=1, x=1`を代入すれば

```text
E[tau]=sum_{n>=0} A_n(1)=F(1,1)=e.
```

この証明の要点は、単体体積列を先に求めないことである。畳み込み再帰を母関数に集めると、Cauchy積がそのまま指数関数の微分方程式になる。
