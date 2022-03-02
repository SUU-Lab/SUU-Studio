#!/bin/bash


CURRENT=$(cd $(dirname $0);pwd)
pushd $CURRENT

INSTALL_DIR=Install/Linux

if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p $INSTALL_DIR
fi

# Clone and build
if [ ! -d "Repositories" ]; then
    mkdir Repositories
fi

pushd Repositories

GRPC_VERSION=1.43.0

if [ ! -d "grpc" ]; then
    git clone --recurse-submodules -b v$GRPC_VERSION https://github.com/grpc/grpc
fi

pushd grpc

BUILD_DIR=.build_Linux

if [ ! -d "$BUILD_DIR" ]; then
    mkdir $BUILD_DIR
fi

function build_grpc() {
    echo ---------- Build gRPC $1 ----------
    BUILD_CONFIGURATION=$1
    GRPC_INSTALL_DIR=$CURRENT/$INSTALL_DIR/grpc-$GRPC_VERSION/$BUILD_CONFIGURATION

    cmake \
    -GNinja \
    -DgRPC_INSTALL=ON \
    -DgRPC_BUILD_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=$GRPC_INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=$BUILD_CONFIGURATION \
    -B$BUILD_DIR

    cmake --build $BUILD_DIR
    cmake --install $BUILD_DIR --prefix $GRPC_INSTALL_DIR
}

build_grpc Debug
build_grpc Release

# pop grpc
popd

# pop Repositories
popd

# pop CURRENT
popd
