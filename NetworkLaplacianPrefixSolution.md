# network Laplacian prefix解

この解では、残り容量を連続ネットワークの節点と見て、prefix総量をLaplacian型の収支で決める。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。残り容量`r`から始めたときの空prefixを含む生存prefix総量を`V(r)`と置く。節点`r`には単位の自己報酬があり、`0<=u<=r`の一口で節点`r-u`へ流れる。連続ネットワークの収支は

```text
V(r)=1+int_0^r V(r-u) du.
```

これはLaplacianを反転したPoisson方程式の退化形と見られる。変数を替えると

```text
V(r)=1+int_0^r V(v) dv.
```

したがって

```text
V'(r)=V(r),  V(0)=1,
```

なので

```text
V(r)=e^r.
```

初期残り容量は`1`だから

```text
E[tau]=V(1)=e.
```

この証明では、ネットワークのGreen関数を明示的に展開しない。Laplacian型の節点収支が一次方程式に潰れることだけを見る。
