require("dotenv").config(); // This line loads the environment variables from the .env file

const express = require("express");
const cors = require("cors");
const { createProxyMiddleware } = require("http-proxy-middleware");
const axios = require("axios");
const sdk = require("dhanhq"); // Import the DhanHQ SDK
const fs = require("fs");
const csv = require("fast-csv");

const app = express();

app.use(cors()); // Enable CORS for all routes
app.use(express.json()); // To parse JSON bodies

// Initialize the DhanHQ client
const ACCESS_TOKEN = process.env.DHAN_API_TOKEN;
const DHAN_CLIENT_ID = String(process.env.DHAN_CLIENT_ID);

const client = new sdk.DhanHqClient({
  accessToken: ACCESS_TOKEN,
  env: "DEV",
});

// Root route to prevent "Cannot GET /" error
app.get("/", (req, res) => {
  res.send("Welcome to the Proxy Server");
});

// Proxy configuration for Dhan API
app.use(
  "/api",
  createProxyMiddleware({
    target: "https://api.dhan.co",
    changeOrigin: true,
    pathRewrite: {
      "^/api": "",
    },
    onProxyReq: (proxyReq, req, res) => {
      // Log the headers to verify they are set correctly
      console.log("Proxying request to:", proxyReq.path);
      console.log("Request headers:", req.headers);
    },
    onProxyRes: (proxyRes, req, res) => {
      console.log("Received response with status:", proxyRes.statusCode);
    },
    onError: (err, req, res) => {
      console.error("Proxy Error:", err);
      res.status(500).json({ message: "Error in proxying request" });
    },
  })
);


app.get("/symbols", (req, res) => {
  const { exchangeSymbol, masterSymbol } = req.query;
  const callStrikes = [];
  const putStrikes = [];
  const expiryDates = new Set();

  fs.createReadStream("./api-scrip-master.csv")
    .pipe(csv.parse({ headers: true }))
    .on('data', (row) => {
      if (row['SEM_EXM_EXCH_ID'] === exchangeSymbol && row['SEM_TRADING_SYMBOL'].startsWith(masterSymbol + '-')) {
        if (['OPTIDX', 'OP'].includes(row['SEM_EXCH_INSTRUMENT_TYPE'])) {
          const strikeData = {
            tradingSymbol: row['SEM_TRADING_SYMBOL'],
            expiryDate: row['SEM_EXPIRY_DATE'],
            securityId: row['SEM_SMST_SECURITY_ID']
          };
          if (row['SEM_OPTION_TYPE'] === 'CE') {
            callStrikes.push(strikeData);
          } else if (row['SEM_OPTION_TYPE'] === 'PE') {
            putStrikes.push(strikeData);
          }
          expiryDates.add(row['SEM_EXPIRY_DATE']);
        }
      }
    })
    .on('end', () => {
      res.json({
        callStrikes,
        putStrikes,
        expiryDates: Array.from(expiryDates)
      });
    })
    .on('error', (error) => {
      res.status(500).json({ message: "Failed to process CSV file" });
    });
});

app.listen(3000, () => {
  console.log("Proxy server running on http://localhost:3000");
});
