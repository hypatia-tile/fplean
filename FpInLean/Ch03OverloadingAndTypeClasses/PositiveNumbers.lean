namespace PositiveNumbers

-- Define the type of Positive numbers in a very similar way to the definition
-- of Nat type.
inductive Pos where
  | one
  | succ (n : Pos)

-- Currently, we cannot use number literal to represent a value of the type
-- Pos.

/--
info: failed to synthesize instance of type class
  OfNat Pos 7
numerals are polymorphic in Lean, but the numeral `7` cannot be used in a context where the expected type is
  Pos
due to the absence of the instance above

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
-/
#guard_msgs in
#check_failure (7 : Pos)

-- Instead, we have to define @seven@ as following:
def seven : Pos :=
  Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ Pos.one)))))

-- Addition and multiplication are not easy to use.
/--
info: failed to synthesize instance of type class
  HAdd Pos Pos ?m.3

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
-/
#guard_msgs in
#check_failure seven + seven
/--
info: failed to synthesize instance of type class
  HMul Pos Pos ?m.3

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
-/
#guard_msgs in
#check_failure seven * seven

-- 3.1.1. Classes and Instances

-- Declare a typeclass Plus
class Plus (α : Type) where
  plus : α → α → α

-- Make the plus method accessible without the namespace Plus.
open Plus (plus)

-- Declare an instance of Plus typeclass for  Nat.
instance : Plus Nat where
  plus m n := m + n

/--
info: failed to synthesize instance of type class
  Plus Float

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
---
info: plus 5.2 917.25861 : Float
-/
#guard_msgs in
#check_failure plus 5.2 917.25861

#guard plus 5 3 = 8
#guard plus 3 5 = 8

-- Define the addition on Pos type.
def Pos.plus : Pos → Pos → Pos
  | .one, k => k.succ
  | .succ n, k => .succ <| n.plus k

-- Declare an instance of Plus typeclass for Pos.
instance : Plus Pos where
  plus := Pos.plus

-- def fourteen : Pos := plus seven seven

-- 3.1.2 Overloaded Addition

-- To use '+' for addition, declare an Add instance.
instance : Add Pos where
  add := Pos.plus

def fourteen : Pos := seven + seven

-- 3.1.3. Conversion to Strings

def posToString (atTop : Bool) (p : Pos) : String :=
  let paren s := if atTop then s else "(" ++ s ++ ")"
  match p with
  | .one => "Pos.one"
  | .succ n => paren s!"Pos.succ {posToString false n}"

instance : ToString Pos where
  toString := posToString true

/--
info: "There are Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ Pos.one)))))"
-/
#guard_msgs in
#eval s!"There are {seven}"

def Pos.toNat : Pos → Nat
  | .one => 1
  | .succ n => .succ <| n.toNat

instance : ToString Pos where
  toString x := toString <| x.toNat

/--
info: "There are 7"
-/
#guard_msgs in
#eval s!"There are {seven}"

-- 3.1.4. Overloaded Multiplication

def Pos.mul : Pos → Pos → Pos
  | .one, k => k
  | .succ n, k => k + n.mul k

instance : Mul Pos where
  mul := Pos.mul

/--
info: [7, 49, 14]
-/
#guard_msgs in
#eval [seven * Pos.one,
  seven * seven,
  .succ .one * seven]

-- 3.1.5. Literal Numbers

instance : One Pos where
  one := .one

namespace Digression
inductive LT4 where
  | zero
  | one
  | two
  | three

instance : OfNat LT4 0 where
  ofNat := .zero

instance : OfNat LT4 1 where
  ofNat := .one

instance : OfNat LT4 2 where
  ofNat := .two
instance : OfNat LT4 3 where
  ofNat := .three

def LT4.toNat : LT4 → Nat
  | .zero => 0
  | .one => 1
  | .two => 2
  | .three => 3

instance : ToString LT4 where
  toString n := toString <| n.toNat

/--
info: [0, 1, 2, 3]
-/
#guard_msgs in
#eval ([0, 1, 2, 3] : List LT4)
/--
info: failed to synthesize instance of type class
  OfNat LT4 4
numerals are polymorphic in Lean, but the numeral `4` cannot be used in a context where the expected type is
  LT4
due to the absence of the instance above

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
-/
#guard_msgs in
#check_failure (4 : LT4)

end Digression

instance : OfNat Pos (n + 1) where
  ofNat :=
    let rec natPlusOne : Nat → Pos
      | .zero => Pos.one
      | .succ k => .succ (natPlusOne k)
    natPlusOne n

def eight : Pos := 8

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

end PositiveNumbers
