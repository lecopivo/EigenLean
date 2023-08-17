cmake_minimum_required(VERSION 3.0)
project(myproject)
 
find_package(Eigen3 3.3 REQUIRED NO_MODULE)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
 
add_library(EigenLean STATIC LDLT.cpp SparseMatrix.cpp SparseSolvers.cpp)

target_link_libraries(EigenLean Eigen3::Eigen)


