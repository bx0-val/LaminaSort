@echo off
setlocal
cd /d "%~dp0.."
for /f "usebackq delims=" %%I in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "LAMINA_VS=%%I"
if not defined LAMINA_VS exit /b 1
call "%LAMINA_VS%\VC\Auxiliary\Build\vcvars64.bat" >nul
if errorlevel 1 exit /b 1
if not exist build mkdir build
cl /nologo /std:c++20 /EHsc /utf-8 /W4 /Isrc src\mod\sort\*.cpp tests\*.cpp /Fo:build\ /Fe:build\LaminaSortTests.exe
if errorlevel 1 exit /b 1
build\LaminaSortTests.exe
exit /b %errorlevel%
