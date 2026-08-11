# Progressive Pi Workflow Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a four-file classroom workflow that moves from a pi-related Lean statement to theorem search, a reviewed natural-language proof, and a kernel-checked AI-generated Lean proof.

**Architecture:** Keep the classroom-sized `arctan 1 = pi / 4` example entirely inside `Course/PiWorkflow/`. Treat the full irrationality proof as a capstone: expose its short statement and verified entry point in the workflow, while retaining the implementation in the existing `PiNoIntegral/` modules.

**Tech Stack:** Lean 4.31.0, Mathlib 4.31.0, Lake, Markdown, ReasLab.

---

### Task 1: Add the statement-only stage

**Files:**
- Create: `Course/PiWorkflow/Step1_Statement.lean`

**Step 1: Write proposition checks that contain no proof**

Add `#check` commands for:

```lean
(Real.arctan 1 = Real.pi / 4 : Prop)
(Irrational Real.pi : Prop)
```

Explain how `1`, `/`, equality, and `Irrational` are elaborated, and include a commented theorem skeleton students can copy into the next stage.

**Step 2: Compile the file**

Run: `lake env lean Course/PiWorkflow/Step1_Statement.lean`

Expected: exit code 0 and two proposition types printed.

### Task 2: Add the theorem-search stage

**Files:**
- Create: `Course/PiWorkflow/Step2_TheoremSearch.lean`

**Step 1: Record the search workflow**

Document three ReasLab routes: Project Search for exact names, Semantic Search for mathematical descriptions, and `#check` for exact theorem types.

**Step 2: Add executable theorem checks**

Check:

```lean
#check Real.arctan_eq_of_tan_eq
#check Real.tan_pi_div_four
#check Real.pi_pos
#check PiNoIntegral.pi_irrational_no_integral
```

Import the minimal modules needed for these names. Explain what subgoal each theorem discharges and why finding the final irrationality theorem is reuse rather than rediscovery.

**Step 3: Compile the file**

Run: `lake env lean Course/PiWorkflow/Step2_TheoremSearch.lean`

Expected: exit code 0 and all four theorem signatures printed.

### Task 3: Add the natural-language proof stage

**Files:**
- Create: `Course/PiWorkflow/Step3_NaturalLanguageProof.md`

**Step 1: Save a reusable AI prompt**

Ask the model to prove `arctan(1) = pi/4`, explicitly requiring it to state the inverse-function interval condition and to separate cited facts from deductions.

**Step 2: Save and audit the answer**

Give a concise proof through `tan(pi/4) = 1` and `-pi/2 < pi/4 < pi/2`. Add a human checklist identifying the branch-condition omission as the main plausible error.

**Step 3: Connect to the capstone**

Summarize the Niven route for `Irrational pi`, link each mathematical stage to the corresponding `PiNoIntegral/` module, and record the limited interpretation of the ReasLab 438-line model result.

### Task 4: Add the AI-generated Lean proof stage

**Files:**
- Create: `Course/PiWorkflow/Step4_AIGeneratedProof.lean`

**Step 1: Add the raw prompt as a comment**

The prompt must request a Lean 4 proof, require interaction with Lean until there are no errors, and prohibit `sorry` and `admit`.

**Step 2: Add the checked classroom proof**

Implement:

```lean
theorem arctan_one_eq_pi_div_four :
    Real.arctan 1 = Real.pi / 4 := by
  refine Real.arctan_eq_of_tan_eq ?_ ?_
  · exact Real.tan_pi_div_four
  · constructor <;> linarith [Real.pi_pos]
```

Annotate the proof by showing which goal Lean expects after each structural step.

**Step 3: Add the capstone verification entry**

Give a short theorem whose proof is `PiNoIntegral.pi_irrational_no_integral`, explicitly label it as reuse of the repository's verified implementation, and point readers to its three source modules.

**Step 4: Compile the file**

Run: `lake env lean Course/PiWorkflow/Step4_AIGeneratedProof.lean`

Expected: exit code 0.

### Task 5: Integrate the workflow with the course

**Files:**
- Create: `Course/PiWorkflow/README.md`
- Modify: `Course/README.md`
- Modify: `Course.lean`
- Modify: `README.md`

**Step 1: Write the four-stage operating guide**

Explain what students do, what artifact they obtain, and what Lean/ReasLab verifies at every stage. Keep the distinction between natural-language plausibility and kernel acceptance explicit.

**Step 2: Update module imports and reading order**

Import the three Lean stage files from `Course.lean`, and make the workflow the documented route into the pi examples. Preserve `Course/PiExamples.lean` as a backward-compatible supplementary example.

**Step 3: Compile all targets**

Run:

```bash
lake env lean Course/PiWorkflow/Step1_Statement.lean
lake env lean Course/PiWorkflow/Step2_TheoremSearch.lean
lake env lean Course/PiWorkflow/Step4_AIGeneratedProof.lean
lake build Course
lake build
```

Expected: every command exits 0.

**Step 4: Audit proof placeholders**

Run a targeted `rg` scan over `Course/` and `PiNoIntegral/`.

Expected: no `sorry`, `admit`, or custom `axiom` in course-owned proof files; MIL exercise placeholders remain documented exceptions.

**Step 5: Commit**

```bash
git add Course Course.lean README.md docs/plans/2026-08-11-pi-workflow.md
git commit -m "feat: add progressive pi proof workflow"
```

### Task 6: Publish and verify in ReasLab

**Files:**
- No new repository files unless verification discovers a defect.

**Step 1: Push the commits**

Run: `git push origin main`

Expected: GitHub accepts the new commits and CI starts.

**Step 2: Remove the misleading temporary model diff**

Reject the unaccepted `Course/PiAIChallenge.lean` diff after retaining the audit conclusion. This removes only the ReasLab model's temporary duplicate, not a committed repository file.

**Step 3: Sync and open the workflow files**

Refresh the imported GitHub project in ReasLab. Open each stage separately so the heavy full-project `Main.lean` LSP path is not required.

**Step 4: Re-run a bounded model test**

Ask ReasLab Agent to produce the short proof using the statement and theorem-search results, then confirm the resulting file has no error, `sorry`, or `admit`. Report whether it used the intended lemmas and whether Lean accepted it.
