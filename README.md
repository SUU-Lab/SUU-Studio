# SUU-Studio

![Windows](https://github.com/SUU-Lab/SUU-Studio/actions/workflows/windows.yml/badge.svg)
![Linux](https://github.com/SUU-Lab/SUU-Studio/actions/workflows/linux.yml/badge.svg)
![Android](https://github.com/SUU-Lab/SUU-Studio/actions/workflows/android.yml/badge.svg)

# Pre-requisites

## Windows
- Install [Visual Studio 2022](https://visualstudio.microsoft.com/ja/vs/whatsnew/)

- Install Git, CMake, NASM, and Ninja. You can install them manually or use Chocolatey.

### Install Manually
[Git](https://git-scm.com/download/win), [CMake](https://cmake.org/download/), [NASM](https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/), [Ninja](https://github.com/ninja-build/ninja/releases) And Add to PATH


### Install with [Chocolatey](https://docs.chocolatey.org/en-us/choco/setup)
```cmd
> @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

> cinst -y cmake -Version 3.22.2
> cinst -y ninja -Version 1.10.2
> cinst -y nasm -Version 2.15.05
```


## Linux
```sh
$ [sudo] apt-get install build-essential autoconf libtool pkg-config
$ [sudo] apt-get install cmake
$ [sudo] apt-get install libx11-dev
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
