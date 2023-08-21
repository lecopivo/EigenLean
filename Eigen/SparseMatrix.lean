import Eigen.Matrix

namespace Eigen

opaque SparseMatrix.nonemptytype (n m : USize) : NonemptyType
def SparseMatrix (n m : USize) : Type := SparseMatrix.nonemptytype n m |>.type
instance {n m : USize} : Nonempty (SparseMatrix n m) := SparseMatrix.nonemptytype n m |>.property

structure Triplet (n m : USize) where
  row : USize
  col : USize
  val : Float
  h_row : row < n
  h_col : col < m

instance (n m : USize) : Coe (Array (Nat×Nat×Float)) (Array (Triplet n m)) :=
  ⟨λ u => Id.run do
    let mut t : Array (Triplet n m) := Array.mkEmpty u.size
    for i in [0:u.size] do
      let (row, col, val) := u[i]!
      if h : row.toUSize < n ∧ col.toUSize < m then
        t := t.push ⟨row.toUSize, col.toUSize, val, h.1, h.2⟩
    t⟩

@[export eigenlean_triplets_get_row]
def tripletsGetRow (entries : @& Array (Triplet n m)) (i : USize) (p : i.toNat < entries.size) : USize := (entries.uget i p).row
@[export eigenlean_triplets_get_col]
def tripletsGetCol (entries : @& Array (Triplet n m)) (i : USize) (p : i.toNat < entries.size) : USize := (entries.uget i p).col
@[export eigenlean_triplets_get_val]
def tripletsGetVal (entries : @& Array (Triplet n m)) (i : USize) (p : i.toNat < entries.size) : Float := (entries.uget i p).val

@[extern "eigenlean_sparse_matrix_mk_from_triplets"]
opaque SparseMatrix.mk (entries : @& Array (Triplet n m)) : SparseMatrix n m

@[extern "eigenlean_sparse_matrix_mk_zero"]
opaque SparseMatrix.mkZero (n m : USize) : SparseMatrix n m

@[extern "eigenlean_sparse_matrix_mk_identity"]
opaque SparseMatrix.mkIdentity (n : USize) : SparseMatrix n n

@[extern "eigenlean_sparse_matrix_to_dense"]
opaque SparseMatrix.toDense (A : @& SparseMatrix n m) : Matrix n m

@[extern "eigenlean_sparse_matrix_is_compressed"]
opaque SparseMatrix.isCompressed (A : @& SparseMatrix n m) : Bool

@[extern "eigenlean_sparse_matrix_make_compressed"]
opaque SparseMatrix.mkCompressed (A : @& SparseMatrix n m) : SparseMatrix n m


end Eigen
