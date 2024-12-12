import Eigen

open Eigen

def main : IO Unit := do
  let entries : Array (Triplet 2 2) := (#[(0,0,2.0), (1,0,1.0), (1,1,2.0), (0,1, 1.0)] : Array (Nat×Nat×Float))
  let A := SparseMatrix.mk entries
  let b : Matrix 2 1 := ⟨FloatArray.mk #[1,1], by native_decide⟩

  IO.println s!"A  = {A.toDense}"
  IO.println s!"b  = {b}"
  IO.println s!"A⁻¹ = {A.simplicialLLT.solve b}"
