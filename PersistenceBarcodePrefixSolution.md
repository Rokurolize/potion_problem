# persistence barcode prefix解

この解では、停止前prefixを容量で濾過された単体のbarcodeとして見る。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。容量`x`で生存する長さ`n`のprefix領域を

```text
B_n(x)={u_i>=0, u_1+...+u_n<=x}
```

と置く。これは`x`とともに単調に増える濾過で、体積を`b_n(x)`とすれば

```text
b_0(x)=1,
b_n'(x)=b_{n-1}(x),
b_n(0)=0  (n>=1).
```

したがって

```text
b_n(x)=x^n/n!.
```

容量`1`での全次数のbarcode質量を足すと、停止前prefixの期待個数になる。

```text
E[tau]=sum_{n>=0} b_n(1)
      =sum_{n>=0} 1/n!
      =e.
```

ここでbarcodeの持続時間そのものを複雑に追う必要はない。停止境界内で生まれて残っている全prefixの濾過質量だけが効いている。
