# conductance境界解

この解では、境界層へprefixが流れ込む係数をconductanceとして読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。境界`x`までの停止前prefix総量を`F(x)`と置く。`0<=x<=1`では、次の一口が新しい薄層`[x,x+dx]`へ入るconductanceは一様密度により`1`である。したがって流量は

```text
current = conductance * potential = 1 * F(x).
```

これは

```text
F(x+dx)-F(x)=F(x)dx+o(dx)
```

を意味するので

```text
F'(x)=F(x),  F(0)=1.
```

解は

```text
F(x)=e^x.
```

初期境界`1`で

```text
E[tau]=F(1)=e.
```

この見方では、`e`は境界層のconductanceが定数であるために生じる自己増殖流の総応答である。
