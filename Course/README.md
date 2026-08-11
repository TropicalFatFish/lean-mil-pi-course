# 课程文件阅读顺序

1. `LeanBasics.lean`：从函数类型、命题类型到常用 tactic。
2. `StatementExercises.lean`：十道只写命题、不写证明的练习。
3. `PiExamples.lean`：`arctan 1 = pi/4` 与 Machin 公式。
4. `../PiNoIntegral/PiIrrational.lean`：完整的 pi 无理性主定理。

在编辑器或 ReasLab 中把光标依次放到每条 tactic 后面，观察 Infoview 中
目标如何变化。先读 statement，再读当前假设，最后判断 tactic 需要交付
哪种类型的证据。

`MIL/C02_Basics/` 和 `MIL/C03_Logic/` 中非 `solutions/` 文件是官方练习版，
其中的 `sorry` 是有意留下的课堂填空；完整参考答案在相邻的 `solutions/`
目录中。`Course/` 与 `PiNoIntegral/` 的课程自有证明不含证明占位符。
