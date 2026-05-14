# activity derivative partition解

この解では、活動度付き分配関数を作り、その値で期待prefix数を読む。

容量`1`内に収まる長さ`n`のprefix体積を

```text
A_n=vol{u_i>=0, u_1+...+u_n<=1}
```

とする。活動度`z`を導入して

```text
Z(z)=sum_{n>=0} z^n A_n
```

を考える。累積和座標により`A_n=1/n!`なので

```text
Z(z)=sum_{n>=0} z^n/n!=e^z.
```

元の停止時刻は空prefixを含む停止前prefixの数であり、尾和公式で

```text
E[tau]=sum_{n>=0}A_n=Z(1)=e.
```

さらに活動度微分は

```text
z Z'(z)=sum_{n>=0} n z^n A_n
```

となり、prefix長の重み付き統計も同じ分配関数から出る。ここでは期待停止時刻そのものが、活動度`1`の分配関数として現れる。
