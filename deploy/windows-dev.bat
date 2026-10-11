@echo off
set "CONF=%~dp0deploy.conf"
set "SRC=%~dp0.."

for /f "usebackq tokens=1,* delims==" %%a in ("%CONF%") do (
    if "%%a"=="WINDOWS_DEST" set "DEST=%%b"
)

if not defined DEST (
    echo Error: WINDOWS_DEST not found in deploy.conf
    exit /b 1
)

rd /s /q "%DEST%"
mkdir "%DEST%\modules"
mkdir "%DEST%\settings"
mkdir "%DEST%\textures"

copy /y "%SRC%\YaworsCleanUI.toc"  "%DEST%\" >nul
copy /y "%SRC%\Core.lua"           "%DEST%\" >nul
copy /y "%SRC%\Settings.lua"       "%DEST%\" >nul
copy /y "%SRC%\modules\*.lua"      "%DEST%\modules\" >nul
copy /y "%SRC%\settings\*.lua"     "%DEST%\settings\" >nul
copy /y "%SRC%\textures\*"         "%DEST%\textures\" >nul

echo Done.
