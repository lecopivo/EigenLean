import EigenLean

open Eigen

def main : IO Unit := do

  let A : Matrix 2 2 := ⟨FloatArray.mk #[2,1,1,57], sorry⟩
  let b : Matrix 2 1 := ⟨FloatArray.mk #[1,0], sorry⟩
  let I : Matrix 2 2 := ⟨FloatArray.mk #[1,0,0,1], sorry⟩
  IO.println A
  IO.println b
  IO.println (make_empty 3)
  let ldlt := A.ldlt
  IO.println (ldlt.solve I)
  IO.println s!"Hello, {hello}!"




