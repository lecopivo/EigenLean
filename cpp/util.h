#pragma once
#include <Eigen/Dense>
#include <lean/lean.h>

extern "C" lean_object * eigenlean_get_matrix_array(size_t n, size_t m, lean_object * matrix);
extern "C" size_t eigenlean_get_matrix_rows(b_lean_obj_arg matrix);
extern "C" size_t eigenlean_get_matrix_cols(b_lean_obj_arg matrix);
extern "C" lean_object * eigenlean_array_to_matrix(lean_object * array, size_t n, size_t m, lean_object*);

double * eigenlean_get_matrix_ptr(size_t n, size_t m, b_lean_obj_arg matrix);
Eigen::Map<Eigen::MatrixXd> to_eigenMatrix(lean_object * matrix, size_t n, size_t m);
