# coefficient functional prefix解

この解では、停止前prefixの体積を指数級数の係数汎関数として取り出す。

長さ`n`まで停止しない確率は

```text
P(U_1+...+U_n<=1)
```

である。容量を変数`x`にして

```text
A_n(x)=P(U_1+...+U_n<=x)
```

とおく。最後の変数で切ると

```text
A_n'(x)=A_{n-1}(x),  A_0(x)=1,  A_n(0)=0.
```

この再帰は、係数汎関数`[z^n]`を用いて

```text
A_n(x)=[z^n] exp(zx)
```

と一意に解ける。実際、

```text
partial_x exp(zx)=z exp(zx)
```

なので、係数は一段前へずれる。

したがって

```text
P(U_1+...+U_n<=1)=A_n(1)=[z^n]e^z=1/n!.
```

尾和公式より

```text
E[tau]=sum_{n>=0}[z^n]e^z=e.
```

ここでは、確率を一つずつ積分せず、容量再帰を満たす生成関数の係数として停止前prefixを読む。
