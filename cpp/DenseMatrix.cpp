#include "util.h"
#include "CppClass.h"
#include <Eigen/src/Core/util/Constants.h>
#include <lean/lean.h>
#include <assert.h>
#include <iostream>


// Matmul

// C bindig for matrix vector multiplication
extern "C" LEAN_EXPORT lean_obj_res eigenlean_matrix_matmul(size_t n, size_t m, size_t k, b_lean_obj_arg _A, b_lean_obj_arg _x){

  auto const& A = to_eigenMatrix(_A, n, m);
  auto const& x = to_eigenMatrix(_x, m, k);

  lean_object * result = lean_alloc_sarray(sizeof(double), n*k, 1);

  auto y = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), n, k);

  y = A*x;

  return eigenlean_array_to_matrix(result, m, 1, nullptr);
}

// C bindig for matrix vector multiplication with output buffer
extern "C" LEAN_EXPORT lean_obj_res eigenlean_matrix_matmul_out(size_t n, size_t m, size_t k, b_lean_obj_arg _A, b_lean_obj_arg _x, lean_obj_arg _out){

  if (lean_is_exclusive(_out)) {
    auto const& A = to_eigenMatrix(_A, n, m);
    auto const& x = to_eigenMatrix(_x, m, k);
    auto out = to_eigenMatrix(_out, n, k);

    out = A*x;

    return _out;

  } else {
    if (_out->m_rc > 1) {
      std::cout << "warning: running `Matrix.vecmul!` with shared `out` argument!" << std::endl;
    }

    return eigenlean_matrix_matmul(n, m, k, _A, _x);
  }
}

