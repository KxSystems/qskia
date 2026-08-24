# Conda Package

## Introduction
This document explains how to build the KDB-X Skia module conda package.

A copy of the Skia source code and depot_tools are required to build the module.
```Bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git deps/depot_tools
git -C deps/depot_tools checkout 33eb99bb23c5a7c26f85faa4e89020ab345b1c5d
git clone https://skia.googlesource.com/skia.git deps/skia
git -C deps/skia checkout fcad874e42553f65911022f53c7d04553c296609
```

## Skia
### Linux
Launch an interactive container for the build.
```Bash
docker run -it --rm -v $(pwd):/workspace -w /workspace -e ME=$(id -un) ubuntu:20.04 bash -c "groupadd -g $(id -g) $(id -un); useradd -u $(id -u) -g $(id -g) $(id -un) -m -s /bin/bash; bash"
```
Install required system packages.
```Bash
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y curl git unzip
```
Install Micromamba.
```Bash
su $ME
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
```
Create a new environment for building.
```Bash
micromamba create --name build
micromamba activate build
```
Install required build packages.
```Bash
micromamba install python==3.10 clangxx fontconfig-devel-conda-$(uname -m) freetype ninja
```
Run the Skia build script.
```Bash
./build-skia-conda.sh
```

### macOS
Install:
* [Command Line Tools for Xcode](https://developer.apple.com/documentation/xcode/installing-the-command-line-tools/).
* Micromamba.
  ```Bash
  "${SHELL}" <(curl -L micro.mamba.pm/install.sh)
  ```
Create a new environment for building.
```Bash
micromamba create --name build
micromamba activate build
```
Install required build packages.
```Bash
micromamba install freetype ninja
```
Run the build script.
```Bash
./build-skia-conda.sh
```

### Windows
Install:
* [LLVM 18.0.0](https://releases.llvm.org/download.html#18.0.0)
* [Visual Studio 2017 Build Tools](https://aka.ms/vs/15/release/vs_buildtools.exe)
* Micromamba
  ```PowerShell
  Invoke-Expression ((Invoke-WebRequest -Uri https://micro.mamba.pm/install.ps1 -UseBasicParsing).Content)
  ```
Create a new environment for building.
```PowerShell
micromamba create --name build
micromamba activate build
```
Install the required build packages.
```PowerShell
micromamba install freetype ninja
```
Run the build script.
```PowerShell
.\build-skia-conda.ps1
```

## KDB-X Module
Activate the build environment from the previous section.
```Bash
micromamba activate build
```
Install required build packages.
```Bash
micromamba install rattler-build rattler-index
```
Build the conda package.
```Bash
cd recipe
rattler-build build
```
Publish the package to a local channel.
* Linux/macOS
  ```Bash
  rattler-build publish ./output/*/q-kx-skia-*.conda  --to file:///tmp/mychannel
  ```
* Windows
  ```PowerShell
  rattler-build publish (Get-ChildItem .\output\win-64\q-kx-skia-*.conda) --to file:///C:/tmp/mychannel
  ```
Index the channel.
* Linux/macOS
  ```Bash
  rattler-index -f fs /tmp/mychannel/
  ```
* Windows
  ```PowerShell
  rattler-index -f fs C:\tmp\mychannel\
  ```

## Testing
Create a new environment for testing.
```Bash
micromamba create --name test
micromamba activate test
```
Install the package.
* Linux/macOS
  ```Bash
  micromamba install -c /tmp/mychannel q-kx-skia
  ```
* Windows
  ```PowerShell
  micromamba install -c C:\tmp\mychannel q-kx-skia
  ```
Try the running the example script.
* Linux/macOS
  ```Bash
  QPATH=$CONDA_PREFIX/lib/q/mod q example.q
  ```
* Windows
  ```PowerShell
  $env:QPATH="$env:CONDA_PREFIX\lib\q\mod";q example.q
  ```
