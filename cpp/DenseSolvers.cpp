#include "util.h"
#include "CppClass.h"
#include <Eigen/src/Core/util/Constants.h>
#include <lean/lean.h>


// PartialPivLU

// C bindig for `Matrix.partialPivLu`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_partial_piv_lu(size_t n, b_lean_obj_arg matrix){

  auto const& A = to_eigenMatrix(matrix, n, n);

  auto lu = new Eigen::PartialPivLU<Eigen::MatrixXd>{A};

  return of_cppClass(lu);
}

// C bindings for `PartialPivLU.solve`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_partial_piv_lu_solve(size_t n, size_t m, b_lean_obj_arg _lu, b_lean_obj_arg _rhs){

  auto const& lu = *to_cppClass<Eigen::PartialPivLU<Eigen::MatrixXd>>(_lu);
  auto const& rhs = to_eigenMatrix(_rhs, n, m);

  lean_object * result = lean_alloc_sarray(sizeof(double), n*m, n*m); 

  auto lhs = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), n, m);

  lhs = lu.solve(rhs);
  
  return eigenlean_array_to_matrix(result, n, m, nullptr);
}

// FullPivLU 

// C bindings for `Matrix.fullPivLU`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_full_piv_lu(size_t n, size_t m, b_lean_obj_arg matrix){

  auto const& A = to_eigenMatrix(matrix, n, m);

  auto lu = new Eigen::FullPivLU<Eigen::MatrixXd>{A};

  return of_cppClass(lu);
}

// C bindings for `FullPivLU.solve`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_full_piv_lu_solve(size_t n, size_t m, size_t k, b_lean_obj_arg _lu, b_lean_obj_arg _rhs){

  auto const& lu = *to_cppClass<Eigen::FullPivLU<Eigen::MatrixXd>>(_lu);
  auto const& rhs = to_eigenMatrix(_rhs, n, k);

  lean_object * result = lean_alloc_sarray(sizeof(double), m*k, m*k); 

  auto lhs = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), m, k);

  lhs = lu.solve(rhs);

  return eigenlean_array_to_matrix(result, m, k, nullptr);
}


// ColPivHouseholderQR

// C bindings for `Matrix.colPivHouseholderQR`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_col_piv_householder_qr(size_t n, size_t m, b_lean_obj_arg matrix){

  auto const& A = to_eigenMatrix(matrix, n, m);

  auto qr = new Eigen::ColPivHouseholderQR<Eigen::MatrixXd>{A};

  return of_cppClass(qr);
}


// C bindings for `ColPivHouseholderQR.solve`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_col_piv_householder_qr_solve(size_t n, size_t m, size_t k, b_lean_obj_arg _qr, b_lean_obj_arg _rhs){

  auto const& qr = *to_cppClass<Eigen::ColPivHouseholderQR<Eigen::MatrixXd>>(_qr);
  auto const& rhs = to_eigenMatrix(_rhs, n, k);

  lean_object * result = lean_alloc_sarray(sizeof(double), m*k, m*k); 

  auto lhs = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), m, k);

  lhs = qr.solve(rhs);

  return eigenlean_array_to_matrix(result, m, k, nullptr);
}


// FullPivHouseholderQR

// C bindings for `Matrix.fullPivHouseholderQR`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_full_piv_householder_qr(size_t n, size_t m, b_lean_obj_arg matrix){

  auto const& A = to_eigenMatrix(matrix, n, m);

  auto qr = new Eigen::FullPivHouseholderQR<Eigen::MatrixXd>{A};

  return of_cppClass(qr);
}


// C bindings for `FullPivHouseholderQR.solve`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_full_piv_householder_qr_solve(size_t n, size_t m, size_t k, b_lean_obj_arg _qr, b_lean_obj_arg _rhs){

  auto const& qr = *to_cppClass<Eigen::FullPivHouseholderQR<Eigen::MatrixXd>>(_qr);
  auto const& rhs = to_eigenMatrix(_rhs, n, k);

  lean_object * result = lean_alloc_sarray(sizeof(double), m*k, m*k); 

  auto lhs = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), m, k);

  lhs = qr.solve(rhs);

  return eigenlean_array_to_matrix(result, m, k, nullptr);
}


// LLT

// C bindings for `Matrix.llt`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_llt(size_t n, b_lean_obj_arg matrix){

  auto const& A = to_eigenMatrix(matrix, n, n);

  auto llt = new Eigen::LLT<Eigen::MatrixXd>{A};

  return of_cppClass(llt);
}


// C bindings for `LLT.solve`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_llt_solve(size_t n, size_t m, b_lean_obj_arg _llt, b_lean_obj_arg _rhs){

  auto const& llt = *to_cppClass<Eigen::LLT<Eigen::MatrixXd>>(_llt);
  auto const& rhs = to_eigenMatrix(_rhs, n, m);

  lean_object * result = lean_alloc_sarray(sizeof(double), n*m, n*m); 

  auto lhs = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), n, m);

  lhs = llt.solve(rhs);

  return eigenlean_array_to_matrix(result, n, m, nullptr);
}


// LDLT

// C bindings for `Matrix.ldlt`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_ldlt(size_t n, b_lean_obj_arg matrix){

  auto const& A = to_eigenMatrix(matrix, n, n);

  auto ldlt = new Eigen::LDLT<Eigen::MatrixXd>{A};

  return of_cppClass(ldlt);
}

// C bindings for `LDLT.solve`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_ldlt_solve(size_t n, size_t m, b_lean_obj_arg _ldlt, b_lean_obj_arg _rhs){ // b_lean_obj_arg _rhs)

  auto const& ldlt = *to_cppClass<Eigen::LDLT<Eigen::MatrixXd>>(_ldlt);
  auto const& rhs  = to_eigenMatrix(_rhs, n, m);

  // `FloatArray` is just `sarray`, see for example `lean_mk_empty_float_array`
  lean_object * result = lean_alloc_sarray(sizeof(double), n*m, n*m); 

  auto lhs = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), n, m);

  lhs = ldlt.solve(rhs);
  
  return eigenlean_array_to_matrix(result, n, m, nullptr);
}




// JacobiSVD

// C bindings for `Matrix.jacobiSVD`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_jacobi_svd(size_t n, size_t m, b_lean_obj_arg matrix){

  auto const& A = to_eigenMatrix(matrix, n, m);

  auto svd = new Eigen::JacobiSVD<Eigen::MatrixXd>{A, Eigen::ComputeFullU | Eigen::ComputeFullV};

  return of_cppClass(svd);
}


// C bindings for `JacobiSVD.singularValues`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_jacobi_svd_singular_values(size_t n, size_t m, b_lean_obj_arg _svd){

  auto const& svd = *to_cppClass<Eigen::JacobiSVD<Eigen::MatrixXd>>(_svd);

  auto const& singularValues = svd.singularValues();

  lean_object * result = lean_alloc_sarray(sizeof(double), singularValues.size(), singularValues.size());

  std::copy(singularValues.data(), singularValues.data() + singularValues.size(), lean_float_array_cptr(result));

  return result;
}

// C bindings for `JacobiSDF.matrixU`
extern "C" LEAN_EXPORT lean_obj_res eigenlean_jacobi_svd_matrix_u(size_t n, size_t m, b_lean_obj_arg _svd){

  auto const& svd = *to_cppClass<Eigen::JacobiSVD<Eigen::MatrixXd>>(_svd);

  svd.computeU();
  auto const& U = svd.matrixU();

  lean_object * result = lean_alloc_sarray(sizeof(double), U.rows()*U.cols(), U.rows()*U.cols());

  std::copy(U.data(), U.data() + U.rows()*U.cols(), lean_float_array_cptr(result));

  return eigenlean_array_to_matrix(result, U.rows(), U.cols(), nullptr);
}




