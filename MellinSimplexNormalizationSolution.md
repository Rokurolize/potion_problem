# Mellin単体正規化解

この解では、生存prefixの単体体積を、Mellin型の半径積分で正規化して読む。

長さ`n`のprefixについて

```text
S_n = X_1 + ... + X_n
```

とする。`S_n <= 1`の領域は正錐のうち

```text
x_i >= 0,   x_1 + ... + x_n <= 1
```

である。

ここで総量

```text
r = x_1 + ... + x_n
```

と割合

```text
p_i = x_i / r
```

に分ける。`p`は

```text
p_i >= 0,   p_1 + ... + p_n = 1
```

を満たす。Lebesgue要素は

```text
dx_1 ... dx_n = r^{n-1} dr d\sigma(p)
```

の形になる。

## Mellin側で断面を正規化する

指数重みを入れた正錐全体の積分は

```text
int_{x_i >= 0} exp(-(x_1+...+x_n)) dx_1 ... dx_n = 1.
```

一方、上の半径と割合で書くと

```text
1 = area(Delta_{n-1}) int_0^infty exp(-r) r^{n-1} dr.
```

右の半径積分はMellin型のGamma積分で

```text
int_0^infty exp(-r) r^{n-1} dr = Gamma(n) = (n-1)!.
```

したがって割合断面の面積は

```text
area(Delta_{n-1}) = 1/(n-1)!.
```

欲しい生存領域は、同じ断面の上で`0 <= r <= 1`だけを取った錐なので

```text
P(S_n <= 1)
  = area(Delta_{n-1}) int_0^1 r^{n-1} dr
  = (1/(n-1)!) * (1/n)
  = 1/n!.
```

空prefixを含めて足すと

```text
E[tau] = sum_{n >= 0} P(S_n <= 1) = sum_{n >= 0} 1/n! = e.
```

この証明では、単体体積を直接積分しない。まず正錐を半径と割合に分け、Mellin型のGamma正規化で割合断面の大きさを決める。`e`は、その正規化済み断面を半径`1`まで積み戻した全次数和として現れる。
