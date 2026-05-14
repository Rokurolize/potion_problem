# Riemann-Liouville積分半群解

この解では、一口増やす操作をRiemann-Liouville型の積分半群として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。期待値は

```text
E[tau] = sum_{n >= 0} P(S_n <= 1)
```

である。

## 一口追加は積分作用素

境界を`x`にしたときの生存質量を

```text
A_n(x) = P(S_n <= x)
```

と置く。`0 <= x <= 1`では一様密度の右端はまだ効かないので

```text
A_0(x) = 1,
A_{n+1}(x) = int_0^x A_n(t) dt.
```

ここでRiemann-Liouville積分作用素

```text
(I^alpha f)(x)
  = 1/Gamma(alpha) int_0^x (x-t)^{alpha-1} f(t) dt
```

を考える。`alpha=1`では通常の積分であり、一口追加は`I^1`である。半群性

```text
I^a I^b = I^{a+b}
```

から

```text
A_n(x) = I^n 1.
```

定数関数`1`に作用させると

```text
I^n 1 = x^n/Gamma(n+1) = x^n/n!.
```

したがって

```text
P(S_n <= 1) = A_n(1) = 1/Gamma(n+1) = 1/n!.
```

## 半群の全軌道を足す

求める期待値は、この積分半群の整数時刻軌道を`x=1`で足したものである。

```text
E[tau]
  = sum_{n >= 0} (I^n 1)(1)
  = sum_{n >= 0} 1/Gamma(n+1)
  = e.
```

この証明では、単体体積を先に公式として使わない。一口追加を積分半群の時間1ステップとして束ね、`Gamma(n+1)`を半群の正規化として読む。`e`は、積分半群の整数軌道を全て足した値として現れる。
