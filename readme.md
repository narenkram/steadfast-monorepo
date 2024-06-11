# Project Overview

This repository is a monorepo containing three main projects:

1. **steadfast-stoic-app**: The frontend application.
2. **steadfast-stoic-api**: The backend API server.
3. **steadfast-dhan-websocket**: The WebSocket service(Not Implemented yet).

To run the frontend application, navigate to the steadfast-stoic-app directory and use the following commands:

```bash
cd steadfast-stoic-app
npm install
npm run dev
```
The application will be available at http://localhost:5173.


To run the backend API server, navigate to the steadfast-stoic-api directory and use the following commands:

```bash
cd steadfast-stoic-api
npm install
node server.js
```
The API server will be available at http://localhost:3000.


# Quick Start

To quickly start all the services, you can use the **start-all.bat** script. This script will:

1. Start the frontend application.
2. Start the backend API server.

## Running the Script

For Windows:

```bash
start-all.bat
```

This will ensure that all services are up and running.



## steadfast-dhan-websocket - Not Implemented yet.

The steadfast-dhan-websocket folder contains a Python package for interacting with the DhanHQ API. This service manages WebSocket connections to receive real-time market data and updates.

### Getting Started

To run the WebSocket service, navigate to the steadfast-dhan-websocket directory and use the following commands:

```bash
cd steadfast-dhan-websocket
pip install -r requirements.txt
python main.py
```

The WebSocket service will connect to the DhanHQ API and start receiving real-time market data.
