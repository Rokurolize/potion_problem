# Dirichlet problem capacity解

この解では、残り容量上の期待prefix数を、一次元のDirichlet問題として解く。

残り容量`x`から始め、空prefixを含む期待prefix数を`V(x)`とする。次の入力`u`が`0<=u<=x`なら残り容量は`x-u`で続くので

```text
V(x)=1+int_0^x V(x-u)du.
```

変数を替えると

```text
V(x)=1+int_0^x V(t)dt.
```

したがって

```text
V'(x)=V(x).
```

境界容量`0`では空prefixだけが残るため

```text
V(0)=1.
```

これは一次元の境界値問題

```text
V'-V=0,  V(0)=1
```

であり、解は

```text
V(x)=e^x.
```

元の問題は容量`1`から始まるので

```text
E[tau]=V(1)=e.
```

確率過程を直接追う代わりに、停止前prefixの期待数を容量区間上の境界値問題として閉じている。
