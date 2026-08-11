import PiNoIntegral.MeanValue
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Topology.Algebra.Order.Floor
import Mathlib.Tactic

/-!
# 主定理：pi 是无理数

反设 `pi = a / b`。对足够大的 `n`，前两个模块构造出一个端点差：
它一方面等于整数，另一方面严格位于 `0` 与 `1` 之间，产生矛盾。
-/

noncomputable section

open Filter Polynomial Real Set
open scoped Nat

namespace PiNoIntegral

/-- A non-irrational real number can be represented by an integer over a positive natural. -/
private lemma not_irrational_exists_rep {x : ℝ} :
    ¬Irrational x → ∃ (a : ℤ) (b : ℕ), 0 < b ∧ x = a / b := by
  rw [Irrational, not_not, mem_range]
  rintro ⟨q, rfl⟩
  exact ⟨q.num, q.den, q.pos, by exact_mod_cast (Rat.num_div_den _).symm⟩

private lemma evalRatPoly_eq_int_of_eval_eq_int
    {p : ℚ[X]} {x : ℚ} {z : ℤ} (h : eval x p = (z : ℚ)) :
    evalRatPoly p (x : ℝ) = (z : ℝ) := by
  change p.eval₂ (Rat.castHom ℝ) ((Rat.castHom ℝ) x) = (z : ℝ)
  rw [eval₂_hom, h]
  rfl

private lemma eventually_small (a : ℤ) :
    ∀ᶠ n : ℕ in atTop,
      π * ((((a : ℝ) ^ 2 / 4) ^ n) / (n ! : ℕ)) < 1 := by
  have hlim :
      Tendsto
        (fun n : ℕ => π * ((((a : ℝ) ^ 2 / 4) ^ n) / (n ! : ℕ)))
        atTop (nhds 0) := by
    simpa using
      (FloorSemiring.tendsto_pow_div_factorial_atTop
        ((a : ℝ) ^ 2 / 4)).const_mul π
  exact hlim.eventually_lt_const zero_lt_one

/--
Pi is irrational.  This proof uses formal polynomial derivatives and the mean value theorem,
not integration and not Mathlib's pre-existing theorem about irrationality of pi.
-/
theorem pi_irrational_no_integral : Irrational π := by
  -- 反设 pi 是有理数，并把它写成整数除以正整数。
  by_contra hrat
  obtain ⟨a, b, hb, hpi⟩ := not_irrational_exists_rep hrat
  let B : ℤ := b
  have hB : 0 < B := by
    dsimp [B]
    exact_mod_cast hb
  have hpiB : π = (a : ℝ) / (B : ℝ) := by
    simpa [B] using hpi
  -- 阶乘最终压过固定底数的指数，因此可以选择使上界小于 1 的 n。
  obtain ⟨n, hn⟩ := (eventually_small a).exists
  -- 端点多项式值分别对应整数 z0 与 zpi。
  obtain ⟨z0, hz0⟩ := eval_nivenAuxPoly_zero_eq_int a B n
  obtain ⟨zpi, hzpi⟩ := eval_nivenAuxPoly_div_eq_int a B n hB.ne'
  have hz0R :
      evalRatPoly (nivenAuxPoly a B n) 0 = (z0 : ℝ) := by
    simpa using evalRatPoly_eq_int_of_eval_eq_int hz0
  have hzpiR :
      evalRatPoly (nivenAuxPoly a B n) π = (zpi : ℝ) := by
    rw [hpiB]
    simpa using evalRatPoly_eq_int_of_eval_eq_int hzpi
  let z : ℤ := zpi + z0
  have hgapInt :
      auxiliaryFunction a B n π - auxiliaryFunction a B n 0 = (z : ℝ) := by
    rw [auxiliaryFunction_pi_sub_zero, hzpiR, hz0R]
    simp [z]
  have hbounds := auxiliaryFunction_sub_bounds a B n hB hpiB
  -- 中值定理的正性与上界把整数 z 严格压进开区间 (0, 1)。
  have hzrange : (0 : ℝ) < (z : ℝ) ∧ (z : ℝ) < 1 := by
    constructor
    · rw [← hgapInt]
      exact hbounds.1
    · rw [← hgapInt]
      exact hbounds.2.trans_lt hn
  -- 搬回整数后，`omega` 关闭“不存在 0 < z < 1 的整数”这一矛盾。
  norm_cast at hzrange
  omega

end PiNoIntegral
