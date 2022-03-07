@echo off

set CURRENT_DIR=%~dp0
cd /d %CURRENT_DIR%

@REM call ThirdParty\InstallPrerequisites.bat

@REM %1 : abi arm64-v8a armeabi-v7a x86_64 x86
@REM %2 : api-level
@REM %3 : configuration Debug Release
call ThirdParty\CloneAndBuildAll-Android.bat %1 %2 %3

:EXIT
