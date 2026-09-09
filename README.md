# fplean

Transcriptions, exercises and experiments from
[Functional Programming in Lean](https://lean-lang.org/functional_programming_in_lean/),
read from chapter 3 onwards.

Chapters 1 and 2 and the first Interlude were read in
[`book-fpinlean`](https://github.com/hypatia-tile/book-fpinlean), which this
repository supersedes. That code is not carried over.

The plan, the conventions and the reasoning behind them live in
[`docs/roadmap.md`](docs/roadmap.md).

## Getting started

The environment is a Nix flake entered through direnv. `.envrc` is not tracked,
so copy it once:

```sh
cp .envrc.example .envrc
direnv allow
lean --version        # Lean (version 4.33.1, ...)
```

On macOS the first entry **builds Lean from source and takes about 80 minutes**.
This is not optional: the prebuilt macOS release cannot be realised by Nix
([lean4-nix#76](https://github.com/lenianiva/lean4-nix/issues/76)), and the
reason is recorded in `flake.nix` next to the code that works around it. Linux
uses the prebuilt archive and is quick. `lake --version` reporting `5.0.0-src`
means you are on the source-built toolchain.

`lean.nvim` starts the language server by running `lake` from `PATH`, so
**Neovim has to be started from inside this directory** — direnv must have
loaded first, or the server will not come up.

## Building

```sh
lake build            # type-check everything under FpInLean/
lake build Scratch    # type-check the experiments
```

Only `FpInLean` is a default target. Experiments under `Scratch/` are deliberately
left out of `lake build` so that something half-written never turns the book's
build red; check them when you actually want to know.

Both libraries are declared with globs in `lakefile.lean`, so a module is picked
up by existing on disk. Adding a section means adding one file — no `import`
line, no edit to the build definition.

## Layout

```
FpInLean/Ch<NN><ChapterSlug>/<SectionSlug>.lean           the section, plus examples of my own
FpInLean/Ch<NN><ChapterSlug>/<SectionSlug>Exercises.lean  the book's exercises
Scratch/                                                  experiments unrelated to the book
```

Paths use slugs rather than section numbers, because the numbering shifts
between editions of the book — "Additional Conveniences" has already moved from
1.7 to 1.8. Numbers are kept in one place, `docs/roadmap.md`, where they can be
corrected without renaming files.

Each file opens a namespace named after its section. That keeps the book's habit
of redefining names like `Pos` from section to section harmless, and lets later
sections import earlier ones where the book itself builds up.

## Licence

The code in this repository is MIT licensed; see [`LICENSE`](LICENSE).

Functional Programming in Lean is licensed
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). It was originally
released by Microsoft Corporation in 2023, and the current version carries
modifications copyright 2023-2025 Lean FRO, LLC. **This repository contains code
derived from the book, and that code has been modified** — transcribed by hand,
rearranged into the layout above, and extended with examples and solutions of my
own.
