namespace Eigen

--- Matrix Type ---
-------------------
-- It is just a wrapper around FloatArray storing dimensions

-- TODO: Add map option and stride
-- TODO: Add precision float vs double. Note that Lean's FloatArray is array of doubles
structure Matrix (n m : USize) where
  data : FloatArray
  property : data.size = n.toNat * m.toNat

instance {n m : USize} : Inhabited (Matrix n m) where
  default := ⟨FloatArray.mk (Array.mkArray (n.toNat*m.toNat) (0:Float)), by simp[FloatArray.size]⟩

-- TODO: Proper rectangular printing of matrices
instance {n m : USize} : ToString (Matrix n m) := ⟨λ A => toString A.data⟩

abbrev Vector (n : USize) := Matrix n 1

-- Utiliti Functions used in C API ---
---------------------------------------

-- Curently there is no binary difference between FloatArray and Matrix.
-- These functions are identies at the end. This might change in the
-- future, so using these function is advised

/-- Convert a FloatArray to a matrix. -/
@[export eigenlean_get_matrix_array]
def Matrix.toArray {n m} (A : Matrix n m) : FloatArray := A.data

/-- Convert a matrix to a FloatArray. -/
@[export eigenlean_array_to_matrix]
def FloatArray.toMatrix (array : FloatArray) (n m : USize) (property : array.size = n.toNat * m.toNat) : Matrix n m := ⟨array, property⟩


/-- Random matrix with entries uniformtly sampled from [0,1] -/
def Matrix.rand (n m : USize) : IO (Matrix n m) := do

  let rand : IO Float := do
    let N := 10000000000000
    let n ← IO.rand 0 N
    return n.toFloat / N.toFloat

  let nm := (n*m).toNat
  let mut buffer : FloatArray := FloatArray.mkEmpty nm
  for i in [0:nm] do
    buffer := buffer.push (← rand)

  return ⟨buffer, sorry⟩

--------------------------------------------------------------------------------
-- Basic operations ------------------------------------------------------------
--------------------------------------------------------------------------------

@[extern "eigenlean_matrix_matmul"]
opaque Matrix.matmul {n m k : USize} (A : @& Matrix n m) (x : @& Matrix m k) : Matrix n k

/-- Matrix vector multiplication `A*x`.

Argument `out` is used for the output, it should be call linearly. -/
@[extern "eigenlean_matrix_matmul_out"]
opaque Matrix.matmulOut {n m k : USize} (A : @& Matrix n m) (x : @& Matrix m k) (out : Matrix n k) : Matrix n k



--------------------------------------------------------------------------------
-- Matrix Decopositions and solvers --------------------------------------------
--------------------------------------------------------------------------------
-- https://eigen.tuxfamily.org/dox/group__TopicLinearAlgebraDecompositions.html

opaque PartialPivLU.nonemptytype (n : USize) : NonemptyType
/-- LU decomposition of matrix with partial pivoting. -/
def PartialPivLU (n : USize) : Type := PartialPivLU.nonemptytype n |>.type
instance {n : USize} : Nonempty (PartialPivLU n) := PartialPivLU.nonemptytype n |>.property

/-- LU decomposition of matrix with partial pivoting. -/
@[extern "eigenlean_partial_piv_lu"]
opaque Matrix.partialPivLU (A : @& Matrix n n) : PartialPivLU n

/-- Solve the linear system `A x = rhs` using the LU decomposition `lu`. -/
@[extern "eigenlean_partial_piv_lu_solve"]
opaque PartialPivLU.solve {n m} (lu : @& PartialPivLU n) (rhs : @& Matrix n m) : Matrix n m


opaque FullPivLU.nonemptytype (n m : USize) : NonemptyType
/-- LU decomposition of matrix with full pivoting -/
def FullPivLU (n m : USize) : Type := FullPivLU.nonemptytype n m |>.type
instance {n m : USize} : Nonempty (FullPivLU n m) := FullPivLU.nonemptytype n m |>.property

/-- LU decomposition of matrix with full pivoting. -/
@[extern "eigenlean_full_piv_lu"]
opaque Matrix.fullPivLU (A : @& Matrix n m) : FullPivLU n m

/-- Solve the linear system `A x = rhs` using the LU decomposition `lu`. -/
@[extern "eigenlean_full_piv_lu_solve"]
opaque Matrix.fullPivLUSolve {n m k} (lu : @& FullPivLU n m) (rhs : @& Matrix n k) : Matrix m k


opaque ColPivHouseholderQR.nonemptytype (n m : USize) : NonemptyType
/-- Householder QR decomposition of matrix with column pivoting -/
def ColPivHouseholderQR (n m : USize) : Type := ColPivHouseholderQR.nonemptytype n m |>.type
instance {n m : USize} : Nonempty (ColPivHouseholderQR n m) := ColPivHouseholderQR.nonemptytype n m |>.property

/-- Householder QR decomposition of matrix with column pivoting. -/
@[extern "eigenlean_col_piv_householder_qr"]
opaque Matrix.colPivHouseholderQR (A : @& Matrix n m) : ColPivHouseholderQR n m

/-- Solve the linear system `A x = rhs` using the QR decomposition `qr`. -/
@[extern "eigenlean_col_piv_householder_qr_solve"]
opaque ColPivHouseholderQR.solve {n m k} (qr : @& ColPivHouseholderQR n m) (rhs : @& Matrix n k) : Matrix m k


opaque FullPivHouseholderQR.nonemptytype (n m : USize) : NonemptyType
/-- Householder QR decomposition of matrix with full pivoting  -/
def FullPivHouseholderQR (n m : USize) : Type := FullPivHouseholderQR.nonemptytype n m |>.type
instance {n m : USize} : Nonempty (FullPivHouseholderQR n m) := FullPivHouseholderQR.nonemptytype n m |>.property

/-- Householder QR decomposition of matrix with full pivoting.  -/
@[extern "eigenlean_full_piv_householder_qr"]
opaque Matrix.fullPivHouseholderQR (A : @& Matrix n m) : FullPivHouseholderQR n m

/-- Solve the linear system `A x = rhs` using the QR decomposition `qr`. -/
@[extern "eigenlean_full_piv_householder_qr_solve"]
opaque FullPivHouseholderQR.solve {n m k} (qr : @& FullPivHouseholderQR n m) (rhs : @& Matrix n k) : Matrix m k


opaque LLT.nonemptytype (n : USize) : NonemptyType
/-- LLT decomposition of a matrix. -/
def LLT (n : USize) : Type := LLT.nonemptytype n |>.type
instance {n : USize} : Nonempty (LLT n) := LLT.nonemptytype n |>.property

/-- LLT decomposition of a matrix. -/
@[extern "eigenlean_llt"]
opaque Matrix.llt (A : @& Matrix n n) : LLT n

/-- Solve the linear system `A x = rhs` using the LLT decomposition `llt`. -/
@[extern "eigenlean_llt_solve"]
opaque LLT.solve {n m} (llt : @& LLT n) (rhs : @& Matrix n m) : Matrix n m


opaque LDLT.nonemptytype (n : USize) : NonemptyType
/-- LDLT decomposition of a matrix. -/
def LDLT (n : USize) : Type := LDLT.nonemptytype n |>.type
instance {n : USize} : Nonempty (LDLT n) := LDLT.nonemptytype n |>.property

/-- LDLT decodef SVDOptions.toInt (opts : SVDOptions) : Nat := Id.run do
  let mut flags := 0
  if opts.computeU then flags := flags + Eigen.ComputeFullU
  if opts.computeV then flags := flags + Eigen.ComputeFullV
  if opts.computeThinU then flags := flags + Eigen.ComputeThinU
  if opts.computeThinV then flags := flags + Eigen.ComputeThinV
  flagsmposition of a matrix. -/
@[extern "eigenlean_ldlt"]
opaque Matrix.ldlt (A : @& Matrix n n) : LDLT n

/-- Solve the linear system `A x = rhs` using the LDLT decomposition `ldlt`. -/
@[extern "eigenlean_ldlt_solve"]
opaque LDLT.solve {n m} (ldlt : @& LDLT n) (rhs : @& Matrix n m) : Matrix n m



--------------------------------------------------------------------------------
-- Singular values and eigenvalues decompositions ------------------------------
--------------------------------------------------------------------------------

opaque JacobiSVD.nonemptytype (n m : USize) : NonemptyType
def JacobiSVD (n m : USize) : Type := JacobiSVD.nonemptytype n m |>.type
instance {n m : USize} : Nonempty (JacobiSVD n m) := JacobiSVD.nonemptytype n m |>.property

def Eigen.ComputeFullU : USize := 0x01
def Eigen.ComputeFullV : USize := 0x02
def Eigen.ComputeThinU : USize := 0x04
def Eigen.ComputeThinV : USize := 0x08

structure SVDOptions where
  computeU : Bool
  computeV : Bool
  computeThinU : Bool
  computeThinV : Bool

def SVDOptions.toInt (opts : SVDOptions) : USize := Id.run do
  let mut flags : USize := 0
  if opts.computeU then flags := flags + Eigen.ComputeFullU
  if opts.computeV then flags := flags + Eigen.ComputeFullV
  if opts.computeThinU then flags := flags + Eigen.ComputeThinU
  if opts.computeThinV then flags := flags + Eigen.ComputeThinV
  flags


/-- Internal implementation of singular value decomposition that interfaces with the extern C function. -/
@[extern "eigenlean_jacobi_svd"]
opaque Matrix.jacobiSVD_impl (A : @& Matrix n m) (options : USize) : JacobiSVD n m

/-- User-facing singular value decomposition of a matrix with options for computing U, V, and their thin versions packaged into a structure. -/
def Matrix.jacobiSVD (A : @& Matrix n m) (options : SVDOptions) : JacobiSVD n m :=
  Matrix.jacobiSVD_impl A (SVDOptions.toInt options)


/-- Compute the singular values of a matrix. -/
@[extern "eigenlean_jacobi_svd_singular_values"]
opaque JacobiSVD.singularValues {n m} (svd : @& JacobiSVD n m) : Vector (min n m)

/-- Compute the left singular vectors of a matrix. -/
@[extern "eigenlean_jacobi_svd_matrix_u"]
opaque JacobiSVD.matrixU {n m} (svd : @& JacobiSVD n m) : Matrix n n

-- /-- Compute the right singular vectors of a matrix. -/
-- @[extern "eigenlean_jacobi_svd_matrix_v"]
-- opaque JacobiSVD.matrixV {n m} (svd : @& JacobiSVD n m) : Matrix m m

-- /-- Solve the linear system `A x = rhs` using the SVD decomposition `svd`. -/
-- @[extern "eigenlean_jacobi_svd_solve"]
-- opaque JacobiSVD.solve {n m k} (svd : @& JacobiSVD n m) (rhs : @& Matrix n k) : Matrix m k


end Eigen
