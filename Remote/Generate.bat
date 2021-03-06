@echo off

set CURRENT_DIR=%~dp0

set TARGET_PROTO_FILE=%1
set GRPC_TOOL_DIR=%CURRENT_DIR%..\ThirdParty\Install\Windows\grpc\x64\Release\bin


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

@rem copy src files
set CPP_CODE_DIR=..\SUU-Runtime\source\Runtime\Remote\Generated
if not exist %CPP_CODE_DIR% (
	mkdir %CPP_CODE_DIR%
)
xcopy /e /Y %CPP_GEN_DIR% %CPP_CODE_DIR%
del /Q %CPP_GEN_DIR%


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

@rem copy src files
set CSHARP_CODE_DIR=..\WindowsDesktop\VisualStudio2022\SUU-Studio\Remote
xcopy /e /Y %CSHARP_GEN_DIR% %CSHARP_CODE_DIR%
del /Q %CSHARP_GEN_DIR%
