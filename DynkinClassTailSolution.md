# Dynkin class tail解

この解では、尾和公式をDynkin classで安定な事象族として整理する。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。事象

```text
{tau>n}={S_n<=1}
```

は、最初の`n`個の座標だけで決まるcylinder事象である。これらのcylinderは有限交差で安定なπ-systemを作り、そこから生成されるDynkin class上で一様積測度が一意に決まる。

したがって各尾確率は有限次元の体積で計算してよい。

```text
P(tau>n)=P(S_n<=1)
        =vol{u_i>=0, u_1+...+u_n<=1}
        =1/n!.
```

整数値変数の尾和より

```text
E[tau]=sum_{n>=0} P(tau>n)
      =sum_{n>=0} 1/n!
      =e.
```

Dynkin classの役割は、無限列上の停止時刻の話を有限次元cylinderの体積計算へ正当に戻す点にある。
