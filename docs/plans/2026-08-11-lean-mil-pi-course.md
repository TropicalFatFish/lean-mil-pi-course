# Lean MIL Pi Course Repository Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Publish a single reproducible Lean course repository containing MIL chapters 2 and 3, introductory course exercises, and verified pi formalizations, then verify GitHub and ReasLab import.

**Architecture:** Use one Lake project pinned to Lean 4.31.0 and Mathlib 4.31.0. Keep upstream MIL files under their original module names, place course-owned examples under `Course`, and retain the modular no-integral proof under `PiNoIntegral`.

**Tech Stack:** Lean 4.31.0, Mathlib 4.31.0, Lake, Git, GitHub CLI, XeLaTeX/Beamer, ReasLab.

---

### Task 1: Establish the licensed single-project skeleton

**Files:**
- Create: `lean-toolchain`
- Create: `lakefile.toml`
- Create: `.gitignore`
- Create: `LICENSE`
- Create: `THIRD_PARTY_NOTICES.md`
- Create: `MIL.lean`

**Step 1: Record the upstream source**

Resolve the current `leanprover-community/mathematics_in_lean` commit and its Apache-2.0 license.

**Step 2: Copy the required modules**

Copy `MIL/Common.lean`, `MIL/C02_Basics/`, and `MIL/C03_Logic/`, including solutions, from a clean upstream checkout.

**Step 3: Add the root project files**

Pin `leanprover/lean4:v4.31.0` and Mathlib `v4.31.0`, and declare the `MIL`, `Course`, and `PiNoIntegral` libraries plus the `pi_no_integral` executable.

**Step 4: Fetch dependencies**

Run: `lake update`

Expected: `lake-manifest.json` is created with Mathlib `v4.31.0`.

**Step 5: Commit**

```bash
git add lean-toolchain lakefile.toml lake-manifest.json .gitignore LICENSE THIRD_PARTY_NOTICES.md MIL MIL.lean
git commit -m "feat: add MIL chapters 2 and 3"
```

### Task 2: Add commented course entry points

**Files:**
- Create: `Course.lean`
- Create: `Course/LeanBasics.lean`
- Create: `Course/StatementExercises.lean`
- Create: `Course/PiExamples.lean`
- Create: `Course/README.md`

**Step 1: Add the basic examples**

Port the classroom definitions, `#check` examples, and tactic demonstrations with concise Chinese comments explaining inputs, goals, and expected proof-state changes.

**Step 2: Add statement-only exercises**

Keep ten exercises as `def taskN : Prop := ...`, with comments distinguishing stating a theorem from proving it.

**Step 3: Add the short pi examples**

Include compiled proofs of `Real.arctan 1 = Real.pi / 4` and the Machin formula structure used in the slides.

**Step 4: Compile the entry points**

Run: `lake env lean Course/LeanBasics.lean`, `lake env lean Course/StatementExercises.lean`, and `lake env lean Course/PiExamples.lean`.

Expected: all commands exit with status 0.

**Step 5: Commit**

```bash
git add Course Course.lean
git commit -m "feat: add commented course exercises"
```

### Task 3: Integrate the no-integral pi irrationality proof

**Files:**
- Create: `PiNoIntegral.lean`
- Create: `PiNoIntegral/NivenPolynomial.lean`
- Create: `PiNoIntegral/MeanValue.lean`
- Create: `PiNoIntegral/PiIrrational.lean`
- Create: `Main.lean`
- Create: `docs/pi-irrational-proof-zh.md`

**Step 1: Copy the verified proof modules**

Preserve the theorem `PiNoIntegral.pi_irrational_no_integral : Irrational Real.pi` and add orienting Chinese comments at module boundaries and difficult proof stages.

**Step 2: Add the executable audit**

`Main.lean` must `#check` the theorem, `#print axioms` for it, and print a short successful-build message.

**Step 3: Audit prohibited shortcuts**

Run `rg` for `sorry`, `admit`, custom `axiom`, integral APIs, and direct use of Mathlib's `irrational_pi`.

Expected: no prohibited proof shortcut is found.

**Step 4: Build**

Run: `lake build` and `lake exe pi_no_integral`.

Expected: the full project builds and reports only `propext`, `Classical.choice`, and `Quot.sound`.

**Step 5: Commit**

```bash
git add PiNoIntegral PiNoIntegral.lean Main.lean docs/pi-irrational-proof-zh.md
git commit -m "feat: add verified no-integral pi proof"
```

### Task 4: Document and test the repository as a fresh clone

**Files:**
- Create: `README.md`
- Create: `.github/workflows/lean.yml`
- Modify: `Course/README.md`

**Step 1: Write the student workflow**

Document prerequisites, recommended reading order, local build commands, ReasLab import steps, source attribution, and the theorem inventory.

**Step 2: Add CI**

Create a GitHub Actions workflow using `leanprover/lean-action@v1` and `lake build`.

**Step 3: Validate from a clean clone**

Clone the local repository to a temporary directory, run `lake build`, and confirm no untracked source dependency is required.

**Step 4: Commit**

```bash
git add README.md Course/README.md .github/workflows/lean.yml
git commit -m "docs: add course guide and CI"
```

### Task 5: Remove awkward short trailing lines from the Beamer deck

**Files:**
- Modify: `../course/0812/beamer/lean-ai-mil-opening.tex`
- Modify: `../course/0812/beamer/lean-ai-mil-opening-v2.tex`

**Step 1: Use the rendered PDF to identify candidates**

Inspect extracted line geometry and rendered pages. Prioritize sentences whose second line is a short tail, including page 2's isolated `吗？`.

**Step 2: Apply local typography fixes**

Use local `\fontsize{...}\selectfont` or concise rewrites so short tails disappear without globally shrinking the deck.

**Step 3: Recompile and scan the log**

Run `latexmk -xelatex lean-ai-mil-opening.tex`.

Expected: 64 pages and no overfull, underfull, missing-character, undefined-command, or LaTeX-error messages.

**Step 4: Render and inspect all pages**

Render the final PDF to PNG, inspect contact sheets and all changed pages at full size, then keep official and v2 sources synchronized.

### Task 6: Publish the GitHub repository

**Files:**
- Modify: Git remote metadata only.

**Step 1: Confirm the target does not already exist**

Run: `gh repo view TropicalFatFish/lean-mil-pi-course`.

Expected: repository not found before creation.

**Step 2: Create and push**

Run: `gh repo create TropicalFatFish/lean-mil-pi-course --public --source=. --remote=origin --push`.

Expected: the public repository URL is returned and `main` tracks `origin/main`.

**Step 3: Verify public metadata and CI**

Use unauthenticated HTTP or GitHub API checks to confirm visibility, default branch, license, and workflow status.

### Task 7: Test ReasLab import from GitHub

**Files:**
- Modify: `README.md` only if the observed UI requires corrected instructions.

**Step 1: Open ReasLab**

Navigate to `https://reaslab.io`, locate the GitHub import or project creation control, and enter the public repository URL.

**Step 2: Import and inspect**

Confirm the project is created, the root Lake files are detected, and `Course`, `MIL`, and `PiNoIntegral` appear in the workspace.

**Step 3: Verify Lean feedback**

Open `Course/LeanBasics.lean` or `Main.lean` and confirm Lean initializes without a project-configuration error.

**Step 4: Record the result**

Report whether the import and Lean initialization succeeded; if authentication or a ReasLab service limitation blocks the test, capture the exact visible blocker without claiming success.
