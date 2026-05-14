# dataflow liveness tail解

この解では、停止前であることをdataflow解析のlivenessとして数える。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。時刻`n`で計算がまだliveである条件は

```text
S_n<=1.
```

したがってliveな時刻の指示関数を

```text
L_n=1_{S_n<=1}
```

と置けば

```text
tau=sum_{n>=0} L_n.
```

期待値を取ると

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

固定した`n`では、liveである入力列の領域は標準単体であり、体積は`1/n!`である。よって

```text
E[tau]=sum_{n>=0} 1/n! = e.
```

dataflow livenessとして見ると、停止時刻の期待値はlive判定が真になる全prefixの質量である。
