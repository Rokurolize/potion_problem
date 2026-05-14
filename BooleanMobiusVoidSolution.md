# Boolean Möbius空白反転解

この解では、停止前prefix全体を、Poisson空白事象をBoolean束上でMöbius反転したものとして読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。期待値は

```text
E[tau] = sum_{n >= 0} P(S_n <= 1)
```

である。

## 空白事象のMöbius関数

区間`[0,1]`上の単位強度Poisson点過程を考える。点がちょうど`n`個ある確率は

```text
exp(-1) / n!
```

である。ここで`1/n!`は、`n`個の点を順序付きprefixとして並べた領域の体積に等しい。したがって停止前prefixの全質量は、Poisson配置確率から共通因子`exp(-1)`を外したものになる。

これをBoolean束の言葉で見る。有限集合`A`の各点を「採用するか消すか」というBoolean束で空白事象を包除すると、空白確率は

```text
sum_{A finite} (-1)^{|A|} / |A|!
  = exp(-1)
```

である。Boolean束のMöbius関数は

```text
mu(empty, A) = (-1)^{|A|}
```

なので、空白事象は全有限配置測度にMöbius符号を掛けて畳み込んだ値である。

求める停止前prefix総量は、そのMöbius符号を外したzeta側の全質量である。したがって

```text
E[tau]
  = sum_{n >= 0} 1/n!
  = exp(1)
  = e.
```

この証明では、各`P(S_n <= 1)`を個別に積分しない。Poisson空白確率`exp(-1)`をBoolean束のMöbius反転として見て、符号付きに消した有限配置をzeta側へ戻す。`e`は空白のMöbius反転で失われた全配置質量である。
