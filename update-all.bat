@echo off
:: Function to update or clone a repository
:UpdateOrClone
if exist %1 (
    echo Updating %1...
    cd %1
    git pull %2
    cd ..
) else (
    echo Cloning %1...
    git clone %2 %1
)
goto :eof

:: Update or clone steadfast-stoic-app
call :UpdateOrClone steadfast-stoic-app https://github.com/narenkram/steadfast-stoic-app

:: Update or clone steadfast-stoic-api
call :UpdateOrClone steadfast-stoic-api https://github.com/narenkram/steadfast-stoic-api

echo Update complete.
pause