@echo off

set CURRENT_DIR=%~dp0
cd /d %CURRENT_DIR%

call ThirdParty\InstallPrerequisites.bat
call ThirdParty\CloneAndBuildAll.bat

:EXIT
