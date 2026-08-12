# 课程文件阅读顺序

1. `LeanBasics.lean`：从函数类型、命题类型到最小 Lean 示例。
2. `StatementExercises.lean`：先查询定义，再调用 AI 完成十道 statement 空白题。
3. `MILClassroomExercises.lean`：查询定理，并按 MIL 第 2、3 章练典型 tactic。
4. `PiWorkflow/Step1_TheoremSearch.lean`：先查询 pi 例子需要的定义、对象和定理。
5. `PiWorkflow/Step2_Statement.lean`：使用已经核对的名字写 pi 相关 statement。
6. `PiWorkflow/Step3_NaturalLanguageProof.md`：让 AI 给出自然语言证明并人工审核。
7. `PiWorkflow/Step4_AIGeneratedProof.lean`：让 AI 生成 Lean，再由 kernel 检查。
8. `../PiNoIntegral/PiIrrational.lean`：进入完整的 pi 无理性综合项目。

四步流程的具体课堂操作见 `PiWorkflow/README.md`。`PiExamples.lean` 中的
Machin 公式作为补充例子保留，不属于这条主线。

在编辑器或 ReasLab 中把光标依次放到每条 tactic 后面，观察 Infoview 中
目标如何变化。先查询定义与定理，再写 statement，然后审核自然语言证明，最后
判断每条 tactic 是否交付了 Lean 当前要求的证据。

`MIL/C02_Basics/` 和 `MIL/C03_Logic/` 中非 `solutions/` 文件是官方练习版，
其中的 `sorry` 是有意留下的课堂填空；完整参考答案在相邻的 `solutions/`
目录中。`Course/` 与 `PiNoIntegral/` 的课程自有证明不含证明占位符。
