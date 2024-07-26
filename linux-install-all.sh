#!/bin/bash

set -e

# Function to handle errors
function error {
    echo "An error occurred. Please check the output above for details."
    exit 1
}

# Clone the app repository and install dependencies
echo "Checking app repository..."
if [ ! -d "steadfast-app/.git" ]; then
    echo "Cloning app..."
    git clone https://github.com/narenkram/steadfast-app.git || error
else
    echo "App repository already exists, skipping clone..."
fi
cd steadfast-app
echo "Installing app dependencies..."
npm install || error
cd ..

# Clone the API repository and install dependencies
echo "Checking API repository..."
if [ ! -d "steadfast-api/.git" ]; then
    echo "Cloning API..."
    git clone https://github.com/narenkram/steadfast-api.git || error
else
    echo "API repository already exists, skipping clone..."
fi
cd steadfast-api
echo "Installing API dependencies..."
npm install || error
cd ..

# Clone the WebSocket repository and install dependencies
echo "Checking WebSocket repository..."
if [ ! -d "steadfast-websocket/.git" ]; then
    echo "Cloning WebSocket..."
    git clone https://github.com/narenkram/steadfast-websocket.git || error
else
    echo "WebSocket repository already exists, skipping clone..."
fi
cd steadfast-websocket

echo "Installing WebSocket dependencies..."
echo "Installing Flattrade dependencies..."
cd flattrade
chmod +x flattrade-websocket.py
pip install -r requirements.txt || error
cd ..

echo "Installing Shoonya dependencies..."
cd shoonya
chmod +x shoonya-websocket.py
pip install -r requirements.txt || error
cd ..

echo "Installing Dhanhq dependencies..."
cd dhanhq
chmod +x dhan-websocket.py
pip install -r requirements.txt || error
cd ../.. 
echo "Repositories cloned and dependencies installed successfully."

# End of script
