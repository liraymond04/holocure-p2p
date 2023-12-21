# HoloCure Example Mod

A mod template for HoloCure using [YYToolkit](https://github.com/AurieFramework/YYToolkit) (note: this template is for YYTK v3 which uses [Aurie](https://github.com/AurieFramework/Aurie), for the YYTK v2 template use the [legacy](https://github.com/liraymond04/holocure-example-mod/tree/legacy) branch)

This GitHub repository is configured with GitHub actions to automatically build a mod DLL and upload it to releases when a commit is made to the `main` branch

The mod DLL name and version are defined inside the `manifest.json` under the `name` and `version` entries.

Releases published by GitHub Actions are tagged with the `version`, and the changelog of the release is defined inside of [CHANGELOG.md](CHANGELOG.md)

- [HoloCure Example Mod](#holocure-example-mod)
    * [Building with Docker](#building-with-docker)
        - [(Optional) Change Docker build directory](#optional-change-docker-build-directory)
   * [Building with CMake](#building-with-cmake)
        + [Linux](#linux)
            - [(Optional) Change CMake build directory](#optional-change-cmake-build-directory)
            - [(Optional) Fix compile_commands.json](#optional-fix-compile_commandsjson)
    * [Building with Visual Studio](#building-with-visual-studio)

## Building with Docker

Building a mod DLL is simplified with [Docker](https://github.com/microsoft/docker), and it only requires that you have Docker and Docker's Buildkit installed

For Arch Linux, you can install Docker and Buildkit with pacman

```bash
sudo pacman -S docker docker-buildx
```

Building with Docker will require an internet connection and ~8gb of disk space in Docker's root directory

The DLL name and version can be edited in `Dockerfile` at the top of the file (WARNING: do not edit the rest of the Dockerfile unless you know what you are doing)

Start the build with Docker by running `build.sh`
```bash
./build.sh
```

DLL will be outputted to `build/example-mod-v1.0.2.dll`

#### (Optional) Change Docker build directory

The `./build.sh` script defaults to the `build` directory, but you can optionally pass in a different output directory

```bash
./build.sh -b <new-directory>
```

## Building with CMake

### Linux

Building a mod DLL through CMake requires using [msvc-wine](https://github.com/mstorsjo/msvc-wine) 

For Arch Linux, the prerequisite packages are,

```bash
sudo pacman -S --needed git gcc make cmake wine msitools samba python python-simplejson python-six
```

To install the MSVC compiler, we can clone the repository and run the install scripts

```bash
git clone https://github.com/mstorsjo/msvc-wine.git
cd msvc-wine

# This example installs the compiler to ~/my_msvc/opt/msvc
./vsdownload.py --dest ~/my_msvc/opt/msvc
./install.sh ~/my_msvc/opt/msvc

# Add compiler commands to PATH
export PATH=~/my_msvc/opt/msvc/bin/x64:$PATH

# Optional: Start a persistent wineserver
wineserver -k # Kill a potential old server
wineserver -p # Start a new server
wine64 wineboot # Run a process to start up all background wine processes
```

Generate build files and compile
```bash
# Generate CMake build files
./setup_cmake.sh
# Navigate to build directory
cd build
# Compile with make
make
```

DLL will be outputted to `x64/Release/example-mod.dll`

#### (Optional) Change CMake build directory

The `./setup_cmake.sh` script defaults to the `build` directory, but you can optionally pass in a different output directory

```bash
./setup_cmake.sh -b <new-directory>
```

#### (Optional) Fix compile_commands.json
If you are using clangd for Intellisense, you will need to edit the generated `compile_commands.json` to replace the MSVC compiler with the mingw-w64 cross compiler

For Arch Linux, you need to install the `mingw-w64-gcc` package

```bash
sudo pacman -S mingw-w64-gcc
```

Create a `.secrets` file and add the paths for the old and new compilers
```bash
# Example .secrets file

# path to MSVC compiler cl
old_compiler="/home/liray/my_msvc/opt/msvc/bin/x64/cl"
# path to mingw-w64-g++
new_compiler="/usr/bin/x86_64-w64-mingw32-g++"
```

Run the `update_compile_commands.sh` script and pass in the `.secrets` and optionally the `compile_commands.json` (if the `compile_commands.json` is not passed in, it is searched for in the directory the script is run in) 

```bash
./scripts/update_compile_commands.sh -f ./secrets -j build/compile_commands.json
```

## Building with Visual Studio

Visual Studio solution files are generated using CMake from the command line, so when installing CMake you should **check the option to `Add CMake to the system PATH`** for either all users or the current users

When CMake are installed and added to the system PATH and Visual Studio is also installed, run the `setup_vs.bat` script to generate the Visual Studio solution files

To open the project in Visual Studio, open the generated `main.sln` file
