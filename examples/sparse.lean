import Eigen

open Eigen

def main : IO Unit := do
  let entries : Array (Triplet 2 2) := (#[(0,0,2.0), (1,0,1.0), (1,1,2.0), (0,1, 1.0)] : Array (Nat×Nat×Float))
  let A := SparseMatrix.mk entries
  let b ← Matrix.rand 2 1
  let x := A.simplicialLLT.solve b
  let b' := A.densemul x

  IO.println s!"A  = {A.toDense}"
  IO.println s!"b  = {b}"
  IO.println s!"x = A⁻¹*b = {x}"
  IO.println s!"A*x = {b'}"
