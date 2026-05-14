# Jackson積分prefix解

この解では、停止前prefixのVolterra積分をJackson積分で離散近似してから連続極限へ戻す。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めると

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

残り容量`r`から見た全prefix質量を`J(r)`と書く。通常の再帰は

```text
J(r)=1+int_0^r J(v) dv.
```

この積分をq格子上のJackson積分で近似すると、各格子点のprefixが次のprefixを作る寄与を離散的に足す式になる。`q -> 1`でJackson積分は通常の積分へ収束し、

```text
J(r)=1+int_0^r J(v) dv
```

へ戻る。微分して

```text
J'(r)=J(r),
J(0)=1.
```

よって

```text
J(r)=exp(r),
E[tau]=J(1)=e.
```

この証明では、長さごとの確率を出さない。prefix再帰をJackson積分で離散化し、連続極限で同じVolterra方程式が残ることを見る。`e`は、そのJackson積分近似の極限値である。
