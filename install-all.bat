@echo off

REM Clone the app repository and install dependencies
cd steadfast-stoic-app
git init
git remote add origin https://github.com/narenkram/steadfast-stoic-app.git
git fetch
git checkout -b main origin/main
echo Installing app dependencies...
npm install
cd ..

REM Clone the API repository and install dependencies
cd steadfast-stoic-api
git init
git remote add origin https://github.com/narenkram/steadfast-stoic-api.git
git fetch
git checkout -b main origin/main
echo Installing API dependencies...
npm install
cd ..

echo Repositories cloned and dependencies installed successfully.
pause