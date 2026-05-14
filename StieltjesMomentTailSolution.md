# Stieltjes moment tail解

この解では、停止前確率を分布関数のStieltjesモーメントとして読む。

長さ`n`で止まっていない条件は

```text
S_n=X_1+...+X_n<=1
```

である。`S_n`の分布を`F_n`とすると、

```text
P(tau>n)=F_n(1)
```

である。`0<=s<=1`では、`S_n`の密度は単体断面の体積として

```text
f_n(s)=s^{n-1}/(n-1)!
```

になる。したがってStieltjes積分で

```text
F_n(1)=int_{[0,1]} dF_n(s)
      =int_0^1 s^{n-1}/(n-1)! ds
      =1/n!.
```

尾和公式より

```text
E[tau]=sum_{n>=0}P(tau>n)
      =sum_{n>=0}1/n!
      =e.
```

分布関数を直接見ると、停止前確率は`S_n`の1点評価であり、その評価が単体断面密度のStieltjesモーメントに分解される。
