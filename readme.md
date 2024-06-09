# Project Overview

This repository is a monorepo containing three main projects:

1. **steadfast-stoic-app**: The frontend application.
2. **steadfast-stoic-api**: The backend API server.
3. **steadfast-dhan-websocket**: The WebSocket service.

# Quick Start

To quickly start all the services, you can use the **start-all.bat** script. This script will:

1. Kill any running Redis server.
2. Start a new Redis server.
3. Start the frontend application.
4. Start the backend API server.
5. Start the WebSocket service.

## Running the Script

For Windows:

```bash
start-all.bat
```

This will ensure that all services are up and running.

# Project Details

## steadfast-stoic-app

The steadfast-stoic-app folder contains the frontend application built with Vue 3 and Vite. This application provides the user interface for interacting with the backend services and displaying real-time data.

### Key Features

Built with Vue 3 and Vite for a modern, fast development experience.
Provides a user-friendly interface for trading and monitoring market data.
Integrates with the backend API and WebSocket services for real-time updates.

### Getting Started

To run the frontend application, navigate to the steadfast-stoic-app directory and use the following commands:

```bash
cd steadfast-stoic-app
npm install
npm run dev
```

The application will be available at http://localhost:5173.

## steadfast-stoic-api

The steadfast-stoic-api folder contains the backend API server, which is built using Node.js and Express. This server handles API requests, interacts with the DhanHQ SDK, and serves data to the frontend application.

### Key Features

Built with Node.js and Express for a robust and scalable backend.
Handles authentication, data processing, and business logic.
Provides RESTful API endpoints for the frontend application.

### Getting Started

To run the backend API server, navigate to the steadfast-stoic-api directory and use the following commands:

```bash
cd steadfast-stoic-api
npm install
npm run dev
```

The API server will be available at http://localhost:3000.

## steadfast-dhan-websocket

The steadfast-dhan-websocket folder contains a Python package for interacting with the DhanHQ API. This service manages WebSocket connections to receive real-time market data and updates.

### Key Features

Built with Python for efficient handling of WebSocket connections.
Interacts with the DhanHQ API to subscribe to market data feeds.
Publishes real-time data to Redis for consumption by other services.

### Getting Started

To run the WebSocket service, navigate to the steadfast-dhan-websocket directory and use the following commands:

```bash
cd steadfast-dhan-websocket
pip install -r requirements.txt
python main.py
```

The WebSocket service will connect to the DhanHQ API and start receiving real-time market data.
