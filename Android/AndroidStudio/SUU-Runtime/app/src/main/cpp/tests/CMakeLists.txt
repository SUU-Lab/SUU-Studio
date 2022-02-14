

cmake_minimum_required(VERSION 3.14)
project(suu_runtime_test)

# GoogleTest requires at least C++11, but SUU-Runtime using C++14
set(CMAKE_CXX_STANDARD 14)

#include(FetchContent)
#FetchContent_Declare(
#        googletest
#        URL https://github.com/google/googletest/archive/609281088cfefc76f9d0ce82e1ff6c30cc3591e5.zip
#)
#
## For Windows: Prevent overriding the parent project's compiler/linker settings
#set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
#FetchContent_MakeAvailable(googletest)

set(GOOGLETEST_ROOT ${ANDROID_NDK}/sources/third_party/googletest/)
add_library(gtest_main STATIC ${GOOGLETEST_ROOT}/src/gtest_main.cc ${GOOGLETEST_ROOT}/src/gtest-all.cc)
target_include_directories(gtest_main PRIVATE ${GOOGLETEST_ROOT})
target_include_directories(gtest_main PUBLIC ${GOOGLETEST_ROOT}/include)

enable_testing()

set(test_src_dir ../../../../../../../../SUU-Runtime-Test/source)

add_executable(suu_runtime_test ${test_src_dir}/Test-Platform/Android/SUU-Runtime-Test-Android.cpp)

include(../static_library/CMakeLists.txt)

target_link_libraries(
        suu_runtime_test
        suu_runtime_static
        gtest_main)

set(include_dir ../../../../../../../../SUU-Runtime/include)

target_include_directories(
        suu_runtime_test
        PUBLIC
        ${include_dir}
        ${GOOGLETEST_ROOT}/include
)

#add_test(NAME suu-runtime-test COMMAND suu_runtime_test)

#include(GoogleTest)
#gtest_discover_tests(suu_runtime_test)
