
cmake_minimum_required(VERSION 3.18.1)

project(suu_runtime_static)

set(include_dir ../../../../../../../../SUU-Runtime/include)

set(src_dir ../../../../../../../../SUU-Runtime/source)

include_directories(${include_dir})

add_library(
        suu_runtime_static
        STATIC
        ${src_dir}/Runtime-Platform/Android/SUU-Runtime-Android.cpp)

