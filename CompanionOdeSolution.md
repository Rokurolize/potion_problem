# companion ODE解

この解では、全prefix総量を閉じた一次ODEとして見る前に、有限段のcompanion型ODEで近似する。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。長さ`N`までの切断総量を

```text
F_N(x)=sum_{n=0}^N P(S_n <= x)
```

と置く。`0<=x<=1`では、各段の境界微分が一段前を返すので

```text
F_N'(x)=F_N(x)-P(S_N<=x),
F_N(0)=1.
```

同時に各成分`a_n(x)=P(S_n<=x)`は

```text
a_n'(x)=a_{n-1}(x)
```

を満たす。これは有限のcompanion型ODE系であり、解は

```text
a_n(x)=x^n/n!.
```

よって

```text
F_N(1)=sum_{n=0}^N 1/n!.
```

最後に`N -> infinity`とすると

```text
E[tau]=lim_N F_N(1)=e.
```

この見方では、いきなり無限級数を仮定しない。有限次元の線形ODE系を解き、そのcompanion鎖の極限として期待値を読む。
