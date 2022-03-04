
cmake_minimum_required(VERSION 3.18.1)

project(suu_runtime_static)

set(PACKAGE_SEARCH_BASE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../../../ThirdParty/Install/Android/grpc-1.44.0/${ANDROID_ABI}/${CMAKE_BUILD_TYPE}/lib/cmake)

set(absl_DIR ${PACKAGE_SEARCH_BASE_DIR}/absl)
set(Protobuf_DIR ${PACKAGE_SEARCH_BASE_DIR}/protobuf)
set(gRPC_DIR ${PACKAGE_SEARCH_BASE_DIR}/grpc)
set(CMAKE_MODULE_PATH
        ${CMAKE_MODULE_PATH}
        ${absl_DIR}
        ${Protobuf_DIR}
        ${gRPC_DIR})

find_package(absl CONFIG REQUIRED)
find_package(Protobuf CONFIG REQUIRED)
find_package(gRPC CONFIG REQUIRED)

set(include_dir ../../../../../../../../SUU-Runtime/include)
set(src_dir ../../../../../../../../SUU-Runtime/source)

add_library(
        suu_runtime_static
        STATIC
        ${src_dir}/Runtime/Remote/HelloTest.cpp
        ${src_dir}/Runtime-Platform/Android/Remote/Hello.grpc.pb.cc
        ${src_dir}/Runtime-Platform/Android/Remote/Hello.pb.cc
        ${src_dir}/Runtime-Platform/Android/SUU-Runtime-Android.cpp)

target_compile_definitions(
        suu_runtime_static
        PUBLIC
        SUU_RUNTIME_PLATFORM_ANDROID=1)

target_link_libraries(
        suu_runtime_static
        gRPC::grpc++
        gRPC::grpc++_reflection
        protobuf::libprotobuf)

target_include_directories(
        suu_runtime_static
        PUBLIC
        ${include_dir}
        ${src_dir})

