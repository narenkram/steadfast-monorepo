# Project Overview

This repository is a monorepo containing three main projects:

1. [**steadfast-stoic-app**](https://github.com/narenkram/steadfast-stoic-app): The frontend application.
2. [**steadfast-stoic-api**](https://github.com/narenkram/steadfast-stoic-api): The backend API server.
3. [**steadfast-websocket**](https://github.com/narenkram/steadfast-websocket): The WebSocket service.

Legend:
🟢 Available/Implemented
🟡 In Progress
🔵 Planned

### Quick Status (Updated: 14-07-2024)

| Broker             | Trading Capabilities | Realtime Market LTP |
| ------------------ | -------------------- | ------------------- |
| Flattrade          | 🟢 Available         | 🟢 Available        |
| Shoonya (Finvasia) | 🟢 Available         | 🔵 Planned          |
| Dhan               | 🟢 Available         | 🟡 In Progress      |

### What Works? (Updated: 14-07-2024)

| Feature                           | Flattrade | Shoonya (Finvasia) | Dhan |
| --------------------------------- | --------- | ------------------ | ---- |
| **Trading Operations**            |
| Buy/Sell at market price          | 🟢        | 🟢                 | 🟢   |
| Place limit orders                | 🟢        | 🟢                 | 🟢   |
| Cancel orders                     | 🟢        | 🟢                 | 🟢   |
| Close all positions               | 🟢        | 🟢                 | 🟢   |
| One-click trading buttons         | 🟢        | 🟢                 | 🟢   |
| **Order Management**              |
| Kill switch (client-side)         | 🟢        | 🟢                 | 🟢   |
| Select strikes                    | 🟢        | 🟢                 | 🟢   |
| Automatic ATM strike selection    | 🟢        | 🟢                 | 🟢   |
| **Real-Time Market Data**         |
| LTP for underlying                | 🟢        | 🔵                 | 🔵   |
| LTP for selected call/put strikes | 🟢        | 🔵                 | 🔵   |

#### Note:

- kill switch works on client side only, you will still be able to trade from your broker terminal.
- All these symbols can be traded: NIFTY, BANKNIFTY, FINIFTY, MIDCPNIFTY NIFTYNXT50, SENSEX, BANKEX and SENSEX50.

# App Screenshots

## Manage Brokers

![Preview in Manage Brokers](preview_managebroker_light.png)

## Dark Mode

![Preview in Dark Mode](preview_dark.png)

## Add Broker

![Preview in Add Broker](preview_addbroker_light.png)

## Light Mode

![Preview in Light Mode](preview_light.png)

# Join Our Telegram Channel

Stay updated by joining our [Telegram Channel](https://t.me/steadfaststoic).


## Steps to run the app

### `Step 0`: Prerequisites

1. Ensure [Git](https://git-scm.com/download/win) is installed and accessible from the command line.

```
git --version
```

2. Ensure [Node.js and npm](https://nodejs.org/en/download/prebuilt-installer) are installed and accessible from the command line.

```
node -v && npm -v
```

3. Ensure [Python](https://www.python.org/downloads/) is installed and accessible from the command line.

```
python -v
```

### `Step 1`: Clone the Steadfast Stoic Monorepo

1. Download & Install [GitHub Desktop](https://desktop.github.com/)
2. On top right of this repo click "Code" > "Open with GitHub Desktop"
3. Choose a local path and click "Clone"
4. Open the monorepo folder in file explorer.

### `Step 2`: Install

Double-click the `install-all.bat` file or run it from the command prompt.

#### What it does:

1. Clones the steadfast-stoic-app repository
2. Installs app dependencies
3. Clones the steadfast-stoic-api repository
4. Installs API dependencies
5. Clones the steadfast-websocket repository
6. Installs WebSocket dependencies

### `Step 3`: Start

Double-click the `start-all.bat` file or run it from the command prompt.

#### What it does:

1. Starts the steadfast-stoic-app at `localhost: 5173`
2. Starts the steadfast-stoic-api server at `localhost: 3000`
3. Starts the steadfast-websocket server at `localhost: 8765`

### `Step 4`: Stop

- To `Stop` simply close the opened command prompt windows.
- Or Press any key to stop the app, api and websocket.
