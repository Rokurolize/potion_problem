# submarkov kernel potential解

この解では、残り容量の遷移を吸収付きsubmarkov kernelとして見て、そのポテンシャルの全質量を計算する。

状態空間を`[0,1]`の残り容量とする。容量`x`から次の入力を読むと、`u<=x`なら`y=x-u`へ移り、`u>x`なら吸収される。従って続行部分の核は

```text
K(x,dy)=1_{0<=y<=x} dy.
```

停止前prefix期待数は、空prefixを含む訪問ポテンシャル

```text
U1(x)=sum_{n>=0} K^n 1(x)
```

である。核の一回作用は

```text
Kf(x)=int_0^x f(y)dy.
```

帰納的に

```text
K^n1(x)=x^n/n!
```

となる。よって

```text
U1(x)=sum_{n>=0} x^n/n!=e^x.
```

元の問題は初期容量`x=1`だから

```text
E[tau]=U1(1)=e.
```

この見方では、停止時刻の期待値は吸収付き核のポテンシャルであり、`e`はsubmarkov kernelを何回でも訪問する全質量として現れる。
