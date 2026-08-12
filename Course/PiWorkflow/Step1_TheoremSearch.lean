import Mathlib
import PiNoIntegral.PiIrrational

/-!
# 第一步：先查询定义与已有定理

在 ReasLab 中可以按下面的顺序查询：

1. **Project Search**：输入已经知道的名字片段，例如 `tan_pi_div_four`；
2. **Semantic Search**：输入数学含义，例如 “arctan is inverse to tan on its main interval”；
3. **编辑器中的 `#check`**：确认候选定理的精确类型，而不是只凭名字猜用途。

把光标放在每条 `#check` 后面，ReasLab 会在 Infoview 中显示完整类型。
-/

namespace Course.PiWorkflow

-- 写 statement 前先确认这些名字分别表示什么对象。
#check Real.arctan
#check Real.pi
#check (Irrational : ℝ → Prop)

-- 把 arctan 等式化为两个目标：tan 的值，以及角度属于主值区间。
#check Real.arctan_eq_of_tan_eq

-- 提供第一个目标：tan (pi/4) = 1。
#check Real.tan_pi_div_four

-- 提供第二个目标所需的事实：0 < pi。
#check Real.pi_pos

/-!
根据这些类型，可以先写出证明骨架：

```lean
refine Real.arctan_eq_of_tan_eq ?_ ?_
```

此时 Lean 会产生两个明确的 goal。接下来不是猜整份证明，而是分别给每个
goal 寻找一个类型匹配的证明。

对于最终综合项目，项目搜索还能找到下面这个定理：
-/

#check PiNoIntegral.pi_irrational_no_integral

/-!
它的类型正是 `Irrational Real.pi`，但使用它是在**复用本仓库已经完成的证明**，
不是让 AI 从 statement 重新发现 pi 无理性的证明。完整实现分布在：

* `PiNoIntegral/NivenPolynomial.lean`
* `PiNoIntegral/MeanValue.lean`
* `PiNoIntegral/PiIrrational.lean`
-/

end Course.PiWorkflow
