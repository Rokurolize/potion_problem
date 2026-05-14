# Hamilton-Jacobi特性曲線解

この解では、停止前prefixの各次数を求めない。境界容量`x`を時間と見て、全prefix質量の対数をHamilton-Jacobi型の作用として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めれば

```text
E[tau] = sum_{n >= 0} P(S_n <= 1)
```

である。

`0 <= x <= 1`で

```text
M(x) = sum_{n >= 0} P(S_n <= x)
```

を置く。`M(x)`は境界`x`までに存在する停止前prefixの総質量である。

境界を`x`から`x+h`へ動かす。既存prefixの和を`y <= x`とすると、最後に一様増分`u`を足して新しい薄層へ入る条件は

```text
x-y < u <= x+h-y.
```

この幅は`h+o(h)`であり、一様密度は`1`である。したがって

```text
M(x+h)-M(x)=h M(x)+o(h).
```

ここで作用

```text
W(x)=log M(x)
```

を導入する。上の式は

```text
W'(x)=1
```

という退化したHamilton-Jacobi方程式である。Hamiltonianは定数`H(p)=p-1`で、特性曲線上では運動量`p=W'(x)`が常に`1`に固定される。

初期値は空prefixだけなので

```text
M(0)=1,
W(0)=0.
```

特性曲線に沿って

```text
W(x)=x
```

となり、

```text
M(x)=exp(W(x))=exp(x).
```

求める期待値は

```text
E[tau]=M(1)=e.
```

この証明では、各`P(S_n<=1)`を先に評価しない。境界を時間と見たとき、対数総質量のHamilton-Jacobi方程式が定数速度の特性曲線に潰れることだけを見る。`e`は、その特性曲線が作用`1`を獲得した結果である。
