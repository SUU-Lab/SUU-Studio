@echo off

set CURRENT_DIR=%~dp0

C:\SDK\vcpkg\installed\x64-windows\tools\protobuf\protoc.exe --grpc_out=. --cpp_out=. --plugin=protoc-gen-grpc=C:\SDK\vcpkg\installed\x64-windows\tools\grpc\grpc_cpp_plugin.exe .\Hello.proto

