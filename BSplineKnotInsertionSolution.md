# B-spline knot insertion解

この解では、`S_n`の密度をB-splineとして見て、境界`1`までに必要な先頭片をknot insertionの反復で読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。停止前prefixを数えると

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

`n`個の一様分布の畳み込み密度はcardinal B-splineである。境界が`1`なので、必要なのは最初のknot区間`[0,1]`の片だけである。knot insertionで次数を一つ上げると、この先頭片は一回積分される。

初期密度は

```text
f_0(x)=delta_0
```

と見られ、先頭片の分布関数は反復積分により

```text
P(S_n<=x)=x^n/n!  (0<=x<=1)
```

となる。したがって

```text
P(S_n<=1)=1/n!,
E[tau]=sum_{n>=0}1/n!=e.
```

B-spline全体の折れ線構造を求めず、knot`1`より左の先頭片だけを追えば十分である。
