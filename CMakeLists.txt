cmake_minimum_required(VERSION 3.10)
project(K_Means_Mio_Cpp)

# Use system default C++ compiler
# set(CMAKE_CXX_COMPILER "/usr/local/opt/llvm/bin/clang++")

# Enable OpenMP support
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fopenmp")
find_package(OpenMP REQUIRED)

set(SOURCE_FILES main_sequential.cpp Point.h Cluster.h main_parallel.cpp)
add_executable(main main_sequential.cpp Point.h Cluster.h)
target_link_libraries(main PRIVATE OpenMP::OpenMP_CXX)

add_executable(main_parallel main_parallel.cpp Point.h Cluster.h)
target_link_libraries(main_parallel PRIVATE OpenMP::OpenMP_CXX)
