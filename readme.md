# Project Overview

This repository is a monorepo containing three main projects:

1. [**steadfast-stoic-app**](https://github.com/narenkram/steadfast-stoic-app): The frontend application.
2. [**steadfast-stoic-api**](https://github.com/narenkram/steadfast-stoic-api): The backend API server.
3. [**steadfast-websocket**](https://github.com/narenkram/steadfast-websocket): The WebSocket service(Not Implemented yet).

### Quick Status: (Updated on 30-06-2024)

- Dhan - 🟢 Partial Trading Capabilities
- Flattrade - 🟢 Partial Trading Capabilities
- Shoonya (Finvasia) - 🔵 Will be added in few days
- Websocket - 🟡 Implementation on progress

### What works? (Updated on 02-07-2024)
👉 All these basic operations now work well for both brokers:

- ✅ kill switch
- ✅ buy/sell
- ✅ cancel orders
- ✅ place limit
- ✅ select strikes
- ✅ close all positions

#### Note: 
kill switch works on client side only, you will still be able to trade from your broker terminal.

# App Screenshots

![Preview in Manage Brokers](preview_managebroker_light.png)
![Preview in Dark Mode](preview_dark.png)
![Preview in Light Mode](preview_light.png)

# Join Our Telegram Channel

Stay updated by joining our [Telegram Channel](https://t.me/steadfaststoic).

### Get your API Key from your Broker and replace API Key in steadfast-stoic-api/.env

```
DHAN_CLIENT_ID = "Your_Dhan_Client_ID"
DHAN_API_TOKEN = "Your_Dhan_API_Token"


FLATTRADE_CLIENT_ID = "Your_Flattrade_Client_ID"
FLATTRADE_API_KEY = "Your_Flattrade_API_Key"
FLATTRADE_API_SECRET = "Your_Flattrade_API_Secret"
```

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

## If you prefer to run the services manually, follow the steps below:

## steadfast-app

### Running the Frontend Application

To run the frontend application, navigate to the steadfast-stoic-app directory and use the following commands:

```bash
cd steadfast-stoic-app
npm install
npm run dev
```

The application will be available at http://localhost:5173.

## steadfast-api

### Running the Backend API Server

To run the backend API server, navigate to the steadfast-stoic-api directory and use the following commands:

```bash
cd steadfast-stoic-api
npm install
node server.js
```

The API server will be available at http://localhost:3000.

## steadfast-websocket - Not Implemented yet.

The steadfast-websocket folder contains a Python package for interacting with the API. This service manages WebSocket connections to receive real-time market data and updates.

### Running the Websocket Server

To run the Websocket service, navigate to the steadfast-websocket directory and use the following commands:

```bash
cd steadfast-websocket
pip install -r requirements.txt
python main.py
```

The Websocket server will be available at http://localhost:5000.
