# Kleisli iteration prefix解

この解では、一様入力を読む操作をsubprobability kernelのKleisli反復として見る。

容量`x`から容量`y`へ続行する核を

```text
K(x,dy)=1_{0<=y<=x}dy
```

とする。これは「入力を一つ読んで、まだ停止していない場合だけ残る」subprobability kernelである。長さ`n`まで停止しない質量は

```text
K^n 1(1)
```

であり、空prefixを含む期待停止時刻は

```text
E[tau]=sum_{n>=0}K^n1(1).
```

Kleisli合成を一回行うことは

```text
(Kf)(x)=int_0^x f(y)dy
```

である。よって帰納的に

```text
K^n1(x)=x^n/n!.
```

したがって

```text
E[tau]=sum_{n>=0}K^n1(1)=sum_{n>=0}1/n!=e.
```

停止を吸収として捨てるKleisli反復の全質量が、そのまま指数級数になる。
