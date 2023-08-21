#include "CppClass.h"
#include "util.h"

#include <Eigen/Sparse>
#include <Eigen/SparseLU>
#include <Eigen/SparseQR>
#include <Eigen/SparseCholesky>


//- SimplicialLLT --------------------------------------------------------------
//------------------------------------------------------------------------------

extern "C" LEAN_EXPORT lean_obj_res eigenlean_SimplicialLLT_mk(size_t n, b_lean_obj_arg objA){

  auto const& A = *to_cppClass<Eigen::SparseMatrix<double>>(objA);

  auto llt = new Eigen::SimplicialLLT<Eigen::SparseMatrix<double>>{A};

  return of_cppClass(llt);;
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


//- SimplicialLDLT -------------------------------------------------------------
//------------------------------------------------------------------------------

extern "C" LEAN_EXPORT lean_obj_res eigenlean_SimplicialLDLT_mk(size_t n, b_lean_obj_arg objA){

  auto const& A = *to_cppClass<Eigen::SparseMatrix<double>>(objA);

  auto ldlt = new Eigen::SimplicialLDLT<Eigen::SparseMatrix<double>>{A};

  return of_cppClass(ldlt);;
}


extern "C" LEAN_EXPORT lean_obj_res eigenlean_SimplicialLDLT_solve(size_t n, size_t m, b_lean_obj_arg objldlt, b_lean_obj_arg objrhs){

  auto const& ldlt = *to_cppClass<Eigen::SimplicialLDLT<Eigen::SparseMatrix<double>>>(objldlt);
  auto const& rhs  = to_eigenMatrix(objrhs, n, m);

    // `FloatArray` is just `sarray`, see for example `lean_mk_empty_float_array`
  lean_object * result = lean_alloc_sarray(sizeof(double), n*m, n*m);
  

  auto lhs = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), n, m);

  lhs = ldlt.solve(rhs);

  return eigenlean_array_to_matrix(result, n, m, nullptr);;
}


//- SparseLU -------------------------------------------------------------
//------------------------------------------------------------------------------

// extern "C" LEAN_EXPORT lean_obj_res eigenlean_SparseLU_mk(size_t n, b_lean_obj_arg objA){

//   auto const& A = *to_cppClass<Eigen::SparseMatrix<double>>(objA);

//   auto lu = new Eigen::SparseLU<Eigen::SparseMatrix<double>>{A};

//   return of_cppClass(lu);;
// }


// extern "C" LEAN_EXPORT lean_obj_res eigenlean_SparseLU_solve(size_t n, size_t m, b_lean_obj_arg objlu, b_lean_obj_arg objrhs){

//   auto const& lu = *to_cppClass<Eigen::SparseLU<Eigen::SparseMatrix<double>>>(objlu);
//   auto const& rhs  = to_eigenMatrix(objrhs, n, m);

//     // `FloatArray` is just `sarray`, see for example `lean_mk_empty_float_array`
//   lean_object * result = lean_alloc_sarray(sizeof(double), n*m, n*m);
  

//   auto lhs = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), n, m);

//   lhs = lu.solve(rhs);

//   return eigenlean_array_to_matrix(result, n, m, nullptr);;
// }



//- SparseQR -------------------------------------------------------------
//------------------------------------------------------------------------------

using QR = Eigen::SparseQR<Eigen::SparseMatrix<double>, Eigen::COLAMDOrdering<int>>;

extern "C" LEAN_EXPORT lean_obj_res eigenlean_SparseQR_mk(size_t n, size_t m, lean_obj_arg objA){

  auto A = to_cppClass<Eigen::SparseMatrix<double>>(objA);

  lean_object * uniqueA = nullptr;
  if (!A->isCompressed()) {
    uniqueA = cppClass_make_exclusive<Eigen::SparseMatrix<double>>(objA);
    A = to_cppClass<Eigen::SparseMatrix<double>>(uniqueA);
    A->makeCompressed();
  }

  auto qr = new QR{*A};

  lean_dec(objA);
  if (uniqueA) lean_dec(uniqueA);
  
  return of_cppClass(&qr);
}


extern "C" LEAN_EXPORT lean_obj_res eigenlean_SparseQR_solve(size_t n, size_t m, size_t k, b_lean_obj_arg objqr, b_lean_obj_arg objrhs){

  auto const& qr  = *to_cppClass<QR>(objqr);
  auto const& rhs = to_eigenMatrix(objrhs, n, k);

    // `FloatArray` is just `sarray`, see for example `lean_mk_empty_float_array`
  lean_object * result = lean_alloc_sarray(sizeof(double), m*k, m*k);
  
  auto lhs = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), m, k);

  lhs = qr.solve(rhs);

  return eigenlean_array_to_matrix(result, m, k, nullptr);
}

