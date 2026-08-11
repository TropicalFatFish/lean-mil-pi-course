import Mathlib

/-!
# 第一步：只写 statement

这一阶段不证明任何结论，只把自然语言翻译成 Lean 能理解的命题。
`#check` 会要求 Lean 检查表达式的类型，但不会要求我们提供证明。
-/

namespace Course.PiWorkflow

-- 自然语言：1 的反正切等于 pi/4。
#check (Real.arctan 1 = Real.pi / 4 : Prop)

-- 自然语言：pi 是无理数。
#check (Irrational Real.pi : Prop)

/-!
逐项阅读第一个 statement：

* `1` 根据 `Real.arctan` 的输入类型被解释为实数；
* `Real.pi / 4` 中的 `4` 也因此被解释为实数；
* 等号两边都是实数，所以整个等式是一个 `Prop`；
* 现在我们只有待证明的命题，还没有这个命题的证明。

学生可以先仿照下面的外形写自己的命题。证明部分暂时不要交给 AI：

```lean
theorem my_statement : Real.arctan 1 = Real.pi / 4 := by
  -- 下一阶段再寻找证明需要的定理。
```

完整无理性项目的 statement 同样很短：

```lean
theorem pi_is_irrational : Irrational Real.pi := by
  -- 真正的形式化证明会比 statement 长得多。
```
-/

end Course.PiWorkflow
