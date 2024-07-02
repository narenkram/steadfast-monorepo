@echo off

REM Start the app in a new command prompt window
start cmd /k "cd steadfast-stoic-app && npm run dev"

REM Start the API in a new command prompt window
start cmd /k "cd steadfast-stoic-api && node server.js"

echo Services started. Close this window to stop all services.
pause