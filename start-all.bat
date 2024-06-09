@echo off

REM Kill any running Redis server
taskkill /F /IM redis-server.exe

REM Start Redis server
start redis-server

REM Navigate to each directory and start the respective services
concurrently ^
  "cd steadfast-stoic-app && npm run dev" ^
  "cd steadfast-stoic-api && node server.js" ^
  "cd steadfast-dhan-websocket && python market_feed_socket.py"