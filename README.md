# SUU-Studio

![Windows](https://github.com/SUU-Lab/SUU-Studio/actions/workflows/windows.yml/badge.svg)
![Linux](https://github.com/SUU-Lab/SUU-Studio/actions/workflows/linux.yml/badge.svg)
![Android](https://github.com/SUU-Lab/SUU-Studio/actions/workflows/android.yml/badge.svg)

# Pre-requisites

## Windows
- Install Visual Studio 2022
- Install [Git](https://git-scm.com/)

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
```sh
$ cd SUU-Studio
$ ./setup-linux.sh
```
