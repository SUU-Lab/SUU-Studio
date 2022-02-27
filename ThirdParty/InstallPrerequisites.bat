@echo off

set CURRENT_DIR=%~dp0
set TARGET_DIR=%CURRENT_DIR%Install\Windows
if not exist %TARGET_DIR% (
	md %TARGET_DIR%
)

pushd %TARGET_DIR%

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
%CMAKE_PATH%\cmake --version


echo ---------- NASM ----------
set NASM_VERSION=2.15.05
set NASM_PATH=%TARGET_DIR%\nasm-%NASM_VERSION%

if exist %NASM_PATH% (
	goto :NASM_INSTALLED
)

bitsadmin /RawReturn /TRANSFER getfile ^
https://www.nasm.us/pub/nasm/releasebuilds/%NASM_VERSION%/win64/nasm-%NASM_VERSION%-win64.zip ^
%TARGET_DIR%\nasm-%NASM_VERSION%-win64.zip

powershell Expand-Archive -Path nasm-%NASM_VERSION%-win64.zip -DestinationPath %TARGET_DIR%

del nasm-%NASM_VERSION%-win64.zip

@rem Check PATH
echo "%PATH%" | find "nasm.exe" > NUL
if not ERRORLEVEL 1 goto :NASM_INSTALLED

:NASM_INSTALLED
%NASM_PATH%\nasm -version


:EXIT
popd