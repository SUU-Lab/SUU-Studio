#!/bin/bash

CURRENT=$(cd $(dirname $0);pwd)
pushd $CURRENT

TARGET_PROTO_FILE=$1
GRPC_TOOL_DIR=$CURRENT/../ThirdParty/Install/Linux/grpc/Release/bin

chmod +x $GRPC_TOOL_DIR/protoc

echo ---------- Generate C++ code ----------

CPP_GEN_DIR=CPP

if [ ! -d "$CPP_GEN_DIR" ]; then
    mkdir $CPP_GEN_DIR
fi

pushd $CPP_GEN_DIR

chmod +x $GRPC_TOOL_DIR/grpc_cpp_plugin

$GRPC_TOOL_DIR/protoc \
-I ../ \
--grpc_out=. \
--cpp_out=. \
--plugin=protoc-gen-grpc=$GRPC_TOOL_DIR/grpc_cpp_plugin \
$TARGET_PROTO_FILE

# copy src files
CPP_CODE_DIR=../../SUU-Runtime/source/Runtime/Remote/Generated

if [ ! -d "$CPP_CODE_DIR" ]; then
    mkdir $CPP_CODE_DIR
fi

mv *.* $CPP_CODE_DIR

popd

rm -rf $CPP_GEN_DIR

popd
