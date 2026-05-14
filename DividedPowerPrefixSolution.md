# divided power prefix解

この解では、停止前prefixの体積列をdivided power基底そのものとして読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。容量`x`までで生き残る長さ`n`のprefix重みを

```text
a_n(x)=P(S_n<=x)
```

と置く。最後の増分を外せば

```text
a_0(x)=1,
a_n'(x)=a_{n-1}(x),
a_n(0)=0  (n>=1).
```

これは多項式環のdivided power基底

```text
x^{[n]} = x^n/n!
```

の特徴づけそのものである。したがって

```text
a_n(x)=x^{[n]}=x^n/n!.
```

停止時刻は空prefixを含む停止前prefixの個数なので

```text
E[tau]=sum_{n>=0} a_n(1)
      =sum_{n>=0} 1/n!
      =e.
```

ここでは階乗を後から割るのではない。停止前prefixの再帰が最初からdivided power基底を選んでいる。
