@echo off

:: Function to clone and install a repository
:CloneAndInstall
if not exist %1 (
    echo Cloning %1...
    git clone %2 %1
)
echo Installing dependencies for %1...
cd %1
npm install
cd ..
goto :eof

:: Clone and install steadfast-stoic-app
call :CloneAndInstall steadfast-stoic-app https://github.com/narenkram/steadfast-stoic-app

:: Clone and install steadfast-stoic-api
call :CloneAndInstall steadfast-stoic-api https://github.com/narenkram/steadfast-stoic-api

echo Installation complete.
pause