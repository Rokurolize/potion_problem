# Radon-Nikodym空白傾き解

この解では、停止前prefixの測度をPoisson配置確率に対するRadon-Nikodym密度として見る。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めると

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

累積和`T_k=S_k`を使えば、長さ`n`の生存prefixは

```text
0<T_1<...<T_n<1
```

という順序付き配置である。この配置空間上のLebesgue測度を`mu_n`と書く。

一方、区間`[0,1]`上の単位率Poisson過程の順序付き`n`点Janossy測度は

```text
dP_n = e^{-1} dmu_n.
```

つまり、生存prefix測度はPoisson配置確率に対して全階層で同じRadon-Nikodym密度

```text
dmu_n/dP_n = e
```

を持つ。Poisson過程は必ず有限個の点を持つので

```text
sum_{n>=0} P_n(全順序配置)=1.
```

したがって

```text
sum_{n>=0} mu_n(全順序配置)=e.
```

左辺がそのまま`E[tau]`なので

```text
E[tau]=e.
```

`e`は級数の結果としてではなく、Poisson確率測度から空白因子`e^{-1}`を外すRadon-Nikodym密度として現れる。
