# Gamma正規化錐解

この解では、生存単体の体積を直接積分しない。正の錐を「半径」と「割合」に分け、Gamma積分の正規化から、境界`1`以下に残る割合空間の質量を読む。

独立な一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。停止前prefixを数えると

```text
tau = sum_{n >= 0} 1_{S_n <= 1}
```

なので

```text
E[tau] = sum_{n >= 0} P(S_n <= 1).
```

固定した`n`について、`S_n <= 1`なら全ての`U_i`は自動的に`[0,1]`内にある。したがって

```text
P(S_n <= 1)
```

は正の錐

```text
u_i >= 0
```

を超平面

```text
u_1 + ... + u_n <= 1
```

で切った部分のLebesgue体積である。

## Gamma重みで錐を量る

正の錐全体に指数重みを置く。

```text
I_n = int_{u_i >= 0} exp(-(u_1+...+u_n)) du_1...du_n.
```

各座標で分離するので

```text
I_n = prod_{i=1}^n int_0^infinity exp(-u_i) du_i = 1.
```

一方で

```text
r = u_1 + ... + u_n
```

と、割合

```text
p_i = u_i / r
```

へ変数変換する。`p_i >= 0`かつ`sum p_i = 1`であり、Jacobianは

```text
r^(n-1)
```

を出す。したがって同じ積分は

```text
I_n
= int_0^infinity exp(-r) r^(n-1) dr
  * area(simplex of p).
```

Gamma積分は

```text
int_0^infinity exp(-r) r^(n-1) dr = (n-1)!.
```

`I_n=1`だから、割合simplexの面積は

```text
1 / (n-1)!.
```

## 境界`1`以下の錐体積に戻す

欲しい生存領域は、同じ割合simplexの上で半径`r`を`0 <= r <= 1`に制限した錐である。したがって

```text
P(S_n <= 1)
= area(simplex of p) * int_0^1 r^(n-1) dr
= (1 / (n-1)!) * (1/n)
= 1/n!.
```

`n=0`は空prefixで寄与`1`である。

よって

```text
E[tau]
= sum_{n >= 0} P(S_n <= 1)
= sum_{n >= 0} 1/n!
= e.
```

## この見方の芯

この証明は、単体の体積公式を初めから使わない。まず指数重み付きの正の錐を、独立指数変数の総質量として`1`に正規化する。その正規化を半径`r`と割合`p`へ分解すると、割合simplexの面積がGamma積分の逆数として決まる。

答えの`e`は、停止前prefixの各長さが、Gamma正規化された正の錐を半径`1`で切った質量として並ぶことで現れる。
