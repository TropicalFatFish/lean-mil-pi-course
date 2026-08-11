# Pi 形式化教学工作流设计

## 目标

把课程中的 pi 示例拆成学生可以依次完成的四个阶段：写出命题、检索定理、生成并审核自然语言证明、生成并由 Lean 检查形式化证明。每一步保留独立文件，使课堂可以逐步打开结果，也便于 ReasLab 单独加载。

## 方案选择

采用“短例子完整走流程，pi 无理性作为综合项目”的结构。主例子是

```lean
Real.arctan 1 = Real.pi / 4
```

它足够短，能在课堂中展示 statement、定理检索、自然语言论证和 Lean 证明之间的对应。完整的 `Irrational Real.pi` 证明仍由 `PiNoIntegral/` 的三个模块实现；工作流文件说明其自然语言路线、检索到的关键构件和最终入口，但不复制数百行代码。

没有采用以下两个方案：

1. 把完整无理性证明复制进第四步。这样会造成大量重复，并掩盖 ReasLab 模型读取已有证明后再重组的事实。
2. 把所有阶段放进一个文件。这样无法清楚展示每一步的输入和输出，也不利于 ReasLab 分阶段教学。

## 文件结构

```text
Course/PiWorkflow/
├── README.md
├── 01_Statement.lean
├── 02_TheoremSearch.lean
├── 03_NaturalLanguageProof.md
└── 04_AIGeneratedProof.lean
```

- `01_Statement.lean`：只把自然语言命题翻译成 Lean 中的 `Prop`，使用 `#check` 保持文件可编译，不提前给证明。
- `02_TheoremSearch.lean`：记录在 ReasLab/Mathlib 中应检索的概念、可直接运行的 `#check`、以及找到的定理类型。
- `03_NaturalLanguageProof.md`：保存给 AI 的提示词、AI 证明结果和人工审核要点。
- `04_AIGeneratedProof.lean`：保存 AI 生成并经 Lean 修复、检查通过的短证明；同时给出完整无理性证明的已验证入口和模块索引。
- `README.md`：给出课堂操作顺序，并区分“AI 找证明”和“AI 重组已有证明”。

## 教学流程

学生先在 `01_Statement.lean` 中只关注对象、等号、量词和类型。第二步进入 ReasLab，通过项目搜索、语义搜索和 Lean 的 `#check` 查看候选定理的精确类型。第三步让 AI 给出自然语言证明，并人工检查主值区间等容易漏掉的条件。第四步让 AI 把论证翻译为 Lean tactic；每一次候选证明都由 Lean kernel 接受或拒绝。

完成短例子后，再把同一流程应用到 pi 无理性。此时学生会看到：statement 仍然很短，但检索结果、自然语言证明和形式化实现会迅速增长，因此完整证明需要拆成 `NivenPolynomial`、`MeanValue` 和 `PiIrrational` 三个模块。

## ReasLab 模型测试口径

ReasLab 的 Agent 能生成并编译通过一个 438 行的 `Irrational Real.pi` 文件，但执行记录显示它先读取了仓库已有的三个证明模块，再将其提炼、复制并修复到通过。因此课程中把该结果描述为“能检索、重组并调通已有形式化证明”，不描述为“从 statement 独立发现 pi 无理性证明”。

## 验证

1. 本地运行 `lake env lean` 分别检查两个 `.lean` 阶段文件。
2. 运行 `lake build Course` 和完整 `lake build`。
3. 扫描课程自有文件，确保没有 `sorry`、`admit` 或自定义 `axiom`。
4. 推送 GitHub 后，在 ReasLab 重新同步，逐个打开四步文件，确认轻量文件能正常加载、Infoview 能显示目标变化。
