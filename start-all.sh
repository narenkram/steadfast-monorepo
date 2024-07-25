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
    echo "Updating steadfast-stoic-monorepo..."
    git pull https://github.com/narenkram/steadfast-stoic-monorepo main || {
        echo "Error updating steadfast-stoic-monorepo."
        error
    }

    # Update steadfast-stoic-app
    echo "Updating steadfast-stoic-app..."
    cd steadfast-stoic-app
    git pull https://github.com/narenkram/steadfast-stoic-app main || {
        echo "Error updating steadfast-stoic-app."
        error
    }
    cd ..

    # Update steadfast-stoic-api
    echo "Updating steadfast-stoic-api..."
    cd steadfast-stoic-api
    git pull https://github.com/narenkram/steadfast-stoic-api main || {
        echo "Error updating steadfast-stoic-api."
        error
    }
    cd ..

    # Update steadfast-websocket
    echo "Updating steadfast-websocket..."
    cd steadfast-websocket
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
    gnome-terminal -- bash -c "cd steadfast-stoic-api && node server.js"

    # Start the app in a new terminal window
    echo "Starting app..."
    gnome-terminal -- bash -c "cd steadfast-stoic-app && npm run dev"

    # Start the Flattrade websocket in a new terminal window
    echo "Starting Flattrade websocket..."
    gnome-terminal -- bash -c "cd steadfast-websocket/flattrade && python3 flattrade-websocket.py"

    # Start the Shoonya websocket in a new terminal window
    echo "Starting Shoonya websocket..."
    gnome-terminal -- bash -c "cd steadfast-websocket/shoonya && python3 shoonya-websocket.py"

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
