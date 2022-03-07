@echo off

set CURRENT_DIR=%~dp0
pushd %CURRENT_DIR%

for %%A in (*.proto) do call Generate.bat %%A

popd

