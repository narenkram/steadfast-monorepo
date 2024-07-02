@echo off
setlocal enabledelayedexpansion

REM Clone the app repository and install dependencies
echo Cloning and installing app...
cd steadfast-stoic-app
git init
git remote add origin https://github.com/narenkram/steadfast-stoic-app.git
git fetch
git checkout -b main origin/main
if !errorlevel! neq 0 (
    echo Error occurred while cloning app repository.
    goto :error
)
echo Installing app dependencies...
call npm install
if !errorlevel! neq 0 (
    echo Error occurred while installing app dependencies.
    goto :error
)
cd ..

REM Clone the API repository and install dependencies
echo Cloning and installing API...
cd steadfast-stoic-api
git init
git remote add origin https://github.com/narenkram/steadfast-stoic-api.git
git fetch
git checkout -b main origin/main
if !errorlevel! neq 0 (
    echo Error occurred while cloning API repository.
    goto :error
)
echo Installing API dependencies...
call npm install
if !errorlevel! neq 0 (
    echo Error occurred while installing API dependencies.
    goto :error
)
cd ..

echo Repositories cloned and dependencies installed successfully.
goto :end

:error
echo An error occurred. Please check the output above for details.

:end
pause
endlocal