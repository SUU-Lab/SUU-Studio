@echo off

set CURRENT_DIR=%~dp0

set TARGET_PROTO_FILE=%1
set GRPC_TOOL_DIR=%CURRENT_DIR%..\ThirdParty\Install\Windows\grpc-1.43.0\x64\Release\bin


echo ---------- Generate C++ code ----------

set CPP_GEN_DIR=CPP

if not exist %CPP_GEN_DIR% (
	mkdir %CPP_GEN_DIR%
)

pushd %CPP_GEN_DIR%

%GRPC_TOOL_DIR%\protoc.exe ^
-I ..\ ^
--grpc_out=. ^
--cpp_out=. ^
--plugin=protoc-gen-grpc=%GRPC_TOOL_DIR%\grpc_cpp_plugin.exe ^
%TARGET_PROTO_FILE%

popd


echo ---------- Generate C# code ----------

set CSHARP_GEN_DIR=CSharp

if not exist %CSHARP_GEN_DIR% (
	mkdir %CSHARP_GEN_DIR%
)

pushd %CSHARP_GEN_DIR%

%GRPC_TOOL_DIR%\protoc.exe ^
-I ..\ ^
--grpc_out=. ^
--csharp_out=. ^
--plugin=protoc-gen-grpc=%GRPC_TOOL_DIR%\grpc_csharp_plugin.exe ^
%TARGET_PROTO_FILE%

popd
