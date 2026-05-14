# Abel極限生成関数解

この解では、prefixの長さに減衰係数を入れて安全に総和し、最後にAbel極限で減衰を外す。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めて

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

`0<=q<1`に対して

```text
A_q(x)=sum_{n>=0} q^n P(S_n<=x)
```

を置く。境界を`x`から`x+h`へ広げると、既存prefixは幅`h+o(h)`だけ次のprefixを生み、長さが一つ増えるので重みは`q`倍になる。よって

```text
A_q(x+h)-A_q(x)=h q A_q(x)+o(h).
```

したがって

```text
A_q'(x)=q A_q(x),
A_q(0)=1.
```

よって

```text
A_q(x)=exp(qx).
```

Abel極限で減衰を外すと

```text
E[tau]=lim_{q -> 1-} A_q(1)=e.
```

この証明では、無限和を最初から裸で扱わない。長さ方向にAbel減衰を入れ、境界再帰を解いてから`q`を`1`へ戻す。`e`は、このAbel極限の値である。
