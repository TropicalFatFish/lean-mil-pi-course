# pi 无理性的无积分证明：中文导读

对应主定理：

```lean
PiNoIntegral.pi_irrational_no_integral : Irrational Real.pi
```

项目固定为 Lean 4.31.0 / Mathlib 4.31.0。证明不使用积分，也不调用
Mathlib 已有的 `irrational_pi`。

## 一、反证目标

反设

\[
  \pi=\frac ab,
\]

其中 `a` 是整数，`b` 是正整数。我们将为充分大的自然数 `n` 构造一个
整数 `N`，同时证明

\[
  0<N<1,
\]

从而得到矛盾。

## 二、Niven 多项式

定义

\[
  f(x)=\frac{b^n}{n!}x^n(a-bx)^n.
\]

两个 `n` 次因子让低阶导数在两个端点消失；`n!` 分母会被高阶求导
产生的阶乘消去。因此 `f` 的所有阶导数在 `0` 和 `a/b` 处都是整数。

对称性

\[
  f(a/b-x)=f(x)
\]

把 `0` 处的整数性传递到另一个端点。Lean 中这一部分在
`PiNoIntegral/NivenPolynomial.lean` 的多项式层完成，避免过早处理实函数
可微性。

## 三、有限交错导数和

因为 `f` 的次数是 `2n`，定义有限和

\[
  F=f-f''+f^{(4)}-\cdots+(-1)^n f^{(2n)}.
\]

相邻项在两次求导后抵消，所以

\[
  F''+F=f.
\]

`F(0)`、`F'(0)`、`F(pi)` 和 `F'(pi)` 都是整数。

## 四、辅助函数与中值定理

构造

\[
  G(x)=F'(x)\sin x-F(x)\cos x.
\]

利用乘积求导和 `F''+F=f`，中间的 `F' cos x` 项相消，得到

\[
  G'(x)=f(x)\sin x.
\]

三角函数端点值给出

\[
  N:=G(\pi)-G(0)=F(\pi)+F(0)\in\mathbb Z.
\]

当 `0<x<pi` 时，`f(x)>0` 且 `sin x>0`，所以中值定理推出 `N>0`。
完全平方估计给出

\[
  x(a-bx)\leq\frac{a^2}{4b},
  \qquad
  f(x)\leq\frac{(a^2/4)^n}{n!}.
\]

于是

\[
  0<N\leq
  \pi\frac{(a^2/4)^n}{n!}<1
\]

对充分大的 `n` 成立。

## 五、Lean 模块

| 文件 | 形式化内容 |
|---|---|
| `PiNoIntegral/NivenPolynomial.lean` | 多项式、次数界、反射对称、端点整数性、交错导数和 |
| `PiNoIntegral/MeanValue.lean` | 实函数解释、导数恒等式、正性、配方上界和中值定理 |
| `PiNoIntegral/PiIrrational.lean` | 有理数反设、选择充分大的 `n`、整数 `N` 与最终矛盾 |
| `Main.lean` | 主定理类型和公理依赖的最小审计入口 |

主定理最后得到某个整数 `z` 满足 `0 < z < 1`。`norm_cast` 把实数不等式
搬回整数，`omega` 排除这样的整数。

## 六、验证

在项目根目录运行：

```bash
lake build
lake exe pi_no_integral
```

期望看到：

```text
PiNoIntegral.pi_irrational_no_integral : Irrational Real.pi
'PiNoIntegral.pi_irrational_no_integral' depends on axioms:
[propext, Classical.choice, Quot.sound]
Lean MIL pi course project compiled successfully.
```

这里的三项是 Mathlib 常见的基础逻辑依赖，不是未完成证明。项目审计还应
确认没有 `sorry`、`admit`、自定义 `axiom`、积分 API 或对现成
`irrational_pi` 的调用。
