# first passage simplex解

この解では、停止時刻をレベル1へのfirst passage timeとして扱う。

部分和

```text
S_n=X_1+...+X_n
```

を考えると、停止時刻は

```text
tau=min{n: S_n>1}
```

である。したがって

```text
{tau>n}={S_n<=1}
```

であり、長さ`n`までのfirst passageがまだ起きていない領域は

```text
D_n={x_i>=0, x_1+...+x_n<=1}
```

である。

`D_n`は標準`n`単体なので

```text
P(tau>n)=vol(D_n)=1/n!.
```

尾和公式から

```text
E[tau]=sum_{n>=0}P(tau>n)
      =sum_{n>=0}1/n!
      =e.
```

初到達時刻の尾事象をそのまま見ると、各時刻で残っている履歴空間は標準単体になる。
