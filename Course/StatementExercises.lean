import Mathlib

/-!
# 第二次课练习：只写 statement

下面十题只把自然语言命题翻译成 Lean。`def taskN : Prop := ...` 定义了
一个命题，并没有声称已经证明它，因此不需要也不应加入 `sorry`。
-/

namespace Course.StatementExercises

-- 1. 二加三等于五。
def task1 : Prop := (2 : ℕ) + 3 = 5

-- 2. 任意自然数加零仍等于它自己。
def task2 : Prop := ∀ n : ℕ, n + 0 = n

-- 3. 任意两个整数相加可以交换顺序。
def task3 : Prop := ∀ a b : ℤ, a + b = b + a

-- 4. 任意实数的平方都非负。
def task4 : Prop := ∀ x : ℝ, 0 ≤ x ^ 2

-- 5. 偶数的平方仍为偶数。
def task5 : Prop := ∀ n : ℕ, Even n → Even (n ^ 2)

-- 6. 对每个自然数，都存在一个更大的自然数。
def task6 : Prop := ∀ n : ℕ, ∃ m : ℕ, m > n

-- 7. 不存在比所有自然数都大的自然数。
def task7 : Prop := ¬ ∃ m : ℕ, ∀ n : ℕ, m > n

-- 8. 如果 P 和 Q 都成立，那么 Q 和 P 也都成立。
def task8 : Prop := ∀ P Q : Prop, P ∧ Q → Q ∧ P

-- 9. 存在一个严格位于 2 与 3 之间的实数。
def task9 : Prop := ∃ x : ℝ, 2 < x ∧ x < 3

-- 10. arctan(1) 等于 pi/4。
def task10 : Prop := Real.arctan 1 = Real.pi / 4

#check task1
#check task5
#check task10

end Course.StatementExercises
