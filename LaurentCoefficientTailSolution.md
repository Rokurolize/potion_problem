# Laurent coefficient tail解

この解では、停止前確率をLaurent級数の留数係数として取り出す。

長さ`n`で止まっていない確率は

```text
P(tau>n)=vol{x_i>=0, x_1+...+x_n<=1}=1/n!.
```

一方、指数関数の係数はLaurent係数として

```text
1/n! = [z^n] exp(z)
     = [z^{-1}] exp(z)/z^{n+1}
```

と書ける。つまり、停止前単体の体積は`exp(z)/z^{n+1}`の`z^{-1}`係数である。

したがって

```text
P(tau>n)=[z^{-1}] exp(z)/z^{n+1}.
```

尾和を取れば

```text
E[tau]=sum_{n>=0}P(tau>n)
      =sum_{n>=0}1/n!
      =e.
```

各尾確率をLaurent係数として抜き出すと、期待値は指数関数の全係数和になる。
