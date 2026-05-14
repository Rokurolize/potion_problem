# support function tail解

この解では、停止境界を支える超平面のsupport functionで停止前領域を記述する。

正の直交象限で、ベクトル

```text
1=(1,...,1)
```

に対する線形汎関数を

```text
h(x)=<1,x>=x_1+...+x_n
```

と置く。長さ`n`で停止前にある条件は

```text
h(x)<=1,  x_i>=0
```

である。これはsupport hyperplane`h(x)=1`で切られた標準単体に他ならない。

したがって

```text
P(tau>n)=vol{x_i>=0, h(x)<=1}=1/n!.
```

よって尾和公式により

```text
E[tau]=sum_{n>=0}P(tau>n)
      =sum_{n>=0}1/n!
      =e.
```

停止は、正の直交象限をsupport functionのレベル1で切る操作であり、その切り取られた体積が期待値の各項になる。
