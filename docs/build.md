# Building Guide

## Introduction
This document explains how to build the KDB-X Skia module from source.

A copy of the Skia source code and depot_tools are required to build the module.
```Bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git deps/depot_tools
git -C deps/depot_tools checkout 33eb99bb23c5a7c26f85faa4e89020ab345b1c5d
git clone https://skia.googlesource.com/skia.git deps/skia
git -C deps/skia checkout fcad874e42553f65911022f53c7d04553c296609
```

## Linux
### Skia
Launch an interactive container for the build.
```Bash
docker run -it --rm -v $(pwd):/workspace -w /workspace -e ME=$(id -un) ubuntu:20.04 bash -c "groupadd -g $(id -g) $(id -un); useradd -u $(id -u) -g $(id -g) $(id -un) -m -s /bin/bash; bash"
```
Install the following system packages.
```Bash
apt update && DEBIAN_FRONTEND=noninteractive apt install -y git gnupg libfontconfig1-dev lsb-release software-properties-common wget
```
Install LLVM.
```Bash
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
./llvm.sh 15
```
Switch to the non-root.
```Bash
su $ME
```
`depot_tools` requires Python 3.10, which can be installed on Ubuntu 20.04 using `uv`.
```Bash
wget -qO- https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv venv -p python3.10
source .venv/bin/activate
```
Run the Skia build script.
```Bash
./build-skia.sh 15
```
### KDB-X Module
Launch an interactive container for the build.
```Bash
docker run -it --rm -v $(pwd):/workspace -w /workspace -e ME=$(id -un) ubuntu:20.04 bash -c "groupadd -g $(id -g) $(id -un); useradd -u $(id -u) -g $(id -g) $(id -un) -m -s /bin/bash; bash"
```
Install the following packages.
```Bash
apt update && DEBIAN_FRONTEND=noninteractive apt install -y build-essential cmake libfontconfig1-dev
```
Switch to the non-root user and build.
```Bash
su $ME
cmake -S . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=dist -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_STANDARD_REQUIRED=ON -DSKIA_DEPS_STATIC=ON
cmake --build build --config RelWithDebInfo --target install
```

## macOS
Install [Command Line Tools for Xcode](https://developer.apple.com/documentation/xcode/installing-the-command-line-tools/).
### Skia
Run the build script.
```Bash
./build-skia.sh
```
### KDB-X Module
Run CMake.
```Bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=dist -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_STANDARD_REQUIRED=ON -DSKIA_DEPS_STATIC=ON -DCMAKE_OSX_ARCHITECTURES=$(uname -m) 
cmake --build build --config RelWithDebInfo --target install
```

## Windows
Install:
* [LLVM 18.0.0](https://releases.llvm.org/download.html#18.0.0)
* [Visual Studio 2017 Build Tools](https://aka.ms/vs/15/release/vs_buildtools.exe)
### Skia
Run the build script.
```CMD
.\build-skia.bat
```
### KDB-X Module
Run CMake.
```CMD
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=dist -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_STANDARD_REQUIRED=ON -DSKIA_DEPS_STATIC=ON -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
cmake --build build --config RelWithDebInfo --target install
```

## Testing
Running the `example.q` script should produce a `example.png` containing some text and a red circle.
### Linux and macOS
```Bash
QPATH=./dist q example.q
```
### Windows
```PowerShell
$env:QPATH=".\dist";q example.q
```
