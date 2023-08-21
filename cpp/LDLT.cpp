#include "util.h"
#include "CppClass.h"

extern "C" LEAN_EXPORT lean_obj_res eigenlean_ldlt(size_t n, b_lean_obj_arg matrix){

  auto const& A = to_eigenMatrix(matrix, n, n);

  auto ldlt = new Eigen::LDLT<Eigen::MatrixXd>{A};

  return of_cppClass(ldlt);
}

extern "C" LEAN_EXPORT lean_obj_res eigenlean_ldlt_solve(size_t n, size_t m, b_lean_obj_arg _ldlt, b_lean_obj_arg _rhs){ // b_lean_obj_arg _rhs)

  auto const& ldlt = *to_cppClass<Eigen::LDLT<Eigen::MatrixXd>>(_ldlt);
  auto const& rhs  = to_eigenMatrix(_rhs, n, m);

  // `FloatArray` is just `sarray`, see for example `lean_mk_empty_float_array`
  lean_object * result = lean_alloc_sarray(sizeof(double), n*m, n*m); 

  auto lhs = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), n, m);

  lhs = ldlt.solve(rhs);
  
  return eigenlean_array_to_matrix(result, n, m, nullptr);
}



