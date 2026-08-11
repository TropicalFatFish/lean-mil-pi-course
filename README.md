# Lean、MIL 与 pi 形式化课程

[![Lean build](https://github.com/TropicalFatFish/lean-mil-pi-course/actions/workflows/lean.yml/badge.svg)](https://github.com/TropicalFatFish/lean-mil-pi-course/actions/workflows/lean.yml)

这个仓库把三组课堂材料放进同一个可编译的 Lean 4 项目：

- Mathematics in Lean（MIL）第 2、3 章；
- 带中文注释的 Lean 入门示例与 statement 练习；
- 从 statement、定理检索到 AI 证明的 `pi` 四步工作流，以及一份不使用积分的
  `pi` 无理性完整证明。

项目固定使用 Lean 4.31.0 与 Mathlib 4.31.0，适合从 GitHub 克隆，
也适合直接导入 ReasLab。

## 从哪里开始

建议按下面的顺序阅读：

1. `Course/LeanBasics.lean`：从函数、类型和命题开始，认识常用 tactic。
2. `MIL/C02_Basics/`：计算、改写、调用定理和代数结构。
3. `MIL/C03_Logic/`：蕴含、量词、否定、合取、析取和收敛。
4. `Course/StatementExercises.lean`：把十个自然语言命题翻译成 Lean statement。
5. `Course/PiWorkflow/`：依次完成 statement、定理检索、自然语言证明和 Lean 证明。
6. `Course/PiExamples.lean`：把 Machin 公式作为补充例子。
7. `docs/pi-irrational-proof-zh.md`：先读自然语言证明，再进入 `PiNoIntegral/`。

在编辑器中，把光标依次放在每条 tactic 后面，观察目标和局部假设怎样变化。
遇到不熟悉的名字时，可先用 `#check 定理名` 确认它的类型。

## 练习文件为什么含有 `sorry`

MIL 的非 `solutions/` 文件是官方练习版，其中的 `sorry` 是刻意留给学生完成的
教学空格；同一章的 `solutions/` 目录给出了完整答案。因此 `lake build` 可能报告
这些练习占位符，但仍会成功完成编译。

课程自有示例和 `PiNoIntegral/` 的主证明没有 `sorry`、`admit` 或自定义公理。
其中主定理为：

```lean
PiNoIntegral.pi_irrational_no_integral : Irrational Real.pi
```

这份证明不调用 Mathlib 中现成的 `irrational_pi`，也不使用积分 API。

## 本地构建

安装 [elan](https://github.com/leanprover/elan) 后，在仓库根目录运行：

```bash
lake build
lake exe pi_no_integral
```

第二条命令会打印主定理的类型。编译阶段的 `#print axioms` 显示该证明只依赖
Mathlib 常规使用的 `propext`、`Classical.choice` 和 `Quot.sound`。

也可以只编译某一组课程材料：

```bash
lake build MIL
lake build Course
lake build PiNoIntegral
```

## 从 ReasLab 导入

1. 在 ReasLab 中选择从 GitHub 创建或导入项目。
2. 填入 `https://github.com/TropicalFatFish/lean-mil-pi-course`。
3. 等待依赖初始化完成，然后打开 `Course/LeanBasics.lean`。
4. 依次打开 `Course/PiWorkflow/` 中的四个阶段文件；不要先打开较重的 `Main.lean`。
5. 光标移到证明内部，确认 Infoview 能够显示 Lean 的当前 proof state。

仓库根目录已经包含 `lean-toolchain`、`lakefile.toml` 和
`lake-manifest.json`，无需在 ReasLab 中另建 Lake 项目。

## 目录结构

```text
Course/             中文注释的 Lean 入门、statement 练习和 pi 四步工作流
MIL/C02_Basics/     Mathematics in Lean 第 2 章（含 solutions）
MIL/C03_Logic/      Mathematics in Lean 第 3 章（含 solutions）
PiNoIntegral/       pi 无理性证明的三个模块
docs/               中文证明导读与项目设计记录
Main.lean           主定理与公理依赖的最小编译审计
```

## 来源与许可证

MIL 文件来自 Lean 社区的
[Mathematics in Lean](https://github.com/leanprover-community/mathematics_in_lean)，
固定于提交 `dd6d752fedb14082f557913c2dccb2d4851e5173`。详细归属见
`THIRD_PARTY_NOTICES.md`。整个仓库按 Apache-2.0 许可证发布。
