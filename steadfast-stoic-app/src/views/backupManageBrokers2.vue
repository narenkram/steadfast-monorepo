<template>
  <section class="row py-5">
    <div class="col-6 text-start">
      <RouterLink to="/add-broker">
        <button class="btn btn-primary">Add New Broker</button>
      </RouterLink>
      <button class="ms-3 btn btn-outline-secondary">Refresh Broker List</button>
    </div>
    <div class="col-6 text-end">
      <RouterLink to="/">
        <button class="btn btn-primary">
          Open 1 Click Trade View
        </button>
      </RouterLink>
    </div>
  </section>

  <section class="row">
    <div class="col-12">
      <table class="table">
        <thead>
          <tr>
            <th scope="col">Broker</th>
            <th scope="col">Broker Client ID</th>
            <th scope="col">App ID</th>
            <th scope="col">App Secret Key</th>
            <th scope="col">Status</th>
            <th scope="col">Last Token Generated At</th>
            <th scope="col">Generate Token</th>
            <th scope="col">Action</th>
            <th scope="col">Added At</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="broker in brokers" :key="broker.id">
            <td>{{ broker.brokerName }}</td>
            <td>
              <span class="badge bg-primary">{{ maskBrokerClientId(broker.brokerClientId) }}</span>
            </td>
            <td>{{ broker.appId }}</td>
            <td>{{ maskApiSecret(broker.apiSecret) }}</td>
            <td><span class="badge text-bg-success">{{ broker.status }}</span></td>
            <td>{{ broker.lastTokenGeneratedAt }}</td>
            <td><a class="link" @click="generateToken(broker)">Generate Token</a></td>
            <td>
              <a class="mx-1"><span class="SelectBroker">▶️</span></a>
              <a class="mx-1"><span class="PauseBroker">⏸️</span></a>
              <a class="mx-1"><span class="DeleteBroker">❌</span></a>
            </td>
            <td>{{ broker.addedAt }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>

  <div v-if="request_code">
    <h1>Request Code: {{ request_code }}</h1>
    <h1>Client: {{ client }}</h1>
    <h1>Token: {{ token }}</h1>
  </div>
</template>

<script>
import axios from 'axios';
import crypto from 'crypto-js'; // Ensure you have crypto-js installed
import qs from 'qs'; // Ensure you have qs installed

export default {
  data() {
    return {
      brokers: [],
      request_code: '', // Initialize request_code in the component's data
      client: null,
      token: '', // Initialize token in the component's data
    };
  },
  async mounted() {
    try {
      const response = await axios.get('http://localhost:3000/brokers');
      this.brokers = response.data;
    } catch (error) {
      console.error('Failed to fetch brokers:', error);
    }
  },
  methods: {
    maskApiSecret(apiSecret) {
      if (!apiSecret || apiSecret.length < 10) return '******';
      const start = apiSecret.slice(0, 3);
      const end = apiSecret.slice(-3);
      return `${start}******${end}`;
    },
    maskBrokerClientId(brokerClientId) {
      if (!brokerClientId) return 'N/A';
      const length = brokerClientId.length;
      if (length <= 2) return brokerClientId;
      const maskLength = Math.max(1, Math.floor(length / 2));
      const startUnmaskedLength = Math.ceil((length - maskLength) / 2);
      const endUnmaskedLength = length - startUnmaskedLength - maskLength;
      const firstPart = brokerClientId.slice(0, startUnmaskedLength);
      const lastPart = brokerClientId.slice(-endUnmaskedLength);
      const middleMask = '*'.repeat(maskLength);
      return `${firstPart}${middleMask}${lastPart}`;
    },
    async generateToken(broker) {
      if (broker.brokerName !== 'Flattrade') return;

      const apiKey = broker.apiKey; // Ensure this is available in your broker object
      const apiSecret = broker.apiSecret; // Ensure this is available in your broker object
      const authUrl = `https://auth.flattrade.in/?app_key=${apiKey}`;

      // Open the authorization URL in a new tab
      const authWindow = window.open(authUrl, '_blank');

      // Listen for messages from the new tab
      const messageListener = async (event) => {
        console.log('Received message:', event);
        console.log('Event data:', event.data);
        if (event.origin !== 'http://localhost:5173') return; // Ensure the message is from the expected origin

        try {
          if (typeof event.data === 'string') {
            const url = new URL(event.data);
            const requestCode = url.searchParams.get('request_code'); // Extract the request_code from the URL
            this.request_code = requestCode;
            this.client = url.searchParams.get('client'); // Extract the client from the URL
            console.log('Extracted request code:', this.request_code);
            console.log('Extracted client:', this.client);
            if (!this.request_code) return;

            // Generate the SHA-256 hash
            const concatenatedValue = `${apiKey}${this.request_code}${apiSecret}`;
            const hashedSecret = crypto.SHA256(concatenatedValue).toString();
            console.log('Generated hashed secret:', hashedSecret);

            // Send the POST request to get the token
            try {
              const response = await axios.post('https://authapi.flattrade.in/trade/apitoken', qs.stringify({
                api_key: apiKey,
                request_code: requestCode,
                api_secret: hashedSecret,
              }), {
                headers: {
                  'Content-Type': 'application/x-www-form-urlencoded'
                }
              });
              console.log('Token:', response.data.token);
              this.token = response.data.token; // Store the token in the component's data
            } catch (error) {
              console.error('Failed to generate token:', error);
            }
          } else {
            console.error('Invalid event data:', event.data);
          }
        } catch (error) {
          console.error('Failed to construct URL:', error);
        }

        // Close the auth window and remove the event listener
        authWindow.close();
        window.removeEventListener('message', messageListener);
      };

      window.addEventListener('message', messageListener);
    },
  },
};
</script>