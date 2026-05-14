# Eilenberg-Moore prefix代数解

この解では、一口を追加する劣確率カーネルをモナド的な「prefix生成」と見て、その自由生成物をEilenberg-Moore代数で潰す。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めて

```text
tau = sum_{n >= 0} 1_{S_n <= 1}
```

なので

```text
E[tau] = sum_{n >= 0} P(S_n <= 1).
```

残り容量`r`から一口飲んでまだ生きている操作を

```text
(Kf)(r)=int_0^r f(r-u) du
```

と置く。これは一段のprefix生成である。停止前prefix全体は

```text
1 + K1 + K^2 1 + ...
```

であり、自由なprefix列を作ってから期待値へ畳み込む操作になっている。

この自由prefixモナドのEilenberg-Moore代数として、全prefixを数える評価

```text
H(r)=sum_{n>=0} K^n 1(r)
```

を考える。代数構造は「空prefixを`1`として受け取り、一段生成したprefixは同じ評価に戻す」という式

```text
H(r)=1+int_0^r H(r-u) du
```

で表される。変数を替えれば

```text
H(r)=1+int_0^r H(v) dv.
```

したがって

```text
H'(r)=H(r),
H(0)=1.
```

よって

```text
H(r)=exp(r).
```

求める期待値は初期残量`1`で

```text
E[tau]=H(1)=e.
```

この証明では、各`P(S_n<=1)`を先に計算しない。自由に伸ばしたprefix列を、全prefix数を返すEilenberg-Moore代数で一度に畳み込む。`e`は、その代数方程式の初期残量`1`での値である。
