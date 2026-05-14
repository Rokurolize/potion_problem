# Schwartz核trace解

この解では、一口追加をSchwartz核として書き、全prefix和を核の反復traceとして読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めて

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

残り容量`r`から`v`へ移る一口追加の核は

```text
K(r,v)=1_{0<=v<=r}
```

である。実際、`v=r-u`とおけば一様密度は`du=dv`であり、許される範囲は`0<=v<=r`である。

停止前prefixの全質量は、定数関数`1`に対するNeumann和

```text
R(r)=sum_{n>=0} K^n 1(r)
```

である。Schwartz核の合成は三角領域の積分になり、境界`r`を少し動かすと新しく加わる核のtraceは、すでに存在する全prefix和そのものである。したがって

```text
R(r+h)-R(r)=h R(r)+o(h).
```

よって

```text
R'(r)=R(r),
R(0)=1.
```

したがって

```text
R(r)=exp(r).
```

初期容量は`1`なので

```text
E[tau]=R(1)=e.
```

この証明では、各`K^n`の核を展開しない。Volterra型Schwartz核の反復traceが境界微分で自分自身を返すことだけを見る。`e`は、その核resolventを初期容量で評価した値である。
