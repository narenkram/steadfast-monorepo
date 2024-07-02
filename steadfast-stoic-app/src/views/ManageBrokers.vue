<script setup>
import { ref, onMounted, watch } from 'vue';
import axios from 'axios';

const FLATTRADE_API_KEY = ref('');
const FLATTRADE_API_SECRET = ref('');
const FLATTRADE_CLIENT_ID = ref('');
const FLATTRADE_API_TOKEN = ref(localStorage.getItem('FLATTRADE_API_TOKEN') || ''); // Initialize from localStorage
const DHAN_API_TOKEN = ref('');
const DHAN_CLIENT_ID = ref('');

const reqCode = ref('');
const token = ref('');
const errorMessage = ref('');
const statusMessage = ref('');
const userTriggeredTokenGeneration = ref(false); // Flag to track user-triggered token generation

const brokers = ref([]);
const fetchBrokers = async () => {
  try {
    const response = await axios.get('http://localhost:3000/brokers');
    brokers.value = response.data;
    await fetchFlattradeCredentials(); // Fetch Flattrade credentials
    await fetchDhanCredentials(); // Fetch Dhan credentials
  } catch (error) {
    console.error('Failed to fetch brokers:', error);
  }
};

const fetchFlattradeCredentials = async () => {
  try {
    const response = await axios.get('http://localhost:3000/api/flattrade-credentials');
    FLATTRADE_API_KEY.value = response.data.apiKey;
    FLATTRADE_API_SECRET.value = response.data.apiSecret;
    FLATTRADE_CLIENT_ID.value = response.data.clientId;

    // Store the API key and secret in localStorage
    localStorage.setItem('FLATTRADE_API_KEY', FLATTRADE_API_KEY.value);
    localStorage.setItem('FLATTRADE_API_SECRET', FLATTRADE_API_SECRET.value);
    localStorage.setItem('FLATTRADE_CLIENT_ID', FLATTRADE_CLIENT_ID.value);

    return {
      apiKey: FLATTRADE_API_KEY.value,
      apiSecret: FLATTRADE_API_SECRET.value,
      clientId: FLATTRADE_CLIENT_ID.value
    };
  } catch (error) {
    console.error('Failed to fetch Flattrade credentials:', error);
    return null;
  }
};

const fetchDhanCredentials = async () => {
  try {
    const response = await axios.get('http://localhost:3000/api/dhan-credentials');
    DHAN_API_TOKEN.value = response.data.apiToken;
    DHAN_CLIENT_ID.value = response.data.clientId;

    // Store the API key and secret in localStorage
    localStorage.setItem('DHAN_API_TOKEN', DHAN_API_TOKEN.value);
    localStorage.setItem('DHAN_CLIENT_ID', DHAN_CLIENT_ID.value);

    return {
      apiToken: DHAN_API_TOKEN.value,
      clientId: DHAN_CLIENT_ID.value
    };
  } catch (error) {
    console.error('Failed to fetch Dhan credentials:', error);
    return null;
  }
};

onMounted(() => {
  fetchBrokers();

  const storedCode = localStorage.getItem('reqCode');
  if (storedCode) {
    reqCode.value = storedCode;
  }
  statusMessage.value = localStorage.getItem('statusMessage') || '';

  // Add event listener for postMessage
  window.addEventListener('message', (event) => {
    if (event.data.type === 'reqCode' && event.data.code) {
      reqCode.value = event.data.code;
      localStorage.setItem('reqCode', event.data.code); // Update local storage with new reqCode
    }
  });
});

watch(reqCode, (newCode) => {
  if (newCode && userTriggeredTokenGeneration.value) {
    statusMessage.value = `Received reqCode: ${newCode}`;
    generateToken();
  }
});

// Watch for changes in FLATTRADE_API_TOKEN and update localStorage
watch(FLATTRADE_API_TOKEN, (newToken) => {
  if (newToken) {
    localStorage.setItem('FLATTRADE_API_TOKEN', newToken);
  } else {
    localStorage.removeItem('FLATTRADE_API_TOKEN');
  }
});

const openFlattradeAuthUrl = () => {
  localStorage.setItem('statusMessage', 'Waiting for broker auth to complete...');
  const storedFlattradeApiKey = localStorage.getItem('FLATTRADE_API_KEY');

  if (!storedFlattradeApiKey) {
    errorMessage.value = 'API key is missing';
    clearErrorMessage();
    return;
  }

  const authUrl = `https://auth.flattrade.in/?app_key=${storedFlattradeApiKey}`;
  window.open(authUrl, '_blank');
};

const clearErrorMessage = () => {
  setTimeout(() => {
    errorMessage.value = '';
  }, 5000); // Clear error message after 5 seconds
};

const generateToken = async (broker) => {
  userTriggeredTokenGeneration.value = true; // Set the flag when user triggers token generation

  if (!broker) {
    errorMessage.value = 'Broker information is missing';
    clearErrorMessage();
    return;
  }

  if (broker.brokerName === 'Flattrade') {
    openFlattradeAuthUrl();
    statusMessage.value = 'Waiting for reqCode...';
    return;
  }

  if (!reqCode.value) {
    errorMessage.value = 'Request code is missing';
    clearErrorMessage();
    return;
  }
};

watch(reqCode, async (newCode) => {
  if (newCode && userTriggeredTokenGeneration.value) {
    const storedApiKey = localStorage.getItem('FLATTRADE_API_KEY');
    const storedApiSecret = localStorage.getItem('FLATTRADE_API_SECRET');

    if (!storedApiKey || !storedApiSecret) {
      errorMessage.value = 'API key or secret is missing';
      clearErrorMessage();
      return;
    }

    const api_secret = storedApiKey + newCode + storedApiSecret;
    const hashedSecret = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(api_secret));
    const apiSecretHex = Array.from(new Uint8Array(hashedSecret)).map(b => b.toString(16).padStart(2, '0')).join('');

    const payload = {
      api_key: storedApiKey,
      request_code: newCode,
      api_secret: apiSecretHex,
    };

    try {
      const res = await axios.post('/flattradeApi/trade/apitoken', payload);
      const token = res.data.token;
      if (!token) {
        errorMessage.value = "Token generation failed";
        clearErrorMessage();
      } else {
        FLATTRADE_API_TOKEN.value = token; // Store the token in the reactive reference
        errorMessage.value = '';
        statusMessage.value = `Token generated successfully: ${token}`;
        console.log('Token generated successfully:', token);
      }
    } catch (error) {
      errorMessage.value = 'Error generating token: ' + error.message;
      clearErrorMessage();
      console.error('Error generating token:', error);
    }
  }
});

function maskBrokerClientId(brokerClientId) {
  const placeholders = [
    "Your_Dhan_Client_ID",
    "Your_Dhan_API_Token",
    "Your_Flattrade_Client_ID",
    "Your_Flattrade_API_Key",
    "Your_Flattrade_API_Secret"
  ];

  if (!brokerClientId || placeholders.includes(brokerClientId)) return brokerClientId; // Ensure brokerClientId is defined and not a placeholder

  const length = brokerClientId.length;
  if (length <= 2) return brokerClientId; // If the length is 2 or less, return as is

  const maskLength = Math.max(1, Math.floor(length / 2)); // Mask at least 1 character, up to half the length
  const startUnmaskedLength = Math.ceil((length - maskLength) / 2);
  const endUnmaskedLength = length - startUnmaskedLength - maskLength;

  const firstPart = brokerClientId.slice(0, startUnmaskedLength);
  const lastPart = brokerClientId.slice(-endUnmaskedLength);
  const middleMask = '*'.repeat(maskLength); // Mask middle portion dynamically

  return `${firstPart}${middleMask}${lastPart}`;
}
const placeholders = [
  "Your_Dhan_Client_ID",
  "Your_Dhan_API_Token",
  "Your_Flattrade_Client_ID",
  "Your_Flattrade_API_Key",
  "Your_Flattrade_API_Secret"
];
const getStatus = (broker) => {
  let status = 'Active';
  let statusClass = 'bg-success';

  if (placeholders.includes(broker.brokerClientId) || placeholders.includes(broker.apiToken)) {
    status = 'API details & Token missing';
    statusClass = 'bg-danger';
  }

  if (broker.brokerName === 'Flattrade' && !FLATTRADE_API_TOKEN.value) {
    status = status === 'API details & Token missing' ? 'API details & Token missing' : 'Token missing, Click generate';
    statusClass = status === 'API details & Token missing' ? 'bg-danger' : 'bg-warning text-dark';
  }

  return { status, statusClass };
};

function maskTokenSecret(apiSecret) {

  if (!apiSecret || apiSecret.length < 10 || placeholders.includes(apiSecret)) return apiSecret; // Ensure there are enough characters to mask and not a placeholder

  const start = apiSecret.slice(0, 3);
  const end = apiSecret.slice(-3);
  return `${start}******${end}`;
}


const fundLimits = ref('');
const flattradeFundLimits = async () => {
  let jKey = localStorage.getItem('FLATTRADE_API_TOKEN') || token.value;

  if (!jKey) {
    errorMessage.value = 'Token is missing. Please generate a token first.';
    clearErrorMessage();
    return;
  }

  const jData = JSON.stringify({ uid: FLATTRADE_CLIENT_ID.value, actid: FLATTRADE_CLIENT_ID.value });
  const payload = `jKey=${jKey}&jData=${jData}`;

  try {
    const res = await axios.post('https://piconnect.flattrade.in/PiConnectTP/Limits', payload, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    });
    fundLimits.value = res.data;
    console.log(res.data);
  } catch (error) {
    errorMessage.value = 'Error fetching fund limits: ' + error.message;
    clearErrorMessage();
    console.error('Error fetching fund limits:', error);
  }
};
</script>

<template>
  <section class="row py-5">
    <div class="col-6 text-start">
      <!-- <RouterLink to="/add-broker">
        <button class="btn btn-primary">Add New Broker</button>
      </RouterLink> -->
      <blockquote class="blockquote">Add your API Key details in <code class="bg-light"><b>.env</b></code> file <br />
        and Restart API Server
      </blockquote>
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
            <th scope="col">API Token</th>
            <th scope="col">Validity</th>
            <th scope="col">Generate Token</th>
            <th scope="col">Status</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="broker in brokers" :key="broker.id">
            <td>{{ broker.brokerName }}</td>
            <td>
              <span class="badge bg-primary">{{ maskBrokerClientId(broker.brokerClientId) }}</span>
            </td>
            <td>
              <span v-if="broker.brokerName === 'Flattrade' && FLATTRADE_API_TOKEN">{{
                maskTokenSecret(FLATTRADE_API_TOKEN) }}</span>
              <span v-else>{{ maskTokenSecret(broker.apiToken) }}</span>
            </td>
            <td>
              24 Hours
            </td>
            <td v-if="broker.brokerName !== 'Dhan'">
              <a class="link" @click.prevent="generateToken(broker)">Generate Token</a>
            </td>
            <td v-else>
              -
            </td>
            <td>
              <span :class="`badge ${getStatus(broker).statusClass}`">{{ getStatus(broker).status }}</span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>

  <section class="row">
    <div class="col-12">
      <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>
      <div v-if="statusMessage" class="alert alert-info">{{ statusMessage }}</div>
    </div>
  </section>

</template>