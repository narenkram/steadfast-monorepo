@echo off
setlocal enabledelayedexpansion

:menu
echo Choose an option:
echo 1. Install all (Recommended for first time setup)
echo 2. Update, install and run (Recommended when a update is available)
echo 3. Run existing version
echo 4. Exit
set /p choice="Enter your choice (1, 2, 3, or 4): "

if "%choice%"=="1" goto install
if "%choice%"=="2" goto update_and_run
if "%choice%"=="3" goto run
if "%choice%"=="4" goto end
echo Invalid choice. Please try again.
goto menu

:install
REM Clone the app repository and install dependencies
echo Checking app repository...
if not exist "steadfast-app\.git" (
    echo Cloning app...
    git clone https://github.com/narenkram/steadfast-app.git
) else (
    echo App repository already exists, skipping clone...
)
cd steadfast-app
echo Installing app dependencies...
call npm install
if !errorlevel! neq 0 (
    echo Error occurred while installing app dependencies.
    goto :error
)
cd ..

REM Clone the API repository and install dependencies
echo Checking API repository...
if not exist "steadfast-api\.git" (
    echo Cloning API...
    git clone https://github.com/narenkram/steadfast-api.git
) else (
    echo API repository already exists, skipping clone...
)
cd steadfast-api
echo Installing API dependencies...
call npm install
if !errorlevel! neq 0 (
    echo Error occurred while installing API dependencies.
    goto :error
)
cd ..

REM Clone the WebSocket repository and install dependencies
echo Checking WebSocket repository...
if not exist "steadfast-websocket\.git" (
    echo Cloning WebSocket...
    git clone https://github.com/narenkram/steadfast-websocket.git
) else (
    echo WebSocket repository already exists, skipping clone...
)
cd steadfast-websocket

echo Installing WebSocket dependencies...
pip install -r requirements.txt
if !errorlevel! neq 0 (
    echo Error occurred while installing WebSocket dependencies.
    goto :error
)

REM Install NorenRestApi without dependencies
echo Installing NorenRestApi...
pip install --no-deps NorenRestApi
if !errorlevel! neq 0 (
    echo Error occurred while installing NorenRestApi.
    goto :error
)

cd ..
echo Repositories cloned and dependencies installed successfully.
goto menu

:update_and_run
REM Update the entire monorepo
echo Updating steadfast-monorepo...
git pull https://github.com/narenkram/steadfast-monorepo main
if !errorlevel! neq 0 (
    echo Error updating steadfast-monorepo.
    goto :error
)

REM Update steadfast-app
echo Updating steadfast-app...
cd steadfast-app
git pull https://github.com/narenkram/steadfast-app main
if !errorlevel! neq 0 (
    echo Error updating steadfast-app.
    goto :error
)
echo Installing app dependencies...
call npm install
call npm audit fix
cd ..

REM Update steadfast-api
echo Updating steadfast-api...
cd steadfast-api
git pull https://github.com/narenkram/steadfast-api main
if !errorlevel! neq 0 (
    echo Error updating steadfast-api.
    goto :error
)
echo Installing api dependencies...
call npm install
call npm audit fix
cd ..

REM Update steadfast-websocket
echo Updating steadfast-websocket...
cd steadfast-websocket
git pull https://github.com/narenkram/steadfast-websocket main
if !errorlevel! neq 0 (
    echo Error updating steadfast-websocket.
    goto :error
)
cd ..

echo Update complete.
goto run

:run
REM Start the API in a new command prompt window
echo Starting API...
start /min cmd /c "cd steadfast-api && node server.js"

REM Start the app in a new command prompt window
echo Starting app...
start /min cmd /c "cd steadfast-app && npm run dev"

REM Start the WebSocket server in a new command prompt window
echo Starting WebSocket server...
start /min cmd /c "cd steadfast-websocket && python main.py"

REM Wait for a few seconds to allow the app to start
timeout /t 5

REM Open the default browser to the API's URL
echo Opening browser to API's URL...
start http://localhost:3000

REM Open the default browser to the app's URL
echo Opening browser to app's URL...
start http://localhost:5173

echo Services started and browsers opened. Close this window to stop all services.
echo Press any key to stop all services...
pause > nul

REM Kill all node processes
taskkill /F /IM node.exe > nul 2>&1

REM Kill all python processes
taskkill /F /IM python.exe > nul 2>&1

echo All services stopped.
goto menu

:end
endlocal
