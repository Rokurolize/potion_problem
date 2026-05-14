# integrated hazard capacity解

この解では、残り容量を寿命軸と見て、prefixが生まれる累積hazardを積分する。

残り容量`x`から始めたとき、空prefixを含めた期待prefix数を`V(x)`とする。次の入力が容量内に収まると、残り容量は`x-u`になる。従って

```text
V(x)=1+int_0^x V(x-u)du.
```

変数を替えれば

```text
V(x)=1+int_0^x V(t)dt.
```

この積分は、容量軸上でprefixが一段増える累積hazardであり、その局所率は現在の残り容量ポテンシャル`V(t)`そのものである。よって

```text
V'(x)=V(x),  V(0)=1.
```

境界`x=0`では空prefixだけが数えられるので初期値は`1`である。したがって

```text
V(x)=e^x.
```

元の問題は`x=1`だから

```text
E[tau]=V(1)=e.
```

この見方では、停止前prefix数を容量軸上の自己励起する累積hazardとして読む。
