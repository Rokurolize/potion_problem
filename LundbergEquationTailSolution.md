# Lundberg equation tail解

この解では、残り準備金の期待prefix数をLundberg型の積分方程式で読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。残り準備金が`x`のとき、破産前に数えられるprefixの期待個数を`R(x)`と書く。空prefixを一つ数え、次の請求額`u`が`0<=u<=x`なら残りは`x-u`である。

```text
R(x)=1+int_0^x R(x-u) du.
```

変数を替えれば

```text
R(x)=1+int_0^x R(t) dt.
```

よって

```text
R'(x)=R(x),  R(0)=1,
```

なので

```text
R(x)=e^x.
```

初期準備金は`1`だから

```text
E[tau]=R(1)=e.
```

Lundberg型の名前を付けても、ここでは指数調整係数を探すのではない。準備金を削る一段再帰がそのまま指数関数を生む。
