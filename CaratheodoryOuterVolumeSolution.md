# Caratheodory outer volume解

この解では、停止前領域を外測度から可測集合として確定させて測る。

長さ`n`の停止前集合を

```text
D_n={x_i>=0, x_1+...+x_n<=1}
```

と置く。これは半空間と座標半空間の有限交差なのでBorel集合であり、Caratheodory可測である。したがって確率はLebesgue外測度の値と一致する。

```text
P(tau>n)=lambda^*(D_n)=lambda(D_n).
```

`D_n`は標準`n`単体で、体積は

```text
lambda(D_n)=1/n!
```

である。よって尾和公式から

```text
E[tau]=sum_{n>=0}P(tau>n)
      =sum_{n>=0}1/n!
      =e.
```

可測性を外測度の段階から確認しても、計算の芯は停止前単体の体積に尽きる。
