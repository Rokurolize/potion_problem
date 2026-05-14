# integer composition scaling解

この解では、整数compositionのスケーリング極限から単体体積を得る。

合計が高々`m`の非負整数列

```text
(k_1,...,k_n)
```

を考え、`x_i=k_i/m`と縮尺する。条件

```text
k_1+...+k_n<=m
```

は

```text
x_1+...+x_n<=1
```

に変わる。これは長さ`n`で停止前にある条件そのものである。

格子点数は

```text
binom(m+n,n)
```

であり、`n`次元体積へ直すために`m^n`で割ると

```text
vol{x_i>=0, x_1+...+x_n<=1}
=lim_{m->infty} binom(m+n,n)/m^n
=1/n!.
```

よって

```text
E[tau]=sum_{n>=0}P(tau>n)=sum_{n>=0}1/n!=e.
```

整数compositionのスケーリング極限が、停止前履歴の連続単体をそのまま再現している。
