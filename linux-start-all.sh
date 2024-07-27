#!/bin/bash

function menu {
    echo "Choose an option:"
    echo "1. Update everything (monorepo, app, api, websocket) (Recommended once a day)"
    echo "2. Run existing version"
    echo "3. Exit"
    read -p "Enter your choice (1, 2, or 3): " choice

    case $choice in
    1) update ;;
    2) run ;;
    3) exit 0 ;;
    *)
        echo "Invalid choice. Please try again."
        menu
        ;;
    esac
}

function update {
    # Update the entire monorepo
    echo "Updating steadfast-monorepo..."
    git pull https://github.com/narenkram/steadfast-monorepo main || {
        echo "Error updating steadfast-monorepo."
        error
    }

    # Update steadfast-app
    echo "Updating steadfast-app..."
    cd steadfast-app || { echo "Directory steadfast-app not found."; error; }
    git pull https://github.com/narenkram/steadfast-app main || {
        echo "Error updating steadfast-app."
        error
    }
    cd ..

    # Update steadfast-api
    echo "Updating steadfast-api..."
    cd steadfast-api || { echo "Directory steadfast-api not found."; error; }
    git pull https://github.com/narenkram/steadfast-api main || {
        echo "Error updating steadfast-api."
        error
    }
    cd ..

    # Update steadfast-websocket
    echo "Updating steadfast-websocket..."
    cd steadfast-websocket || { echo "Directory steadfast-websocket not found."; error; }
    git pull https://github.com/narenkram/steadfast-websocket main || {
        echo "Error updating steadfast-websocket."
        error
    }
    cd ..

    echo "Update complete."
    menu
}

function run {
    # Start the API in a new terminal window
    echo "Starting API..."
    gnome-terminal -- bash -c "cd steadfast-api && node server.js" || { echo "Failed to start API."; error; }

    # Start the Flattrade websocket in a new terminal window
    echo "Starting Flattrade websocket..."
    gnome-terminal -- bash -c "cd steadfast-websocket/flattrade && python3 flattrade-websocket.py" || { echo "Failed to start Flattrade websocket."; error; }

    # Start the Shoonya websocket in a new terminal window
    echo "Starting Shoonya websocket..."
    gnome-terminal -- bash -c "cd steadfast-websocket/shoonya && python3 shoonya-websocket.py" || { echo "Failed to start Shoonya websocket."; error; }
    
    # Start the app in a new terminal window
    echo "Starting app..."
    gnome-terminal -- bash -c "cd steadfast-app && npm run dev" || { echo "Failed to start app."; error; }

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

function error {
    echo "An error occurred. Returning to menu."
    menu
}

menu