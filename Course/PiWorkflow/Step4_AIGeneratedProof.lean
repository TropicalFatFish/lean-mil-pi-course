import Mathlib
import PiNoIntegral.PiIrrational

/-!
# 第四步：让 AI 生成 Lean 证明

在 ReasLab 右侧的 Agent 中输入下面的任务。与自然语言阶段不同，这次必须要求
模型实际编辑文件并让 Lean 检查，不能把“看起来正确”当成完成。

```text
请在当前文件中证明：

theorem arctan_one_eq_pi_div_four :
    Real.arctan 1 = Real.pi / 4 := by
  ...

请先使用项目搜索、语义搜索或 #check 确认可用定理的精确类型。
证明必须处理 arctan 主值区间的条件。请反复读取 Lean 的 goal 和报错并修复，
直到文件无 error；不得使用 sorry、admit 或新增 axiom。最后列出实际使用的定理。
```

下面保存模型候选经过 Lean 检查后的结果。注释记录每一步的目标变化。
-/

namespace Course.PiWorkflow

theorem arctan_one_eq_pi_div_four :
    Real.arctan 1 = Real.pi / 4 := by
  -- 把原目标拆成：tan 的值，以及 pi/4 属于 arctan 的主值区间。
  refine Real.arctan_eq_of_tan_eq ?_ ?_
  · -- goal: tan (pi/4) = 1
    exact Real.tan_pi_div_four
  · -- goal: pi/4 ∈ (-pi/2, pi/2)
    constructor <;> linarith [Real.pi_pos]

/-!
最终综合项目已经在本仓库中完成。下面这行只演示如何复用经过 kernel 检查的
结果；它不是一份由 AI 从 statement 独立发现的新证明。完整证明请依次阅读：

* `PiNoIntegral/NivenPolynomial.lean`
* `PiNoIntegral/MeanValue.lean`
* `PiNoIntegral/PiIrrational.lean`
-/

theorem pi_irrational_from_verified_project : Irrational Real.pi :=
  PiNoIntegral.pi_irrational_no_integral

#print axioms arctan_one_eq_pi_div_four
#print axioms pi_irrational_from_verified_project

end Course.PiWorkflow
