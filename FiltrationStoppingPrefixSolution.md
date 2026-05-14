# filtration stopping prefix解

この解では、停止時刻が自然なフィルトレーションの停止時刻であることを正面から使う。

`F_n=sigma(X_1,...,X_n)`とする。停止時刻

```text
tau=min{n: X_1+...+X_n>1}
```

に対して、`{tau>n}`は`F_n`可測であり、

```text
{tau>n}={X_1+...+X_n<=1}
```

である。

よって尾確率は有限次元のprefixだけで測れる。

```text
P(tau>n)=lambda_n{x_i>=0, x_1+...+x_n<=1}.
```

右辺は標準`n`単体の体積なので

```text
P(tau>n)=1/n!.
```

したがって

```text
E[tau]=sum_{n>=0}P(tau>n)=sum_{n>=0}1/n!=e.
```

停止時刻性を明示すると、無限列全体ではなく各時刻のprefix単体だけを測ればよいことがはっきりする。
