# 流れ箱Jacobian解

この解では、生存単体を境界法線方向と境界面上の座標に分ける流れ箱で読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。期待値は

```text
E[tau]=sum_{n>=0} P(S_n<=1).
```

`n`次の生存領域を

```text
Delta_n={u_i>=0, u_1+...+u_n<=1}
```

と置く。境界量

```text
r=u_1+...+u_n
```

を固定すると、断面は`r Delta_{n-1}`であり、流れ箱のJacobianは`r^{n-1}`になる。したがって

```text
vol(Delta_n)=int_0^1 r^{n-1} vol(Delta_{n-1}) dr
            =vol(Delta_{n-1})/n.
```

`vol(Delta_0)=1`から

```text
P(S_n<=1)=vol(Delta_n)=1/n!.
```

よって

```text
E[tau]=sum_{n>=0}1/n!=e.
```

流れ箱の見方では、斜めの単体を直接積分せず、境界法線方向へ縮む断面のJacobianだけを読む。
