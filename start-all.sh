#!/bin/bash

# Enable error handling
set -e

# Function to display the menu
menu() {
    echo "Choose an option:"
    echo "1. Install all (Recommended for first time setup)"
    echo "2. Update and install dependencies (For updating existing setup)"
    echo "3. Run existing version"
    echo "4. Exit"
    read -p "Enter your choice (1, 2, 3, or 4): " choice

    case $choice in
        1) install ;;
        2) update_and_run ;;
        3) run ;;
        4) exit 0 ;;
        *) echo "Invalid choice. Please try again."
           menu ;;
    esac
}

# Function to install all repositories and dependencies
install() {
    echo "Cloning repositories..."

    echo "Checking app repository..."
    if [ ! -d "steadfast-app/.git" ]; then
        echo "Cloning app..."
        git clone https://github.com/narenkram/steadfast-app.git
    else
        echo "App repository already exists, skipping clone..."
    fi

    echo "Checking API repository..."
    if [ ! -d "steadfast-api/.git" ]; then
        echo "Cloning API..."
        git clone https://github.com/narenkram/steadfast-api.git
    else
        echo "API repository already exists, skipping clone..."
    fi

    echo "Checking WebSocket repository..."
    if [ ! -d "steadfast-websocket/.git" ]; then
        echo "Cloning WebSocket..."
        git clone https://github.com/narenkram/steadfast-websocket.git
    else
        echo "WebSocket repository already exists, skipping clone..."
    fi

    echo "Installing dependencies for all repositories..."

    echo "Installing app dependencies..."
    cd steadfast-app
    npm install || { echo "Error occurred while installing app dependencies."; exit 1; }
    cd ..

    echo "Installing API dependencies..."
    cd steadfast-api
    npm install || { echo "Error occurred while installing API dependencies."; exit 1; }
    cd ..

    echo "Installing WebSocket dependencies..."
    cd steadfast-websocket

    # Create and activate virtual environment
    python -m venv venv
    source venv/bin/activate

    # Install dependencies within virtual environment
    pip install -r requirements.txt || { echo "Error occurred while installing WebSocket dependencies."; exit 1; }
    
    cd ..

    echo "Installing NorenRestApi..."
    pip install --no-deps NorenRestApi || { echo "Error occurred while installing NorenRestApi."; exit 1; }
    deactivate

    echo "Repositories cloned and dependencies installed successfully."
    menu
}

# Function to update repositories and install dependencies
update_and_run() {
    echo "Updating steadfast-monorepo..."
    git pull https://github.com/narenkram/steadfast-monorepo main || { echo "Error updating steadfast-monorepo."; exit 1; }

    echo "Updating steadfast-app..."
    cd steadfast-app
    git pull https://github.com/narenkram/steadfast-app main || { echo "Error updating steadfast-app."; exit 1; }
    echo "Installing app dependencies..."
    npm install
    npm audit fix
    cd ..

    echo "Updating steadfast-api..."
    cd steadfast-api
    git pull https://github.com/narenkram/steadfast-api main || { echo "Error updating steadfast-api."; exit 1; }
    echo "Installing API dependencies..."
    npm install
    npm audit fix
    cd ..

    echo "Updating steadfast-websocket..."
    cd steadfast-websocket
    git pull https://github.com/narenkram/steadfast-websocket main || { echo "Error updating steadfast-websocket."; exit 1; }
    
    # Activate virtual environment and install dependencies
    source venv/bin/activate
    pip install -r requirements.txt || { echo "Error occurred while installing WebSocket dependencies."; exit 1; }
    deactivate
    cd ..

    echo "Update complete."
    menu
}

# Function to run the existing version
run() {
    echo "Starting API..."
    bash -c "cd steadfast-api && node server.js & "

    echo "Starting app..."
    bash -c "cd steadfast-app && npm run dev & "

    echo "Starting WebSocket server..."
    bash -c "cd steadfast-websocket && source venv/bin/activate && python main.py & "

    sleep 5

    echo "Opening browser to API's URL..."
    xdg-open http://localhost:3000

    echo "Opening browser to app's URL..."
    xdg-open http://localhost:5173

    echo "Services started and browsers opened. Close this window to stop all services."
    read -p "Press any key to stop all services..." -n1 -s

    echo "Stopping all services..."
    pkill -f node
    pkill -f python

    echo "All services stopped."
    menu
}

# Start the menu
menu