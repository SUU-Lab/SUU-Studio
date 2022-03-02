@echo off

set CURRENT_DIR=%~dp0

if not exist %CURRENT_DIR%\Repositories (
	md %CURRENT_DIR%\Repositories
)
pushd %CURRENT_DIR%\Repositories

set GRPC_VERSION=1.43.0

if not exist grpc (
	git clone --recurse-submodules -b v%GRPC_VERSION% https://github.com/grpc/grpc
)

pushd grpc
@rem call :Func_Build_gRPC Win32 Debug
@rem call :Func_Build_gRPC Win32 Release
call :Func_Build_gRPC x64 Debug
call :Func_Build_gRPC x64 Release
popd

goto :EXIT

@rem ########## Func_Build_gRPC ##########
:Func_Build_gRPC
echo ---------- Build gRPC %1 %2 ----------
echo "BUILD_TARGET=%1"
set BUILD_TARGET=%1
set BUILD_DIR=.build_%BUILD_TARGET%_Windows
set BUILD_CONFIGURATION=%2
set INSTALL_DIR=%CURRENT_DIR%\Install\Windows\grpc-%GRPC_VERSION%\%BUILD_TARGET%\%BUILD_CONFIGURATION%

set VC_TARGET_NAME=%BUILD_TARGET%

if "%VC_TARGET_NAME%"=="Win32" (
	set VC_TARGET_NAME=x86
)

for /f "usebackq delims=" %%A in (`vswhere.exe -products * -requires Microsoft.Component.MSBuild -property installationPath -latest`) do set VS_INSTALL_PATH=%%A

if not exist %BUILD_DIR% (
	md %BUILD_DIR%
	call "%VS_INSTALL_PATH%\VC\Auxiliary\Build\vcvarsall.bat" %VC_TARGET_NAME%
)

%CMAKE_PATH%\cmake.exe ^
-GNinja ^
-DCMAKE_BUILD_TYPE=%BUILD_CONFIGURATION% ^
-DgRPC_INSTALL=ON ^
-DgRPC_BUILD_TESTS=OFF ^
-DCMAKE_INSTALL_PREFIX=%INSTALL_DIR% ^
-B%BUILD_DIR%

if not exist %BUILD_DIR%\%BUILD_CONFIGURATION% (
	cmake --build %BUILD_DIR%
)

if not exist %INSTALL_DIR% (
	cmake --install %BUILD_DIR% --prefix %INSTALL_DIR%
)

exit /b
@rem ########## END Func_Build_gRPC ##########

:EXIT
popd
