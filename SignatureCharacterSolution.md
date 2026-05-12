# signature character解

この解では、生存prefix全体を、区間`[0,1]`のpath signatureに対するcharacter評価として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }.
```

停止時刻は生存しているprefixの個数だから、

```text
tau = sum_{n >= 0} 1_{S_n <= 1}.
```

したがって

```text
E[tau] = sum_{n >= 0} P(S_n <= 1).
```

## prefixをsignatureの成分にする

`n >= 1`で累積和

```text
t_i = S_i
```

へ変数変換する。Jacobianは`1`で、`S_n <= 1`は

```text
0 < t_1 < ... < t_n <= 1
```

という順序付き時刻列になる。よって

```text
P(S_n <= 1)
= int_{0<t_1<...<t_n<=1} dt_1 ... dt_n.
```

これは、一次元path

```text
gamma(t) = t,    0 <= t <= 1
```

のsignatureの`n`次成分である。

## 全prefixはcharacter評価である

一次元pathのsignatureは、テンソル代数で

```text
Sig(gamma) = sum_{n >= 0} e^{tensor n} / n!
```

と書ける。ここで`e`は1文字の基底で、`n=0`成分は空語である。

今ほしい量は、全次数の成分を全部足すことなので、各語`e^{tensor n}`を`1`に送るcharacter

```text
chi(e^{tensor n}) = 1
```

でsignatureを評価すればよい。

したがって

```text
E[tau]
= chi(Sig(gamma))
= chi( sum_{n >= 0} e^{tensor n} / n! )
= sum_{n >= 0} 1 / n!
= exp(1)
= e.
```

## この見方の要点

この証明では、飲用量の分布を最後まで展開してから足すのではない。累積和への変数変換により、生存prefixは区間`[0,1]`上の順序付き時刻列になる。

その全体は、直線path`gamma(t)=t`のsignatureそのものである。期待値は、そのsignatureの全成分を足すcharacter評価であり、答えの`e`は直線pathのsignatureがテンソル指数になることから現れる。
