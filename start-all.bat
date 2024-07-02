@echo off
setlocal enabledelayedexpansion

:menu
echo Choose an option:
echo 1. Update the app, api and Run (Recommended once a day)
echo 2. Run existing version
set /p choice="Enter your choice (1 or 2): "

if "%choice%"=="1" goto update
if "%choice%"=="2" goto run
echo Invalid choice. Please try again.
goto menu

:update
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

:run
REM Start the app in a new command prompt window
start /min cmd /c "cd steadfast-stoic-app && npm run dev"

REM Start the API in a new command prompt window
start /min cmd /c "cd steadfast-stoic-api && node server.js"

REM Wait for a few seconds to allow the app to start
timeout /t 5

REM Open the default browser to the app's URL
start http://localhost:5173

echo Services started and browser opened. Close this window to stop all services.
echo Press any key to stop all services...
pause > nul

REM Kill all node processes
taskkill /F /IM node.exe > nul 2>&1

echo All services stopped.
goto :end

:error
echo An error occurred during the update process.
pause
exit /b 1

:end
endlocal