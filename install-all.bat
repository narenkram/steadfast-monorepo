@echo off

REM Clone the app repository
cd steadfast-stoic-app
git init
git remote add origin https://github.com/narenkram/steadfast-stoic-app.git
git fetch
git checkout -b main origin/main
cd ..

REM Clone the API repository
cd steadfast-stoic-api
git init
git remote add origin https://github.com/narenkram/steadfast-stoic-api.git
git fetch
git checkout -b main origin/main
cd ..

echo Repositories cloned successfully.
pause