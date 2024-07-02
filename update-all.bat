@echo off
setlocal enabledelayedexpansion

REM Update steadfast-stoic-app
echo Updating steadfast-stoic-app...
cd steadfast-stoic-app
git pull https://github.com/narenkram/steadfast-stoic-app main
if !errorlevel! neq 0 (
    echo Error updating steadfast-stoic-app.
    goto :error
)
cd ..

REM Update steadfast-stoic-api
echo Updating steadfast-stoic-api...
cd steadfast-stoic-api
git pull https://github.com/narenkram/steadfast-stoic-api main
if !errorlevel! neq 0 (
    echo Error updating steadfast-stoic-api.
    goto :error
)
cd ..

echo Update complete.
goto :end

:error
echo An error occurred during the update process.

:end
pause
endlocal