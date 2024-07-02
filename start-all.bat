@echo off

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