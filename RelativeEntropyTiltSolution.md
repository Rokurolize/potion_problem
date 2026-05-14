# 相対エントロピー傾き解

この解では、生存prefixの全体をPoisson配置測度からの傾きとして見て、相対エントロピーの正規化定数だけを読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含む停止前prefix数から

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

累積和`T_k=S_k`へ移ると、長さ`n`の生存prefixは順序付き配置

```text
0<T_1<...<T_n<1
```

であり、そのLebesgue測度を`mu_n`と書く。

単位率Poisson過程の順序付き`n`点配置確率は

```text
dP_n = e^{-1} dmu_n.
```

したがって、停止前prefix測度`mu=sum mu_n`はPoisson配置確率`P=sum P_n`に対して

```text
dmu/dP = e
```

という一定密度を持つ。これはPoisson測度から空白罰則`-1`を外す相対エントロピー傾きであり、正規化定数は

```text
exp(1).
```

Poisson側の全質量は`1`なので

```text
E[tau]=mu(全配置)=e P(全配置)=e.
```

ここでは各単体体積を個別に計算しない。停止前prefixの測度が、Poisson配置測度を一定密度で傾けたものだと見抜き、その正規化定数だけを読む。
