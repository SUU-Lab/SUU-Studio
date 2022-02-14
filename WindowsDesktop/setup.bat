@echo off

set CURRENT_DIR=%~dp0
cd /d %CURRENT_DIR%

if not exist install (
	mkdir install
)

if not exist install\repo (
	mkdir install\repo
)

@rem ========== INSTALL ==========
pushd install


echo ---------- CMake ----------
set CMAKE_PATH=%CURRENT_DIR%\install\cmake-3.22.2-windows-x86_64\bin

if exist %CMAKE_PATH% (
	goto :CMAKE_INSTALLED
)

bitsadmin /RawReturn /TRANSFER getfile ^
https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2-windows-x86_64.zip ^
%CURRENT_DIR%\install\cmake-3.22.2-windows-x86_64.zip

powershell Expand-Archive -Path cmake-3.22.2-windows-x86_64.zip -DestinationPath %CURRENT_DIR%\install

del cmake-3.22.2-windows-x86_64.zip

set CMAKE_PATH=%CURRENT_DIR%\install\cmake-3.22.2-windows-x86_64\bin

:CMAKE_INSTALLED
%CMAKE_PATH%\cmake --version


echo ---------- NASM ----------
set NASM_PATH=%CURRENT_DIR%\install\nasm-2.15.05

if exist %NASM_PATH% (
	goto :NASM_INSTALLED
)

bitsadmin /RawReturn /TRANSFER getfile ^
https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/win64/nasm-2.15.05-win64.zip ^
%CURRENT_DIR%\install\nasm-2.15.05-win64.zip

powershell Expand-Archive -Path nasm-2.15.05-win64.zip -DestinationPath %CURRENT_DIR%\install

del nasm-2.15.05-win64.zip

@rem Check PATH
echo "%PATH%" | find "nasm.exe" > NUL
if not ERRORLEVEL 1 goto :NASM_INSTALLED

set PATH=%CURRENT_DIR%\install\nasm-2.15.05;%PATH%

:NASM_INSTALLED
nasm -version

@rem ========== Clone and Build ==========
pushd repo

echo ---------- gRPC ----------
if not exist grpc (
	git clone --recurse-submodules -b v1.43.0 https://github.com/grpc/grpc
)

pushd grpc
call :Func_Build_gRPC Win32
call :Func_Build_gRPC x64
popd

popd
@rem ========== END Clone and Build ==========

popd
@rem ========== END INSTALL ==========


goto :EXIT


@rem ########## Func_Build_gRPC ##########
:Func_Build_gRPC
echo "BUILD_TARGET=%1"
set BUILD_TARGET=%1
set BUILD_DIR=.build%BUILD_TARGET%

if not exist %BUILD_DIR% (
	md %BUILD_DIR%
)

%CMAKE_PATH%\cmake ^
-G "Visual Studio 17 2022" ^
-A %BUILD_TARGET% ^
-DgRPC_INSTALL=ON ^
-DgRPC_BUILD_TESTS=OFF ^
-DCMAKE_INSTALL_PREFIX=%CURRENT_DIR%\install\grpc\%BUILD_TARGET% ^
-B%BUILD_DIR%

%CMAKE_PATH%\cmake --build %BUILD_DIR% --config Release
%CMAKE_PATH%\cmake --install %BUILD_DIR% --prefix %CURRENT_DIR%\install\grpc\%BUILD_TARGET%

exit /b
@rem ########## END Func_Build_gRPC ##########


:EXIT
