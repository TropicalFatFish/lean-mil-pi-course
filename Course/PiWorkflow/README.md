# pi 示例的四步工作流

这一目录模拟学生在 ReasLab 中完成一次形式化任务的实际顺序。不要一开始就让 AI 输出整份 Lean 证明；每一步都先保存可检查的中间结果。

| 步骤 | 文件 | 学生要做什么 | 本步得到什么 |
|---|---|---|---|
| 1 | `Step1_TheoremSearch.lean` | 用 ReasLab 搜索定义、对象和定理，并用 `#check` 核对 | 可用于 statement 与证明的精确名字和类型 |
| 2 | `Step2_Statement.lean` | 使用已经核对的名字把自然语言写成 Lean 表达式 | 一个类型为 `Prop` 的 statement |
| 3 | `Step3_NaturalLanguageProof.md` | 让 AI 生成论证并人工找遗漏条件 | 经人工审核的证明路线 |
| 4 | `Step4_AIGeneratedProof.lean` | 让 AI 写 Lean，并按 goal 和报错修改 | 由 Lean kernel 接受的证明项 |

## 课堂操作

先打开第一步，在 ReasLab 左侧分别尝试 **Project Search** 和 **Semantic Search**，再把光标放到 `#check` 后面阅读定义、对象和定理的完整类型。第二步只使用已经确认的名字书写 statement，并逐句翻回自然语言核对。

第三步给出了可以直接发送给 ReasLab Agent 的自然语言提示词。得到回答后，学生先完成文件中的三项人工审核，不要因为语言流畅就默认正确。

第四步给出了 Lean 提示词和最终通过检查的结果。让学生把光标依次放在 `refine`、`exact` 和 `constructor` 后面，观察一个等式目标怎样被拆成两个可机械检查的子目标。

## 两个不同难度的任务

完整走完四步的课堂例子是：

```lean
Real.arctan 1 = Real.pi / 4
```

最终综合项目是：

```lean
Irrational Real.pi
```

后者的 statement 仍然只有一行，但证明实现必须拆成 `PiNoIntegral/` 下的三个模块。这正好说明 statement 的长度不能代表证明搜索和形式化实现的难度。

## 怎样理解 ReasLab 模型测试

模型能读取本项目已有的 Niven 证明，重新组织成一个 438 行文件，并在与 Lean 反复交互后编译通过。这证明了“检索、重组、修复和验证”的能力。由于模型在生成前读取了现有三个证明模块，这个实验不支持“模型从 statement 独立发现了 pi 无理性证明”的结论。

课堂上可以把 AI 的角色表述为：AI 大量提出候选步骤，Lean 给出确定的接受、目标或报错；只有最后通过 kernel 的结果才成为形式化证明。
