# Chen iterated integral signature解

この解では、停止前prefixの測度を、直線路のsignatureの各次数成分として読む。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。尾和公式により

```text
E[tau] = sum_{n>=0} P(S_n<=1)
```

である。ここで

```text
P(S_n<=1)
 = int_{u_i>=0, u_1+...+u_n<=1} du_1...du_n
```

を、変数

```text
t_k = u_1+...+u_k
```

へ写す。ヤコビアンは`1`で、領域は

```text
0 <= t_1 <= ... <= t_n <= 1
```

になる。この積分は、直線路`x(t)=t`のChen反復積分

```text
int_{0<=t_1<=...<=t_n<=1} dx(t_1)...dx(t_n)
```

そのものであり、値はsignatureの次数`n`成分`1/n!`である。

したがって停止前prefix全体の期待数は、直線路の全signature成分のスカラー和で

```text
E[tau] = sum_{n>=0} 1/n! = exp(1) = e.
```

この見方では、単体体積を個別に計算するのではなく、単調な時刻変換で停止前履歴を直線路のsignatureへ送り、`e`をsignatureの群-like指数として読む。
