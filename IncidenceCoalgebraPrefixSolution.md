# incidence coalgebra prefix解

この解では、停止前prefixを「切れる列」のincidence coalgebraの重みとして読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。長さ`n`のprefixが停止前である条件は

```text
u_1+...+u_n<=1
```

である。このprefixは、容量区間`[0,1]`を左から順に切っていく鎖

```text
0=t_0<=t_1<=...<=t_n<=1
```

と同じで、`u_i=t_i-t_{i-1}`で互いに移り合う。Jacobianは`1`である。

長さ`n`の鎖の重みは

```text
int_{0<=t_1<=...<=t_n<=1} dt_1...dt_n = 1/n!.
```

incidence coalgebraでは、全ての有限鎖を長さで足すzeta的な元が自然に現れる。停止時刻の期待値は、空鎖を含む停止前鎖の総重みなので

```text
E[tau]=sum_{n>=0} 1/n! = e.
```

ここで単に単体体積を言い換えているだけではない。停止前prefixを「区間を逐次分解する鎖」として見ているため、`e`は鎖全体のzeta重みとして現れる。
