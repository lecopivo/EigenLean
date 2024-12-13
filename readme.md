# Lean 4 interface to Eigen

Proof of concept for interfacing Eigen's linear solvers in Lean 4.

# Installation

To compile and build examples:
```
lake build dense sparse
```

It is required that you have `cmake` and `eigen3` installed on your system. For example on Ubuntu you can install these with:
```
sudo apt-get install libeigen3-dev cmake
```


# Dense Matrix

An example of solving simple 2x2 system with LDLT:
```
def main : IO Unit := do
  let A : Matrix 2 2 := ⟨FloatArray.mk #[2,1,1,2], by native_decide⟩
  let b ← Matrix.rand 2 1
  let x := A.ldlt.solve b
  let b' := A.matmul x

  IO.println s!"A = {A}"
  IO.println s!"b = {b}"
  IO.println s!"x = A⁻¹*b = {x}"
  IO.println s!"A*x = {b'}"
```
Running this produces
```
$ ./.lake/build/bin/dense

A = [2.000000, 1.000000, 1.000000, 2.000000]
b = [0.541198, 0.432483]
x = A⁻¹*b = [0.216638, 0.107922]
A*x = [0.541198, 0.432483]
```

# Sparse Matrix

```
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
```
Running this produces
```
$ ./.lake/build/bin/sparse

A  = [2.000000, 1.000000, 1.000000, 2.000000]
b  = [0.604736, 0.884092]
x = A⁻¹*b = [0.108460, 0.387816]
A*x = [0.604736, 0.884092]
```


# Contributing

Testing this library on Windows and Mac would be highly appreciated and setting up CI for all platforms.

Writting more bindings for basic operations. This usuall consists of two parts:

1. Declare Lean function
```
@[extern "eigenlean_matrix_matmul"]
opaque Matrix.matmul {n m k : USize} (A : @& Matrix n m) (x : @& Matrix m k) : Matrix n k
```

2. Provide C/C++ implementation
```
extern "C" LEAN_EXPORT lean_obj_res eigenlean_matrix_matmul(size_t n, size_t m, size_t k, b_lean_obj_arg _A, b_lean_obj_arg _x){

  auto const& A = to_eigenMatrix(_A, n, m);
  auto const& x = to_eigenMatrix(_x, m, k);

  lean_object * result = lean_alloc_sarray(sizeof(double), n*k, 1);

  auto y = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), n, k);

  y = A*x;

  return eigenlean_array_to_matrix(result, m, 1, nullptr);
}
```

