def hello := "world"

namespace Eigen

-- TODO: Add map option and stride
structure Matrix (n m : USize) where
  data : FloatArray 
  property : data.size = n.toNat * m.toNat

instance {n m : USize} : Inhabited (Matrix n m) := 
  ⟨FloatArray.mk (Array.mkArray (n.toNat*m.toNat) (0:Float)) ,sorry⟩

instance {n m : USize} : ToString (Matrix n m) := ⟨λ A => toString A.data⟩

def Vector (n : USize) := Matrix n 1

constant SPointed : NonemptyType
def LDLT (n : USize) : Type := SPointed.type
instance {n : USize} : Nonempty (LDLT n) := SPointed.property

@[export eigenlean_get_matrix_array]
def Matrix.toArray {n m} (A : Matrix n m) : FloatArray := A.data

@[export eigenlean_array_to_matrix]
def FloatArray.toMatrix (array : FloatArray) (n m : USize) (property : array.size = n.toNat * m.toNat) : Matrix n m := ⟨array, property⟩

@[extern "eigenlean_ldlt"]
constant Matrix.ldlt (A : @& Matrix n n) : LDLT n

@[extern "eigenlean_ldlt_solve"]
constant LDLT.solve {n m} (ldlt : @& LDLT n) (rhs : @& Matrix n m) : Matrix n m

@[extern "make_empty"]
constant make_empty (n : USize) : FloatArray




end Eigen
