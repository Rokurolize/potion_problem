# microcanonical slice解

この解では、合計値をエネルギーとして固定したmicrocanonical sliceから単体体積を出す。

長さ`n`の停止前領域を

```text
D_n={u_i>=0, u_1+...+u_n<=1}
```

とする。エネルギー

```text
E=u_1+...+u_n
```

を固定したsliceの密度を`g_n(E)`と書く。正の直交象限では、`0<=E<=1`で

```text
g_n(E)=E^{n-1}/(n-1)!  (n>=1)
```

である。これはsliceを一つ下の単体で媒介して得られる。

したがって

```text
vol(D_n)=int_0^1 g_n(E)dE=1/n!.
```

尾和公式から

```text
E[tau]=sum_{n>=0}vol(D_n)=sum_{n>=0}1/n!=e.
```

この見方では、停止条件をエネルギー上限`1`として扱い、microcanonical slice密度を積分して答えを得る。
