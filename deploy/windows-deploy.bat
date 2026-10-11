@echo off
setlocal
set "SRC=%~dp0.."
set "OUT=%SRC%\dist"

for /f "tokens=1,* delims=:" %%a in ('findstr /b /c:"## Version:" "%SRC%\YaworsCleanUI.toc"') do set "VERSION=%%b"
if not defined VERSION (
    echo Error: ## Version not found in YaworsCleanUI.toc
    exit /b 1
)
set "VERSION=%VERSION: =%"

set "STAGE=%TEMP%\YaworsCleanUI-build-%RANDOM%"
rem CurseForge expects the addon folder at the zip root.
set "ADDON=%STAGE%\YaworsCleanUI"
mkdir "%ADDON%\modules"
mkdir "%ADDON%\settings"
mkdir "%ADDON%\textures"

copy /y "%SRC%\YaworsCleanUI.toc"  "%ADDON%\" >nul
copy /y "%SRC%\Core.lua"           "%ADDON%\" >nul
copy /y "%SRC%\Settings.lua"       "%ADDON%\" >nul
copy /y "%SRC%\LICENSE"            "%ADDON%\" >nul
copy /y "%SRC%\CHANGELOG.md"       "%ADDON%\" >nul
copy /y "%SRC%\modules\*.lua"      "%ADDON%\modules\" >nul
copy /y "%SRC%\settings\*.lua"     "%ADDON%\settings\" >nul
copy /y "%SRC%\textures\*"         "%ADDON%\textures\" >nul

set "ZIP=%OUT%\YaworsCleanUI-%VERSION%.zip"
if not exist "%OUT%" mkdir "%OUT%"
if exist "%ZIP%" del "%ZIP%"

rem tar.exe ships with Windows 10+ and writes zip when the archive name ends in .zip.
tar -a -c -f "%ZIP%" -C "%STAGE%" YaworsCleanUI
set "RESULT=%ERRORLEVEL%"
rd /s /q "%STAGE%"
if not "%RESULT%"=="0" exit /b %RESULT%

echo Done: %ZIP%
