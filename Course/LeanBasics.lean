import Mathlib

/-!
# Lean 基础课堂示例

这个文件假设读者见过 Python 或 C 的函数。普通函数的类型描述输入与
输出；Lean 中命题也是类型，而证明是具有相应类型的程序。
-/

namespace Course

/- `square : ℝ → ℝ` 和普通程序的函数签名类似。 -/
def square (x : ℝ) : ℝ := x ^ 2

#check square

example : square 3 = 9 := by
  norm_num [square]

/- `rfl` 检查两边展开定义后是否相同。 -/
theorem square_definition (x : ℝ) : square x = x ^ 2 := by
  rfl

/-
`P → P` 的证明是一段程序：输入一份 `P` 的证据，再把它原样返回。
-/
theorem id_proof (P : Prop) : P → P :=
  fun h => h

theorem id_proof_tactic (P : Prop) : P → P := by
  intro h
  exact h

#print axioms id_proof

/- 全称命题用 `intro` 引入任意输入，存在命题用 `⟨见证, 证明⟩` 构造。 -/
theorem exists_larger_nat : ∀ n : ℕ, ∃ m : ℕ, m > n := by
  intro n
  exact ⟨n + 1, Nat.lt_succ_self n⟩

theorem no_largest_nat : ¬ ∃ m : ℕ, ∀ n : ℕ, m > n := by
  rintro ⟨m, hm⟩
  exact (Nat.lt_irrefl m) (hm m)

/- Modus ponens is just function application under Curry--Howard. -/
theorem modus_ponens (P Q : Prop) : (P → Q) → P → Q :=
  fun hPQ hP => hPQ hP

#check mul_left_cancel₀

def IsEven (n : ℕ) : Prop := ∃ k : ℕ, n = 2 * k

/-
把偶数见证 `k` 拆出来后，要证明平方仍为偶数，就构造新见证
`2 * k ^ 2`；最后的多项式恒等式交给 `ring`。
-/
theorem square_even {n : ℕ} : IsEven n → IsEven (n ^ 2) := by
  rintro ⟨k, rfl⟩
  refine ⟨2 * k ^ 2, ?_⟩
  ring

/- `#check` 只询问表达式的类型，不会尝试证明新命题。 -/
#check Nat
#check (3 : ℝ)
#check Real.pi
#check Real.sin
#check Real.arctan_eq_of_tan_eq

/- `rfl` 适合定义化简，不适合任意一个数学上为真的等式。 -/
example (x : ℝ) : (fun y : ℝ => y) x = x := by
  rfl

example (a b : ℝ) : a + b = b + a := by
  exact add_comm a b

/- `rw` 使用已知等式改写当前目标。 -/
example (a b : ℝ) (h : a = b) : a + 1 = b + 1 := by
  rw [h]

/- `calc` 把纸笔证明中的等式链完整保留下来。 -/
example (a b c : ℝ) (h₁ : a = b) (h₂ : b = c) : a + 1 = c + 1 := by
  calc
    a + 1 = b + 1 := by rw [h₁]
    _ = c + 1 := by rw [h₂]

/- `ring` 证明交换环中的多项式恒等式。 -/
example (a b : ℝ) :
    (a + b) ^ 2 = a ^ 2 + 2 * a * b + b ^ 2 := by
  ring

/- `linarith` 组合线性等式和不等式。 -/
example (x y : ℝ) (hxy : x ≤ y) (hy : y ≤ x + 1) :
    0 ≤ y - x ∧ y - x ≤ 1 := by
  constructor <;> linarith

/- `intro`、`apply`、`exact` 分别引入前提、倒推所需前提、交付证据。 -/
example (P Q R : Prop) (hPQ : P → Q) (hQR : Q → R) : P → R := by
  intro hP
  apply hQR
  apply hPQ
  exact hP

/- 合取的证明由两份证据组成。 -/
example (P Q : Prop) (hP : P) (hQ : Q) : P ∧ Q := by
  constructor
  · exact hP
  · exact hQ

/- 存在命题的证明包含具体见证和该见证满足性质的证明。 -/
example : ∃ x : ℝ, 2 < x ∧ x < 3 := by
  use 5 / 2
  constructor <;> norm_num

/- `rintro` 可以直接拆开合取证据。 -/
example (P Q : Prop) : P ∧ Q → Q ∧ P := by
  rintro ⟨hP, hQ⟩
  exact ⟨hQ, hP⟩

end Course
