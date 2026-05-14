# incremental view maintenance解

この解では、生存prefix集合を一段ずつ増やすviewとして保守する。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。容量`x`までで生存する長さ`n`のprefix viewを

```text
V_n(x)={u_i>=0, u_1+...+u_n<=x}
```

と置く。新しい一列を追加するとき、最後の値`u`を選び、残り`x-u`で一段前のviewを参照する。

```text
vol V_n(x)=int_0^x vol V_{n-1}(x-u) du,
vol V_0(x)=1.
```

したがって

```text
vol V_n(x)=x^n/n!.
```

求める期待値は、容量`1`で維持される全深さのviewの総量である。

```text
E[tau]=sum_{n>=0} vol V_n(1)
      =sum_{n>=0} 1/n!
      =e.
```

incremental view maintenanceとして見ると、各深さのviewを再計算せず、一段前のviewを積分して更新している。
