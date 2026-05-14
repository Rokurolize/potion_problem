# feedback control survival解

この解では、残り容量を状態として、許される入力だけを選ぶfeedback制約で生存prefixを数える。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。残り容量が`x`の状態で、次の入力`u`が`0<=u<=x`なら生存し、状態は`x-u`へ移る。残り容量`x`からの停止前prefix期待個数を`F(x)`とすると

```text
F(x)=1+int_0^x F(x-u) du.
```

変数を替えて

```text
F(x)=1+int_0^x F(t) dt.
```

したがって

```text
F'(x)=F(x),  F(0)=1,
```

より

```text
F(x)=e^x.
```

初期状態は`x=1`なので

```text
E[tau]=F(1)=e.
```

feedback controlの言葉では、許容入力集合が状態`x`に応じて`[0,x]`へ縮む。その閉じた再帰だけで指数関数が出る。
