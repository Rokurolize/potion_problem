# Toeplitz-Volterra行列解

この解では、境界容量を細かく刻み、一口追加をToeplitz型の下三角Volterra行列として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めれば

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

容量`x`までの全prefix質量を

```text
F(x)=sum_{n>=0} P(S_n<=x)
```

と置く。区間を幅`h`で格子化すると、一口追加の作用素は、下側の全格子点から幅`h`の重みで流れ込む下三角Toeplitz行列になる。境界を一段進めたときに増える量は、既存prefix総量に`h`を掛けたものだから

```text
F(x+h)-F(x)=hF(x)+o(h).
```

極限で

```text
F'(x)=F(x),
F(0)=1.
```

したがって

```text
F(x)=exp(x),
E[tau]=F(1)=e.
```

この証明では、各次元の単体体積を求めない。有限格子のToeplitz-Volterra行列が境界極限で`F'=F`へ潰れることだけを見る。`e`は、その行列resolventの連続極限である。
