# Dirichlet integral tail解

この解では、停止前確率をDirichlet積分の特殊例として評価する。

長さ`n`の和を

```text
S_n=x_1+...+x_n
```

とする。`tau>n`は`S_n<=1`と同値なので、

```text
P(tau>n)=int_{x_i>=0, x_1+...+x_n<=1} dx_1...dx_n.
```

余り変数

```text
x_{n+1}=1-S_n
```

を入れると、これは指数がすべて1のDirichlet積分になる。標準公式

```text
int_{x_i>=0, sum_{i=1}^{n+1}x_i=1} 1 d\sigma
```

を`x_{n+1}`で押し戻すと、`n`次元体積は

```text
Gamma(1)^n Gamma(1)/Gamma(n+1)=1/n!
```

である。

よって

```text
P(tau>n)=1/n!
```

となり、尾和公式により

```text
E[tau]=sum_{n>=0}P(tau>n)=sum_{n>=0}1/n!=e.
```

停止前領域は、Dirichlet分布の全パラメータが1である単体そのものであり、その正規化定数が期待値の指数級数を作る。
