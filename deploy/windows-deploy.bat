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

copy /y "%SRC%\YaworsCleanUI.toc"           "%DEST%\"
copy /y "%SRC%\Core.lua"                    "%DEST%\"
copy /y "%SRC%\Settings.lua"               "%DEST%\"
copy /y "%SRC%\modules\HideElements.lua"   "%DEST%\modules\"

echo Done.
