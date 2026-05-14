# Stieltjes変換prefix解

この解では、停止前prefix総量を境界容量の測度として置き、そのStieltjes変換が満たす局所方程式から値を読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めると

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

境界`x`までのprefix質量を

```text
M(x)=sum_{n>=0} P(S_n<=x)
```

と置く。Stieltjes変換で見れば、測度`dM`は一口追加の畳み込み再帰を持つ。境界`0<=x<=1`では一様分布の右端はまだ効かず、薄層`(x,x+h]`へ入る質量は既存prefix総量の`h+o(h)`倍である。

したがってStieltjes側の局所再帰は逆変換すると

```text
M(x+h)-M(x)=hM(x)+o(h).
```

よって

```text
M'(x)=M(x),
M(0)=1.
```

初期値は空prefixの原子である。したがって

```text
M(x)=exp(x)
```

であり、

```text
E[tau]=M(1)=e.
```

この証明では、各`P(S_n<=1)`を先に求めない。prefix測度をStieltjes変換でまとめ、境界`1`までの局所窓では変換側の再帰が`M'=M`へ戻ることだけを見る。`e`は、そのStieltjes測度の累積値である。
