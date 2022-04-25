import EigenLean

open Eigen

def main : IO Unit := do
  let entries : Array (Triplet 2 2) := (#[(0,0,1.0), (1,1,-1.0), (0,1, 2.0)] : Array (Nat×Nat×Float))
  let B := SparseMatrix.mk entries
  IO.println B.toDense

