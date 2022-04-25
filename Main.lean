import EigenLean

open Eigen

def main : IO Unit := do
  let A : Matrix 2 2 := ⟨FloatArray.mk #[2,1,1,2], by native_decide⟩
  let b : Matrix 2 1 := ⟨FloatArray.mk #[1,1], by native_decide⟩
  IO.println A
  IO.println b
  IO.println (A.ldlt.solve b)

  let entries : Array (Triplet 2 2) := (#[(0,0,1.0), (1,1,-1.0), (0,1, 2.0)] : Array (Nat×Nat×Float))
  let B := SparseMatrix.mk entries
  IO.println B.toDense
