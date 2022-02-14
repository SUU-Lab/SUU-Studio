
cmake_minimum_required(VERSION 3.16.3)

project("suu_runtime")

set(include_dir ../SUU-Runtime/include)

set(src_dir ../SUU-Runtime/source)

find_package(X11 REQUIRED)

# suu_runtime_static
add_library(
        suu_runtime_static
        STATIC
        ${src_dir}/Runtime-Platform/Linux/SUU-Runtime-Linux.cpp)

target_include_directories(
    suu_runtime_static
    PUBLIC
    ${include_dir})

# suu_runtime
add_executable(
    suu_runtime
    ${src_dir}/Runtime-Platform/Linux/Main.cpp)

target_link_libraries(
        suu_runtime
        suu_runtime_static
        ${X11_LIBRARIES})

target_include_directories(
        suu_runtime
        PUBLIC
        ${include_dir}
)


# suu_runtime_test
# GoogleTest requires at least C++11, but SUU-Runtime using C++14
set(CMAKE_CXX_STANDARD 14)

include(FetchContent)
FetchContent_Declare(
       googletest
       URL https://github.com/google/googletest/archive/609281088cfefc76f9d0ce82e1ff6c30cc3591e5.zip
)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

set(test_src_dir ../SUU-Runtime-Test/source)

add_executable(
    suu_runtime_test
    ${test_src_dir}/Test-Platform/Linux/SUU-Runtime-Test-Linux.cpp)

target_link_libraries(
        suu_runtime_test
        suu_runtime_static
        gtest_main)

target_include_directories(
        suu_runtime_test
        PUBLIC
        ${include_dir}
        ${GOOGLETEST_ROOT}/include
)

include(GoogleTest)
gtest_discover_tests(suu_runtime_test)
