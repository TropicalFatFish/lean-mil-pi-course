import Mathlib.Algebra.Polynomial.SumIteratedDerivative
import Mathlib.Tactic

/-!
# Niven 多项式与端点整数性

本模块只处理代数部分：构造带有 `n!` 分母的多项式，证明它关于
`a / b` 反射对称，并证明各阶导数在两个端点取整数值。最后构造有限的
交错偶数阶导数和 `F`，使 `F'' + F = f`。
-/

noncomputable section

open Finset Polynomial
open scoped Nat

namespace PiNoIntegral

/-- The integer polynomial before the normalizing factor `1 / n!` is applied. -/
def nivenIntPoly (a b : ℤ) (n : ℕ) : ℤ[X] :=
  (C b * X) ^ n * (C a - C b * X) ^ n

/-- The polynomial used in the no-integral proof of irrationality of pi. -/
def nivenPoly (a b : ℤ) (n : ℕ) : ℚ[X] :=
  C (((n ! : ℕ) : ℚ)⁻¹) * (nivenIntPoly a b n).map (Int.castRingHom ℚ)

@[simp]
lemma nivenIntPoly_map (a b : ℤ) (n : ℕ) :
    (nivenIntPoly a b n).map (Int.castRingHom ℚ) =
      (C (b : ℚ) * X) ^ n * (C (a : ℚ) - C (b : ℚ) * X) ^ n := by
  simp [nivenIntPoly]

lemma nivenIntPoly_natDegree_le (a b : ℤ) (n : ℕ) :
    (nivenIntPoly a b n).natDegree ≤ 2 * n := by
  have hbx : (C b * X : ℤ[X]).natDegree ≤ 1 := by
    calc
      (C b * X : ℤ[X]).natDegree ≤ (C b).natDegree + X.natDegree :=
        natDegree_mul_le
      _ ≤ 0 + 1 := Nat.add_le_add (by simp) natDegree_X_le
      _ = 1 := by omega
  have habx : (C a - C b * X : ℤ[X]).natDegree ≤ 1 := by
    calc
      (C a - C b * X : ℤ[X]).natDegree ≤
          max (C a : ℤ[X]).natDegree (C b * X : ℤ[X]).natDegree :=
        natDegree_sub_le _ _
      _ ≤ 1 := max_le (by simp) hbx
  calc
    (nivenIntPoly a b n).natDegree ≤
        ((C b * X : ℤ[X]) ^ n).natDegree +
          ((C a - C b * X : ℤ[X]) ^ n).natDegree := by
      exact natDegree_mul_le
    _ ≤ n * (C b * X : ℤ[X]).natDegree +
          n * (C a - C b * X : ℤ[X]).natDegree :=
      Nat.add_le_add natDegree_pow_le natDegree_pow_le
    _ ≤ n * 1 + n * 1 :=
      Nat.add_le_add (Nat.mul_le_mul_left n hbx) (Nat.mul_le_mul_left n habx)
    _ = 2 * n := by omega

lemma nivenPoly_natDegree_le (a b : ℤ) (n : ℕ) :
    (nivenPoly a b n).natDegree ≤ 2 * n := by
  calc
    (nivenPoly a b n).natDegree ≤
        (C (((n ! : ℕ) : ℚ)⁻¹)).natDegree +
          ((nivenIntPoly a b n).map (Int.castRingHom ℚ)).natDegree := by
      exact natDegree_mul_le
    _ ≤ 0 + (nivenIntPoly a b n).natDegree :=
      Nat.add_le_add (by simp) natDegree_map_le
    _ ≤ 2 * n := by simpa using nivenIntPoly_natDegree_le a b n

@[simp]
lemma eval_nivenPoly (a b : ℤ) (n : ℕ) (x : ℚ) :
    eval x (nivenPoly a b n) =
      ((b : ℚ) * x) ^ n * ((a : ℚ) - (b : ℚ) * x) ^ n / (n ! : ℕ) := by
  simp [nivenPoly, nivenIntPoly, div_eq_mul_inv]
  ring

lemma nivenPoly_reflect (a b : ℤ) (n : ℕ) (hb : b ≠ 0) :
    (nivenPoly a b n).comp (C ((a : ℚ) / (b : ℚ)) - X) = nivenPoly a b n := by
  apply Polynomial.funext
  intro x
  rw [eval_comp, eval_nivenPoly, eval_nivenPoly]
  have hbq : (b : ℚ) ≠ 0 := by exact_mod_cast hb
  simp only [eval_sub, eval_C, eval_X]
  field_simp [hbq]
  ring

/-
在 `x = 0` 处，低于 `n` 阶的导数因为 `x^n` 因子而消失；更高阶导数
产生的阶乘可以消去定义中的 `n!` 分母，因此结果是整数。
-/
lemma eval_iterateDerivative_zero_eq_int (a b : ℤ) (n k : ℕ) :
    ∃ z : ℤ, eval 0 (derivative^[k] (nivenPoly a b n)) = (z : ℚ) := by
  by_cases hk : k < n
  · refine ⟨0, ?_⟩
    have hp :
        (nivenPoly a b n).map (algebraMap ℚ ℚ) =
          (X - C (0 : ℚ)) ^ n *
            (C (((n ! : ℕ) : ℚ)⁻¹) * C (b : ℚ) ^ n *
              (C (a : ℚ) - C (b : ℚ) * X) ^ n) := by
      simp [nivenPoly, nivenIntPoly]
      ring
    have hzero :=
      Polynomial.aeval_iterate_derivative_of_lt
        (nivenPoly a b n) n (0 : ℚ) hp hk
    rw [eval, eval₂_at_zero]
    simpa [aeval_def] using hzero
  · have hnk : n ≤ k := Nat.le_of_not_gt hk
    obtain ⟨gp, -, hgp⟩ :=
      Polynomial.exists_iterate_derivative_eq_factorial_smul
        (nivenIntPoly a b n) k
    obtain ⟨m, hm⟩ := Nat.factorial_dvd_factorial hnk
    refine ⟨(m : ℤ) * eval 0 gp, ?_⟩
    rw [nivenPoly, iterate_derivative_C_mul, iterate_derivative_map, hgp]
    simp [hm]
    field_simp

lemma iterateDerivative_comp_reflection (p : ℚ[X]) (c : ℚ) (k : ℕ) :
    derivative^[k] (p.comp (C c - X)) =
      (-1 : ℚ) ^ k • (derivative^[k] p).comp (C c - X) := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [Function.iterate_succ_apply', ih, derivative_smul, derivative_comp,
        Function.iterate_succ_apply']
      simp
      rw [← neg_smul]
      congr 1
      rw [pow_succ]
      ring

lemma eval_iterateDerivative_reflect (a b : ℤ) (n k : ℕ) (hb : b ≠ 0) :
    eval ((a : ℚ) / (b : ℚ)) (derivative^[k] (nivenPoly a b n)) =
      (-1 : ℚ) ^ k * eval 0 (derivative^[k] (nivenPoly a b n)) := by
  have hpoly :=
    congrArg (fun p : ℚ[X] => derivative^[k] p) (nivenPoly_reflect a b n hb)
  rw [iterateDerivative_comp_reflection] at hpoly
  have heval := congrArg (eval ((a : ℚ) / (b : ℚ))) hpoly
  simpa [eval_comp] using heval.symm

lemma eval_iterateDerivative_div_eq_int (a b : ℤ) (n k : ℕ) (hb : b ≠ 0) :
    ∃ z : ℤ,
      eval ((a : ℚ) / (b : ℚ)) (derivative^[k] (nivenPoly a b n)) = (z : ℚ) := by
  obtain ⟨z, hz⟩ := eval_iterateDerivative_zero_eq_int a b n k
  refine ⟨(-1 : ℤ) ^ k * z, ?_⟩
  rw [eval_iterateDerivative_reflect a b n k hb, hz]
  norm_cast

/-!
## 交错导数和

把 `p - p'' + p⁽⁴⁾ - ...` 写成有限递归，避免在后续实函数证明中直接
管理无限级数。次数界保证最高阶之后的导数为零。
-/

/-- The finite alternating sum `p - p'' + p⁽⁴⁾ - ...`, written recursively. -/
def alternatingDerivatives : ℕ → ℚ[X] → ℚ[X]
  | 0, p => p
  | n + 1, p => p - alternatingDerivatives n (derivative^[2] p)

lemma derivative_alternatingDerivatives (n : ℕ) (p : ℚ[X]) :
    derivative (alternatingDerivatives n p) =
      alternatingDerivatives n (derivative p) := by
  induction n generalizing p with
  | zero => simp [alternatingDerivatives]
  | succ n ih =>
      simp only [alternatingDerivatives, derivative_sub, ih]
      congr 1

lemma alternatingDerivatives_add_secondDerivative
    (n : ℕ) (p : ℚ[X]) (hdeg : p.natDegree ≤ 2 * n) :
    (alternatingDerivatives n p).derivative.derivative +
        alternatingDerivatives n p = p := by
  induction n generalizing p with
  | zero =>
      have hzero : derivative^[2] p = 0 :=
        iterate_derivative_eq_zero (hdeg.trans_lt (by omega))
      simp only [alternatingDerivatives]
      simpa [Function.iterate_succ_apply] using congrArg id hzero
  | succ n ih =>
      have hdeg' : (derivative^[2] p).natDegree ≤ 2 * n := by
        exact (natDegree_iterate_derivative p 2).trans (by omega)
      have hrec := ih (derivative^[2] p) hdeg'
      simp only [alternatingDerivatives, derivative_sub]
      rw [show derivative (derivative p) = derivative^[2] p by
        simp [Function.iterate_succ_apply]]
      linear_combination -hrec

/-- All formal derivatives of `p` take integer values at `x`. -/
def IntegerDerivativesAt (p : ℚ[X]) (x : ℚ) : Prop :=
  ∀ k : ℕ, ∃ z : ℤ, eval x (derivative^[k] p) = (z : ℚ)

lemma IntegerDerivativesAt.alternating (h : IntegerDerivativesAt p x) (n : ℕ) :
    ∃ z : ℤ, eval x (alternatingDerivatives n p) = (z : ℚ) := by
  induction n generalizing p with
  | zero =>
      simpa [alternatingDerivatives] using h 0
  | succ n ih =>
      obtain ⟨z, hz⟩ := h 0
      have htwo : IntegerDerivativesAt (derivative^[2] p) x := by
        intro k
        simpa [Function.iterate_add_apply] using h (k + 2)
      obtain ⟨w, hw⟩ := ih htwo
      refine ⟨z - w, ?_⟩
      have hz' : eval x p = (z : ℚ) := by simpa using hz
      have hw' :
          eval x (alternatingDerivatives n (derivative (derivative p))) = (w : ℚ) := by
        simpa [Function.iterate_succ_apply] using hw
      simp [alternatingDerivatives, hz', hw']

lemma IntegerDerivativesAt.derivative_alternating
    (h : IntegerDerivativesAt p x) (n : ℕ) :
    ∃ z : ℤ, eval x (derivative (alternatingDerivatives n p)) = (z : ℚ) := by
  rw [derivative_alternatingDerivatives]
  apply IntegerDerivativesAt.alternating (n := n)
  intro k
  simpa [IntegerDerivativesAt, Function.iterate_add_apply] using h (k + 1)

def nivenAuxPoly (a b : ℤ) (n : ℕ) : ℚ[X] :=
  alternatingDerivatives n (nivenPoly a b n)

lemma nivenAuxPoly_add_secondDerivative (a b : ℤ) (n : ℕ) :
    (nivenAuxPoly a b n).derivative.derivative + nivenAuxPoly a b n =
      nivenPoly a b n :=
  alternatingDerivatives_add_secondDerivative n _ (nivenPoly_natDegree_le a b n)

lemma integerDerivativesAt_nivenPoly_zero (a b : ℤ) (n : ℕ) :
    IntegerDerivativesAt (nivenPoly a b n) 0 :=
  eval_iterateDerivative_zero_eq_int a b n

lemma integerDerivativesAt_nivenPoly_div
    (a b : ℤ) (n : ℕ) (hb : b ≠ 0) :
    IntegerDerivativesAt (nivenPoly a b n) ((a : ℚ) / (b : ℚ)) :=
  fun k => eval_iterateDerivative_div_eq_int a b n k hb

lemma eval_nivenAuxPoly_zero_eq_int (a b : ℤ) (n : ℕ) :
    ∃ z : ℤ, eval 0 (nivenAuxPoly a b n) = (z : ℚ) :=
  (integerDerivativesAt_nivenPoly_zero a b n).alternating n

lemma eval_derivative_nivenAuxPoly_zero_eq_int (a b : ℤ) (n : ℕ) :
    ∃ z : ℤ, eval 0 (nivenAuxPoly a b n).derivative = (z : ℚ) :=
  (integerDerivativesAt_nivenPoly_zero a b n).derivative_alternating n

lemma eval_nivenAuxPoly_div_eq_int (a b : ℤ) (n : ℕ) (hb : b ≠ 0) :
    ∃ z : ℤ,
      eval ((a : ℚ) / (b : ℚ)) (nivenAuxPoly a b n) = (z : ℚ) :=
  (integerDerivativesAt_nivenPoly_div a b n hb).alternating n

lemma eval_derivative_nivenAuxPoly_div_eq_int
    (a b : ℤ) (n : ℕ) (hb : b ≠ 0) :
    ∃ z : ℤ,
      eval ((a : ℚ) / (b : ℚ)) (nivenAuxPoly a b n).derivative = (z : ℚ) :=
  (integerDerivativesAt_nivenPoly_div a b n hb).derivative_alternating n

end PiNoIntegral
