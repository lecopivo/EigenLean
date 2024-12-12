import Eigen

open Eigen

def main : IO Unit := do
  let A : Matrix 2 2 := ⟨FloatArray.mk #[2,1,1,2], by native_decide⟩
  let b : Matrix 2 1 := ⟨FloatArray.mk #[1,1], by native_decide⟩

  IO.println s!"A  = {A}"
  IO.println s!"b  = {b}"
  IO.println s!"A⁻¹ = {A.ldlt.solve b}"
