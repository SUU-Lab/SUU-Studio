# SUU-Studio

![Windows](https://github.com/SUU-Lab/SUU-Studio/actions/workflows/windows.yml/badge.svg)
![Linux](https://github.com/SUU-Lab/SUU-Studio/actions/workflows/linux.yml/badge.svg)
![Android](https://github.com/SUU-Lab/SUU-Studio/actions/workflows/android.yml/badge.svg)

# Pre-requisites

## Windows
- Install [Git](https://git-scm.com/download/win)
- Install [Visual Studio 2022](https://visualstudio.microsoft.com/ja/vs/whatsnew/)

## Linux
```sh
$ [sudo] apt install git
$ [sudo] apt install build-essential autoconf libtool pkg-config
$ [sudo] apt install cmake
$ [sudo] apt install ninja-build
$ [sudo] apt install libx11-dev
```

# Clone the repository
Before building, you need to clone the SUU-Studio github repository. Use following commands to clone the SUU-Studio repository.

## Windows
```cmd
> git clone https://github.com/SUU-Lab/SUU-Studio.git
```
## Linux
```sh
$ git clone https://github.com/SUU-Lab/SUU-Studio.git
```

# Build and install dependencies
After clone, build and install third-party libaries and tools for SUU-Studio's dependencies. Use following commands to build and install the third-party components.

## Windows
```cmd
> cd SUU-Studio
> Setup.bat
```
## Linux
Give `setup-linux.sh` execute permission. Then, run `setup-linux.sh`.
```sh
$ cd SUU-Studio
$ chmod +x setup-linux.sh
$ ./setup-linux.sh
```

Visual Studio で gRPC を使う際、C4127 C4251 の警告が出る。
ソースファイル単位で警告を無効にできるが、生成の度に設定するのは面倒。
Remoteを別プロジェクトとして、そのプロジェクトでは該当する警告を無効にすることで対応できないか？
（今は SUU-Runtime-Static で C4127 C4251 を無効にしている。）
