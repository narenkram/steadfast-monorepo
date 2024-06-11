@echo off

REM Navigate to each directory and start the respective services
concurrently ^
  "cd steadfast-stoic-app && npm run dev" ^
  "cd steadfast-stoic-api && node server.js" ^