<template>
  <section class="row py-5">
    <div class="row">
      <div class="col-6">
        <h3>Steps to generate API Key 🔑 and API Secret key</h3>

        <div class="card w-100 h-75 bg-light">
          <div class="card-body">
            <p class="card-text">YouTube Video</p>
          </div>
        </div>
      </div>

      <div class="col-6">
        <h3>Add broker API Details 🔐</h3>
        <p>Please watch the YouTube video on how to obtain the following details.</p>
        <!-- Select Broker -->
        <form @submit.prevent="addBroker">
          <label for="SelectBroker" class="mt-3 form-label mb-0"><b>Select Broker</b></label>
          <select class="form-select" aria-label="Select Broker">
            <option value="Dhan" selected>Dhan</option>
            <option value="Flattrade">Flattrade</option>
            <option value="Shoonya">Shoonya</option>
          </select>

          <!-- Link to Open Selected Broker's API Dashboard -->
          <div class="text-center w-100">
            <a class="nav-link my-3" href="" target="_blank">Click here to access your selectedBroker API Dashboard</a>
          </div>

          <!-- API Key -->
          <label for="APIKey" class="form-label mb-0  mt-3"><b>API Key</b></label>
          <input type="text" class="form-control" id="APIKey" required>

          <!-- API Secret Key -->
          <label for="APISecretKey" class="form-label mb-0  mt-3"><b>API Secret Key</b></label>
          <input type="text" class="form-control" id="APISecretKey" required>

          <!-- Name Tag -->
          <label for="NameTag" class="form-label mb-0 mt-3"><b>Name Tag</b></label>
          <input type="text" class="form-control" id="NameTag" required>

          <!-- Redirect URL -->
          <label for="RedirectURL" class="form-label mb-0 mt-3"><b>Redirect URL</b></label>
          <input type="text" class="form-control" id="RedirectURL" disabled
            value="https://localhost:5173/broker/login/{{ selectedBroker }}" required>

          <!-- Add Broker -->
          <div class="d-flex justify-content-between mt-5">
            <button class="btn btn-primary w-100">Add Broker</button>
            <RouterLink to="/manage-brokers" class=" ms-2 w-100">
              <button class="btn btn-secondary w-100">Cancel</button>
            </RouterLink>
          </div>
        </form>
      </div>
    </div>


  </section>
</template>

<script>
import axios from 'axios';

export default {
  methods: {
    async addBroker() {
      const brokerDetails = {
        brokerName: this.selectedBroker,
        apiKey: this.apiKey,
        apiSecret: this.apiSecret,
        nameTag: this.nameTag,
      };
      try {
        await axios.post('http://localhost:3000/addBroker', brokerDetails);
        this.$router.push('/manage-brokers');
      } catch (error) {
        console.error('Failed to add broker:', error);
      }
    },
  },
};
</script>