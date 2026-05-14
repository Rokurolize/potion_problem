# holonomic消滅作用素解

この解では、停止前prefix総量をholonomic関数として扱い、その消滅作用素から値を読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めると

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

境界`x`までの全prefix質量を

```text
F(x)=sum_{n>=0} P(S_n<=x)
```

と置く。境界を`x`から`x+h`に動かすと、既存prefixそれぞれが一様密度`1`で幅`h+o(h)`だけ次のprefixを薄層へ送る。したがって

```text
F(x+h)-F(x)=hF(x)+o(h).
```

つまり

```text
(D-1)F=0
```

である。ここで`D=d/dx`である。これは一次のholonomic系であり、解空間は初期値一つで決まる。

初期値は空prefixだけなので

```text
F(0)=1.
```

消滅作用素`D-1`と初期値から

```text
F(x)=exp(x)
```

が従う。よって

```text
E[tau]=F(1)=e.
```

この証明では、各次数の項を展開しない。全prefix質量が一次のholonomic消滅作用素`D-1`に殺されることを証明し、初期値だけで解を決める。`e`は、そのholonomic解の境界値である。
