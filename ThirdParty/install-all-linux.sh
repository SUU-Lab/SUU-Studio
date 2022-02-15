#!/bin/bash


CURRENT=$(cd $(dirname $0);pwd)
pushd $CURRENT

# Install pre-requisites
if [ ! -d "Install" ]; then
    mkdir Install
fi

pushd Install

echo ---------- CMake ----------
CMAKE_VERSION=3.22.2
CMAKE_ARCHIVE_NAME=cmake-$CMAKE_VERSION-linux-x86_64
CMAKE_PATH=$CURRENT/Install/$CMAKE_ARCHIVE_NAME/bin
CMAKE_PATH_NAME="$CMAKE_PATH"
if [ ! -d $CMAKE_PATH_NAME ]; then
    echo "$CMAKE_PATH_NAME is not exist."
    wget -q https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/$CMAKE_ARCHIVE_NAME.tar.gz
    tar zxf $CMAKE_ARCHIVE_NAME.tar.gz
    rm -rf $CMAKE_ARCHIVE_NAME.tar.gz
fi

export CMAKE_PATH
$CMAKE_PATH/cmake --version

# pop Install
popd

# Clone and build
if [ ! -d "Repositories" ]; then
    mkdir Repositories
fi

pushd Repositories

GRPC_VERSION=1.43.0

echo ---------- gRPC ----------
if [ ! -d "grpc" ]; then
    git clone --recurse-submodules -b v$GRPC_VERSION https://github.com/grpc/grpc
fi

pushd grpc

BUILD_DIR=.build_Linux
INSTALL_DIR=$CURRENT/../Install/Linux/grpc-$GRPC_VERSION

if [ ! -d "$BUILD_DIR" ]; then
    mkdir $BUILD_DIR
fi

$CMAKE_PATH/cmake \
-DgRPC_INSTALL=ON \
-DgRPC_BUILD_TESTS=OFF \
-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
-DCMAKE_BUILD_TYPE=Release \
-B$BUILD_DIR

if [ ! -d "$BUILD_DIR/Release" ]; then
    pushd $BUILD_DIR
    make
    popd
fi

if [ ! -d "$INSTALL_DIR" ]; then
    pushd $BUILD_DIR
    make install
    popd
fi

# pop grpc
popd

# pop Repositories
popd

# pop CURRENT
popd
