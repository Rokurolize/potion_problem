# 連分数resolvent解

この解では、有限段で止めた停止前prefixの値を連分数型resolventとして読み、段数を無限へ送る。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めると

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

残り容量`r`から高々`N`段だけprefixを伸ばす値を`V_N(r)`とする。すると

```text
V_0(r)=1,
V_{N+1}(r)=1+int_0^r V_N(r-u) du.
```

この有限段resolventは、積分作用素を一段ずつ折りたたむ連分数型の近似と見られる。微分すると

```text
V_{N+1}'(r)=V_N(r),
V_{N+1}(0)=1.
```

したがって`V_N(1)`は指数関数の有限近似列になり、単調極限で

```text
V(r)=lim_{N->infty} V_N(r)
```

は

```text
V'(r)=V(r),
V(0)=1
```

を満たす。よって

```text
V(r)=exp(r),
E[tau]=V(1)=e.
```

この証明では、停止時刻分布を先に計算しない。有限段resolventを連分数的に折りたたみ、その極限が同じVolterra方程式になることを見る。`e`は、その連分数resolventの極限値である。
