#include "util.h"

double * eigenlean_get_matrix_ptr(size_t n, size_t m, b_lean_obj_arg matrix){
  return lean_float_array_cptr(eigenlean_get_matrix_array(n, m, matrix));
}

Eigen::Map<Eigen::MatrixXd> to_eigenMatrix(lean_object * matrix, size_t n, size_t m){
  return Eigen::Map<Eigen::MatrixXd>(eigenlean_get_matrix_ptr(n, m, matrix), n, m);  
}
