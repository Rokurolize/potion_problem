# shuffle algebra exponential解

この解では、停止前prefix領域を反復積分のshuffle代数で束ねる。

独立一様乱数`U_1,U_2,...`について

```text
S_n=U_1+...+U_n,
tau=min { n>=1 : S_n>1 }
```

とする。尾和公式より

```text
E[tau]=sum_{n>=0}P(S_n<=1).
```

累積和`T_k=U_1+...+U_k`へ写すと、`S_n<=1`は

```text
0<=T_1<=...<=T_n<=1
```

であり、ヤコビアンは`1`である。従って各項は1形式`dt`の反復積分

```text
I_n=int_{0<=t_1<=...<=t_n<=1} dt_1...dt_n
```

である。shuffle積は同じ1形式の反復積分に対して

```text
I_1^n = n! I_n
```

を与える。`I_1=1`だから

```text
I_n=1/n!.
```

よって

```text
E[tau]=sum_{n>=0}I_n=sum_{n>=0}1/n!=e.
```

停止前履歴を順序付き反復積分へ移すと、`e`はshuffle代数での指数級数そのものとして現れる。
