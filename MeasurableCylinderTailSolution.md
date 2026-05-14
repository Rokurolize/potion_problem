# measurable cylinder tail解

この解では、無限列空間のcylinder集合として停止前事象を測る。

無限列

```text
(X_1,X_2,...)
```

の積測度空間で、`tau>n`は最初の`n`座標だけに依存するcylinder集合である。

```text
C_n={x_1+...+x_n<=1}
```

このcylinderの測度は、最初の`n`座標の周辺測度で測ればよい。独立一様分布なので密度は1であり、

```text
P(tau>n)=int_{x_i>=0, x_1+...+x_n<=1}1 dx=1/n!.
```

尾和公式から

```text
E[tau]=sum_{n>=0}P(tau>n)
      =sum_{n>=0}1/n!
      =e.
```

停止前事象は無限列上ではcylinder集合で、有限次元の底面が標準単体になるため、その測度が階乗分母を与える。
