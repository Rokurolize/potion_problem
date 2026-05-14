# dyadic細分prefix解

この解では、境界区間をdyadicに細分して、細かい格子極限でprefix総量の方程式を読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。境界`x`までの停止前prefix総量を

```text
F(x)=sum_{n>=0}P(S_n<=x)
```

と置く。`[0,x]`を幅`2^{-m}`のdyadic小区間に分ける。各小区間を一つ右へ増やすと、既存prefixは一様密度`1`でその新しい薄い層へ次のprefixを送る。

幅を`h=2^{-m}`とすると、dyadic差分は

```text
F(x+h)-F(x)=h F(x)+o(h).
```

`m -> infinity`で

```text
F'(x)=F(x),  F(0)=1
```

を得る。したがって

```text
F(x)=e^x,
E[tau]=F(1)=e.
```

この証明では、単体体積を先に計算しない。dyadic細分で見える薄層増分だけを残し、極限で指数方程式へ渡す。
