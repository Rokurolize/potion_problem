# viability kernel prefix解

この解では、停止前prefixを容量制約のviability kernel内に残る軌道として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。状態を残り容量

```text
X_n=1-S_n
```

と置く。viability条件は

```text
X_n>=0
```

であり、これは`S_n<=1`と同じである。長さ`n`の軌道がviability kernelに残る増分列の領域は

```text
{u_i>=0, u_1+...+u_n<=1}
```

で、その体積は`1/n!`である。

停止時刻はviabilityを保つprefixの数なので

```text
E[tau]=sum_{n>=0} P(S_n<=1)
      =sum_{n>=0} 1/n!
      =e.
```

viability kernelとして見ると、境界を越えた後の軌道ではなく、制約集合内に残っている全prefix軌道の質量を足している。
