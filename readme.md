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
- ✅ place limit/market
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

### `Step 3`: Start

Double-click the `start-all.bat` file or run it from the command prompt.

#### What it does:

1. Starts the steadfast-stoic-app at `localhost: 5173`
2. Starts the steadfast-stoic-api server at `localhost: 3000`

### `Step 4`: Update

- `Optional` if you are running for the first time, immedieatly after installation.
- Double-click the `update-all.bat` file or run it from the command prompt.
- This script updates both the app and API repositories to their latest versions. `Run it daily for app updates before Step 3`.
- If you update when the app and api is running, you will have to `Stop` and `Start` again to see the updates.
- To `Stop` simply close the opened command prompt windows.
