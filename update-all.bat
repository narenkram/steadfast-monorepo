@echo off
echo Updating steadfast-stoic-app...
cd steadfast-stoic-app
git pull https://github.com/narenkram/steadfast-stoic-app
cd ..

echo Updating steadfast-stoic-api...
cd steadfast-stoic-api
git pull https://github.com/narenkram/steadfast-stoic-api
cd ..

echo Update complete.
pause