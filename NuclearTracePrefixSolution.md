# nuclear trace prefix解

この解では、長さごとの停止前質量をtrace class的な対角和として読む。

長さ`n`で止まっていない履歴の空間は

```text
D_n={x_i>=0, x_1+...+x_n<=1}
```

である。`D_n`上の恒等核を考えると、そのtraceは対角を積分した量、つまり`D_n`の体積である。

```text
tr(I_{D_n})=int_{D_n}1 dx=vol(D_n).
```

標準単体の体積は

```text
vol(D_n)=1/n!
```

なので

```text
P(tau>n)=tr(I_{D_n})=1/n!.
```

停止時刻の期待値は尾和だから

```text
E[tau]=sum_{n>=0}tr(I_{D_n})
      =sum_{n>=0}1/n!
      =e.
```

長さごとの生存空間を核のtraceで測ると、期待値はそれらのtraceの総和として表される。
