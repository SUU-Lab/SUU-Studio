#!/bin/bash

CURRENT=$(cd $(dirname $0);pwd)
pushd $CURRENT


BUILD_CONFIGURATION=$1
BUILD_DIR=.build_$BUILD_CONFIGURATION
GRPC_INSTALL_DIR=$CURRENT/../ThirdParty/Install/Linux/grpc/$BUILD_CONFIGURATION

cmake \
-GNinja \
-B$BUILD_DIR \
-DCMAKE_BUILD_TYPE=$BUILD_CONFIGURATION \
-DCMAKE_PREFIX_PATH=$GRPC_INSTALL_DIR \
-DSUU_RUNTIME_PLATFORM_LINUX=1

cmake --build $BUILD_DIR

popd
