---
name: step-start
description: Start the next step of this hand-written Functional Programming in Lean repository. Reads docs/roadmap.md, files a GitHub issue with the step spec, and prints the spec in chat. Use when the user invokes step-start directly, or asks to begin / resume / move on to the next step (Japanese: ステップ開始、次のステップ、次に進む).
---

# step-start (fplean)

Start one step. Produce a specification and a GitHub issue. **Never write
Lean, lakefile, workflow YAML, or other repository code** — the user types
everything except as noted under Working contract.

## Working contract

- **The user writes all code.** Lean source, `flake.nix`, `lakefile.lean`,
  `README.md`, workflow YAML — everything committed except `docs/roadmap.md`
  is written by hand by the user.
- **Nix is transcribed; everything else is written from scratch.** For
  `flake.nix` and other Nix expressions only: the AI supplies the full text,
  the user types it in, and understanding is chased afterwards by asking.
  Lean, `lakefile.lean`, and workflow YAML stay hand-written.
- **The AI writes `docs/roadmap.md` and GitHub issues only.** Specs, review
  comments, and roadmap checkboxes. It never writes code to unblock a stuck
  step.
- **Everything is written in English** — roadmap, `README.md`, comments in
  `.lean` files, issue bodies, review comments, and commit messages.
  Conversation may be Japanese.
- **The AI may run `git commit` and `push` on the user's behalf.** Print
  every commit message before committing; the user corrects it when wrong.
  Commits go straight to `main` and are pushed.
- **Never amend a pushed commit.** Reviews pin a hash; amending orphans it.
  Fixes stack as new commits. An unpushed commit may be amended only after
  talking it over case by case.
- **One logical change per commit.** A step usually produces several. The
  test: could any single one be reverted without dragging the others?
- **One step at a time.** Do not start while the previous step's issue is
  open or the working tree is dirty.
- **Progress may outrun understanding.** Gaps become issues labelled
  `comprehension` (what was skipped, what understanding would close it).
  They are debts, not step issues; they do **not** block starting a step.
- **Pedagogy (ITS + Adaptive Assessment + Socratic Questioning):**
  - Mid-step, when stuck: **Socratic Questioning** first — questions, not
    answers or finished code.
  - After Socratic is exhausted and the user explicitly asks for the answer:
    give **direction, missing concepts, or small expression fragments only**.
    Never a complete `.lean` file or a full exercise solution. Record the
    gap as a `comprehension` issue.
  - **Adaptive Assessment:** the issue carries one fixed comprehension
    question (do not rewrite it). Follow-ups in chat deepen or move on
    according to the quality of the user's answers.
  - **ITS learner model:** no dedicated file. Weak spots live in open
    `comprehension` issues and prior review comments; read them when
    choosing focus for this step's hints and comprehension question.

## Before starting

1. Read `docs/roadmap.md` only — that is the required reading for start.
2. Run `gh issue list --state open`. If a previous **step** issue is still
   open, stop and push for review and closure first. Open `comprehension`
   or `deferred` issues do **not** block.
3. Run `git status`. A dirty working tree means leftovers; clear them first.
4. Optionally skim open `comprehension` issues and the latest review on the
   prior step so the ITS focus is not blind — this does not replace the
   roadmap as required reading.

## Writing the spec

Target the first unchecked (`- [ ]`) step in the roadmap.

**Look up every fact before writing.** Never guess book URLs, module paths,
or toolchain details. Read the roadmap and, when needed, the book page.

The spec must contain:

- **Goal** — one observable sentence: what must work for this step to be done
- **Why** — background and design reasoning (the learning substance)
- **Files to write, and what goes in each** — filenames, required elements,
  constraints. **Never write the code itself.** Naming a definition is
  specification; writing its body is implementation. For Nix-only steps,
  the AI may include the full Nix text in chat for the user to type; still
  do not commit that text for them.
- **Verification** — exact commands (usually `lake build`, and
  `lake build Scratch` when relevant) and expected outcomes
- **A comprehension question** — one question whose answer you withhold.
  Anchors Adaptive Assessment for the rest of the step
- **A suggested commit message** (or messages, if the step will be several
  logical commits)

Align the definition of done with the roadmap's section-step criteria
(transcription, exercises, `section Own`, green `lake build`, comprehension
answered on the issue).

Do **not** tick the roadmap checkbox at start.

## Filing the issue

1. Write the full spec to a temporary file
2. `gh issue create --title "Step N: <name>" --body-file <file>`
3. Report the issue number and URL
4. **Also print the full spec in chat.** The issue is the record; chat is
   where the work happens

## Mid-step help

While the user implements, stay inside the Working contract and pedagogy
above. End the start turn by noting that `step-review` takes over once the
work is committed, pushed, and the tree is clean.
