# Morse sublevel filtration解

この解では、和写像のsublevel filtrationがどの体積を通過するかで停止時刻を読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。尾和公式で

```text
E[tau]=sum_{n>=0} P(S_n<=1)
```

である。固定した`n`について、和写像

```text
h_n(u_1,...,u_n)=u_1+...+u_n
```

のsublevel

```text
h_n^{-1}([0,x])
```

を`0<=x<=1`で追う。この範囲では立方体の上面に触れず、filtrationは標準単体

```text
Delta_n(x)={u_i>=0, u_1+...+u_n<=x}
```

だけを掃く。

体積を`A_n(x)=vol(Delta_n(x))`と書くと、sublevelの境界が法線方向に動くことから

```text
A_n'(x)=A_{n-1}(x),  A_0(x)=1.
```

したがって帰納的に

```text
A_n(1)=1/n!.
```

よって

```text
E[tau]=sum_{n>=0} A_n(1)=sum_{n>=0} 1/n! = e.
```

この見方では、停止前事象は和写像のsublevel filtrationの通過体積であり、`e`はその全次数の掃過体積の総和として現れる。
