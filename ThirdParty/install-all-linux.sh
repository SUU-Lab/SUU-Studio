#!/bin/bash

set -eu -o pipefail
trap 'echo "ERROR: line no = $LINENO, exit status = $?" >&2; exit 1' ERR

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

GRPC_VERSION=1.44.0

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
    GRPC_INSTALL_DIR=$CURRENT/$INSTALL_DIR/grpc/$BUILD_CONFIGURATION

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

# $1 : configuration Debug Release
if [ -n "$1" ]; then
    build_grpc $1
else
    build_grpc Debug
    build_grpc Release
fi


# pop grpc
popd

# pop Repositories
popd

# pop CURRENT
popd
