@echo off

set CURRENT_DIR=%~dp0

if not exist %CURRENT_DIR%\Repositories (
	md %CURRENT_DIR%\Repositories
)
pushd %CURRENT_DIR%\Repositories

set GRPC_VERSION=1.44.0

if not exist grpc (
	git clone --recurse-submodules -b v%GRPC_VERSION% https://github.com/grpc/grpc
)

pushd grpc

@REM %1 : platform Win32 x64
@REM %2 : configuration Debug Release
if "%1" == "" if "%2" == "" (
	call :Func_Build_gRPC %1 %2
) else (
	call :Func_Build_gRPC Win32 Debug
	call :Func_Build_gRPC Win32 Release
	call :Func_Build_gRPC x64 Debug
	call :Func_Build_gRPC x64 Release
)

popd

goto :EXIT

@rem ########## Func_Build_gRPC ##########
:Func_Build_gRPC
echo ---------- Build gRPC %1 %2 ----------
set BUILD_TARGET=%1
set BUILD_DIR=.build_%BUILD_TARGET%_Windows
set BUILD_CONFIGURATION=%2
set INSTALL_DIR=%CURRENT_DIR%\Install\Windows\grpc\%BUILD_TARGET%\%BUILD_CONFIGURATION%

if not exist %BUILD_DIR% (
	md %BUILD_DIR%
)

%CMAKE_PATH%\cmake ^
-G "Visual Studio 17 2022" ^
-A %BUILD_TARGET% ^
-DCMAKE_BUILD_TYPE=%BUILD_CONFIGURATION% ^
-DgRPC_INSTALL=ON ^
-DgRPC_BUILD_TESTS=OFF ^
-DCMAKE_INSTALL_PREFIX=%INSTALL_DIR% ^
-B%BUILD_DIR%

if not exist %BUILD_DIR%\Release (
	%CMAKE_PATH%\cmake --build %BUILD_DIR% --config %BUILD_CONFIGURATION%
)

if not exist %INSTALL_DIR% (
	%CMAKE_PATH%\cmake --install %BUILD_DIR% --prefix %INSTALL_DIR%
)

exit /b
@rem ########## END Func_Build_gRPC ##########

:EXIT
popd
