@echo off
setlocal enabledelayedexpansion

:: Function to clone and install a repository
:CloneAndInstall
set "repo_name=%~1"
set "repo_url=%~2"

echo Debug: repo_name is "!repo_name!"
echo Debug: repo_url is "!repo_url!"

if exist "!repo_name!" (
    echo Folder !repo_name! already exists.
    if exist "!repo_name!\.git" (
        echo It appears to be a git repository. Updating...
        pushd "!repo_name!"
        git pull
        popd
    ) else (
        echo It's an empty folder. Removing and cloning fresh...
        rmdir /s /q "!repo_name!"
        git clone "!repo_url!" "!repo_name!"
    )
) else (
    echo Cloning !repo_name! from !repo_url!...
    git clone "!repo_url!" "!repo_name!"
)

if errorlevel 1 (
    echo Failed to clone or update !repo_name!. Exiting...
    exit /b 1
)

echo Installing dependencies for !repo_name!...
pushd "!repo_name!"
npm install
if errorlevel 1 (
    echo Failed to install dependencies for !repo_name!. Exiting...
    popd
    exit /b 1
)
popd
exit /b 0

:: Clone and install steadfast-stoic-app
set "app_name=steadfast-stoic-app"
set "app_url=https://github.com/narenkram/steadfast-stoic-app.git"
call :CloneAndInstall "!app_name!" "!app_url!"
if errorlevel 1 exit /b

:: Clone and install steadfast-stoic-api
set "api_name=steadfast-stoic-api"
set "api_url=https://github.com/narenkram/steadfast-stoic-api.git"
call :CloneAndInstall "!api_name!" "!api_url!"
if errorlevel 1 exit /b

echo Installation complete.
pause
endlocal