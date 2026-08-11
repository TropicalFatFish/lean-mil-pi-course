# Lean、MIL 与 pi 课程仓库设计

## 目标

建立一个可以由 GitHub 和 ReasLab 直接导入的公开 Lean 课程仓库。学生应能在同一个项目中学习 Mathematics in Lean 第 2、3 章，运行课堂基础示例，并阅读及编译 pi 相关结论和无积分的 pi 无理性证明。

## 仓库结构

- `MIL/C02_Basics/`、`MIL/C03_Logic/`：取自 Lean 社区官方 Mathematics in Lean，并保留原有练习、答案和 Apache-2.0 归属说明。
- `Course/`：本课程的基础示例、statement 练习、反正切与 Machin 公式示例，以及带中文说明的学习入口。
- `PiNoIntegral/`：无积分的 pi 无理性完整形式化证明，按多项式、导数与中值定理、主定理三个模块组织。
- `docs/`：中文学习顺序、自然语言证明导读、来源及许可证说明。
- 根目录只保留一套 `lakefile.toml`、`lean-toolchain` 和 `lake-manifest.json`，统一使用 Lean 4.31.0 / Mathlib 4.31.0。

## 构建与导入

根库声明 `MIL`、`Course` 和 `PiNoIntegral` 三个 Lean library，并以 `Main.lean` 作为最小验收入口。`lake build` 必须编译所有公开模块；`lake exe pi_no_integral` 输出主定理类型及公理依赖。ReasLab 从 GitHub 根目录导入后，应能识别 `lean-toolchain` 和 Lake 配置并打开这些模块。

## 注释与归属

不大幅改写上游 MIL 教材，以免难以追踪来源；在课程入口和 pi 模块中增加面向初学者的中文注释，解释 statement、tactic、模块依赖和证明结构。仓库采用 Apache-2.0，并在 `THIRD_PARTY_NOTICES.md` 记录 MIL 的来源版本和上游许可证。

## 课件断行

对最终 Beamer PDF 做逐页文字行宽审计。凡同一自然句出现“第一行接近可用宽度、第二行只有很短尾句”的情况，优先在局部缩小字号使其成为一行；无法在保证可读性的前提下放成一行时，改写或平衡两行长度。修改后重新编译、渲染 64 页并检查日志和页面。

## 验收标准

1. `lake build` 与 `lake exe pi_no_integral` 成功。
2. 不含 `sorry`、`admit` 或自定义 `axiom`，无积分实现，也不调用 Mathlib 现成的 `irrational_pi`。
3. GitHub 仓库公开可访问，许可证和第三方来源明确。
4. ReasLab 能从公开 GitHub URL 创建或导入项目，并显示正常的 Lean 项目结构。
5. 正式 PDF 仍为 64 页，无 overfull、underfull、缺字、未定义命令或不协调短尾行。
