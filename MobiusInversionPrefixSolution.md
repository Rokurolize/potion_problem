# Mobius inversion prefix解

この解では、停止前条件を「合計が1を超えたかどうか」の二値束でMobius反転する。

長さ`n`のprefixに対して

```text
A_n={x_1+...+x_n<=1}
```

と置く。事象`A_n`は入れ子で、

```text
A_0 superset A_1 superset A_2 superset ...
```

である。停止時刻`tau`の期待値は、この入れ子列の指示関数をMobius反転して得る尾和

```text
E[tau]=sum_{n>=0}P(A_n)
```

で与えられる。

各`P(A_n)`は標準単体の体積である。実際、

```text
A_n={x_i>=0, x_1+...+x_n<=1}
```

なので

```text
P(A_n)=vol(A_n)=1/n!.
```

よって

```text
E[tau]=sum_{n>=0}1/n!=e.
```

停止時刻そのものを数える代わりに、入れ子になった停止前事象をMobius反転で尾和へほどくと、必要なのは各prefix単体の体積だけになる。
