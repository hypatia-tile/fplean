namespace LocalTypeClass

class One (α : Type) where
  one : α

inductive Pos where
  | one
  | succ (n : Pos)
  deriving DecidableEq

instance : One Pos where
  one := Pos.one

/--
info: failed to synthesize instance of type class
  OfNat Pos 1
numerals are polymorphic in Lean, but the numeral `1` cannot be used in a context where the expected type is
  Pos
due to the absence of the instance above

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
-/
#guard_msgs in
#check_failure (1 : Pos)

instance : @_root_.One Pos where
  one := Pos.one

#guard 1 = Pos.one

end LocalTypeClass
