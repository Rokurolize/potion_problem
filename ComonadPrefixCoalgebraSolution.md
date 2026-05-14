# comonad prefix coalgebra解

この解では、無限列からprefixを取り出す操作をcoalgebraとして見る。

無限列

```text
(X_1,X_2,...)
```

から長さ`n`のprefixを取り出す。停止前かどうかは、そのprefixの合計

```text
S_n=X_1+...+X_n
```

が`1`以下かで決まる。prefixを次々に観測するcoalgebraの各段階で、まだ停止していない状態空間は

```text
D_n={x_i>=0, x_1+...+x_n<=1}
```

である。

`D_n`は標準`n`単体なので

```text
P(tau>n)=vol(D_n)=1/n!.
```

ゆえに

```text
E[tau]=sum_{n>=0}P(tau>n)
      =sum_{n>=0}1/n!
      =e.
```

prefixを展開するcoalgebraの各観測段階で、残っている状態空間の体積を足すと、停止時刻の期待値になる。
