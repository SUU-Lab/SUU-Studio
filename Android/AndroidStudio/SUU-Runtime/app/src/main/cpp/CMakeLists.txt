
cmake_minimum_required(VERSION 3.18.1)

project("suu_runtime")

add_library(
        suu_runtime
        SHARED
        native-lib.cpp)

add_subdirectory(static_library)

target_link_libraries(
        suu_runtime
        suu_runtime_static)

set(include_dir ../../../../../../../SUU-Runtime/include)

target_include_directories(
        suu_runtime
        PUBLIC
        ${include_dir}
)
