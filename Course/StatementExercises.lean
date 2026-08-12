import Mathlib

/-!
# 第二次课学生工作页：只写 statement

本文件已经导入 Mathlib，并按对象类型打开了三个 section。先在 ReasLab 中
查询定义或对象的名字，用 `#check` 核对类型，再取消对应题目的注释并填写
`def taskN : Prop := ...`。

只定义命题，不写证明，也不要使用 `sorry`。初始空白页本身可以编译；填写后
每次只取消一道题的注释，依据 Infoview 修正语法和类型。
-/

namespace Course.StatementExercises

/-! ## 查询后记录下来的名字 -/

#check (Even : ℕ → Prop)
#check (Irrational : ℝ → Prop)
#check Real.arctan
#check Real.pi

section NaturalNumberStatements

-- 1. 二加三等于五。
-- def task1 : Prop :=

-- 2. 任意自然数加零仍等于它自己。
-- def task2 : Prop :=

-- 5. 偶数的平方仍为偶数。
-- def task5 : Prop :=

-- 6. 对每个自然数，都存在一个更大的自然数。
-- def task6 : Prop :=

-- 7. 不存在比所有自然数都大的自然数。
-- def task7 : Prop :=

end NaturalNumberStatements

section IntegerAndLogicStatements

-- 3. 任意两个整数相加可以交换顺序。
-- def task3 : Prop :=

-- 8. 如果 P 和 Q 都成立，那么 Q 和 P 也都成立。
-- def task8 : Prop :=

end IntegerAndLogicStatements

section RealNumberStatements

open Real

-- 4. 任意实数的平方都非负。
-- def task4 : Prop :=

-- 9. 存在一个严格位于 2 与 3 之间的实数。
-- def task9 : Prop :=

-- 10. arctan(1) 等于 pi/4。
-- def task10 : Prop :=

end RealNumberStatements

end Course.StatementExercises
