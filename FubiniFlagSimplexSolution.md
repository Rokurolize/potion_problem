# Fubini旗単体解

この解では、生存単体を入れ子の旗

```text
0<t_1<...<t_n<1
```

として、Fubiniの順序積分だけで読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。Tonelliにより

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

累積時刻

```text
t_k=U_1+...+U_k
```

へ移ると、Jacobianは`1`で、生存条件は

```text
0<t_1<...<t_n<1
```

になる。Fubiniの定理でこの旗領域を内側から積分すれば

```text
int_0^1 int_0^{t_n} ... int_0^{t_2} dt_1 ... dt_n = 1/n!.
```

したがって

```text
P(S_n<=1)=1/n!,
E[tau]=sum_{n>=0}1/n!=e.
```

この証明は、確率分布名を使わず、停止前prefixを時刻の旗に変えて、順序付きFubini積分として評価する。
