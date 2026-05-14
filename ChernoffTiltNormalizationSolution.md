# Chernoff傾き正規化解

この解では、prefixの長さに指数傾きを入れて、傾いた正規化定数から答えを読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めて

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

長さ`n`のprefixにChernoff傾き`theta`を入れ、

```text
C(x,theta)=sum_{n>=0} exp(theta n) P(S_n<=x)
```

と置く。境界を少し増やすと、既存prefixが次のprefixを生む幅は`dx`であり、長さが一つ増えるので重みは`exp(theta)`倍になる。したがって

```text
partial_x C(x,theta)=exp(theta) C(x,theta),
C(0,theta)=1.
```

よって

```text
C(x,theta)=exp(exp(theta) x).
```

傾きを外すには`theta=0`とすればよい。すると

```text
C(1,0)=exp(1)=e.
```

これはまさに

```text
sum_{n>=0} P(S_n<=1)=E[tau]
```

である。

この証明では、長さごとの生存確率を先に計算しない。長さ方向にChernoff傾きを入れ、境界方向の正規化定数が傾き付き出生率`exp(theta)`で指数的に伸びることだけを見る。`e`は、傾きをゼロへ戻した正規化定数である。
