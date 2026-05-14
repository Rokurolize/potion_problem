# 分布境界current解

この解では、停止前prefixの総量を関数ではなく、境界へ流れ込む分布currentとして見る。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めると

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

境界`x`までのprefix総量を

```text
M(x)=sum_{n>=0} P(S_n<=x)
```

と置く。これを分布として微分する。`x=0`には空prefixの原子があり、`0<x<1`では既存prefixが一様密度`1`で薄い境界層へ次のprefixを流す。

したがって分布currentとして

```text
dM = delta_0 + M(x) dx
```

が成り立つ。原子を初期条件として分ければ

```text
M'(x)=M(x),
M(0)=1.
```

よって

```text
M(x)=exp(x).
```

求める期待値は

```text
E[tau]=M(1)=e.
```

この証明では、各次数の単体体積を計算しない。空prefixの原子と、一様密度が作る境界currentだけを分布方程式として読む。`e`は、そのcurrentの累積質量である。
