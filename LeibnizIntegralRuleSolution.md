# Leibniz integral rule解

この解では、上限付き積分をLeibniz則で微分して単体体積を得る。

長さ`n`の停止前体積を

```text
G_n(c)=int_{x_i>=0, x_1+...+x_n<=c}1 dx
```

と置く。最後の座標で切れば

```text
G_n(c)=int_0^c G_{n-1}(c-t) dt.
```

Leibnizの積分微分則により

```text
G_n'(c)=G_{n-1}(c)
```

で、`G_n(0)=0`、`G_0(c)=1`である。したがって

```text
G_n(c)=c^n/n!.
```

元の停止前確率は`c=1`の値なので

```text
P(tau>n)=G_n(1)=1/n!.
```

尾和を取って

```text
E[tau]=sum_{n>=0}P(tau>n)=e.
```

上限が動く単体体積をLeibniz則で微分すると、体積の再帰がそのまま階乗を作る。
