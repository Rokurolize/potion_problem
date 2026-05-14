# stars and bars limit解

この解では、停止前単体をstars and barsの連続極限として数える。

長さ`n`で停止前にある領域は

```text
D_n={x_i>=0, x_1+...+x_n<=1}
```

である。刻み幅`1/m`で近似すると、点は非負整数

```text
k_1+...+k_n<=m
```

に対応する。余り`k_{n+1}=m-(k_1+...+k_n)`を入れると

```text
k_1+...+k_{n+1}=m
```

であり、stars and barsにより個数は

```text
binom(m+n,n)
```

である。格子幅の体積因子`m^{-n}`を掛けて極限を取ると

```text
P(tau>n)=vol(D_n)=lim_{m->infty} binom(m+n,n)/m^n=1/n!.
```

尾和公式から

```text
E[tau]=sum_{n>=0}1/n!=e.
```

星と棒で数えた弱合成を連続化すると、停止前単体の階乗体積が現れる。
