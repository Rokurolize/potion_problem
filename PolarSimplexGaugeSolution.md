# polar simplex gauge解

この解では、停止前条件を標準単体のgaugeで表す。

正の直交象限上で

```text
p(x)=x_1+...+x_n
```

を考える。これは標準単体

```text
Delta_n={x_i>=0, x_1+...+x_n<=1}
```

のMinkowski gaugeであり、`p(x)<=1`がちょうど単体の内部を表す。

長さ`n`でまだ止まらないことは

```text
p(X_1,...,X_n)<=1
```

と同値である。独立一様分布の密度は1なので、この確率はgauge単位球の体積

```text
P(tau>n)=vol(Delta_n)=1/n!
```

である。

したがって

```text
E[tau]=sum_{n>=0}P(tau>n)
      =sum_{n>=0}1/n!
      =e.
```

停止時刻は、prefixベクトルが標準単体gaugeの単位球を出る最初の時刻として読める。
