# Touchard Poissonization解

この解では、停止前確率をPoisson化されたラベル数の重みとして取り出す。

長さ`n`で止まっていない確率は、標準単体の体積

```text
P(tau>n)=vol{x_i>=0, x_1+...+x_n<=1}=1/n!
```

である。この`1/n!`は、Poisson化でラベル数`n`に付く階乗正規化そのものになっている。

Touchard型の見方では、ラベル数を表す変数`z`に対して

```text
sum_{n>=0} P(tau>n) z^n
```

を考える。上の単体体積を代入すると

```text
sum_{n>=0} z^n/n! = exp(z).
```

停止時刻の期待値はこの母関数を`z=1`で評価した尾和だから

```text
E[tau]=sum_{n>=0}P(tau>n)=exp(1)=e.
```

Poisson化の階乗正規化が、停止前単体の体積と完全に一致するため、期待値はTouchard型母関数の最も単純な値として出る。
