import Eigen

open Eigen


def main : IO Unit := do
  let A : Matrix 2 2 := ⟨FloatArray.mk #[2,1,1,2], by native_decide⟩
  let b ← Matrix.rand 2 1
  let x := A.ldlt.solve b
  let b' := A.matmul x

  IO.println s!"A = {A}"
  IO.println s!"b = {b}"
  IO.println s!"x = A⁻¹*b = {x}"
  IO.println s!"A*x = {b'}"
