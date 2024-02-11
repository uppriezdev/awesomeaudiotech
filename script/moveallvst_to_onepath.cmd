@echo off
:: BatchGotAdmin
:-------------------------------------
REM  - Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --If error flag set, we do not have admin.
    if '%errorlevel%' NEQ '0' (
        echo Requesting administrative privileges...
        goto UACPrompt
    ) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
setlocal enabledelayedexpansion

set "TARGET_DIR=C:\Program Files\VSTPlugins"

:: Define source directories
set "SOURCE_DIRS[0]=C:\Program Files\Steinberg\VSTPlugins"
set "SOURCE_DIRS[1]=C:\Program Files\Cakewalk\VSTPlugins"
set "SOURCE_DIRS[2]=C:\Program Files\Common Files\VST2"

:: Move subfolders from each source to target
for /L %%i in (0,1,2) do (
    set "SOURCE_DIR=!SOURCE_DIRS[%%i]!"
    echo Moving subfolders from !SOURCE_DIR! to %TARGET_DIR%
    
    for /d %%d in ("!SOURCE_DIR!\*") do (
        xcopy "%%d" "%TARGET_DIR%\%%~nxd" /E /H /C /I /Y
        rd /s /q "%%d"
    )
)

echo Operation completed.
pause
