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

#### 1. Install nodejs from https://nodejs.org/en/download/prebuilt-installer (One time step)

#### 2. After installation, verify installation using command (One time step)

```bash
node -v && npm -v
```

#### 3. Install the App and node modules using below command (One time step)

```bash
git clone https://github.com/narenkram/steadfast-stoic-app
```

```bash
cd steadfast-stoic-app
```

```bash
npm install
```

#### 4. Install the API server and node modules using below command (One time step)

```bash
git clone https://github.com/narenkram/steadfast-stoic-api
```

```bash
cd steadfast-stoic-api
```

```bash
npm install
```

#### 5. Navigate back to root folder and run the app using below command

```bash
cd ..
```

```bash
.\start-all.bat
```

# Quick Start for Everyday use

Just double click on **start-all.bat** file and it will start both frontend and backend services.

or use cmd and run the following command
For Windows:

```bash
.\start-all.bat
```

## To Keep the app updated

just double click on **update-all.bat** file and it will update both frontend and backend services.

or use cmd and run the following command
For Windows:

```bash
.\update-all.bat
```
