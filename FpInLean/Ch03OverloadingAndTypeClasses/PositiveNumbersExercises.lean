namespace PositiveNumbersExercises

namespace «3.1.6.1»

-- Another representation of positive numbers: the inherent Nat is one less
-- than the value represented. Wrapping a Nat instead of recursing means Add,
-- Mul and OfNat each cost one Nat operation, where the inductive Pos of 3.1
-- recursed as deep as the number itself.
structure Pos where
  succ ::
  pred : Nat
  deriving DecidableEq

def Pos.add : Pos → Pos → Pos
  -- (n + 1) + (m + 1) = (n + m + 1) + 1
  | ⟨n⟩, ⟨m⟩ => Pos.succ <| Nat.succ <| n + m

instance : Add Pos where
  add := Pos.add

-- 7 + 8 = 15
#guard (Pos.succ 6) + (Pos.succ 7) = Pos.succ 14

def Pos.mul : Pos → Pos → Pos
  -- (n + 1)(m + 1) = (nm + n + m) + 1
  | ⟨n⟩, ⟨m⟩ => Pos.succ <| n * m + n + m

instance : Mul Pos where
  mul := Pos.mul

-- 7 * 8 = 56
#guard (Pos.succ 6) * (Pos.succ 7) = Pos.succ 55

instance : ToString Pos where
  toString n :=
    toString n.pred.succ

#guard toString (Pos.succ 14) = "15"
#guard toString (Pos.succ 55) = "56"

instance : OfNat Pos (n + 1) where
  ofNat := ⟨n⟩

#guard 7 + 8 = (15 : Pos)
#guard 7 * 8 = (56 : Pos)
#guard 12 + 13 = (25 : Pos)
#guard 12 * 13 = (156 : Pos)

/--
info: failed to synthesize instance of type class
  OfNat Pos 0
numerals are polymorphic in Lean, but the numeral `0` cannot be used in a context where the expected type is
  Pos
due to the absence of the instance above

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
-/
#guard_msgs in
#check_failure (0 : Pos)

end «3.1.6.1»

namespace «3.1.6.2»

inductive Even where
  | zero
  | add2 (n : Even)
  deriving DecidableEq

def Even.add (n m : Even) :=
  match n with
  | .zero => m
  | .add2 n => .add2 <| n.add m

instance : Add Even where
  add := Even.add

def Even.mul (n m : Even) : Even :=
  match n, m with
  | .zero, _ => .zero
  | _, .zero => .zero
  -- (2 + n) * m = 2 * m + n * m
  | .add2 n, m => m + m + n.mul m

instance : Mul Even where
  mul := Even.mul

def Even.toNat : Even → Nat
  | .zero => 0
  | .add2 n => n.toNat + 2

instance : ToString Even where
  toString n := toString <| n.toNat

def two := Even.add2 <| Even.zero
def four := Even.add2 <| Even.add2 <| Even.zero
def eight := Even.add2 <| Even.add2 <| Even.add2 <| Even.add2 <| Even.zero

#guard two + two = four
#guard two * four = eight
#guard two * Even.zero = Even.zero
#guard Even.zero * two = Even.zero

/--
info: 2
-/
#guard_msgs in
#eval two

end «3.1.6.2»

end PositiveNumbersExercises
