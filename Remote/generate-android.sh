#!/bin/bash

CURRENT=$(cd $(dirname $0);pwd)
pushd $CURRENT

TARGET_PROTO_FILE=$1




echo ---------- Generate C++ code ----------

CPP_GEN_DIR=CPP

if [ ! -d "$CPP_GEN_DIR" ]; then
    mkdir $CPP_GEN_DIR
fi

pushd $CPP_GEN_DIR



protoc \
-I ../ \
--grpc_out=. \
--cpp_out=. \
--plugin=protoc-gen-grpc=`which grpc_cpp_plugin` \
$TARGET_PROTO_FILE

# copy src files
CPP_CODE_DIR=../../SUU-Runtime/source/Runtime-Platform/Android/Remote

if [ ! -d "$CPP_CODE_DIR" ]; then
    mkdir $CPP_CODE_DIR
fi

mv *.* $CPP_CODE_DIR

popd

rm -rf $CPP_GEN_DIR

popd
