@echo off

%~d0
cd %~dp0

echo building pseudo-sc.exe ...

g++ src/pseudo-sc.cpp src/iostream.cpp -Isrc/ -std=c++2a -O2 -o bin-win64/pseudo-sc

if %ERRORLEVEL% NEQ 0 (
    echo [31m BUILD FAILED ![0m
    pause
)
else (
    explorer /select, %~dp0bin-win64\copy-code-point.bat
    exit
)