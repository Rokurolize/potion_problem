# Koopman作用素境界解

この解では、prefix和へ一様乱数を足す操作をKoopman作用素として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixも数えると

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

境界`x`以下に残るprefixの総期待数を

```text
F(x)=sum_{n>=0} P(S_n<=x)
```

と置く。Koopman作用素`K`を

```text
(Kf)(s)=int_0^1 f(s+u) du
```

で定めると、`K`を一回かけることはprefixを一口延長することに等しい。指示関数`1_{s<=x}`で試すと

```text
F(x)=sum_{n>=0} K^n 1_{s<=x}(0).
```

`0<=x<=1`では、境界を`dx`だけ動かしたときに新しく許されるprefixは、既存prefixの末尾に長さ`dx`の最後の一口を付けたものと一対一に対応する。したがって

```text
F'(x)=F(x),  F(0)=1.
```

よって

```text
F(x)=e^x,
E[tau]=F(1)=e.
```

Koopman作用素の見方では、確率分布を直接畳み込まず、観測関数側を押し進める。境界指示関数の resolvent が、結局は自己増殖方程式`F'=F`を作る。
