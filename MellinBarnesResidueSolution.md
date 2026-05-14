# Mellin-Barnes留数解

この解では、階乗係数をMellin-Barnes型の留数として拾い、境界`1`で総和する。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。停止前prefix数より

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

`0<=x<=1`では、生存領域は正の単体なので

```text
P(S_n<=x)=x^n/n!.
```

この係数は、Mellin-Barnes表示で指数関数の極から拾える。

```text
x^n/n! = Res_{s=n} Gamma(-s)(-x)^s
```

と見れば、全次数の留数和は閉曲線をずらして指数関数を復元する操作である。したがって

```text
sum_{n>=0} x^n/n! = e^x.
```

境界`x=1`で

```text
E[tau]=e.
```

Mellin-Barnesの言葉では、各単体体積の階乗を個別に積分せず、指数関数の留数列としてまとめて評価している。
