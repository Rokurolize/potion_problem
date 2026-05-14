# Duhamel killed flow解

この解では、残り容量の上を左へ流れる決定論的流れを、境界`0`でkillされる流れとして扱う。

初期容量を`x`とし、容量が正である間に読めるprefixの期待数を`V(x)`とする。空prefixをまず一つ数える。次の一様入力`u`が`u<=x`なら容量は`x-u`へ移り、`u>x`ならkillされるので

```text
V(x)=1+int_0^x V(x-u) du.
```

これはDuhamelの式として読むことができる。すなわち、killされた流れの自由項`1`に、入力で一度戻る作用

```text
(Kf)(x)=int_0^x f(x-u)du
```

を任意回重ねたNeumann級数である。

```text
V = 1 + K1 + K^2 1 + ...
```

ここで`K^n1(x)`は`n`回のDuhamel積分で

```text
K^n1(x)=int_{u_i>=0, u_1+...+u_n<=x} du_1...du_n = x^n/n!.
```

ゆえに

```text
V(x)=sum_{n>=0} x^n/n! = e^x.
```

元の問題は`x=1`なので

```text
E[tau]=V(1)=e.
```

停止を境界kill、続行をDuhamel項と見れば、答えはkillされた流れのポテンシャル級数の値として出る。
