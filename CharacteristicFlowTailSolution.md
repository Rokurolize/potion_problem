# characteristic flow tail解

この解では、合計値方向のcharacteristic flowで停止前領域を切る。

長さ`n`のprefixに対し

```text
s=x_1+...+x_n
```

を考える。停止前条件は`s<=1`であり、`s`を時間のような変数として見ると、`s=r`のcharacteristic面は

```text
x_i>=0, x_1+...+x_n=r
```

である。

この面の体積密度は、倍率`r`の`n-1`単体として

```text
r^{n-1}/(n-1)!
```

になる。したがって停止前確率は

```text
P(tau>n)=int_0^1 r^{n-1}/(n-1)! dr=1/n!.
```

尾和公式から

```text
E[tau]=sum_{n>=0}P(tau>n)
      =sum_{n>=0}1/n!
      =e.
```

合計値方向へ流して、停止境界`r=1`までのcharacteristic面を積み上げると、期待値の各項が得られる。
