# Laplace-Carson renewal解

この解では、残り容量の更新方程式をLaplace-Carson型の演算計算で解く。

残り容量が`x`のとき、停止前prefix期待数を`V(x)`とする。空prefixを一つ数え、次の入力`u`が`0<=u<=x`なら残り容量は`x-u`になるから

```text
V(x)=1+int_0^x V(x-u)du.
```

これは単位密度との畳み込み方程式

```text
V=1+1*V
```

である。Laplace変換を

```text
hat V(s)=int_0^infty e^{-sx}V(x)dx
```

と書くと、形式的には

```text
hat V(s)=1/s + (1/s)hat V(s).
```

従って

```text
hat V(s)=1/(s-1).
```

逆変換で

```text
V(x)=e^x.
```

元の初期容量は`1`なので

```text
E[tau]=V(1)=e.
```

この証明では、停止前の全prefixを更新方程式にまとめ、畳み込み核のLaplace像が`1/s`であることだけで指数関数を取り出している。
