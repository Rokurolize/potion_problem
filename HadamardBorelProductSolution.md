# Hadamard-Borel積解

この解では、生存prefix列を定数列とBorel階乗列のHadamard積として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めると

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

境界`x`までの生存量を`a_n(x)=P(S_n<=x)`と置く。`0<=x<=1`では最後の一口を外すと

```text
a_n'(x)=a_{n-1}(x),
a_0(x)=1.
```

したがって生存列は、定数列`1,1,1,...`をBorel型に階乗で割った列として現れる。境界`x=1`での全和は、定数列とBorel核`1/n!`のHadamard積の和で

```text
sum_{n>=0} 1 * (1/n!) = e.
```

この証明では、各単体体積を個別に計算しない。境界微分の添字シフトが、生存列をBorel階乗列とのHadamard積へ押し込むことだけを見る。`e`は、そのHadamard-Borel積の全和である。
