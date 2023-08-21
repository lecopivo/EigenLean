import Eigen.SparseMatrix

namespace Eigen


--- SimplicialLLT --------------------------------------------------------------
--------------------------------------------------------------------------------

opaque SimplicialLLT.nonemptytype (n : USize) : NonemptyType
def SimplicialLLT (n : USize) : Type := SimplicialLLT.nonemptytype n |>.type
instance {n : USize} : Nonempty (SimplicialLLT n) := SimplicialLLT.nonemptytype n |>.property

@[extern "eigenlean_SimplicialLLT_mk"]
opaque SparseMatrix.simplicialLLT (A : @& SparseMatrix n n) : SimplicialLLT n

@[extern "eigenlean_SimplicialLLT_solve"]
opaque SimplicialLLT.solve {n m} (SimplicialLLT : @& SimplicialLLT n) (rhs : @& Matrix n m) : Matrix n m



--- SimplicialLDLT -------------------------------------------------------------
--------------------------------------------------------------------------------

opaque SimplicialLDLT.nonemptytype (n : USize) : NonemptyType
def SimplicialLDLT (n : USize) : Type := SimplicialLDLT.nonemptytype n |>.type
instance {n : USize} : Nonempty (SimplicialLDLT n) := SimplicialLDLT.nonemptytype n |>.property

@[extern "eigenlean_SimplicialLDLT_mk"]
opaque SparseMatrix.ldlt (A : @& SparseMatrix n n) : SimplicialLDLT n

@[extern "eigenlean_SimplicialLDLT_solve"]
opaque SimplicialLDLT.solve {n m} (SimplicialLDLT : @& SimplicialLDLT n) (rhs : @& Matrix n m) : Matrix n m



--- SparseLU -------------------------------------------------------------------
--------------------------------------------------------------------------------

-- opaque SparseLU.nonemptytype (n : USize) : NonemptyType
-- def SparseLU (n : USize) : Type := SparseLU.nonemptytype n |>.type
-- instance {n : USize} : Nonempty (SparseLU n) := SparseLU.nonemptytype n |>.property

-- @[extern "eigenlean_SparseLU_mk"]
-- opaque SparseMatrix.lu (A : @& SparseMatrix n n) : SparseLU n

-- @[extern "eigenlean_SparseLU_solve"]
-- opaque SparseLU.solve {n m} (SparseLU : @& SparseLU n) (rhs : @& Matrix n m) : Matrix n m



--- SparseQR -------------------------------------------------------------------
--------------------------------------------------------------------------------

opaque SparseQR.nonemptytype (n m : USize) : NonemptyType
def SparseQR (n m : USize) : Type := SparseQR.nonemptytype n m |>.type
instance {n m : USize} : Nonempty (SparseQR n m) := SparseQR.nonemptytype n m |>.property

/-- Compute QR decomposition of matrix A. 

Eigen reference: https://eigen.tuxfamily.org/dox/classEigen_1_1SparseQR.html

Warning: Matrix A will be compressed before computing QR decompositions. Therefore A will be copied if it is shared!
-/
@[extern "eigenlean_SparseQR_mk"]
opaque SparseMatrix.qr (A : SparseMatrix n n) : SparseQR n m

/-- Solves A*x=rhs given QR decomposition of matrix A. 

Eigen reference: https://eigen.tuxfamily.org/dox/classEigen_1_1SparseQR.html
-/
@[extern "eigenlean_SparseQR_solve"]
opaque SparseQR.solve {n m k} (SparseQR : @& SparseQR n m) (rhs : @& Matrix n k) : Matrix m k



--- ConjugateGradient -------------------------------------------------------------------
--------------------------------------------------------------------------------

-- opaque ConjugateGradient.nonemptytype (n : USize) : NonemptyType
-- def ConjugateGradient (n : USize) : Type := ConjugateGradient.nonemptytype n |>.type
-- instance {n : USize} : Nonempty (ConjugateGradient n) := ConjugateGradient.nonemptytype n |>.property

-- @[extern "eigenlean_ConjugateGradient_mk"]
-- opaque SparseMatrix.cg (A : SparseMatrix n n) : ConjugateGradient n

-- @[extern "eigenlean_ConjugateGradient_solve"]
-- opaque ConjugateGradient.solve {n m} (ConjugateGradient : @& ConjugateGradient n) (rhs : @& Matrix n m) (maxIter : USize := n) (tol : Float := 1e-8) : Matrix n m
