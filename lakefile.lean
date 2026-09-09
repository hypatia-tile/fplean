import Lake

open Lake DSL

package fplean where
  description := "Read the book \"Functional Programming in Lean\""

@[default_target]
lean_lib FpInLean where
  libName := "FpInLean"
  globs := #[.andSubmodules `FpInLean]

lean_lib Scratch where
  globs := #[.andSubmodules `Scratch]

