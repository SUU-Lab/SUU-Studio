#!/bin/bash


CURRENT=$(cd $(dirname $0);pwd)
pushd $CURRENT

INSTALL_DIR=Install/Android

if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p $INSTALL_DIR
fi

# Clone and build
if [ ! -d "Repositories" ]; then
    mkdir Repositories
fi

pushd Repositories

GRPC_VERSION=1.44.0

if [ ! -d "grpc" ]; then
    git clone --recurse-submodules -b v$GRPC_VERSION https://github.com/grpc/grpc
fi

pushd grpc

SDK_DIR=$1
NDK_VERSION=21.4.7075529
NDK_DIR=$SDK_DIR/ndk/$NDK_VERSION

CMAKE_VERSION=3.18.1
ANDROID_CMAKE_PATH=$SDK_DIR/cmake/$CMAKE_VERSION/bin

$ANDROID_CMAKE_PATH/cmake --version

function build_grpc() {
    echo ---------- Build gRPC $1 $2 $3 ----------

    BUILD_ABI=$1
    BUILD_API_LEVEL=$2
    BUILD_CONFIGURATION=$3

    BUILD_DIR=".build_${BUILD_ABI}_Android"
    GRPC_INSTALL_DIR=$CURRENT/$INSTALL_DIR/grpc-$GRPC_VERSION/$BUILD_CONFIGURATION

    if [ ! -d "$BUILD_DIR" ]; then
        mkdir $BUILD_DIR
    fi

    $ANDROID_CMAKE_PATH/cmake \
	-H. \
	-DgRPC_INSTALL=ON \
	-DgRPC_BUILD_TESTS=OFF \
	-DABSL_NO_XRAY_ATTRIBUTES=1 \
	-DCMAKE_SYSTEM_NAME=Android \
	-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
	-DCMAKE_SYSTEM_VERSION=$BUILD_API_LEVEL \
	-DANDROID_PLATFORM=android-$BUILD_API_LEVEL \
	-DANDROID_ABI=$BUILD_ABI \
	-DCMAKE_ANDROID_ARCH_ABI=$BUILD_ABI \
	-DANDROID_NDK=$NDK_DIR \
	-DCMAKE_ANDROID_NDK=$NDK_DIR \
	-DCMAKE_TOOLCHAIN_FILE=$NDK_DIR/build/cmake/android.toolchain.cmake \
	-DCMAKE_MAKE_PROGRAM=$ANDROID_CMAKE_PATH/ninja \
	-DCMAKE_CXX_FLAGS=-std=c++14 \
	-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=".lib_${BUILD_ABI}_${BUILD_CONFIGURATION}" \
	-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=".bin_${BUILD_ABI}_${BUILD_CONFIGURATION}" \
	-DCMAKE_BUILD_TYPE=$BUILD_CONFIGURATION \
	-DANDROID_STL=c++_shared \
	-GNinja \
	-DCMAKE_INSTALL_PREFIX=$GRPC_INSTALL_DIR \
	-B$BUILD_DIR

    echo ---------- build ----------
    $ANDROID_CMAKE_PATH/cmake --build $BUILD_DIR

    echo ---------- install ----------
    $ANDROID_CMAKE_PATH/cmake --install $BUILD_DIR --prefix $GRPC_INSTALL_DIR
}

# build_grpc arm64-v8a 21 Debug
# build_grpc arm64-v8a 21 Release

# build_grpc armeabi-v7a 21 Debug
# build_grpc armeabi-v7a 21 Release

build_grpc x86_64 21 Debug
# build_grpc x86_64 21 Release

# build_grpc x86 21 Debug
# build_grpc x86 21 Release

# pop grpc
popd

# pop Repositories
popd

# pop CURRENT
popd
