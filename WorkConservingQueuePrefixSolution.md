# work conserving queue prefix解

この解では、停止前prefixをwork conservingな系が処理できる仕事列として数える。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。容量`1`の仕事処理枠があり、仕事量`U_i`を順に処理する。work conservingなので、処理できるかどうかは累積仕事量だけで決まる。長さ`n`まで処理可能である条件は

```text
U_1+...+U_n<=1.
```

したがって処理可能な長さ`n`の仕事列の測度は

```text
vol{u_i>=0, u_1+...+u_n<=1}=1/n!.
```

停止時刻は、処理枠を超える直前までのprefix数である。空prefixを含めて足すと

```text
E[tau]=sum_{n>=0} 1/n! = e.
```

この見方では、個々の仕事列の順序は固定され、使うのは「累積仕事量が容量内にある」というwork conservingな判定だけである。
