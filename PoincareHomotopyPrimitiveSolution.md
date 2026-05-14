# Poincareホモトピー原始形式解

この解では、生存単体の体積を積分で直接計算せず、体積形式に対するPoincare補題のホモトピー作用素で一段低い境界積分へ落とす。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。期待値は

```text
E[tau] = sum_{n >= 0} P(S_n <= 1).
```

`n >= 1`について、生存領域を

```text
Delta_n = { (u_1,...,u_n) : u_i >= 0, u_1+...+u_n <= 1 }
```

と置く。この領域での密度は一様密度の積なので、`P(S_n <= 1)`は`Delta_n`の体積である。

## 体積形式を原始形式へ戻す

`R`を原点から外へ向かうEulerベクトル場

```text
R = sum_i u_i d/du_i
```

とする。`n`次元体積形式

```text
omega = du_1 wedge ... wedge du_n
```

に対して

```text
alpha = (1/n) i_R omega
```

と置く。ここで`i_R`は内部積である。Eulerベクトル場は体積形式を次数`n`で伸ばすので

```text
d alpha = omega.
```

したがってStokesの定理から

```text
Vol(Delta_n) = int_{Delta_n} omega
             = int_{partial Delta_n} alpha.
```

座標面`u_i=0`では、`i_R omega`の各項は係数`u_i`を持つか、引き戻しで`du_i`を含んで消える。残るのは斜面

```text
u_1+...+u_n = 1
```

だけである。

この斜面を最初の`n-1`座標で表すと、`alpha`の寄与は

```text
(1/n) du_1 ... du_{n-1}
```

として、前段の単体`Delta_{n-1}`上の体積になる。よって

```text
Vol(Delta_n) = Vol(Delta_{n-1}) / n.
```

`Vol(Delta_0)=1`なので

```text
P(S_n <= 1) = Vol(Delta_n) = 1/n!.
```

したがって

```text
E[tau] = sum_{n >= 0} 1/n! = e.
```

この証明では、各次元の単体積分を展開しない。体積形式をPoincareホモトピー作用素で原始形式に戻し、境界のうち座標面を消して斜面だけを読む。階乗は、原始形式の係数`1/n`を次元ごとに掛けることで現れる。
