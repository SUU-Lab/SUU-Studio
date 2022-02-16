#!/bin/bash


CURRENT=$(cd $(dirname $0);pwd)
pushd $CURRENT

INSTALL_DIR=Install/Linux

# Install pre-requisites
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p $INSTALL_DIR
fi

pushd Install/Linux

echo ---------- CMake ----------
CMAKE_VERSION=3.22.2
CMAKE_ARCHIVE_NAME=cmake-$CMAKE_VERSION-linux-x86_64
CMAKE_PATH=$CURRENT/$INSTALL_DIR/$CMAKE_ARCHIVE_NAME/bin
CMAKE_PATH_NAME="$CMAKE_PATH"
if [ ! -d $CMAKE_PATH_NAME ]; then
    wget -q https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/$CMAKE_ARCHIVE_NAME.tar.gz
    tar zxf $CMAKE_ARCHIVE_NAME.tar.gz
    rm -rf $CMAKE_ARCHIVE_NAME.tar.gz
fi

$CMAKE_PATH/cmake --version

# pop $INSTALL_DIR
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
GRPC_INSTALL_DIR=$CURRENT/$INSTALL_DIR/grpc-$GRPC_VERSION

if [ ! -d "$BUILD_DIR" ]; then
    mkdir $BUILD_DIR
fi

$CMAKE_PATH/cmake \
-DgRPC_INSTALL=ON \
-DgRPC_BUILD_TESTS=OFF \
-DCMAKE_INSTALL_PREFIX=$GRPC_INSTALL_DIR \
-DCMAKE_BUILD_TYPE=Release \
-B$BUILD_DIR

pushd $BUILD_DIR
make
make install
popd

# pop grpc
popd

# pop Repositories
popd

# pop CURRENT
popd
