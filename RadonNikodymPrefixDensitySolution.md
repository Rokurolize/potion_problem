# Radon-Nikodym prefix density解

この解では、停止前prefixの全体を和への押し出し測度と見て、そのRadon-Nikodym密度を読む。

長さ`n`の入力列に対し

```text
q_n(u_1,...,u_n)=u_1+...+u_n
```

とおく。停止前条件は`q_n<=1`であり、尾和公式より

```text
E[tau]=sum_{n>=0} vol{q_n<=1}.
```

各次数のLebesgue測度を`q_n`で`[0,infty)`へ押し出す。`n>=1`では、その押し出し測度はLebesgue測度に絶対連続で、Radon-Nikodym密度は

```text
d(q_n)_*du/dx = x^{n-1}/(n-1)!.
```

これは、和が`x`以下である領域の体積`x^n/n!`を微分したものでもある。

全次数を足した押し出し測度は、空prefixの`delta_0`と連続密度

```text
sum_{n>=1} x^{n-1}/(n-1)! = e^x
```

を持つ。したがって

```text
E[tau]=delta_0([0,1])+int_0^1 e^x dx=e.
```

ここでは、停止前prefixの総量を和座標上の一つの密度に圧縮している。
