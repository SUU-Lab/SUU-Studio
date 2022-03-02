@echo off

set CURRENT_DIR=%~dp0
cd /d %CURRENT_DIR%

@REM call ThirdParty\InstallPrerequisites.bat
call ThirdParty\CloneAndBuildAll-Android.bat

:EXIT
