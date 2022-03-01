@echo off

set CURRENT_DIR=%~dp0
set TARGET_DIR=%CURRENT_DIR%Install\Windows
if not exist %TARGET_DIR% (
	md %TARGET_DIR%
)

pushd %TARGET_DIR%


echo ---------- vswhere ----------
set VSWHERE_VERSION=2.8.4
set VSWHERE_PATH=%TARGET_DIR%\vswhere-%VSWHERE_VERSION%

if exist %VSWHERE_PATH%\vswhere.exe (
	goto :VSWHERE_INSTALLED
) else if not exist %VSWHERE_PATH% (
	mkdir %VSWHERE_PATH%
)

where /Q "vswhere.exe"
if not ERRORLEVEL 1 (
	goto :VSWHERE_INSTALLED
)

bitsadmin /RawReturn /TRANSFER getfile ^
https://github.com/microsoft/vswhere/releases/download/%VSWHERE_VERSION%/vswhere.exe ^
%VSWHERE_PATH%\%vswhere.exe

:VSWHERE_INSTALLED
set PATH=%VSWHERE_PATH%;%PATH%
vswhere.exe -latest

echo ---------- CMake ----------
set CMAKE_VERSION=3.22.2
set CMAKE_ARCHIVE_NAME=cmake-%CMAKE_VERSION%-windows-x86_64
set CMAKE_PATH=%TARGET_DIR%\%CMAKE_ARCHIVE_NAME%\bin

if exist %CMAKE_PATH% (
	goto :CMAKE_INSTALLED
)

bitsadmin /RawReturn /TRANSFER getfile ^
https://github.com/Kitware/CMake/releases/download/v%CMAKE_VERSION%/%CMAKE_ARCHIVE_NAME%.zip ^
%TARGET_DIR%\%CMAKE_ARCHIVE_NAME%.zip

powershell Expand-Archive -Path %CMAKE_ARCHIVE_NAME%.zip -DestinationPath %TARGET_DIR%

del %CMAKE_ARCHIVE_NAME%.zip

:CMAKE_INSTALLED
%CMAKE_PATH%\cmake.exe --version


echo ---------- NASM ----------
set NASM_VERSION=2.15.05
set NASM_PATH=%TARGET_DIR%\nasm-%NASM_VERSION%

if exist %NASM_PATH%\nasm.exe (
	goto :NASM_INSTALLED
)

where /Q "nasm.exe"
if not ERRORLEVEL 1 (
	goto :NASM_INSTALLED
)

bitsadmin /RawReturn /TRANSFER getfile ^
https://www.nasm.us/pub/nasm/releasebuilds/%NASM_VERSION%/win64/nasm-%NASM_VERSION%-win64.zip ^
%TARGET_DIR%\nasm-%NASM_VERSION%-win64.zip

powershell Expand-Archive -Path nasm-%NASM_VERSION%-win64.zip -DestinationPath %TARGET_DIR%

del nasm-%NASM_VERSION%-win64.zip

:NASM_INSTALLED
set PATH=%NASM_PATH%;%PATH%
nasm.exe -version

echo ---------- Ninja ----------
set NINJA_VERSION=1.10.2
set NINJA_PATH=%TARGET_DIR%\Ninja-%NINJA_VERSION%

if exist %NINJA_PATH%\ninja.exe (
	goto :NINJA_INSTALLED
) else if not exist %NINJA_PATH% (
	mkdir %NINJA_PATH%
)

where /Q "ninja.exe"
if not ERRORLEVEL 1 (
	goto :NINJA_INSTALLED
)

pushd %NINJA_PATH%

bitsadmin /RawReturn /TRANSFER getfile ^
https://github.com/ninja-build/ninja/releases/download/v%NINJA_VERSION%/ninja-win.zip ^
%NINJA_PATH%\Ninja-%NINJA_VERSION%.zip

powershell Expand-Archive -Path Ninja-%NINJA_VERSION%.zip -DestinationPath %NINJA_PATH%

del Ninja-%NINJA_VERSION%.zip

popd

:NINJA_INSTALLED
set PATH=%NINJA_PATH%;%PATH%
ninja.exe --version

:EXIT
popd