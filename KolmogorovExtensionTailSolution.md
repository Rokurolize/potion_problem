# Kolmogorov extension tail解

この解では、無限列の積確率をKolmogorov拡張の有限次元分布から読む。

独立一様乱数列は、各有限次元分布

```text
[0,1]^n 上の Lebesgue 測度
```

が整合しているため、Kolmogorov拡張で無限列上の確率測度を定める。

事象`{tau>n}`は最初の`n`座標だけに依存するので、その確率は有限次元分布で計算できる。

```text
P(tau>n)
=lambda_n{x_i>=0, x_1+...+x_n<=1}.
```

この集合は標準`n`単体だから

```text
P(tau>n)=1/n!.
```

尾和公式により

```text
E[tau]=sum_{n>=0}P(tau>n)
      =sum_{n>=0}1/n!
      =e.
```

無限列の測度を拡張定理で作っても、停止前事象は有限次元の単体体積だけで完全に決まる。
