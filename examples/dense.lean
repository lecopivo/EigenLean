import EigenLean

open Eigen

def main : IO Unit := do
  let A : Matrix 2 2 := ⟨FloatArray.mk #[2,1,1,2], by nativeDecide⟩
  let b : Matrix 2 1 := ⟨FloatArray.mk #[1,1], by nativeDecide⟩
  IO.println A
  IO.println b
  IO.println (A.ldlt.solve b)
