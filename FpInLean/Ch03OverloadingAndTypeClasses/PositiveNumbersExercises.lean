namespace PositiveNumbersExercises

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

/--
info: 2
-/
#guard_msgs in
#eval two

end «3.1.6.2»

end PositiveNumbersExercises
