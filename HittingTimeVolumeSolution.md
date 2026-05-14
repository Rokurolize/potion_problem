# hitting time volume解

この解では、レベル1のhitting timeを体積で測る。

部分和過程`S_n`が初めて1を超える時刻を`tau`とする。`n`時点でまだhitしていないことは

```text
S_n<=1
```

と同値である。独立一様分布の密度は1だから、この確率は

```text
P(tau>n)=int_{x_i>=0, x_1+...+x_n<=1}1 dx
```

である。

積分領域は標準単体で、体積は

```text
1/n!
```

したがって

```text
P(tau>n)=1/n!.
```

期待値は尾和なので

```text
E[tau]=sum_{n>=0}1/n!=e.
```

hitting timeの問題として見ると、hit前の履歴全体が単体をなし、その体積が尾確率になる。
