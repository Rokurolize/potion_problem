# Lindley recursion capacity解

この解では、残り容量をLindley型再帰の余裕として見る。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。残り容量を

```text
R_n=1-S_n
```

と書くと、停止前では

```text
R_{n+1}=R_n-U_{n+1},  R_n>=0
```

である。これは待ち行列のLindley再帰を反転した形で、余裕が負になった時点で停止する。

残り容量が`x`のときの停止前prefix期待個数を`L(x)`と置く。空prefixを数え、次の減少量`u`が`0<=u<=x`なら残りは`x-u`なので

```text
L(x)=1+int_0^x L(x-u) du
    =1+int_0^x L(t) dt.
```

したがって

```text
L'(x)=L(x),  L(0)=1,
```

より

```text
L(x)=e^x.
```

初期容量は`1`なので

```text
E[tau]=L(1)=e.
```

Lindley再帰として見ると、停止時刻は余裕過程が非負でいられるprefixの総報酬である。
