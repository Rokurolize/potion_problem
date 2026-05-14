# tensor coalgebra character解

この解では、停止前prefixをテンソル余代数上のcharacterの値としてまとめる。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。長さ`n`の停止前prefixの重みを

```text
a_n = P(S_n<=1)
```

と置く。最後の一文字を切り落とすdeconcatenationを考えると、容量`x`での重み

```text
a_n(x)=P(S_n<=x)
```

は

```text
a_n(x)=int_0^x a_{n-1}(x-u) du,
a_0(x)=1
```

を満たす。これはテンソル余代数のcharacterが、一文字重み`du`からconvolution exponentialで作られることと同じである。

実際、全長をまとめて

```text
A(x)=sum_{n>=0} a_n(x)
```

と置けば

```text
A(x)=1+int_0^x A(t) dt,
```

ゆえに

```text
A(x)=e^x.
```

停止時刻の期待値は停止前prefixの総重みだから

```text
E[tau]=A(1)=e.
```

停止前列をテンソル語として集め、deconcatenationの一段再帰が指数characterを作る。
