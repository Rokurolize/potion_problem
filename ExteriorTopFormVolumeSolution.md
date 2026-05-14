# 外積top form体積解

この解では、停止前prefixの各段を向き付き単体と見て、top formの積分として体積を読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。空prefixを含めれば

```text
E[tau]=sum_{n>=0} P(S_n <= 1).
```

長さ`n`の生存領域は

```text
Delta_n={u_i>=0, u_1+...+u_n<=1}
```

である。この領域に標準の向き付き体積形式

```text
omega_n = du_1 wedge ... wedge du_n
```

を入れると

```text
P(S_n <= 1)=int_{Delta_n} omega_n.
```

境界変数を`x`にした単体`Delta_n(x)`について、境界を少し動かすと断面は`Delta_{n-1}(x)`である。したがって

```text
d/dx int_{Delta_n(x)} omega_n
  = int_{Delta_{n-1}(x)} omega_{n-1}.
```

初期値は`int_{Delta_0(x)} omega_0=1`なので、帰納的に

```text
int_{Delta_n(x)} omega_n = x^n/n!.
```

よって

```text
E[tau]=sum_{n>=0} int_{Delta_n(1)} omega_n
      =sum_{n>=0} 1/n!
      =e.
```

ここでは単体体積公式を外から引用しない。top formの境界微分が一段低いtop formの積分へ落ちることだけで、階乗が一段ずつ生まれる。
