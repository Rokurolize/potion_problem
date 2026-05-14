# Green potential boundary解

この解では、容量区間上のGreenポテンシャルを境界で評価する。

残り容量`x`の期待prefix数を`V(x)`とする。続行核は

```text
K(x,dy)=1_{0<=y<=x}dy
```

であり、空prefixを含むポテンシャルは

```text
V=sum_{n>=0}K^n1.
```

核の一回作用は

```text
Kf(x)=int_0^x f(y)dy.
```

帰納的に

```text
K^n1(x)=x^n/n!.
```

したがってGreenポテンシャルは

```text
V(x)=sum_{n>=0}x^n/n!=e^x.
```

元の停止時刻は容量`1`での停止前prefix数なので

```text
E[tau]=V(1)=e.
```

この見方では、答えは吸収境界を持つ容量核のGreenポテンシャルを端点`1`で読むことで得られる。
