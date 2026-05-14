# replicating portfolio capacity解

この解では、残り容量`x`で得られる停止前coupon列を複製する価値関数として見る。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。残り容量が`x`のとき、停止前に受け取る単位couponの期待総価値を`V(x)`と書く。空prefixのcouponを一つ受け取り、次の増分`u`が`0<=u<=x`なら残り容量は`x-u`である。

```text
V(x)=1+int_0^x V(x-u) du.
```

変数を替えると

```text
V(x)=1+int_0^x V(t) dt.
```

したがって

```text
V'(x)=V(x),  V(0)=1,
```

より

```text
V(x)=e^x.
```

初期容量は`1`なので

```text
E[tau]=V(1)=e.
```

複製ポートフォリオという言葉を借りれば、一段後の残り容量価値を連続的に保有することで停止前coupon全体を複製している。
