# Cartan homotopy volume解

この解では、停止前単体の体積を、放射ベクトル場によるCartan型のホモトピーで一段ずつ落とす。

長さ`n`の停止前領域を

```text
D_n={u_i>=0, u_1+...+u_n<=1}
```

とおく。元の停止時刻

```text
tau=min { n>=1 : U_1+...+U_n>1 }
```

については

```text
E[tau]=sum_{n>=0} vol(D_n)
```

である。

`D_n`上の体積形式を

```text
omega=du_1 wedge ... wedge du_n
```

とし、放射ベクトル場

```text
R=sum_i u_i partial_{u_i}
```

を考える。Cartanの公式では、`omega`が定数形式なので

```text
d(i_R omega)=L_R omega=n omega.
```

従ってStokesにより

```text
n vol(D_n)=int_{boundary D_n} i_R omega.
```

座標面`u_i=0`では`R`が接して流束が消える。寄与するのは斜面`u_1+...+u_n=1`だけで、そこへの射影は`D_{n-1}`と同じ体積を持つ。よって

```text
n vol(D_n)=vol(D_{n-1}).
```

`vol(D_0)=1`から

```text
vol(D_n)=1/n!.
```

したがって

```text
E[tau]=sum_{n>=0} 1/n! = e.
```

この見方では、単体積分を計算する代わりに、放射ホモトピーが境界の斜面だけを残すことからfactorialが出る。
