# stopped process prefix解

この解では、停止前のprefixだけを止めた過程として数える。

停止時刻`tau`の前では、prefix

```text
(X_1,...,X_n)
```

は条件

```text
X_1+...+X_n<=1
```

を満たす。つまり、止めた過程が長さ`n`まで存在するための履歴空間は

```text
D_n={x_i>=0, x_1+...+x_n<=1}
```

である。

この空間は標準`n`単体であり、

```text
P(tau>n)=vol(D_n)=1/n!.
```

ゆえに

```text
E[tau]=sum_{n>=0}P(tau>n)
      =sum_{n>=0}1/n!
      =e.
```

止めた過程のprefix空間を長さごとに測ると、期待値はそれらの体積の総和になる。
