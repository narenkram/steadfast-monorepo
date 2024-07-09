# Project Overview

This repository is a monorepo containing three main projects:

1. [**steadfast-stoic-app**](https://github.com/narenkram/steadfast-stoic-app): The frontend application.
2. [**steadfast-stoic-api**](https://github.com/narenkram/steadfast-stoic-api): The backend API server.
3. [**steadfast-websocket**](https://github.com/narenkram/steadfast-websocket): The WebSocket service.

### Quick Status: (Updated on 09-07-2024)

- Dhan - 🔴 Partial Trading Capabilities [Dropping Support]
- Flattrade - 🟢 Partial Trading Capabilities
- Shoonya (Finvasia) - 🔵 Will be added soon
- Websocket - 🟡 Implementation on progress

### What works? (Updated on 09-07-2024)

👉 All these basic operations now work well for `flattrade`, you can trade [NIFTY, BANKNIFTY, FINIFTY]:

- ✅ kill switch
- ✅ buy/sell
- ✅ cancel orders
- ✅ place limit/market
- ✅ select strikes
- ✅ close all positions
- ✅ 1 click buttons for buy/sell/cancel/close
- ✅ ltp for underlying, selected call/put strikes 
- ✅ automatic atm strike selection 

#### Note:

kill switch works on client side only, you will still be able to trade from your broker terminal.

# App Screenshots

## Manage Brokers

![Preview in Manage Brokers](preview_managebroker_light.png)

## Dark Mode

![Preview in Dark Mode](preview_dark.png)

## Light Mode

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

### Redirect URL for API

- `http://localhost:5173/redirect?`
- Register this redirect URL in your broker's API Key creation process.

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
- Or Press any key to stop the app and api.
