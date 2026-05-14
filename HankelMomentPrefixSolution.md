# Hankel moment prefix解

この解では、停止前prefixの尾確率列をHausdorff moment列として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。`0<=x<=1`で

```text
m_n(x)=P(S_n<=x)
```

と置く。最後の増分で分ければ

```text
m_0(x)=1,
m_n'(x)=m_{n-1}(x),
m_n(0)=0.
```

よって

```text
m_n(x)=x^n/n!.
```

特に`x=1`では、停止前prefixの尾確率列は

```text
1, 1, 1/2!, 1/3!, ...
```

であり、これは単位区間の順序統計量から来る階乗moment列である。Hankel行列を作る必要はなく、moment列の総質量だけを取ればよい。

```text
E[tau]=sum_{n>=0} m_n(1)
      =sum_{n>=0} 1/n!
      =e.
```

moment列として見ると、停止時刻は分布の一点値ではなく、停止前prefixが作る全momentの総和として現れる。
