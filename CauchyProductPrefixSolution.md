# Cauchy積prefix解

この解では、停止前prefixを「空prefix」と「一口追加後のprefix」のCauchy積分解として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めれば

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

残り容量`r`から見た全prefix質量を

```text
F(r)
```

と置く。任意の停止前prefixは、空prefixか、最初の一口`u in [0,r]`と残り容量`r-u`でのprefixの組に一意に分かれる。したがって

```text
F(r)=1+int_0^r F(r-u) du.
```

これは連続Cauchy積で、単位元`1`に一口核を畳み込んだ全反復をまとめた式である。微分して

```text
F'(r)=F(r),
F(0)=1.
```

よって

```text
F(r)=exp(r),
E[tau]=F(1)=e.
```

この証明では、長さごとの確率を先に出さない。prefixの分解をCauchy積として一度に書き、その単位元つき畳み込み方程式を解くだけである。`e`は、このCauchy積resolventの値である。
