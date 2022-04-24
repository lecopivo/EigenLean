cmake_minimum_required(VERSION 3.0)
project(myproject)
 
find_package(Eigen3 3.3 REQUIRED NO_MODULE)
 
add_library(EigenLean STATIC LDLT.cpp SparseMatrix.cpp)
target_link_libraries(EigenLean Eigen3::Eigen)

