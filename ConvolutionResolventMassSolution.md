# convolution resolvent mass解

この解では、停止前prefixの全質量を畳み込み代数のresolventとして読む。

`mu`を`[0,1]`上のLebesgue測度、`delta_0`を原点の単位質量とする。長さ`n`まで停止しない確率は

```text
P(U_1+...+U_n<=1)=mu^{*n}([0,1])
```

である。ただし`n=0`では`mu^{*0}=delta_0`とする。

したがって尾和公式は

```text
E[tau]=sum_{n>=0}mu^{*n}([0,1])
```

である。右辺は畳み込みresolvent

```text
R=(delta_0-mu)^{-1}=sum_{n>=0}mu^{*n}
```

の区間`[0,1]`での質量に等しい。

`0<x<1`では、`mu^{*n}`の密度は上限制約に当たらず

```text
x^{n-1}/(n-1)!
```

である。よってresolventの連続部分の密度は

```text
sum_{n>=1}x^{n-1}/(n-1)!=e^x.
```

空prefixの原子を加えて

```text
R([0,1])=1+int_0^1 e^x dx=e.
```

この見方では、全てのprefix長を個別に扱わず、畳み込み単位のresolventの質量として期待値を取り出す。
