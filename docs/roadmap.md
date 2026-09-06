# Roadmap

A hand-written transcription-and-experiment repository for
[Functional Programming in Lean](https://lean-lang.org/functional_programming_in_lean/).

Chapters 1, 2 and the first Interlude were read in
[`book-fpinlean`](https://github.com/hypatia-tile/book-fpinlean) and are **not**
carried over. This repository starts at chapter 3 and supersedes that one.

## Working contract

Read this before starting or reviewing any step.

- **The user writes all code.** Lean source, `flake.nix`, `lakefile.toml`,
  `README.md`, workflow YAML — everything committed to this repository except
  `docs/roadmap.md` is written by hand by the user.
- **Nix is transcribed; everything else is written from scratch.** Nix is new
  ground, so for `flake.nix` and other Nix expressions the AI supplies the full
  text, the user types it in, and the understanding is chased down afterwards by
  asking. This is the single exception to the rule above, and it is deliberately
  narrow: it covers Nix and nothing else. Lean, `lakefile.toml` and workflow YAML
  stay hand-written.
- **The AI writes `docs/roadmap.md` and GitHub issues only.** Specs, review
  comments, and roadmap checkboxes. It never writes code, not even to unblock a
  stuck step. When the user is stuck, it gives a graded hint first and the
  answer only if that fails.
- **Everything is written in English** — this file, `README.md`, comments inside
  `.lean` files, issue bodies, review comments, and commit messages.
- **Commits go straight to `main` and are pushed.** Never amend: a review is
  pinned to a commit hash, and amending orphans the hash the review comment
  points at. Fixes are stacked as new commits.
- **One logical change per commit.** A step usually produces several. Do not
  bundle unrelated concerns — the toolchain pin, the direnv setup, and the
  ignore rules are three changes, not one. The test is whether any single one
  could be reverted on its own without dragging the others with it.
- **One step at a time.** A new step does not start while the previous step's
  issue is open or the working tree is dirty.

## Environment

- Lean is supplied by [`lenianiva/lean4-nix`](https://github.com/lenianiva/lean4-nix)
  through `readToolchainFile`, whose `binary` argument the flake selects per
  system: **the prebuilt release on Linux, a source build on darwin.**
  The prebuilt macOS archive cannot be realised by Nix at all — its dylibs carry
  `@rpath` install names and nixpkgs' `fixDarwinDylibNames` hook cannot rewrite
  them, which is [lean4-nix#76](https://github.com/lenianiva/lean4-nix/issues/76),
  open since 2025-10 and independent of the Lean version pinned. Source-built
  libraries are linked against their final store paths, so the hook has nothing
  to rewrite. Linux is unaffected and keeps the fast path, which also keeps CI
  fast.
- **The darwin source build takes about 80 minutes**, once. `lake --version`
  reporting `5.0.0-src` is how you tell you are on the source path.
- `nixpkgs` follows `lean4-nix/nixpkgs` rather than carrying its own URL. This
  is not cosmetic: nixpkgs supplies the compiler and every C dependency, all of
  which enter Lean's derivation hash. Pointing it elsewhere makes every hash
  differ, forfeits the upstream binary cache, and discards the source build
  already in the local store.
- `lean-toolchain` pins `leanprover/lean4:v4.33.1`, the latest stable release
  (2026-08-21). Note that the book states its samples are validated against
  4.33.0, one patch release behind; when a sample does not compile, the version
  gap is a candidate explanation before your own typo is.
- The flake exposes **a devShell only**. No `buildLeanPackage`, no
  `packages.default`: those require listing module roots in `flake.nix`, which
  would mean editing Nix every time a section is added. Builds are driven by
  `lake`.
- **elan is not used.** `lean.nvim` starts the language server with
  `{ 'lake', 'serve', '--', root_dir }` taken from `PATH`
  (`lsp/leanls.lua`), so a Nix-provided `lake` is enough.
- `.envrc` uses `use flake`. **Neovim must be started from inside this
  directory** so that direnv has already put `lake` on `PATH`; a Neovim launched
  elsewhere will fail to start the Lean language server.

## Layout

```
FpInLean/Ch<NN><ChapterSlug>/<SectionSlug>.lean           transcription + own examples
FpInLean/Ch<NN><ChapterSlug>/<SectionSlug>Exercises.lean  the book's exercises
Scratch/                                                  experiments unrelated to the book
```

- **One book section = one file = one `namespace` = one step.**
- Section numbers shift between editions of the book, so paths use slugs and
  numbers live only in this file.
- Each file opens a namespace named after its section, so **modules may import
  each other**. Later sections that build on earlier ones import and `open`
  them; sections that redefine a name simply do not `open` it.
- `lakefile.toml` declares two libraries: `FpInLean` (globbed as `FpInLean.*`,
  in `defaultTargets`) and `Scratch` (**not** in `defaultTargets`), so a
  half-finished experiment never turns `lake build` red. Check it explicitly
  with `lake build Scratch`.
- No `notes/` directory. What was learned lives in the issue spec, the review
  comment, and comments inside the `.lean` files.

## Definition of done for a section step

1. The section's code is transcribed into `<SectionSlug>.lean`.
2. The book's exercises for that section are solved in
   `<SectionSlug>Exercises.lean`.
3. **At least one example of your own** — something the book does not contain —
   is written in the section file under a `section Own` block. This is the part
   the review looks at hardest.
4. `lake build` is green.
5. The step's comprehension question is answered on the issue.

## Steps

### Setup

- [x] **1. Retire `book-fpinlean`** — add a `Superseded by hypatia-tile/fplean`
      pointer to the top of its README, commit, push, and archive the repository
      on GitHub. Done outside this repository's working contract.
- [ ] **2. Nix flake providing Lean v4.33.1** — `flake.nix`, `flake.lock`,
      `lean-toolchain`, `.envrc`, `.gitignore`. Verified by `lean --version`
      reporting 4.33.1 inside the direnv environment.
- [ ] **3. Lake package skeleton** — `lakefile.toml`, `FpInLean.lean`,
      `Scratch.lean`, `LICENSE`, `README.md`. Verified by `lake build` and
      `lake build Scratch` both succeeding. The README carries the CC BY 4.0
      attribution described below.
- [ ] **4. CI** — GitHub Actions on `ubuntu-latest` running
      `nix develop -c lake build`, with the Nix store cached so the ~2.7 GB
      toolchain is not refetched on every run.

### Chapter 3: Overloading and Type Classes

Directory: `FpInLean/Ch03OverloadingAndTypeClasses/`

- [ ] **5.** 3.1 [Positive Numbers](https://lean-lang.org/functional_programming_in_lean/Overloading-and-Type-Classes/Positive-Numbers/) — `PositiveNumbers.lean`
- [ ] **6.** 3.2 [Type Classes and Polymorphism](https://lean-lang.org/functional_programming_in_lean/Overloading-and-Type-Classes/Type-Classes-and-Polymorphism/) — `TypeClassesAndPolymorphism.lean`
- [ ] **7.** 3.3 [Controlling Instance Search](https://lean-lang.org/functional_programming_in_lean/Overloading-and-Type-Classes/Controlling-Instance-Search/) — `ControllingInstanceSearch.lean`
- [ ] **8.** 3.4 [Arrays and Indexing](https://lean-lang.org/functional_programming_in_lean/Overloading-and-Type-Classes/Arrays-and-Indexing/) — `ArraysAndIndexing.lean`
- [ ] **9.** 3.5 [Standard Classes](https://lean-lang.org/functional_programming_in_lean/Overloading-and-Type-Classes/Standard-Classes/) — `StandardClasses.lean`
- [ ] **10.** 3.6 [Coercions](https://lean-lang.org/functional_programming_in_lean/Overloading-and-Type-Classes/Coercions/) — `Coercions.lean`
- [ ] **11.** 3.7 [Additional Conveniences](https://lean-lang.org/functional_programming_in_lean/Overloading-and-Type-Classes/Additional-Conveniences/) — `AdditionalConveniences.lean`
- [ ] **12.** 3.8 [Summary](https://lean-lang.org/functional_programming_in_lean/Overloading-and-Type-Classes/Summary/) — `Summary.lean`. No transcription: instead, one
      example of your own that uses the chapter as a whole.

### Chapter 4 onwards

Not listed yet. Chapters are appended one at a time, and the book's table of
contents is re-read immediately beforehand, because section numbering changes
between editions.

Remaining: 4. Monads / 5. Functors, Applicative Functors, and Monads /
6. Monad Transformers / 7. Programming with Dependent Types /
Interlude: Tactics, Induction, and Proofs /
8. Programming, Proving, and Performance / 9. Next Steps.

## Licensing

The repository is MIT licensed (`Copyright (c) 2026 shinokun`).

Functional Programming in Lean is licensed
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/): originally released
by Microsoft Corporation in 2023, with subsequent modifications copyright
2023-2025 Lean FRO, LLC. CC BY is not a share-alike licence, so relicensing an
adaptation under MIT is permitted, but it does require attribution and a
statement that changes were made. `README.md` must therefore say that this
repository contains code derived from the book and modified. Step 3 is where
that text is written.
