cmake_minimum_required(VERSION 3.0)
project(myproject)

find_package(Eigen3 3.3 REQUIRED NO_MODULE)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# add_library(EigenLean STATIC DenseSolvers.cpp SparseMatrix.cpp SparseSolvers.cpp util.cpp)
add_library(EigenLeanCpp SHARED DenseSolvers.cpp SparseMatrix.cpp SparseSolvers.cpp util.cpp)

# target_include_directories(EigenLean PUBLIC ${LEAN_SYSROOT}/include/)
target_include_directories(EigenLeanCpp PUBLIC ${LEAN_SYSROOT}/include/)

# target_link_libraries(EigenLean Eigen3::Eigen)
target_link_libraries(EigenLeanCpp Eigen3::Eigen)

