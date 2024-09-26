#!/bin/bash

function menu {
    echo "Choose an option:"
    echo "1. Install all (Recommended for first time setup)"
    echo "2. Update, install and run (Recommended when an update is available)"
    echo "3. Run existing version"
    echo "4. Exit"
    read -p "Enter your choice (1, 2, 3, or 4): " choice

    case "$choice" in
    1) install ;;
    2) update_and_run ;;
    3) run ;;
    4) exit 0 ;;
    *)
        echo "Invalid choice. Please try again."
        menu
        ;;
    esac
}

function install {
    # Clone the app repository and install dependencies
    echo "Checking app repository..."
    if [ ! -d "steadfast-app/.git" ]; then
        echo "Cloning app..."
        git clone https://github.com/narenkram/steadfast-app.git
    else
        echo "App repository already exists, skipping clone..."
    fi
    cd steadfast-app
    echo "Installing app dependencies..."
    npm install || {
        echo "Error occurred while installing app dependencies."
        cd ..
        menu
    }
    cd ..

    # Clone the API repository and install dependencies
    echo "Checking API repository..."
    if [ ! -d "steadfast-api/.git" ]; then
        echo "Cloning API..."
        git clone https://github.com/narenkram/steadfast-api.git
    else
        echo "API repository already exists, skipping clone..."
    fi
    cd steadfast-api
    echo "Installing API dependencies..."
    npm install || {
        echo "Error occurred while installing API dependencies."
        cd ..
        menu
    }
    cd ..

    # Clone the WebSocket repository and install dependencies
    echo "Checking WebSocket repository..."
    if [ ! -d "steadfast-websocket/.git" ]; then
        echo "Cloning WebSocket..."
        git clone https://github.com/narenkram/steadfast-websocket.git
    else
        echo "WebSocket repository already exists, skipping clone..."
    fi
    cd steadfast-websocket

    echo "Installing WebSocket..."

    # Install NorenRestApi without dependencies for Flattrade and Shoonya
    echo "Installing NorenRestApi for Flattrade and Shoonya..."
    pip install --no-deps NorenRestApi || {
        echo "Error occurred while installing NorenRestApi."
        cd ..
        menu
    }

    echo "Installing Flattrade dependencies..."
    cd flattrade
    pip install -r requirements.txt || {
        echo "Error occurred while installing WebSocket dependencies for Flattrade."
        cd ../..
        menu
    }
    cd ..

    echo "Installing Shoonya dependencies..."
    cd shoonya
    pip install -r requirements.txt || {
        echo "Error occurred while installing WebSocket dependencies for Shoonya."
        cd ../..
        menu
    }
    cd ../..

    echo "Repositories cloned and dependencies installed successfully."
    menu
}

function update_and_run {
    # Update the entire monorepo
    echo "Updating steadfast-monorepo..."
    git -C steadfast-monorepo pull || {
        echo "Error updating steadfast-monorepo."
        menu
    }

    # Update steadfast-app
    echo "Updating steadfast-app..."
    git -C steadfast-app pull || {
        echo "Error updating steadfast-app."
        menu
    }
    echo "Installing app dependencies..."
    npm install
    npm audit fix
    cd ..

    # Update steadfast-api
    echo "Updating steadfast-api..."
    git -C steadfast-api pull || {
        echo "Error updating steadfast-api."
        menu
    }
    echo "Installing API dependencies..."
    npm install
    npm audit fix
    cd ..

    # Update steadfast-websocket
    echo "Updating steadfast-websocket..."
    git -C steadfast-websocket pull || {
        echo "Error updating steadfast-websocket."
        menu
    }
    cd ..

    echo "Update complete."
    run
}

function run {
    # Start the API in a new terminal window
    echo "Starting API..."
    gnome-terminal -- bash -c "cd steadfast-api && node server.js; exec bash"

    # Start the app in a new terminal window
    echo "Starting app..."
    gnome-terminal -- bash -c "cd steadfast-app && npm run dev; exec bash"

    # Start the Flattrade websocket in a new terminal window
    echo "Starting Flattrade websocket..."
    gnome-terminal -- bash -c "cd steadfast-websocket/flattrade && python flattrade-websocket.py; exec bash"

    # Start the Shoonya websocket in a new terminal window
    echo "Starting Shoonya websocket..."
    gnome-terminal -- bash -c "cd steadfast-websocket/shoonya && python shoonya-websocket.py; exec bash"

    # Wait for a few seconds to allow the app to start
    sleep 5

    # Open the default browser to the API's URL
    echo "Opening browser to API's URL..."
    xdg-open http://localhost:3000

    # Open the default browser to the app's URL
    echo "Opening browser to app's URL..."
    xdg-open http://localhost:5173

    echo "Services started and browsers opened. Close this window to stop all services."
    read -n 1 -s -r -p "Press any key to stop all services..."

    # Kill all node processes
    pkill -f node

    # Kill all python processes
    pkill -f python

    echo "All services stopped."
    menu
}

menu
