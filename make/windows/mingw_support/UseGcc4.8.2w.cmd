@echo off

if "%BASEPATH%"=="" set BASEPATH=%path%
set path=C:\mingw-w64\x86_64-4.8.2-win32-seh-rt_v3-rev4\mingw64\bin;C:\Program Files (x86)\Windows Kits\8.1\bin\x64\;%BASEPATH%
set TS_GCC_THREAD=w
