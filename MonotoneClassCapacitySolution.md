# monotone class capacity解

この解では、容量`x`以下で生き残るprefix事象をmonotone classで閉じた後に数える。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。`0<=x<=1`で

```text
A_n(x)=P(S_n<=x)
```

と置く。事象`{S_n<=x}`は`x`について単調に増えるので、半開区間から始めた有限次元cylinderのmonotone class上で測度が連続に延長される。

最後の増分を分けると

```text
A_0(x)=1,
A_n(x)=int_0^x A_{n-1}(x-u) du.
```

よって

```text
A_n'(x)=A_{n-1}(x),  A_n(0)=0
```

から

```text
A_n(x)=x^n/n!.
```

したがって

```text
E[tau]=sum_{n>=0} A_n(1)
      =sum_{n>=0} 1/n!
      =e.
```

monotone classで見れば、容量境界を動かす極限操作と有限次元の積分計算が同じ枠内で扱える。
