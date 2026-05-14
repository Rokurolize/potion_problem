# Volterra survival equation解

この解では、停止前prefixの総量をVolterra方程式として直接数える。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。残り容量が`x`あるとき、空prefixを一つ数え、その次に最初の増分`u`を選ぶ。`0<=u<=x`なら残り容量は`x-u`になるので、停止前prefixの期待総数を`V(x)`と書くと

```text
V(x)=1+int_0^x V(x-u) du.
```

変数を替えれば

```text
V(x)=1+int_0^x V(t) dt.
```

したがって

```text
V'(x)=V(x),  V(0)=1.
```

よって

```text
V(x)=e^x.
```

求める停止時刻は、空prefixを含めた停止前prefixの個数に等しい。したがって

```text
E[tau]=V(1)=e.
```

ここでは各`P(S_n<=1)`を個別に積分しない。prefix全体を一つの再帰的な量として見て、容量を削るVolterra方程式に畳み込む。
