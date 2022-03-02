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

set SDK_DIR=C:\Users\nsuud\AppData\Local\Android\Sdk
set NDK_VERSION=21.4.7075529
set NDK_DIR=%SDK_DIR%\ndk\%NDK_VERSION%

set CMAKE_VERSION=3.18.1
set ANDROID_CMAKE_PATH=%SDK_DIR%\cmake\%CMAKE_VERSION%\bin

%ANDROID_CMAKE_PATH%\cmake.exe --version

call :Func_Build_gRPC arm64-v8a 21 Debug
call :Func_Build_gRPC arm64-v8a 21 Release

@REM call :Func_Build_gRPC armeabi-v7a 21 Debug
@REM call :Func_Build_gRPC armeabi-v7a 21 Release

@REM call :Func_Build_gRPC x86_64 21 Debug
@REM call :Func_Build_gRPC x86_64 21 Release

@REM call :Func_Build_gRPC x86 21 Debug
@REM call :Func_Build_gRPC x86 21 Release

popd

goto :EXIT

@rem ########## Func_Build_gRPC ##########
:Func_Build_gRPC
	echo ---------- Build gRPC %1 %2 %3 ----------

	set BUILD_ABI=%1
	set BUILD_API_LEVEL=%2
	set BUILD_CONFIGURATION=%3

	set BUILD_DIR=.build_%BUILD_ABI%_Android
	set INSTALL_DIR=%CURRENT_DIR%\Install\Android\grpc-%GRPC_VERSION%\%BUILD_ABI%\%BUILD_CONFIGURATION%

	if not exist %BUILD_DIR% (
		md %BUILD_DIR%
	)

	%ANDROID_CMAKE_PATH%\cmake.exe ^
	-GNinja ^
	-H. ^
	-DgRPC_INSTALL=ON ^
	-DgRPC_BUILD_TESTS=OFF ^
	-DABSL_NO_XRAY_ATTRIBUTES=1 ^
	-DCMAKE_SYSTEM_NAME=Android ^
	-DCMAKE_EXPORT_COMPILE_COMMANDS=ON ^
	-DCMAKE_SYSTEM_VERSION=%BUILD_API_LEVEL% ^
	-DANDROID_PLATFORM=android-%BUILD_API_LEVEL% ^
	-DANDROID_ABI=%BUILD_ABI% ^
	-DCMAKE_ANDROID_ARCH_ABI=%BUILD_ABI% ^
	-DANDROID_NDK=%NDK_DIR% ^
	-DCMAKE_ANDROID_NDK=%NDK_DIR% ^
	-DCMAKE_TOOLCHAIN_FILE=%NDK_DIR%\build\cmake\android.toolchain.cmake ^
	-DCMAKE_MAKE_PROGRAM=%ANDROID_CMAKE_PATH%\ninja.exe ^
	-DCMAKE_CXX_FLAGS=-std=c++14 ^
	-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=.lib_%BUILD_ABI%_%BUILD_CONFIGURATION% ^
	-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=.bin_%BUILD_ABI%_%BUILD_CONFIGURATION% ^
	-DCMAKE_BUILD_TYPE=%BUILD_CONFIGURATION% ^
	-DANDROID_STL=c++_shared ^
	-B.build_%BUILD_ABI% ^
	-GNinja ^
	-DCMAKE_INSTALL_PREFIX=%INSTALL_DIR% ^
	-B%BUILD_DIR%

	if not exist %BUILD_DIR%\%BUILD_CONFIGURATION% (
		%ANDROID_CMAKE_PATH%\cmake.exe --build %BUILD_DIR%
	)

	if not exist %INSTALL_DIR% (
		%ANDROID_CMAKE_PATH%\cmake.exe --install %BUILD_DIR% --prefix %INSTALL_DIR%
	)

exit /b
@rem ########## END Func_Build_gRPC ##########

:EXIT
popd
