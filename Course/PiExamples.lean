import Mathlib

/-!
# 两个适合课堂阅读的 pi 例子

这些证明刻意保留主要结构：Lean 不仅要知道恒等式成立，还要求我们
明确提供反函数的值域条件以及每一次使用的反正切恒等式。
-/

namespace Course.PiExamples

/-
`arctan` 只在主值区间内与 `tan` 互为反函数，因此证明被拆成两个目标：
`tan (pi / 4) = 1`，以及 `pi / 4` 位于 `(-pi/2, pi/2)`。
-/
theorem arctan_one_eq_pi_div_four :
    Real.arctan 1 = Real.pi / 4 := by
  refine Real.arctan_eq_of_tan_eq ?_ ?_
  · exact Real.tan_pi_div_four
  · constructor <;> linarith [Real.pi_pos]

/- Mathlib 已经提供了完整 Machin 公式，可作为检索定理后的短证明。 -/
theorem machin_formula_short :
    4 * Real.arctan (5 : ℝ)⁻¹ -
      Real.arctan (239 : ℝ)⁻¹ = Real.pi / 4 := by
  simpa using Real.four_mul_arctan_inv_5_sub_arctan_inv_239

/-
这个版本展开主要步骤：先把四倍写成两次二倍，再使用反正切加法公式；
剩余目标都是有理数计算，由 `norm_num` 检查。
-/
theorem machin_formula_structure :
    4 * Real.arctan (5 : ℝ)⁻¹ -
      Real.arctan (239 : ℝ)⁻¹ = Real.pi / 4 := by
  rw [show 4 * Real.arctan _ = 2 * (2 * _) by ring,
    Real.two_mul_arctan, Real.two_mul_arctan, ← Real.arctan_one,
    sub_eq_iff_eq_add, Real.arctan_add] <;>
    norm_num

end Course.PiExamples
