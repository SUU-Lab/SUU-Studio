#!/bin/bash

chmod +x ./ThirdParty/install-all-android.sh

# $1 : android sdk root
# $2 : abi arm64-v8a armeabi-v7a x86_64 x86
# $3 : api-level
# $4 : configuration Debug Release
./ThirdParty/install-all-android.sh $1 $2 $3 $4
