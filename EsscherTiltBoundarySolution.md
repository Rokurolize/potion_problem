# Esscher傾き境界解

この解では、長さ方向にEsscher傾きを入れてから、境界`1`で傾きを戻す。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。傾きパラメータ`theta`を入れて

```text
Z_theta(x)=sum_{n>=0} exp(theta n) P(S_n<=x)
```

を考える。`0<=x<=1`では、境界を`dx`だけ動かすと、既存prefixそれぞれが最後の一口で薄い層へ入る。新しく生まれるprefixは長さが一つ増えるので、傾き付きでは係数`exp(theta)`が掛かる。したがって

```text
Z_theta'(x)=exp(theta) Z_theta(x),  Z_theta(0)=1.
```

よって

```text
Z_theta(x)=exp(exp(theta)x).
```

傾きを戻して`theta=0`とすれば

```text
E[tau]=Z_0(1)=e.
```

Esscher傾きは、長さを数える生成関数をいったん導入して、境界方向の自己増殖率が傾きでどう変わるかを読むための道具である。
