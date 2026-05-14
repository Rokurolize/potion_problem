# facet sweep prefix解

この解では、停止前prefixの単体を境界facetの掃引として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。境界`x`までの長さ`n`の生存領域を

```text
Delta_n(x)={u_i>=0, u_1+...+u_n<=x}
```

と置く。境界`x`を少し動かすと、新しく掃かれる薄い領域の断面は一つ低いfacet

```text
Delta_{n-1}(x)
```

である。したがって体積`A_n(x)=vol(Delta_n(x))`は

```text
A_0(x)=1,
A_n'(x)=A_{n-1}(x).
```

初期条件`A_n(0)=0`から

```text
A_n(x)=x^n/n!.
```

空prefixを含めて足すと

```text
E[tau]=sum_{n>=0}A_n(1)=sum_{n>=0}1/n!=e.
```

この証明では、単体体積公式を丸ごと引用しない。facetを境界方向に掃引すると一段低い単体が現れる、という再帰だけを見る。
