#include "util.h"
#include "CppClass.h"
#include <iostream>

#include <Eigen/Sparse>

extern "C" size_t eigenlean_triplets_get_row(size_t, size_t, lean_object*, size_t, lean_object*);
extern "C" size_t eigenlean_triplets_get_col(size_t, size_t, lean_object*, size_t, lean_object*);
extern "C" double eigenlean_triplets_get_val(size_t, size_t, lean_object*, size_t, lean_object*);
extern "C" lean_object * eigenlean_array_to_matrix(lean_object * array, size_t n, size_t m, lean_object*);

struct TripletIterator {
  using value_type = double;
  lean_object * lean_array;
  size_t i;

  Eigen::Index row() const{
    lean_inc(lean_array);
    return eigenlean_triplets_get_row(0, 0, lean_array, i, nullptr);
  }
  
  Eigen::Index col() const{
    lean_inc(lean_array);
    return eigenlean_triplets_get_col(0, 0, lean_array, i, nullptr);
  }
  
  double value() const{
    lean_inc(lean_array);
    return eigenlean_triplets_get_val(0, 0, lean_array, i, nullptr);
  }
  
  TripletIterator const* operator->() const{
    return this;
  }

  TripletIterator& operator++(){
    i++;
    return *this;
  }

  bool operator!=(TripletIterator const& it) const{
    return (i != it.i);
  }
};

extern "C" LEAN_EXPORT lean_obj_res eigenlean_sparse_matrix_mk_from_triplets(size_t n , size_t m, b_lean_obj_arg entries){

  size_t N = lean_array_size(entries);
  
  auto A = new Eigen::SparseMatrix<double>{(Eigen::Index)n, (Eigen::Index)m};

  TripletIterator begin = {entries, 0};
  TripletIterator end = {entries, N};

  A->setFromTriplets(begin, end);
  
  return of_cppClass(A);
}

extern "C" LEAN_EXPORT lean_obj_res eigenlean_sparse_matrix_mk_zero(size_t n , size_t m){

  auto A = new Eigen::SparseMatrix<double>{(Eigen::Index)n, (Eigen::Index)m};
  
  return of_cppClass(A);
}

extern "C" LEAN_EXPORT lean_obj_res eigenlean_sparse_matrix_mk_identity(size_t n){

  auto A = new Eigen::SparseMatrix<double>{(Eigen::Index)n, (Eigen::Index)n};

  A->setIdentity();
  
  return of_cppClass(A);
}

extern "C" LEAN_EXPORT lean_obj_res eigenlean_sparse_matrix_to_dense(size_t n, size_t m, b_lean_obj_arg _A){

  auto A = to_cppClass<Eigen::SparseMatrix<double>>(_A);

    // `FloatArray` is just `sarray`, see for example `lean_mk_empty_float_array`
  lean_object * result = lean_alloc_sarray(sizeof(double), n*m, n*m); 

  auto denseA = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), n, m);

  denseA = *A;
  
  return eigenlean_array_to_matrix(result, n, m, nullptr);
}


extern "C" LEAN_EXPORT lean_obj_res eigenlean_sparse_matrix_mk_exclusive(lean_obj_res objA){

  if (lean_is_exclusive(objA)){
    return objA;
  } else {
    auto const& A = *to_cppClass<Eigen::SparseMatrix<double>>(objA);
    auto copyA = new Eigen::SparseMatrix<double>{A};
    return of_cppClass(copyA);
  }
}

extern "C" LEAN_EXPORT uint8_t eigenlean_sparse_matrix_is_compressed(size_t n, size_t m, b_lean_obj_res objA){

  auto const& A = *to_cppClass<Eigen::SparseMatrix<double>>(objA);

  return A.isCompressed();
}

extern "C" LEAN_EXPORT lean_obj_res eigenlean_sparse_matrix_make_compressed(size_t n, size_t m, lean_obj_arg objA){

    lean_obj_arg uniqueA = cppClass_make_exclusive<Eigen::SparseMatrix<double>>(objA); // eigenlean_sparse_matrix_mk_exclusive(objA);

  auto& A = *to_cppClass<Eigen::SparseMatrix<double>>(uniqueA);

  A.makeCompressed();
  
  return uniqueA;
}


// C bindig for sparse matrix and dense matrix multiplication
extern "C" LEAN_EXPORT lean_obj_res eigenlean_sparse_matrix_densemul(size_t n, size_t m, size_t k, b_lean_obj_arg _A, b_lean_obj_arg _x){

  auto const& A = *to_cppClass<Eigen::SparseMatrix<double>>(_A);
  auto const& x = to_eigenMatrix(_x, m, k);

  lean_object * result = lean_alloc_sarray(sizeof(double), n*k, 1);

  auto y = Eigen::Map<Eigen::MatrixXd>(lean_float_array_cptr(result), n, k);

  y = A*x;

  return eigenlean_array_to_matrix(result, m, 1, nullptr);
}

extern "C" LEAN_EXPORT lean_obj_res eigenlean_sparse_matrix_densemul_out(size_t n, size_t m, size_t k, b_lean_obj_arg _A, b_lean_obj_arg _x, lean_obj_arg _out){

  if (lean_is_exclusive(_out)) {
    auto const& A = *to_cppClass<Eigen::SparseMatrix<double>>(_A);
    auto const& x = to_eigenMatrix(_x, m, k);
    auto out = to_eigenMatrix(_out, n, k);

    out = A*x;

    return _out;

  } else {
    if (_out->m_rc > 1) {
      std::cout << "warning: running `Matrix.vecmul!` with shared `out` argument!" << std::endl;
    }

    return eigenlean_sparse_matrix_densemul(n, m, k, _A, _x);
  }
}
