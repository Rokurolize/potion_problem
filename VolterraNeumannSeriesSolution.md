# Volterra Neumann series解

この解では、停止前prefix期待数をVolterra作用素のNeumann級数として読む。

残り容量が`x`のとき、空prefixを含めて読めるprefix数の期待値を`V(x)`とする。次の入力`u`が`0<=u<=x`なら残り容量は`x-u`で続くので

```text
V(x)=1+int_0^x V(x-u)du.
```

Volterra作用素

```text
(Tf)(x)=int_0^x f(t)dt
```

を使えば、これは

```text
V=1+TV
```

である。よって

```text
V=(I-T)^{-1}1=sum_{n>=0}T^n1.
```

Volterra作用素を`n`回かけると

```text
T^n1(x)=int_{0<=t_1<=...<=t_n<=x}dt_1...dt_n=x^n/n!.
```

したがって

```text
V(x)=sum_{n>=0}x^n/n!=e^x.
```

元の問題は初期容量`1`なので

```text
E[tau]=V(1)=e.
```

この証明では、停止前prefixの全長をVolterra resolventの一つの級数にまとめている。
