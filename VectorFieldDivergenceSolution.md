# vector field divergence解

この解では、単体体積を発散定理で再帰的に測る。

長さ`n`で停止前の領域を

```text
D_n={x_i>=0, x_1+...+x_n<=1}
```

とする。ベクトル場

```text
F(x)=x/n
```

を考えると、`div F=1`である。発散定理により

```text
vol(D_n)=int_{D_n}1 dx=int_{boundary D_n} F・nu dS.
```

座標面`x_i=0`では寄与が消え、残るのは停止境界`x_1+...+x_n=1`だけである。この境界は標準`n-1`単体で、計算すると

```text
vol(D_n)=1/n!.
```

したがって

```text
P(tau>n)=vol(D_n)=1/n!,
E[tau]=sum_{n>=0}1/n!=e.
```

停止前確率は、停止境界から流れ込む発散1のベクトル場の総流束として測れる。
