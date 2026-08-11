import PiNoIntegral.NivenPolynomial
import Mathlib.Analysis.Calculus.Deriv.MeanValue
import Mathlib.Analysis.Calculus.Deriv.Polynomial
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import Mathlib.Tactic

/-!
# 从形式多项式到实函数估计

上一模块给出多项式恒等式和端点整数性。本模块把有理系数多项式解释为
实函数，构造导数为 `f(x) * sin x` 的辅助函数，再用拉格朗日中值定理
得到严格正且可以压到 `1` 以下的端点差。整个过程不使用积分。
-/

noncomputable section

open Polynomial Real Set
open scoped Nat

namespace PiNoIntegral

/-- Evaluate a rational-coefficient polynomial as a real polynomial function. -/
def evalRatPoly (p : ℚ[X]) (x : ℝ) : ℝ :=
  p.eval₂ (Rat.castHom ℝ) x

lemma hasDerivAt_evalRatPoly (p : ℚ[X]) (x : ℝ) :
    HasDerivAt (evalRatPoly p) (evalRatPoly p.derivative x) x := by
  have h := (p.map (Rat.castHom ℝ)).hasDerivAt x
  have hfun :
      (fun y : ℝ => eval y (p.map (Rat.castHom ℝ))) = evalRatPoly p := by
    funext y
    simp [evalRatPoly, eval₂_eq_eval_map]
  rw [hfun] at h
  simpa [evalRatPoly, eval₂_eq_eval_map] using h

/-
这个组合的设计目标是让乘积求导产生的两个 `F' * cos` 项相消，最终只
剩下 `f * sin`。这是自然语言证明中最关键的构造。
-/
/-- The auxiliary function whose derivative is the positive, small quantity. -/
def auxiliaryFunction (a b : ℤ) (n : ℕ) (x : ℝ) : ℝ :=
  evalRatPoly (nivenAuxPoly a b n).derivative x * sin x -
    evalRatPoly (nivenAuxPoly a b n) x * cos x

lemma hasDerivAt_auxiliaryFunction (a b : ℤ) (n : ℕ) (x : ℝ) :
    HasDerivAt (auxiliaryFunction a b n)
      (evalRatPoly (nivenPoly a b n) x * sin x) x := by
  have hF := hasDerivAt_evalRatPoly (nivenAuxPoly a b n) x
  have hFd := hasDerivAt_evalRatPoly (nivenAuxPoly a b n).derivative x
  have h :=
    (hFd.mul (Real.hasDerivAt_sin x)).sub
      (hF.mul (Real.hasDerivAt_cos x))
  have heval :
      evalRatPoly (nivenAuxPoly a b n).derivative.derivative x +
          evalRatPoly (nivenAuxPoly a b n) x =
        evalRatPoly (nivenPoly a b n) x := by
    change
      eval₂ (Rat.castHom ℝ) x (nivenAuxPoly a b n).derivative.derivative +
          eval₂ (Rat.castHom ℝ) x (nivenAuxPoly a b n) =
        eval₂ (Rat.castHom ℝ) x (nivenPoly a b n)
    rw [← eval₂_add, nivenAuxPoly_add_secondDerivative]
  have hderiv :
      evalRatPoly (nivenAuxPoly a b n).derivative.derivative x * sin x +
          evalRatPoly (nivenAuxPoly a b n).derivative x * cos x -
        (evalRatPoly (nivenAuxPoly a b n).derivative x * cos x +
          evalRatPoly (nivenAuxPoly a b n) x * -sin x) =
        evalRatPoly (nivenPoly a b n) x * sin x := by
    rw [← heval]
    ring
  unfold auxiliaryFunction
  convert h.congr_deriv hderiv using 1 <;> rfl

lemma auxiliaryFunction_pi_sub_zero (a b : ℤ) (n : ℕ) :
    auxiliaryFunction a b n π - auxiliaryFunction a b n 0 =
      evalRatPoly (nivenAuxPoly a b n) π +
        evalRatPoly (nivenAuxPoly a b n) 0 := by
  simp [auxiliaryFunction, Real.sin_pi, Real.cos_pi]

@[simp]
lemma evalRatPoly_nivenPoly (a b : ℤ) (n : ℕ) (x : ℝ) :
    evalRatPoly (nivenPoly a b n) x =
      ((b : ℝ) * x) ^ n * ((a : ℝ) - (b : ℝ) * x) ^ n / (n ! : ℕ) := by
  have hcomp :
      (Rat.castHom ℝ).comp (Int.castRingHom ℚ) = Int.castRingHom ℝ := by
    ext z
    simp
  unfold evalRatPoly nivenPoly
  rw [eval₂_mul, eval₂_C, eval₂_map, hcomp]
  rw [nivenIntPoly]
  simp only [eval₂_mul, eval₂_pow, eval₂_sub, eval₂_C, eval₂_X,
    map_inv₀, map_natCast]
  rw [div_eq_mul_inv]
  have ha_cast : (Int.castRingHom ℝ) a = (a : ℝ) := by rfl
  have hb_cast : (Int.castRingHom ℝ) b = (b : ℝ) := by rfl
  rw [ha_cast, hb_cast]
  ring

lemma nivenPoly_positive_on_Ioo
    (a b : ℤ) (n : ℕ) (hb : 0 < b)
    (hpi : π = (a : ℝ) / (b : ℝ)) {x : ℝ} (hx : x ∈ Ioo 0 π) :
    0 < evalRatPoly (nivenPoly a b n) x := by
  have hbR : (0 : ℝ) < b := by exact_mod_cast hb
  have hright : 0 < (a : ℝ) - (b : ℝ) * x := by
    rw [show (a : ℝ) - (b : ℝ) * x = (b : ℝ) * (π - x) by
      rw [hpi]
      field_simp]
    exact mul_pos hbR (sub_pos.mpr hx.2)
  rw [evalRatPoly_nivenPoly]
  exact div_pos
    (mul_pos (pow_pos (mul_pos hbR hx.1) n) (pow_pos hright n))
    (by positivity)

/- 完全平方估计给出 `x(a-bx) ≤ a²/(4b)`，从而统一控制多项式大小。 -/
lemma nivenPoly_le_on_Icc
    (a b : ℤ) (n : ℕ) (hb : 0 < b)
    (hpi : π = (a : ℝ) / (b : ℝ)) {x : ℝ} (hx : x ∈ Icc 0 π) :
    evalRatPoly (nivenPoly a b n) x ≤
      (((a : ℝ) ^ 2 / 4) ^ n) / (n ! : ℕ) := by
  have hbR : (0 : ℝ) < b := by exact_mod_cast hb
  have hleft : 0 ≤ (b : ℝ) * x := mul_nonneg hbR.le hx.1
  have hright : 0 ≤ (a : ℝ) - (b : ℝ) * x := by
    rw [show (a : ℝ) - (b : ℝ) * x = (b : ℝ) * (π - x) by
      rw [hpi]
      field_simp]
    exact mul_nonneg hbR.le (sub_nonneg.mpr hx.2)
  have hbase : 0 ≤ ((b : ℝ) * x) * ((a : ℝ) - (b : ℝ) * x) :=
    mul_nonneg hleft hright
  have hcomplete :
      ((b : ℝ) * x) * ((a : ℝ) - (b : ℝ) * x) ≤ (a : ℝ) ^ 2 / 4 := by
    nlinarith [sq_nonneg ((a : ℝ) - 2 * (b : ℝ) * x)]
  rw [evalRatPoly_nivenPoly, ← mul_pow]
  exact div_le_div_of_nonneg_right (pow_le_pow_left₀ hbase hcomplete n) (by positivity)

lemma auxiliaryFunction_sub_bounds
    (a b : ℤ) (n : ℕ) (hb : 0 < b)
    (hpi : π = (a : ℝ) / (b : ℝ)) :
    0 < auxiliaryFunction a b n π - auxiliaryFunction a b n 0 ∧
      auxiliaryFunction a b n π - auxiliaryFunction a b n 0 ≤
        π * ((((a : ℝ) ^ 2 / 4) ^ n) / (n ! : ℕ)) := by
  let f' : ℝ → ℝ :=
    fun x => evalRatPoly (nivenPoly a b n) x * sin x
  have hcont : ContinuousOn (auxiliaryFunction a b n) (Icc 0 π) := by
    intro x hx
    exact (hasDerivAt_auxiliaryFunction a b n x).continuousAt.continuousWithinAt
  have hderiv : ∀ x ∈ Ioo (0 : ℝ) π,
      HasDerivAt (auxiliaryFunction a b n) (f' x) x := by
    intro x hx
    exact hasDerivAt_auxiliaryFunction a b n x
  -- 中值定理把端点差表示为区间内某点的导数乘以区间长度。
  obtain ⟨c, hc, hcSlope⟩ :=
    exists_hasDerivAt_eq_slope
      (f := auxiliaryFunction a b n) (f' := f') Real.pi_pos hcont hderiv
  have hgap :
      auxiliaryFunction a b n π - auxiliaryFunction a b n 0 =
        π * (evalRatPoly (nivenPoly a b n) c * sin c) := by
    have hslope :
        evalRatPoly (nivenPoly a b n) c * sin c =
          (auxiliaryFunction a b n π - auxiliaryFunction a b n 0) / π := by
      simpa [f'] using hcSlope
    have hmul := (eq_div_iff Real.pi_ne_zero).mp hslope
    calc
      auxiliaryFunction a b n π - auxiliaryFunction a b n 0 =
          (evalRatPoly (nivenPoly a b n) c * sin c) * π := hmul.symm
      _ = π * (evalRatPoly (nivenPoly a b n) c * sin c) := by ring
  have hfpos := nivenPoly_positive_on_Ioo a b n hb hpi hc
  have hspos : 0 < sin c := Real.sin_pos_of_pos_of_lt_pi hc.1 hc.2
  constructor
  · rw [hgap]
    positivity
  · have hfbound :=
      nivenPoly_le_on_Icc a b n hb hpi ⟨hc.1.le, hc.2.le⟩
    have hsin :
        evalRatPoly (nivenPoly a b n) c * sin c ≤
          evalRatPoly (nivenPoly a b n) c := by
      simpa using
        mul_le_mul_of_nonneg_left (Real.sin_le_one c) hfpos.le
    rw [hgap]
    exact mul_le_mul_of_nonneg_left (hsin.trans hfbound) Real.pi_pos.le

end PiNoIntegral
