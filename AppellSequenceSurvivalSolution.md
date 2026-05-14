# Appell sequence survival解

この解では、生存確率多項式列がAppell列になることだけを見る。

独立一様乱数`U_1,U_2,...`について

```text
S_n = U_1 + ... + U_n,
tau = min { n >= 1 : S_n > 1 }
```

とする。`0<=x<=1`で

```text
p_n(x)=P(S_n<=x)
```

と置く。畳み込みの一段分解から

```text
p_0(x)=1,
p_n'(x)=p_{n-1}(x),
p_n(0)=0  (n>=1).
```

つまり`n! p_n(x)`は

```text
q_n'(x)=n q_{n-1}(x),  q_n(0)=0
```

を満たすAppell列で、初期値から

```text
q_n(x)=x^n.
```

したがって

```text
p_n(x)=x^n/n!.
```

尾和公式より

```text
E[tau]=sum_{n>=0} p_n(1)
      =sum_{n>=0} 1/n!
      =e.
```

Appell列として読むと、独立一様性は「微分で一段低い生存多項式へ落ちる」性質に集約される。
