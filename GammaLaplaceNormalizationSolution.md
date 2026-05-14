# Gamma-Laplace normalization解

この解では、停止前prefixの単体体積をGamma積分の正規化から読む。

長さ`n`の停止前条件は

```text
u_i>=0,  u_1+...+u_n<=1.
```

この領域の体積を`A_n`とする。正の直交象限で

```text
r=u_1+...+u_n
```

とおくと、`r`ごとの断面体積密度は`n A_n r^{n-1}`である。一方、指数重みを掛けた全空間積分は独立に分離して

```text
int_{u_i>=0} exp(-(u_1+...+u_n)) du_1...du_n = 1.
```

断面で書けば

```text
1 = int_0^infty e^{-r} n A_n r^{n-1} dr
  = n A_n Gamma(n)
  = n! A_n.
```

ゆえに

```text
A_n=1/n!.
```

尾和公式から

```text
E[tau]=sum_{n>=0}A_n=sum_{n>=0}1/n!=e.
```

この証明では、単体を直接測るのではなく、指数測度の正規化とGamma積分が断面体積を決定する。
