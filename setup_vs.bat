@echo off
setlocal enabledelayedexpansion

REM Define the list of Visual Studio versions in descending order
set "vs_versions=17 16 15 14"  REM Add more versions if needed

REM Read the project version from manifest.json
for /f "tokens=2 delims=:, " %%v in ('type manifest.json ^| find /i "version"') do (
    set "project_version=%%v"
    set "project_version=!project_version:"=!"  REM Remove double quotes, if any
)

REM Check if project version is retrieved successfully
if not defined project_version (
    echo Failed to retrieve project version from manifest.json.
    exit /b 1
)

REM Loop through each Visual Studio version
for %%v in (%vs_versions%) do (
    set "vs_version=Visual Studio %%v"

    echo Attempting to generate %vs_version% solution files...

    REM Run CMake with the specified Visual Studio generator
    cmake -G "!vs_version!" -A x64 -DPROJ_VERSION=!project_version! .

    REM Check the exit code of the CMake command
    if !errorlevel! equ 0 (
        echo Solution files generated successfully using %vs_version%.
        exit /b 0
    ) else (
        echo Failed to generate solution files using %vs_version%.
    )
)

echo Unable to generate solution files with any Visual Studio version.
exit /b 1
