import Mathlib

/-!
# MIL 第 2、3 章课堂练习与讲评答案

本文件汇总课件中的例题和教师讲评答案。课堂投影只展示 statement、允许
使用的 tactic 和提交规范；讲评时可打开本文件，逐行移动光标观察 Infoview。

题目主要取自 Mathematics in Lean 第 2、3 章。少量命题只简化了变量名或
数学对象，使初学者能把注意力放在目标形状上。
-/

namespace Course.MILClassroom

/-! ## 查询定理：搜索候选后必须用 `#check` 核对类型 -/

#check add_comm
#check sq_nonneg
#check abs_nonneg
#check lt_trans
#check Real.tan_pi_div_four

-- 课堂上先读专门化到实数的接口，再说明 Mathlib 原定理更加一般。
#check (add_comm : ∀ a b : ℝ, a + b = b + a)
#check (sq_nonneg : ∀ x : ℝ, 0 ≤ x ^ 2)
#check (abs_nonneg : ∀ x : ℝ, 0 ≤ |x|)
#check (lt_trans : ∀ {a b c : ℝ}, a < b → b < c → a < c)
#check (Real.tan_pi_div_four : Real.tan (Real.pi / 4) = 1)

/-! ## 1. `intro` 与 `exact` -/

-- MIL C03S01：子集自反。
example {α : Type*} (s : Set α) : s ⊆ s := by
  intro x hx
  exact hx

-- 课堂练习：把两个蕴涵前提依次放入上下文。
example (P Q : Prop) : P → Q → P := by
  intro hP hQ
  exact hP

/-! ## 2. `apply`：从结论倒推所需前提 -/

-- MIL C03S01：子集传递。
example {α : Type*} (r s t : Set α) :
    r ⊆ s → s ⊆ t → r ⊆ t := by
  intro hrs hst x hx
  apply hst
  apply hrs
  exact hx

-- 课堂练习：同一结构的命题逻辑版本。
example (P Q R : Prop) (hPQ : P → Q) (hQR : Q → R) : P → R := by
  intro hP
  apply hQR
  apply hPQ
  exact hP

/-! ## 3. `constructor`、`use` 与 `rcases` -/

-- MIL C03S04：构造合取。
example (P Q : Prop) (hP : P) (hQ : Q) : P ∧ Q := by
  constructor
  · exact hP
  · exact hQ

-- MIL C03S02：为存在命题提供见证。
example : ∃ x : ℝ, 2 < x ∧ x < 3 := by
  use 5 / 2
  norm_num

-- MIL C03S04：拆开“存在见证 + 两份性质”。
example (x y : ℝ) : (∃ z : ℝ, x < z ∧ z < y) → x < y := by
  rintro ⟨z, hxz, hzy⟩
  exact lt_trans hxz hzy

-- 课堂练习：拆开合取，再按相反顺序重新构造。
example (P Q : Prop) : P ∧ Q → Q ∧ P := by
  rintro ⟨hP, hQ⟩
  constructor
  · exact hQ
  · exact hP

/-! ## 4. `rw` 与 `calc` -/

-- MIL C02S01：一次改写只完成一次可预测的变换。
example (a b c : ℝ) : a * b * c = b * (a * c) := by
  rw [mul_comm a b]
  rw [mul_assoc b a c]

-- MIL C02S01 第一题 Try these。
example (a b c : ℝ) : c * b * a = b * (a * c) := by
  rw [mul_comm c b]
  rw [mul_assoc b c a]
  rw [mul_comm c a]

-- 用 `calc` 保存纸笔证明中的中间表达式。
example (a b c : ℝ) (h₁ : a = b) (h₂ : b = c) : a + 1 = c + 1 := by
  calc
    a + 1 = b + 1 := by rw [h₁]
    _ = c + 1 := by rw [h₂]

/-! ## 5. `rfl`、`simp` 与 `norm_num` -/

example (x : ℝ) : (fun y : ℝ => y) x = x := by
  rfl

example (n : ℕ) : n + 0 = n := by
  simp

example : (2 : ℝ) < 5 / 2 ∧ (5 : ℝ) / 2 < 3 := by
  norm_num

/-! ## 6. `ring` 与 `linarith` -/

-- MIL C02S01：多项式恒等式。
example (a b : ℝ) : (a + b) * (a - b) = a ^ 2 - b ^ 2 := by
  ring

-- 线性不等式只依赖上下文中的线性条件。
example (x y : ℝ) (hxy : x ≤ y) (hy : y ≤ x + 1) :
    0 ≤ y - x ∧ y - x ≤ 1 := by
  constructor <;> linarith

/-! ## 7. 综合练习 -/

-- 先拆输入证据、构造存在见证，再用多项式正规化收尾。
example (n : ℕ) (h : Even n) : Even (n ^ 2) := by
  rcases h with ⟨k, rfl⟩
  use 2 * k ^ 2
  ring

end Course.MILClassroom
