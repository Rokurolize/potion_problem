# Datalog reachability tail解

この解では、停止前prefixを容量制約つきの到達可能関係として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。Datalog風に、残り容量`x`から入力`u<=x`を読むと残り容量`x-u`へ到達できると考える。長さ`n`で到達可能なprefix全体の測度は

```text
R_n(x)=P(S_n<=x)
```

であり、一段規則から

```text
R_0(x)=1,
R_n(x)=int_0^x R_{n-1}(x-u) du.
```

よって

```text
R_n'(x)=R_{n-1}(x),  R_n(0)=0
```

となり、

```text
R_n(x)=x^n/n!.
```

停止前prefixの期待個数は到達可能な全深さの測度を足したものだから

```text
E[tau]=sum_{n>=0} R_n(1)=sum_{n>=0} 1/n! = e.
```

Datalogの固定点として見ても、到達可能関係の閉包は同じ単体体積列を返す。
