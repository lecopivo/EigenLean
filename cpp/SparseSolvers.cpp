#include "CppClass.h"
#include <Eigen/Sparse>
#include <Eigen/SparseLU>
#include <Eigen/SparseQR>
#include <Eigen/SparseCholesky>

#include <lean/lean.h>

#include "CppClass.h"
#include "util.h"

extern "C" LEAN_EXPORT lean_obj_res eigenlean_SimplicialLLT_mk(size_t n, b_lean_obj_arg objA){

  auto const& A = *to_cppClass<Eigen::SparseMatrix<double>>(objA);

  auto llt = new Eigen::SimplicialLLT<Eigen::SparseMatrix<double>>{A};

  return CppClass_to_lean(&llt);;
}


extern "C" LEAN_EXPORT lean_obj_res eigenlean_SimplicialLLT_solve(size_t n, size_t m, b_lean_obj_arg objllt, b_lean_obj_arg objrhs){

  auto const& llt = *to_cppClass<Eigen::SimplicialLLT<Eigen::SparseMatrix<double>>>(objllt);
  auto const& rhs  = to_eigenMatrix(objrhs, n, m);

    // `FloatArray` is just `sarray`, see for example `lean_mk_empty_float_array`
  lean_object * result = lean_alloc_sarray(sizeof(double), n*m, n*m); 

  auto lhs = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), n, m);

  lhs = llt.solve(rhs);

  return eigenlean_array_to_matrix(result, n, m, nullptr);;
}
