# SQL再帰CTE解

この解では、停止前prefixを再帰CTEで生成される行集合として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。残り容量`r`で生成できるprefix総量を`F(r)`とする。SQL風に書けば、基底行は空prefixで重み`1`、再帰項は

```text
select r-u
from prefixes, u in [0,r]
```

である。したがって再帰CTEの総重みは

```text
F(r)=1+int_0^r F(r-u) du.
```

変数を替えて

```text
F(r)=1+int_0^r F(v) dv,
```

ゆえに

```text
F'(r)=F(r),  F(0)=1.
```

解は

```text
F(r)=e^r.
```

初期容量`1`で

```text
E[tau]=F(1)=e.
```

この見方では、再帰CTEの基底行と再帰行がそのまま空prefixと一口追加を表す。評価は、CTEの総重みを閉じたものにすぎない。
