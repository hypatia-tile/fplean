---
name: step-review
description: Review a committed step of this hand-written Functional Programming in Lean repository. Pins the review to a commit hash, reads the actual files, and records findings as a comment on the step's GitHub issue. Use when the user invokes step-review directly, or asks for a review / reports a step finished (Japanese: レビュー、ステップ終わった、レビューして).
---

# step-review (fplean)

Review one step. Report findings; **never write the fix or any repository
code.** The user fixes; the AI may `commit` and `push` those fixes under the
Working contract.

## Working contract

- **The user writes all code.** The AI writes `docs/roadmap.md` and GitHub
  issues (review comments, checkboxes) only. Nix full-text transcription in
  chat remains the sole code-shaped exception, and the user still types it.
- **Everything is written in English** — issue comments, commit messages,
  roadmap edits.
- **The AI may run `git commit` and `push`.** Print messages before
  committing. Commits go to `main` and are pushed.
- **Never amend a pushed commit.** A review is pinned to a hash; amending
  orphans it. Fixes stack as new commits. Unpushed amend only after talking
  it over case by case.
- **One logical change per commit.**
- **Review findings can be deferred.** Once no must-fix remains, "Your
  call" and "Minor" items the user chooses to leave become one issue
  labelled `deferred`, which supersedes them on the step issue so it can
  close. `deferred` does **not** block the next step.
- **`comprehension` issues** record understanding gaps; they do not block
  steps. Prefer opening or updating one when a review exposes a lasting gap
  (ITS learner model).
- **Pedagogy:**
  - **Adaptive Assessment** on the comprehension answer: deepen with
    follow-ups if shallow; move on if clear. Do not rewrite the fixed
    question on the issue.
  - Spotlight **`section Own`** — the part the review looks at hardest.
  - Mid-fix conversation still uses **Socratic Questioning** first; answers
    after exhaustion are direction/fragments only, never a full `.lean`
    solution.

## Before reviewing

1. Run `git status`. **If anything is uncommitted, do not start.** Ask the
   user to commit first.
2. Confirm commits for this step are **pushed**. An unpushed hash does not
   resolve as a link from the issue comment.
3. Run `gh issue list --state open` to find the step issue.
4. Pin the target with `git log --oneline`; express a range as `base..head`
   when there are several commits.
5. Read open `comprehension` issues and prior review comments on this issue
   so findings and follow-up questions use the ITS model.

## Read the actual thing

**Never review from assumption.** Read the target commits with `git show`
and by reading the files directly. Run read-only checks (`lake build`, and
`lake build Scratch` when relevant). Never write a finding that rests on
"this is probably how it turned out."

Check the roadmap definition of done for a section step: transcription,
exercises, `section Own`, green build, comprehension answered on the issue.

## Writing findings

Sort findings into three tiers:

- **Must fix** — real harm: breaks this step, or will break a later one.
  State the concrete failure scenario
- **Your call** — not wrong, but the user should articulate why. Give both
  sides of the trade-off
- **Minor** — taste. Say explicitly that it need not be fixed

Every finding states why it is a problem and what **direction** the fix
goes. **Never write the fix.**

**Always state what was done right**, backed by something verified — naming
what worked is part of the review and the learning.

Never repeat a finding. If something raised last time is still unfixed,
mention it in one line as a leftover.

## Recording

1. Open the comment body with the reviewed hash
   (`Reviewed: abc1234` or `Reviewed: abc1234..def5678`)
2. `gh issue comment <number> --body-file <file>`
3. Print the same content in chat

## Closing

- **Do not close the issue while any must-fix finding remains.** Have the
  user stack fix commits, then add a follow-up comment naming those hashes.
- Close only when must-fix is clear **and the user says to close**.
- If leftover Your call / Minor items should remain: open one `deferred`
  issue that supersedes them, then close the step issue.
- Post a closing comment, `gh issue close <number>`, and tick the step in
  `docs/roadmap.md` (`[x]`).
- The next `step-start` requires this issue closed and a clean working tree.
