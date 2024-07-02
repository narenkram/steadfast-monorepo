<template>
  <!-- Brokers, Broker Status, Total Funds, Utilized Margin & Today's Date -->
  <section class="row py-3">
    <div class="col-12">

      <div class="row">
        <!-- Brokers Page -->
        <div class="col-1">
          <div class="d-flex align-items-center justify-content-start h-100">
            <RouterLink class="fs-2 text-decoration-none" to="/manage-brokers">
              <span>⚙️</span>
            </RouterLink>
          </div>
        </div>


        <!-- Change Broker -->
        <div class="col-2">
          <label for="ChangeBroker" class="form-label mb-0"><b>Change Broker</b></label>
          <div class="d-flex align-items-center">
            <select class="form-select" aria-label="Change Broker" v-model="selectedBroker">
              <option v-for="broker in brokers" :key="broker.brokerClientId" :value="broker">
                {{ broker.brokerName }}
              </option>
            </select>
          </div>
        </div>

        <!-- Broker Name and Status with Broker ID -->
        <div class="col-2">
          <p class="mb-1"><b>Broker</b> <span
              :class="{ 'badge bg-success': brokerStatus === 'Connected', 'badge bg-danger': brokerStatus === 'Not Connected' }">{{
                brokerStatus }}</span></p>
          <p class="mb-0">
            <span v-if="showBrokerClientId" @click="toggleBrokerClientIdVisibility">
              {{ selectedBroker?.brokerClientId || 'N/A' }}
              <span>👀</span>
            </span>
            <span v-else @click="toggleBrokerClientIdVisibility">
              {{ maskBrokerClientId(selectedBroker?.brokerClientId) }}
              <span>👁️</span>
            </span>
          </p>
        </div>

        <!-- Total Funds -->
        <div class="col-3 text-center">
          <p class="mb-1"><b>Total Funds</b></p>
          <p class="mb-0">₹ {{ availableBalance || null }}</p>
        </div>

        <!-- Utilized Margin -->
        <div class="col-2 text-center">
          <p class="mb-1"><b>Utilized Margin</b></p>
          <p>₹ {{ usedAmount || null }}</p>
        </div>

        <!-- Today's date -->
        <div class="col-2 text-end">
          <p class="mb-1"><b>Today's date</b></p>
          <p>{{ formattedDate }}</p>
        </div>

      </div>

    </div>
  </section>

  <!-- <section class="row py-3">
    <div class="col-12">
      <div class="form-check">
        <input class="form-check-input" type="checkbox" id="toggleLineChart" v-model="showLineChart">
        <label class="form-check-label" for="toggleLineChart">
          Show MTM Chart
        </label>
      </div>
      <LineChart v-if="showLineChart" :profitData="profitData" />
    </div>
  </section> -->

  <!-- Total Profit & Net PNL -->
  <section class="row py-3">
    <div class="col-5">
      <div class="Card">
        <blockquote class="fs-3">₹ {{ totalProfit.toFixed(2) }}</blockquote>
        <small>
          ₹ {{ netPnl.toFixed(2) }} Estimated Net PNL (after brokerage)
        </small>
      </div>
    </div>
    <div class="col-5">
      <div class="Card">
        <blockquote class="fs-3">{{ totalCapitalPercentage.toFixed(2) }}% <small> on Total Capital</small></blockquote>
        <small>{{ deployedCapitalPercentage.toFixed(2) }}% on Deployed Capital</small>
      </div>
    </div>
    <div class="col-2 d-flex justify-content-center align-items-center">
      <div class="Card">
        <div class="card-title">
          <h5>Kill Switch</h5>
        </div>
        <button :class="killSwitchButtonClass" @click="toggleKillSwitch">
          {{ killSwitchButtonText }}
        </button>
      </div>
    </div>
  </section>

  <hr />

  <!-- Place Order Form -->
  <section class="row py-2">
    <form @submit.prevent>
      <fieldset :disabled="isFormDisabled">
        <div class="row">
          <!-- Exchange Selection -->
          <div class="col-2">
            <label for="Exchange" class="form-label mb-0">Exchange</label>
            <select id="Exchange" class="form-select" aria-label="Exchange" v-model="selectedExchange"
              @change="fetchTradingData">
              <option v-for="(symbols, exchange) in exchangeSymbols" :key="exchange" :value="exchange">{{
                exchange }}
              </option>
            </select>
          </div>

          <!-- Segment Selection -->
          <div class="col-2">
            <label for="Segment" class="form-label mb-0">Segment</label>
            <select id="Segment" class="form-select" aria-label="Segment">
              <option value="Options" selected>Options</option>
              <option value="Futures">Futures</option>
            </select>
          </div>

          <!-- Master Symbol Selection -->
          <div class="col-2">
            <label for="MasterSymbol" class="form-label mb-0">Master Symbol</label>
            <select id="MasterSymbol" class="form-select" aria-label="Master Symbol" v-model="selectedMasterSymbol"
              @change="fetchTradingData">
              <option v-for="symbol in exchangeSymbols[selectedExchange]" :key="symbol" :value="symbol">{{
                symbol }}
              </option>
            </select>
          </div>

          <!-- Expiry Date Selection -->
          <div class="col-2">
            <label for="Expiry" class="form-label mb-0">Expiry Date</label>
            <select id="Expiry" class="form-select" aria-label="Expiry" v-model="selectedExpiry">
              <option v-for="date in expiryDates" :key="date" :value="date">
                {{ formatDate(date) }}
              </option>
            </select>
          </div>

          <!-- Product Type Selection -->
          <div class="col-2">
            <label for="ProductType" class="form-label mb-0">Product Type</label>
            <select id="ProductType" class="form-select" v-model="selectedProductType" aria-label="ProductType">
              <option v-for="productType in productTypes" :key="productType" :value="getProductTypeValue(productType)">
                {{
                  productType }}
              </option>
            </select>
          </div>

          <!-- Quantity Selection -->
          <div class="col-2">
            <label for="Quantity" class="form-label mb-0">Quantity</label>
            <select id="Quantity" class="form-select" v-model="selectedQuantity" aria-label="Quantity">
              <option v-for="quantity in availableQuantities" :key="quantity" :value="quantity">{{ quantity }}
              </option>
            </select>
          </div>

        </div>

        <div class="row mt-3">
          <!-- Order Type -->
          <div class="col-2">
            <label for="OrderType" class="form-label mb-0">Order Type</label>
            <select id="OrderType" class="form-select" aria-label="OrderType" v-model="selectedOrderType">
              <option v-for="orderType in orderTypes" :key="orderType" :value="orderType">{{ orderType }}
              </option>
            </select>
          </div>
          <!-- Market Protection Order %-->
          <div class="col-3">
            <label for="MarketProtection" class="form-label mb-0">Market Protection Order %</label>
            <select id="MarketProtection" class="form-select" aria-label="Market Protection Order %">
              <option value="1">1%</option>
              <option value="2">2%</option>
              <option value="3">3%</option>
              <option value="4">4%</option>
              <option value="5">5%</option>
            </select>
          </div>
          <!-- Stoploss -->
          <div class="col-2">
            <label for="Stoploss" class="form-label mb-0">Stoploss</label>
            <div class="input-group mb-3">
              <div class="input-group-text">
                <input class="form-check-input mt-0" type="checkbox" value="" aria-label="Enable Stoploss">
              </div>
              <input type="number" class="form-control" aria-label="Stoploss" value="75">
            </div>
          </div>
          <!-- Target -->
          <div class="col-2">
            <label for="Target" class="form-label mb-0">Target</label>
            <div class="input-group mb-3">
              <div class="input-group-text">
                <input class="form-check-input mt-0" type="checkbox" value="" aria-label="Enable Target">
              </div>
              <input type="number" class="form-control" aria-label="Target" value="75">
            </div>
          </div>
          <!-- 1 Click Arrow Keys -->
          <div class="col-3">
            <div class="d-flex align-items-center float-end h-100">
              <label class="ToggleSwitch">
                <input class="ToggleInput" type="checkbox" id="enableHotKeys" v-model="enableHotKeys">
                <span class="ToggleSlider SliderRound"></span>
              </label>
              <label class="ToggleLabel" for="enableHotKeys"><b> 1 Click <br /> Arrow Keys</b></label>
            </div>
          </div>
        </div>

        <!-- Trading Symbols & Buy/Sell Buttons -->
        <div class="row mt-2 align-items-center justify-content-between">
          <!-- Call Strike Selection -->
          <div class="col-3">
            <label for="CallStrike" class="form-label mb-0">Call Strike</label>
            <select id="CallStrike" class="form-select" aria-label="Call Strike" v-model="selectedCallStrike">
              <option v-for="strike in callStrikes" :key="strike.securityId" :value="strike">
                {{ strike.strikePrice }}
              </option>
            </select>
            <div>
              Security ID: {{ defaultCallSecurityId }}
            </div>
            <div>
              {{ selectedCallStrike.tradingSymbol }}
            </div>
            <div class="btn-group w-100">
              <button type="button" class="btn btn-lg btn-success fs-5 my-2 w-75"
                @click="selectedOrderType !== (orderTypes.value && orderTypes.value[1]) && placeOrder(getTransactionType('BUY'), 'CALL')"
                v-bind="selectedOrderType === (orderTypes.value && orderTypes.value[1]) ? { 'data-bs-toggle': 'modal', 'data-bs-target': '#PlaceLimitOrderWindow' } : {}">
                <span v-if="enableHotKeys">⬆️</span>
                Buy CE
              </button>
              <button type="button" class="btn btn-outline-success fs-5 my-2 dropdown-toggle dropdown-toggle-split w-25"
                data-bs-toggle="dropdown" aria-expanded="false" data-bs-reference="parent" data-bs-offset="0,-7">
                <span class="visually-hidden">Toggle Dropdown</span>
              </button>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" @click="setOrderDetails('BUY', 'CALL')" data-bs-toggle="modal"
                    data-bs-target="#PlaceLimitOrderWindow">Place Limit Order</a></li>
              </ul>
            </div>
            <div class="btn-group w-100">
              <button type="button" class="btn btn-lg btn-danger fs-5 w-75"
                @click="selectedOrderType !== (orderTypes.value && orderTypes.value[1]) && placeOrder(getTransactionType('SELL'), 'CALL')"
                v-bind="selectedOrderType === (orderTypes.value && orderTypes.value[1]) ? { 'data-bs-toggle': 'modal', 'data-bs-target': '#PlaceLimitOrderWindow' } : {}">
                <span v-if="enableHotKeys">⬅️</span>
                Sell CE
              </button>
              <button type="button" class="btn btn-outline-danger fs-5 dropdown-toggle dropdown-toggle-split w-25"
                data-bs-toggle="dropdown" aria-expanded="false" data-bs-reference="parent">
                <span class="visually-hidden">Toggle Dropdown</span>
              </button>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" @click="setOrderDetails('SELL', 'CALL')" data-bs-toggle="modal"
                    data-bs-target="#PlaceLimitOrderWindow">Place Limit Order</a></li>
              </ul>
            </div>
          </div>

          <!-- Close All Positions & Cancel Pending Orders -->
          <div class="col-3 text-center">
            <br />
            <br />
            <p class="mb-0">Nifty Bank</p>
            <p class="mb-0"><b>51700 <span class="text-success">(152/0.8%)</span></b></p>
            <button class="btn btn-lg btn-outline-secondary fs-5 w-100 my-2" @click="closeAllPositions">
              <span v-if="enableHotKeys">F6 / </span>
              Close all Positions
            </button>
            <button class="btn btn-lg btn-outline-secondary fs-5 w-100" @click="cancelPendingOrders">
              <span v-if="enableHotKeys">F7 / </span>
              Cancel Order
            </button>
          </div>

          <!-- Put Strike Selection -->
          <div class="col-3">
            <label for="PutStrike" class="form-label mb-0">Put Strike</label>
            <select id="PutStrike" class="form-select" aria-label="Put Strike" v-model="selectedPutStrike">
              <option v-for="strike in putStrikes" :key="strike.securityId" :value="strike">
                {{ strike.strikePrice }}
              </option>
            </select>
            <div>
              Security ID: {{ defaultPutSecurityId }}
            </div>
            <div>
              {{ selectedPutStrike.tradingSymbol }}
            </div>
            <div class="btn-group w-100">
              <button type="button" class="btn btn-lg btn-success fs-5 my-2 w-75"
                @click="selectedOrderType !== (orderTypes.value && orderTypes.value[1]) && placeOrder(getTransactionType('BUY'), 'PUT')"
                v-bind="selectedOrderType === (orderTypes.value && orderTypes.value[1]) ? { 'data-bs-toggle': 'modal', 'data-bs-target': '#PlaceLimitOrderWindow' } : {}">
                <span v-if="enableHotKeys">⬇️</span>
                Buy PE
              </button>
              <button type="button" class="btn btn-outline-success fs-5 my-2 dropdown-toggle dropdown-toggle-split w-25"
                data-bs-toggle="dropdown" aria-expanded="false" data-bs-reference="parent" data-bs-offset="0,-7">
                <span class="visually-hidden">Toggle Dropdown</span>
              </button>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" @click="setOrderDetails('BUY', 'PUT')" data-bs-toggle="modal"
                    data-bs-target="#PlaceLimitOrderWindow">Place Limit Order</a></li>
              </ul>
            </div>
            <div class="btn-group w-100">
              <button type="button" class="btn btn-lg btn-danger fs-5 w-75"
                @click="selectedOrderType !== (orderTypes.value && orderTypes.value[1]) && placeOrder(getTransactionType('SELL'), 'PUT')"
                v-bind="selectedOrderType === (orderTypes.value && orderTypes.value[1]) ? { 'data-bs-toggle': 'modal', 'data-bs-target': '#PlaceLimitOrderWindow' } : {}">
                <span v-if="enableHotKeys">➡️</span>
                Sell PE
              </button>
              <button type="button" class="btn btn-outline-danger fs-5 dropdown-toggle dropdown-toggle-split w-25"
                data-bs-toggle="dropdown" aria-expanded="false" data-bs-reference="parent">
                <span class="visually-hidden">Toggle Dropdown</span>
              </button>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" @click="setOrderDetails('SELL', 'PUT')" data-bs-toggle="modal"
                    data-bs-target="#PlaceLimitOrderWindow">Place Limit Order</a></li>
              </ul>
            </div>
          </div>
        </div>
      </fieldset>
    </form>
  </section>

  <!-- Positions & Trades -->
  <section class="row py-3">
    <div class="col-12">
      <ul class="nav nav-tabs" id="myTab" role="tablist">
        <li class="nav-item" role="presentation">
          <button class="nav-link active" id="positions-tab" data-bs-toggle="tab" data-bs-target="#positions-tab-pane"
            type="button" role="tab" aria-controls="positions-tab-pane" aria-selected="true"
            @click="setActiveTab('positions')">💸
            Positions</button>
        </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link" id="trades-tab" data-bs-toggle="tab" data-bs-target="#trades-tab-pane" type="button"
            role="tab" aria-controls="trades-tab-pane" aria-selected="false" @click="setActiveTab('trades')">📄
            Trades</button>
        </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link" id="ai-automation-tab" data-bs-toggle="tab" data-bs-target="#ai-automation-tab-pane"
            type="button" role="tab" aria-controls="ai-automation-tab-pane" aria-selected="false">🤖 AI
            Automation</button>
        </li>
      </ul>
      <div class="tab-content" id="myTabContent">
        <div class="tab-pane fade show active" id="positions-tab-pane" role="tabpanel" aria-labelledby="positions-tab"
          tabindex="0">
          <div class="row align-items-center">
            <div class="col-6 text-center py-2">
              <p class="mb-0"><b>Net Qty: </b>{{ totalNetQty }}</p>
            </div>
            <div class="col-6 text-center py-2">
              <p class="mb-0"><b>MTM Trailing: </b></p>
            </div>
          </div>
          <!-- Dhan Positions -->
          <table class="table table-hover" v-if="activeFetchFunction === 'fetchDhanPositions'">
            <thead>
              <tr>
                <th scope="col">Symbol Name</th>
                <th scope="col">Position Type</th>
                <th scope="col">Product Type</th>
                <th scope="col">Net Qty</th>
                <th scope="col">Buy Avg</th>
                <th scope="col">Sell Avg</th>
                <th scope="col">Realized Profit</th>
                <th scope="col">Unrealized Profit</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="dhanPosition in dhanPositionBook" :key="dhanPosition.securityId">
                <td>{{ dhanPosition.tradingSymbol }}</td>
                <td>{{ dhanPosition.positionType }}</td>
                <td>{{ dhanPosition.productType }}</td>
                <td>{{ dhanPosition.netQty }}</td>
                <td>{{ dhanPosition.buyAvg }}</td>
                <td>{{ dhanPosition.sellAvg }}</td>
                <td>{{ dhanPosition.realizedProfit }}</td>
                <td>{{ dhanPosition.unrealizedProfit }}</td>
              </tr>
              <tr v-if="dhanPositionBook.length === 0">
                <td colspan="8" class="text-center">No positions on selected broker {{ selectedBroker.brokerName
                  }}</td>
              </tr>
            </tbody>
          </table>
          <!-- Flattrade Positions -->
          <div v-if="activeFetchFunction === 'fetchFlattradePositions' && flatTradePositionBook.length">
            <table class="table table-hover" v-if="flatTradePositionBook.length">
              <thead>
                <tr>
                  <th scope="col">Symbol Name</th>
                  <th scope="col">Net Qty</th>
                  <th scope="col">Position Type</th>
                  <th scope="col">Product Type</th>
                  <th scope="col">LTP</th>
                  <th scope="col">Buy Avg</th>
                  <th scope="col">Sell Avg</th>
                  <th scope="col">Realized</th>
                  <th scope="col">Unrealized</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="flattradePosition in flatTradePositionBook" :key="flattradePosition.tsym">
                  <td>{{ flattradePosition.tsym }}</td>
                  <td>{{ flattradePosition.netqty }}</td>
                  <td>{{ flattradePosition.netqty > 0 ? 'B' : flattradePosition.netqty < 0 ? 'S' : '-' }}</td>
                  <td>{{ flattradePosition.prd }}</td>
                  <td>{{ flattradePosition.lp }}</td>
                  <td>{{ flattradePosition.cfbuyavgprc }}</td>
                  <td>{{ flattradePosition.cfsellavgprc }}</td>
                  <td>{{ flattradePosition.rpnl }}</td>
                  <td>{{ flattradePosition.urmtom }}</td>
                </tr>
                <tr v-if="flatTradePositionBook.length === 0">
                  <td colspan="5" class="text-center">No positions on selected broker {{ selectedBroker.brokerName
                    }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div class="tab-pane fade" id="trades-tab-pane" role="tabpanel" aria-labelledby="trades-tab" tabindex="0">
          <!-- Dhan Trades -->
          <table class="table table-hover" v-if="activeFetchFunction === 'fetchDhanOrdersTradesBook'">
            <thead>
              <tr>
                <th>Order ID</th>
                <th>Symbol</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Execution Time</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="dhanOrder in dhanOrders" :key="dhanOrder.orderId">
                <td>{{ dhanOrder.orderId }}</td>
                <td>{{ dhanOrder.tradingSymbol }}</td>
                <td>{{ dhanOrder.quantity }}</td>
                <td>{{ dhanOrder.price }}</td>
                <td>{{ dhanOrder.createTime }}</td>
                <td>{{ dhanOrder.orderStatus }}</td>
              </tr>
              <tr v-if="dhanOrders.length === 0">
                <td colspan="5" class="text-center">No orders or trades on selected broker {{
                  selectedBroker.brokerName }}</td>
              </tr>
            </tbody>
          </table>
          <!-- Flattrade Trades -->
          <div v-if="activeFetchFunction === 'fetchFlattradeOrdersTradesBook'">
            <table class="table table-hover" v-if="flatOrderBook.length || flatTradeBook.length">
              <thead>
                <tr>
                  <th scope="col">Type</th>
                  <th scope="col">Order ID</th>
                  <th scope="col">Trade ID</th>
                  <th scope="col">Symbol</th>
                  <th scope="col">Quantity</th>
                  <th scope="col">Price</th>
                  <th scope="col">Date</th>
                  <th scope="col">Status</th>
                  <th scope="col">Reason</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="order in flatOrderBook" :key="order.norenordno">
                  <td>Order</td>
                  <td>{{ order.norenordno }}</td>
                  <td>N/A</td>
                  <td>{{ order.tsym }}</td>
                  <td>{{ order.qty }}</td>
                  <td>{{ order.prc }}</td>
                  <td>{{ order.norentm }}</td>
                  <td>{{ order.status }}</td>
                  <td>{{ order.rejreason }}</td>
                </tr>
                <tr v-for="trade in flatTradeBook" :key="trade.norenordno">
                  <td>Trade</td>
                  <td>{{ trade.norenordno }}</td>
                  <td>{{ trade.norenordno }}</td>
                  <td>{{ trade.tsym }}</td>
                  <td>{{ trade.qty }}</td>
                  <td>{{ trade.flprc }}</td>
                  <td>{{ trade.norentm }}</td>
                  <td>{{ trade.stat }}</td>
                  <td>N/A</td>
                </tr>
              </tbody>
            </table>
            <div v-else class="text-center">No orders or trades on selected broker {{ selectedBroker.brokerName }}</div>
          </div>
        </div>
        <div class="tab-pane fade" id="ai-automation-tab-pane" role="tabpanel" aria-labelledby="ai-automation-tab"
          tabindex="0">

          <div class="card text-center py-3">
            <div class="card-body text-danger">
              <p class="fs-5">
                AI Automation
                <small>To be determined</small>
              </p>
            </div>
          </div>
        </div>
      </div>

    </div>
  </section>

  <!-- Toast Alert -->
  <ToastAlert :show="showToast" :message="toastMessage" @update:show="updateToastVisibility" />

  <!-- Limit Price Input Modal (conditionally rendered) -->
  <div class="modal fade" id="PlaceLimitOrderWindow" tabindex="-1" aria-labelledby="PlaceLimitOrderWindowLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="PlaceLimitOrderWindowLabel">
            {{ modalTransactionType }} {{ modalOptionType }}: {{ selectedMasterSymbol }} {{ selectedStrike.strikePrice
            }}
            {{
              selectedStrike.expiryDate }}
          </h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"
            @click="resetOrderType"></button>
        </div>
        <div class="modal-body">
          <div class="col-2">
            <label for="LimitPrice" class="form-label mb-0">Limit Price</label>
            <input type="number" id="LimitPrice" class="form-control" v-model="limitPrice"
              placeholder="Enter limit price">
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
            @click="resetOrderTypeIfNeeded">Cancel</button>
          <button type="button" class="btn btn-primary" data-bs-dismiss="modal"
            @click="placeOrder(modalTransactionType, modalOptionType)">Place
            Order</button>
        </div>
      </div>
    </div>
  </div>

</template>



<script setup>
import { ref, computed, onMounted, watch, onBeforeUnmount } from 'vue';
import axios from 'axios';
import ToastAlert from '../components/ToastAlert.vue';
import qs from 'qs';
// import LineChart from '../components/LineChart.vue';
// const showLineChart = ref(false);
const showToast = ref(false);
const toastMessage = ref('');
const updateToastVisibility = (value) => {
  showToast.value = value;
};
const brokerStatus = computed(() => {
  const dhanClientId = localStorage.getItem('DHAN_CLIENT_ID');
  const dhanApiToken = localStorage.getItem('DHAN_API_TOKEN');
  const flattradeClientId = localStorage.getItem('FLATTRADE_CLIENT_ID');
  const flattradeApiToken = localStorage.getItem('FLATTRADE_API_TOKEN');

  if (selectedBroker.value?.brokerName === 'Dhan') {
    return dhanClientId && dhanApiToken ? 'Connected' : 'Not Connected';
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    return flattradeClientId && flattradeApiToken ? 'Connected' : 'Not Connected';
  }
  return 'Not Connected';
});

const activeTab = ref('positions');
const setActiveTab = (tab) => {
  activeTab.value = tab;
};

// Kill Switch - Client Side
const killSwitchActive = ref(localStorage.getItem('KillSwitchStatus') === 'true');
const isFormDisabled = computed(() => killSwitchActive.value);

const toggleKillSwitch = () => {
  const newStatus = killSwitchActive.value ? 'DEACTIVATED' : 'ACTIVATED';

  if (newStatus === 'DEACTIVATED') {
    const activationTime = localStorage.getItem('KillSwitchActivationTime');
    const currentTime = new Date().getTime();
    const twelveHoursInMillis = 12 * 60 * 60 * 1000;

    if (activationTime && (currentTime - activationTime < twelveHoursInMillis)) {
      toastMessage.value = 'Kill Switch cannot be deactivated within 12 hours of activation';
      showToast.value = true;
      return;
    }
  }

  // Handle different response messages
  if (newStatus === 'ACTIVATED') {
    toastMessage.value = 'Kill Switch activated successfully';
    killSwitchActive.value = true;
    localStorage.setItem('KillSwitchStatus', 'true');
    localStorage.setItem('KillSwitchActivationTime', new Date().getTime());
  } else if (newStatus === 'DEACTIVATED') {
    toastMessage.value = 'Kill Switch deactivated successfully';
    killSwitchActive.value = false;
    localStorage.setItem('KillSwitchStatus', 'false');
    localStorage.removeItem('KillSwitchActivationTime');
  }

  showToast.value = true;
};

const killSwitchButtonText = computed(() => killSwitchActive.value ? 'Deactivate' : 'Activate');
const killSwitchButtonClass = computed(() => killSwitchActive.value ? 'btn btn-sm btn-danger shadow fs-5' : 'btn btn-sm btn-success shadow fs-5');

// Fetch brokers and set selectedBroker
const brokers = ref([]);
const selectedBroker = ref(null);
const fetchBrokers = async () => {
  try {
    const response = await axios.get('http://localhost:3000/brokers');
    brokers.value = response.data;
    if (brokers.value.length > 0) {
      selectedBroker.value = brokers.value[1];
      fetchFundLimit(); // Fetch fund limits after setting the selected broker
    }
  } catch (error) {
    console.error('Failed to fetch brokers:', error);
  }
};

// Fetch trading symbols and strikes
const selectedExchange = ref('NSE');
const selectedMasterSymbol = ref('');
const selectedQuantity = ref(null);
const selectedExpiry = ref(null);
const selectedCallStrike = ref({});
const selectedPutStrike = ref({});
const defaultCallSecurityId = ref(null);
const defaultPutSecurityId = ref(null);
const exchangeSymbols = ref({});

const updateExchangeSymbols = () => {
  if (selectedBroker.value?.brokerName === 'Dhan') {
    exchangeSymbols.value = {
      NSE: ['NIFTY', 'BANKNIFTY', 'FINNIFTY', 'MIDCPNIFTY', 'NIFTYNXT50'],
      BSE: ['SENSEX', 'BANKEX', 'SENSEX50']
    };
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    exchangeSymbols.value = {
      NFO: ['NIFTY', 'BANKNIFTY', 'FINNIFTY', 'MIDCPNIFTY', 'NIFTYNXT50'],
      BFO: ['SENSEX', 'BANKEX', 'SENSEX50']
    };
  }
};
const setDefaultExchangeAndMasterSymbol = () => {
  const exchanges = Object.keys(exchangeSymbols.value);
  if (exchanges.length > 0) {
    selectedExchange.value = exchanges[0];
    if (exchangeSymbols.value[selectedExchange.value].length > 0) {
      selectedMasterSymbol.value = exchangeSymbols.value[selectedExchange.value][0];
    }
  }
};
const callStrikes = ref([]);
const putStrikes = ref([]);
const expiryDates = ref([]);
const synchronizeOnLoad = ref(true);
const fetchTradingData = async () => {
  let response;
  if (selectedBroker.value?.brokerName === 'Dhan') {
    response = await fetch(`http://localhost:3000/dhanSymbols?exchangeSymbol=${selectedExchange.value}&masterSymbol=${selectedMasterSymbol.value}`);
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    response = await fetch(`http://localhost:3000/flattradeSymbols?exchangeSymbol=${selectedExchange.value}&masterSymbol=${selectedMasterSymbol.value}`);
    console.log('Flattrade Symbols:', response);
  } else {
    throw new Error('Unsupported broker');
  }

  const data = await response.json();
  console.log('Data:', data);
  expiryDates.value = data.expiryDates;

  // Filter by selected expiry date before sorting and mapping
  callStrikes.value = data.callStrikes
    .filter(strike => strike.expiryDate === selectedExpiry.value)
    .sort((a, b) => parseInt(a.strikePrice) - parseInt(b.strikePrice))
    .map(strike => ({ ...strike, strikePrice: parseInt(strike.strikePrice) }));

  putStrikes.value = data.putStrikes
    .filter(strike => strike.expiryDate === selectedExpiry.value)
    .sort((a, b) => parseInt(a.strikePrice) - parseInt(b.strikePrice))
    .map(strike => ({ ...strike, strikePrice: parseInt(strike.strikePrice) }));

  // Only set selectedExpiry if it is not already defined
  if (!selectedExpiry.value && expiryDates.value.length > 0) {
    selectedExpiry.value = expiryDates.value[0];
  }

  updateStrikesForExpiry(selectedExpiry.value);
};

const formatDate = (dateString) => {
  if (selectedBroker.value?.brokerName === 'Dhan') {
    // Extract only the date part from the date string for Dhan
    return dateString.split(' ')[0]; // Splits the string by space and returns the first part (date)
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    // Return the date string as is for Flattrade
    return dateString;
  }
  return dateString; // Default case, return the original date string
};

const updateStrikesForExpiry = (expiryDate) => {
  console.log('Updating strikes for expiry:', expiryDate);

  let filteredCallStrikes, filteredPutStrikes;

  if (selectedBroker.value?.brokerName === 'Dhan') {
    console.log('before filtering Dhan Call Strikes:', callStrikes.value);
    console.log('before filtering Dhan Put Strikes:', putStrikes.value);
    filteredCallStrikes = callStrikes.value.filter(strike => strike.expiryDate === expiryDate);
    filteredPutStrikes = putStrikes.value.filter(strike => strike.expiryDate === expiryDate);
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    console.log('before filtering Flattrade Call Strikes:', callStrikes.value);
    console.log('before filtering Flattrade Put Strikes:', putStrikes.value);
    filteredCallStrikes = callStrikes.value.filter(strike => strike.expiryDate === expiryDate);
    filteredPutStrikes = putStrikes.value.filter(strike => strike.expiryDate === expiryDate);
  }

  console.log('Filtered Call Strikes:', filteredCallStrikes);
  console.log('Filtered Put Strikes:', filteredPutStrikes);

  selectedCallStrike.value = filteredCallStrikes.length > 0 ? filteredCallStrikes[0] : {};
  selectedPutStrike.value = filteredPutStrikes.length > 0 ? filteredPutStrikes[0] : {};

  console.log('Update Strike for expiry, Selected Call Strike:', selectedCallStrike.value);
  console.log('Update Strike for expiry, Selected Put Strike:', selectedPutStrike.value);

  if (synchronizeOnLoad.value) {
    synchronizeStrikes();
    synchronizeOnLoad.value = false;
  }

  defaultCallSecurityId.value = selectedCallStrike.value.securityId || 'N/A';
  defaultPutSecurityId.value = selectedPutStrike.value.securityId || 'N/A';
};

const synchronizeStrikes = () => {
  synchronizeCallStrikes();
  synchronizePutStrikes();
};

const synchronizeCallStrikes = () => {
  if (selectedPutStrike.value && selectedPutStrike.value.tradingSymbol) {
    let baseSymbol;
    if (selectedBroker.value?.brokerName === 'Dhan') {
      baseSymbol = selectedPutStrike.value.tradingSymbol.replace(/-PE$/, '');
    } else if (selectedBroker.value?.brokerName === 'Flattrade') {
      baseSymbol = selectedPutStrike.value.tradingSymbol.replace(/P\d+$/, ''); // Adjust regex as needed
    }
    const matchingCallStrike = callStrikes.value.find(strike =>
      strike.tradingSymbol.startsWith(baseSymbol) && strike.tradingSymbol.endsWith(selectedBroker.value?.brokerName === 'Dhan' ? '-CE' : 'C')
    );
    if (matchingCallStrike) {
      selectedCallStrike.value = matchingCallStrike;
    } else {
      selectedCallStrike.value = {};
    }
  }
  updateSecurityIds();
};

const synchronizePutStrikes = () => {
  if (selectedCallStrike.value && selectedCallStrike.value.tradingSymbol) {
    let baseSymbol;
    if (selectedBroker.value?.brokerName === 'Dhan') {
      baseSymbol = selectedCallStrike.value.tradingSymbol.replace(/-CE$/, '');
    } else if (selectedBroker.value?.brokerName === 'Flattrade') {
      baseSymbol = selectedCallStrike.value.tradingSymbol.replace(/C\d+$/, ''); // Adjust regex as needed
    }
    const matchingPutStrike = putStrikes.value.find(strike =>
      strike.tradingSymbol.startsWith(baseSymbol) && strike.tradingSymbol.endsWith(selectedBroker.value?.brokerName === 'Dhan' ? '-PE' : 'P')
    );
    if (matchingPutStrike) {
      selectedPutStrike.value = matchingPutStrike;
    } else {
      selectedPutStrike.value = {};
    }
  }
  updateSecurityIds();
};

const updateSecurityIds = () => {
  console.log('Updating Security IDs');
  defaultCallSecurityId.value = selectedCallStrike.value.securityId || 'N/A';
  defaultPutSecurityId.value = selectedPutStrike.value.securityId || 'N/A';
};

const updateAvailableQuantities = () => {
  availableQuantities.value = quantities.value[selectedMasterSymbol.value] || [];
  if (!availableQuantities.value.includes(selectedQuantity.value)) {
    selectedQuantity.value = availableQuantities.value[0];
  }
};

const enableHotKeys = ref(false);
const handleHotKeys = (event) => {
  if (!enableHotKeys.value) return;

  switch (event.key) {
    case 'ArrowUp':
    case 'ArrowDown':
    case 'ArrowRight':
    case 'ArrowLeft':
    case 'F6':
    case 'F7':
      event.preventDefault(); // Prevent default browser action
      break;
  }

  switch (event.key) {
    case 'ArrowUp':
      placeOrder(getTransactionType('BUY'), 'CALL');
      break;
    case 'ArrowDown':
      placeOrder(getTransactionType('BUY'), 'PUT');
      break;
    case 'ArrowRight':
      placeOrder(getTransactionType('SELL'), 'PUT');
      break;
    case 'ArrowLeft':
      placeOrder(getTransactionType('SELL'), 'CALL');
      break;
    case 'F6':
      closeAllPositions();
      break;
    case 'F7':
      cancelPendingOrders();
      break;
  }
};

const dhanOrders = ref([]);
const fetchDhanOrdersTradesBook = async () => {
  try {
    const response = await axios.get('http://localhost:3000/dhanGetOrders');
    dhanOrders.value = response.data; // Set the orders array
    console.log('Dhan Order Book:', response.data);
  } catch (error) {
    console.error('Error fetching orders:', error);
    toastMessage.value = 'Error fetching orders';
    showToast.value = true;
  }
};
const flatOrderBook = ref('');
const flatTradeBook = ref('');
const token = ref('');

const fetchFlattradeOrdersTradesBook = async () => {
  let jKey = localStorage.getItem('FLATTRADE_API_TOKEN') || token.value;
  let clientId = localStorage.getItem('FLATTRADE_CLIENT_ID');

  if (!jKey || !clientId) {
    toastMessage.value = 'Token or Client ID is missing. Please generate a token first.';
    showToast.value = true;
    return;
  }

  try {
    const response = await axios.get('http://localhost:3000/flattradeGetOrdersAndTrades', {
      params: {
        FLATTRADE_API_TOKEN: jKey,
        FLATTRADE_CLIENT_ID: clientId
      }
    });

    flatOrderBook.value = response.data.orderBook;
    flatTradeBook.value = response.data.tradeBook;
    console.log('Flattrade Order Book:', response.data.orderBook);
    console.log('Flattrade Trade Book:', response.data.tradeBook);
  } catch (error) {
    toastMessage.value = 'Error fetching trades: ' + error.message;
    showToast.value = true;
    console.error('Error fetching trades:', error);
  }
};

const dhanPositionBook = ref([]);
const fetchDhanPositions = async () => {
  try {
    const response = await axios.get('http://localhost:3000/dhanPositions');
    dhanPositionBook.value = response.data;
    console.log('Dhan Position Book:', dhanPositionBook.value);
  } catch (error) {
    console.error('Error fetching dhanPositionBook:', error);
    toastMessage.value = 'Failed to fetch dhanPositionBook';
    showToast.value = true;
  }
};

const flatTradePositionBook = ref([]);
const fetchFlattradePositions = async () => {
  let jKey = localStorage.getItem('FLATTRADE_API_TOKEN') || token.value;

  if (!jKey) {
    toastMessage.value = 'Token is missing. Please generate a token first.';
    showToast.value = true;
    return;
  }

  const positionBookPayload = `jKey=${jKey}&jData=${JSON.stringify({ uid: localStorage.getItem('FLATTRADE_CLIENT_ID'), actid: localStorage.getItem('FLATTRADE_CLIENT_ID') })}`;

  try {
    const positionBookRes = await axios.post('https://piconnect.flattrade.in/PiConnectTP/PositionBook', positionBookPayload, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    });

    if (Array.isArray(positionBookRes.data) && positionBookRes.data.every(item => item.stat === 'Ok')) {
      flatTradePositionBook.value = positionBookRes.data;
      console.log('Flattrade Position Book:', positionBookRes.data);
    } else {
      const errorMsg = positionBookRes.data.emsg || 'Unknown error';
      toastMessage.value = `Error fetching position book: ${errorMsg}`;
      showToast.value = true;
      console.error('Error fetching position book:', errorMsg);
    }
  } catch (error) {
    toastMessage.value = 'Error fetching position book: ' + error.message;
    showToast.value = true;
    console.error('Error fetching position book:', error);
  }
};

const fundLimits = ref({});
const fetchFundLimit = async () => {
  try {
    if (!selectedBroker.value) {
      throw new Error('No broker selected');
    }

    let response;
    if (selectedBroker.value.brokerName === 'Dhan') {
      response = await axios.get('http://localhost:3000/dhanFundLimit');
    } else if (selectedBroker.value.brokerName === 'Flattrade') {
      const FLATTRADE_API_TOKEN = localStorage.getItem('FLATTRADE_API_TOKEN'); // Retrieve the token from local storage
      if (!FLATTRADE_API_TOKEN) {
        throw new Error('Flattrade API Token is missing');
      }
      response = await axios.post('http://localhost:3000/flattradeFundLimit', null, {
        params: { FLATTRADE_API_TOKEN }
      });
    } else {
      throw new Error('Unsupported broker');
    }
    fundLimits.value = response.data;
  } catch (error) {
    console.error('Failed to fetch fund limits:', error);
  }
};

const showBrokerClientId = ref(false);
const toggleBrokerClientIdVisibility = () => {
  showBrokerClientId.value = !showBrokerClientId.value;
};

const maskBrokerClientId = (brokerClientId) => {
  if (!brokerClientId) return 'N/A'; // Ensure brokerClientId is defined

  const length = brokerClientId.length;
  if (length <= 2) return brokerClientId; // If the length is 2 or less, return as is

  const maskLength = Math.max(1, Math.floor(length / 2)); // Mask at least 1 character, up to half the length
  const startUnmaskedLength = Math.ceil((length - maskLength) / 2);
  const endUnmaskedLength = length - startUnmaskedLength - maskLength;

  const firstPart = brokerClientId.slice(0, startUnmaskedLength);
  const lastPart = brokerClientId.slice(-endUnmaskedLength);
  const middleMask = '*'.repeat(maskLength); // Mask middle portion dynamically

  return `${firstPart}${middleMask}${lastPart}`;
};


const quantities = ref({
  NIFTY: [25],
  BANKNIFTY: [15],
  FINNIFTY: [40],
  MIDCPNIFTY: [75],
  NIFTYNXT50: [10],
  SENSEX: [10],
  BANKEX: [15],
  SENSEX50: [25]
});
const availableQuantities = ref([]);

const orderTypes = computed(() => {
  if (selectedBroker.value?.brokerName === 'Dhan') {
    return ['MARKET', 'LIMIT'];
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    return ['MKT', 'LMT'];
  }
  return [];
});
const selectedOrderType = ref(orderTypes.value[0]);
const previousOrderType = ref(orderTypes.value[0]);

const selectedStrike = ref({});
const setOrderDetails = (transactionType, optionType) => {
  modalTransactionType.value = getTransactionType(transactionType); // Use getTransactionType to set modalTransactionType
  modalOptionType.value = optionType;
  selectedOrderType.value = orderTypes.value[1]; // Set selectedOrderType to LIMIT or LMT based on broker
  selectedStrike.value = optionType === 'CALL' ? selectedCallStrike.value : selectedPutStrike.value;
};
const resetOrderTypeIfNeeded = () => {
  if (previousOrderType.value === orderTypes.value[0]) { // Check if previousOrderType is MARKET or MKT
    resetOrderType();
  }
};

const resetOrderType = () => {
  selectedOrderType.value = orderTypes.value[0]; // Set selectedOrderType to MARKET or MKT based on broker
};

const productTypes = computed(() => {
  if (selectedBroker.value?.brokerName === 'Dhan') {
    return ['Intraday', 'Margin'];
  }
  else if (selectedBroker.value?.brokerName === 'Flattrade') {
    return ['Intraday', 'Margin'];
  }
  return [];
});
const getProductTypeValue = (productType) => {
  if (selectedBroker.value?.brokerName === 'Dhan') {
    return productType.toUpperCase();
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    return productType === 'Intraday' ? 'I' : 'M';
  }
  return productType;
};

const selectedProductType = ref(''); // Initialize with an empty string

const getTransactionType = (type) => {
  if (selectedBroker.value?.brokerName === 'Dhan') {
    return type;
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    return type === 'BUY' ? 'B' : 'S';
  }
  return type;
};

const limitPrice = ref(null);
const modalTransactionType = ref('');
const modalOptionType = ref('');
// Get Exchange Segment for Dhan or Flattrade
const getExchangeSegment = () => {
  if (!selectedBroker.value || !selectedExchange.value) {
    throw new Error("Broker or exchange not selected");
  }

  if (selectedBroker.value.brokerName === 'Dhan') {
    if (selectedExchange.value === 'NSE') {
      return 'NSE_FNO';
    } else if (selectedExchange.value === 'BSE') {
      return 'BSE_FNO';
    } else {
      throw new Error("Selected exchange is not valid for Dhan");
    }
  } else if (selectedBroker.value.brokerName === 'Flattrade') {
    if (selectedExchange.value === 'NFO') {
      return 'NFO';
    } else if (selectedExchange.value === 'BFO') {
      return 'BFO';
    } else {
      throw new Error("Selected exchange is not valid for Flattrade");
    }
  } else {
    throw new Error("Unsupported broker");
  }
};

// Prepare Order Payload for Dhan or Flattrade
const prepareOrderPayload = (transactionType, drvOptionType, selectedStrike, exchangeSegment) => {
  if (selectedBroker.value.brokerName === 'Dhan') {
    return {
      brokerClientId: selectedBroker.value.brokerClientId,
      transactionType: transactionType,
      exchangeSegment: exchangeSegment,
      productType: selectedProductType.value,
      orderType: selectedOrderType.value,
      validity: 'DAY',
      tradingSymbol: selectedStrike.tradingSymbol,
      securityId: selectedStrike.securityId,
      quantity: selectedQuantity.value,
      price: selectedOrderType.value === 'LIMIT' ? limitPrice.value : 0,
      drvExpiryDate: selectedExpiry.value,
      drvOptionType: drvOptionType
    };
  } else if (selectedBroker.value.brokerName === 'Flattrade') {
    return {
      uid: selectedBroker.value.brokerClientId,
      actid: selectedBroker.value.brokerClientId,
      exch: exchangeSegment,
      tsym: selectedStrike.tradingSymbol,
      qty: selectedQuantity.value,
      prc: selectedOrderType.value === 'LMT' ? limitPrice.value : 0,
      prd: selectedProductType.value,
      trantype: transactionType,
      prctyp: selectedOrderType.value,
      ret: "DAY"
      // Add any additional fields specific to Flattrade here
    };
  } else {
    throw new Error("Unsupported broker");
  }
};

// Place Order for Dhan or Flattrade
const placeOrder = async (transactionType, drvOptionType) => {
  try {
    let selectedStrike;
    if (drvOptionType === 'CALL') {
      selectedStrike = selectedCallStrike.value;
    } else if (drvOptionType === 'PUT') {
      selectedStrike = selectedPutStrike.value;
    }

    if (!selectedStrike) {
      throw new Error(`Selected ${drvOptionType.toLowerCase()} strike is not defined`);
    }

    if (!selectedStrike.tradingSymbol || !selectedStrike.securityId) {
      throw new Error(`Selected ${drvOptionType.toLowerCase()} strike properties are not properly defined`);
    }

    const exchangeSegment = getExchangeSegment();
    const orderData = prepareOrderPayload(transactionType, drvOptionType, selectedStrike, exchangeSegment);

    console.log("Placing order with data:", orderData);
    let response;
    if (selectedBroker.value.brokerName === 'Dhan') {
      response = await axios.post('http://localhost:3000/dhanPlaceOrder', orderData);
    } else if (selectedBroker.value.brokerName === 'Flattrade') {
      const FLATTRADE_API_TOKEN = localStorage.getItem('FLATTRADE_API_TOKEN');
      const payload = qs.stringify(orderData); // Convert orderData to URL-encoded string
      response = await axios.post('http://localhost:3000/flattradePlaceOrder', payload, {
        headers: {
          'Authorization': `Bearer ${FLATTRADE_API_TOKEN}`,
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      });
    }

    console.log("Order placed successfully:", response.data);
    toastMessage.value = 'Order placed successfully';
    showToast.value = true;
  } catch (error) {
    console.error("Error placing order:", error); // Log the full error
    if (error.response && error.response.data && error.response.data.message) {
      const firstThreeWords = error.response.data.message.split(' ').slice(0, 3).join(' ');
      toastMessage.value = firstThreeWords;
    } else {
      toastMessage.value = 'Failed to place order unfortunately';
    }
    showToast.value = true;
  }
};
// Place Order for Dhan or Flattrade for each position
const placeOrderForPosition = async (transactionType, optionType, position) => {
  try {
    const quantity = Math.abs(Number(position.netQty || position.netqty));

    if (quantity === 0) {
      console.log('Quantity is zero, no order will be placed.');
      return;
    }

    let orderData;
    if (selectedBroker.value.brokerName === 'Dhan') {
      orderData = {
        brokerClientId: selectedBroker.value.brokerClientId,
        transactionType: transactionType,
        exchangeSegment: selectedExchange.value === 'NSE' ? 'NSE_FNO' : 'BSE_FNO',
        productType: selectedProductType.value,
        orderType: 'MARKET',
        validity: 'DAY',
        tradingSymbol: position.tradingSymbol,
        securityId: position.securityId,
        quantity: position.netQty,
        price: 0,
        drvExpiryDate: position.expiryDate,
        drvOptionType: optionType
      };
    } else if (selectedBroker.value.brokerName === 'Flattrade') {
      orderData = {
        uid: selectedBroker.value.brokerClientId,
        actid: selectedBroker.value.brokerClientId,
        exch: selectedExchange.value === 'NFO' ? 'NFO' : 'BFO',
        tsym: position.tsym,
        qty: position.netqty,
        prc: 0,
        prd: position.prd,
        trantype: transactionType,
        prctyp: 'MKT',
        ret: "DAY"
      };
    }

    console.log("Placing order for position with data:", orderData);
    let response;
    if (selectedBroker.value.brokerName === 'Dhan') {
      response = await axios.post('http://localhost:3000/dhanPlaceOrder', orderData);
    } else if (selectedBroker.value.brokerName === 'Flattrade') {
      const FLATTRADE_API_TOKEN = localStorage.getItem('FLATTRADE_API_TOKEN');
      const payload = qs.stringify(orderData); // Convert orderData to URL-encoded string
      response = await axios.post('http://localhost:3000/flattradePlaceOrder', payload, {
        headers: {
          'Authorization': `Bearer ${FLATTRADE_API_TOKEN}`,
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      });
    }

    console.log("Order placed successfully for position:", response.data);
  } catch (error) {
    console.error('Failed to place order for position:', error);
    throw error;
  }
};

// Close all positions for Dhan or Flattrade
const closeAllPositions = async () => {
  try {
    let positionsClosed = false;

    if (selectedBroker.value?.brokerName === 'Dhan') {
      for (const position of dhanPositionBook.value) {
        const netQty = Number(position.netQty); // Ensure netQty is treated as a number
        if (netQty !== 0) {
          const transactionType = netQty > 0 ? 'SELL' : 'BUY';
          const optionType = position.tradingSymbol.includes('CE') ? 'CALL' : 'PUT';
          await placeOrderForPosition(transactionType, optionType, position);
          positionsClosed = true;
        }
      }
      if (positionsClosed) {
        toastMessage.value = 'All Dhan positions closed successfully';
      } else {
        toastMessage.value = 'No positions to close for Dhan';
      }
    } else if (selectedBroker.value?.brokerName === 'Flattrade') {
      for (const position of flatTradePositionBook.value) {
        const netqty = Number(position.netqty); // Ensure netqty is treated as a number
        if (netqty !== 0) {
          const transactionType = netqty > 0 ? 'S' : 'B';
          const optionType = position.tsym.includes('C') ? 'CALL' : 'PUT';
          await placeOrderForPosition(transactionType, optionType, position);
          positionsClosed = true;
        }
      }
      if (positionsClosed) {
        toastMessage.value = 'All Flattrade positions closed successfully';
      } else {
        toastMessage.value = 'No positions to close for Flattrade';
      }
    }

    showToast.value = true;
  } catch (error) {
    console.error('Error closing positions:', error);
    toastMessage.value = 'Failed to close all positions';
    showToast.value = true;
  }
};

const cancelOrder = async (order) => {
  const orderId = selectedBroker.value?.brokerName === 'Dhan' ? order.orderId : order.norenordno;
  const orderStatus = selectedBroker.value?.brokerName === 'Dhan' ? order.orderStatus : order.status;

  console.log(`Attempting to cancel order ${orderId} with status ${orderStatus}`);
  console.log(`Broker: ${selectedBroker.value?.brokerName}`);

  if ((selectedBroker.value?.brokerName === 'Dhan' && orderStatus !== 'PENDING') ||
    (selectedBroker.value?.brokerName === 'Flattrade' && orderStatus !== 'OPEN')) {
    console.log(`Order ${orderId} is not in a cancellable state and cannot be canceled.`);
    return;
  }

  try {
    if (selectedBroker.value?.brokerName === 'Dhan') {
      console.log(`Sending request to cancel Dhan order ${orderId}`);
      await axios.delete('http://localhost:3000/dhanCancelOrder', {
        data: { orderId },
      });
    } else if (selectedBroker.value?.brokerName === 'Flattrade') {
      const jKey = localStorage.getItem('FLATTRADE_API_TOKEN') || token.value;
      const clientId = localStorage.getItem('FLATTRADE_CLIENT_ID');
      console.log(`Sending request to cancel Flattrade order ${orderId}`);
      await axios.post('http://localhost:3000/flattradeCancelOrder', {
        norenordno: orderId,
        uid: clientId
      }, {
        params: {
          FLATTRADE_API_TOKEN: jKey
        }
      });
    }
    console.log(`Order ${orderId} canceled successfully.`);
  } catch (error) {
    console.error(`Failed to cancel order ${orderId}:`, error);
    toastMessage.value = 'Failed to cancel order';
    showToast.value = true;
    throw error; // Rethrow to handle in cancelPendingOrders
  }
};

const cancelPendingOrders = async () => {
  console.log(`Canceling pending orders for broker: ${selectedBroker.value?.brokerName}`);

  // Fetch orders based on the selected broker
  if (selectedBroker.value?.brokerName === 'Dhan') {
    await fetchDhanOrdersTradesBook();
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    await fetchFlattradeOrdersTradesBook();
  }

  const pendingOrders = selectedBroker.value?.brokerName === 'Dhan'
    ? dhanOrders.value.filter(order => order.orderStatus === 'PENDING')
    : flatOrderBook.value.filter(order => order.status === 'OPEN');

  console.log(`Pending orders:`, pendingOrders);

  const cancelPromises = pendingOrders.map(order => cancelOrder(order));

  try {
    await Promise.all(cancelPromises);
    toastMessage.value = 'Pending orders canceled successfully';
    showToast.value = true;

    // Refresh the orders list based on the selected broker
    if (selectedBroker.value?.brokerName === 'Dhan') {
      await fetchDhanOrdersTradesBook();
    } else if (selectedBroker.value?.brokerName === 'Flattrade') {
      await fetchFlattradeOrdersTradesBook();
    }
  } catch (error) {
    console.error('Failed to cancel orders:', error);
    toastMessage.value = 'Failed to cancel some orders';
    showToast.value = true;
  }
};



// Computed properties
const availableBalance = computed(() => {
  if (selectedBroker.value?.brokerName === 'Dhan') {
    return fundLimits.value.availabelBalance; // yes, it's availabelBalance, a misspelling of availableBalance on DhanAPI
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    return fundLimits.value.cash;
  }
  return 0;
});
// Computed property to get the correct utilized amount based on the selected broker
const usedAmount = computed(() => {
  if (selectedBroker.value?.brokerName === 'Dhan') {
    return fundLimits.value.utilizedAmount;
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    return fundLimits.value.marginused;
  }
  return 0;
});

const formattedDate = computed(() => {
  const today = new Date();
  const options = { weekday: 'short', day: '2-digit', month: 'short', year: 'numeric' };
  return today.toLocaleDateString('en-US', options).replace(/,/g, '');
});

const totalNetQty = computed(() => {
  if (selectedBroker.value?.brokerName === 'Dhan') {
    return dhanPositionBook.value.reduce((total, position) => total + position.netQty, 0);
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    return flatTradePositionBook.value.reduce((total, position) => total + parseInt(position.netqty, 10), 0);
  }
  return 0;
});

const totalProfit = computed(() => {
  if (selectedBroker.value?.brokerName === 'Dhan') {
    return dhanPositionBook.value.reduce((acc, position) => acc + position.unrealizedProfit + position.realizedProfit, 0);
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    return flatTradePositionBook.value.reduce((acc, position) => acc + parseFloat(position.urmtom) + parseFloat(position.rpnl), 0);
  }
  return 0;
});

// const profitData = computed(() => {
//   if (selectedBroker.value?.brokerName === 'Dhan') {
//     return dhanPositionBook.value.map(position => position.unrealizedProfit + position.realizedProfit);
//   } else if (selectedBroker.value?.brokerName === 'Flattrade') {
//     return flatTradePositionBook.value.map(position => parseFloat(position.urmtom) + parseFloat(position.rpnl));
//   }
//   return [];
// });

const totalCapitalPercentage = computed(() => {
  const totalMoney = (availableBalance.value || 0) + (usedAmount.value || 0);
  return (totalProfit.value / totalMoney) * 100;
});

const deployedCapitalPercentage = computed(() => {
  const totalUsedAmount = usedAmount.value || 0;
  return totalUsedAmount ? (totalProfit.value / totalUsedAmount) * 100 : 0;
});

const totalBrokerage = computed(() => {
  if (selectedBroker.value?.brokerName === 'Dhan') {
    return dhanOrders.value.filter(order => order.orderStatus === 'TRADED').reduce((total) => total + 20, 0);
  } else if (selectedBroker.value?.brokerName === 'Flattrade') {
    return 0;
  }
  return 0;
});


const netPnl = computed(() => totalProfit.value - totalBrokerage.value);

// Lifecycle hooks
onMounted(async () => {
  await fetchBrokers()
    .then(() => updateExchangeSymbols())
    .then(() => setDefaultExchangeAndMasterSymbol())
    .then(() => fetchTradingData())
    .then(() => updateAvailableQuantities());

  window.addEventListener('keydown', handleHotKeys);

  // Initialize with the default active tab
  if (activeTab.value === 'positions') {
    if (selectedBroker.value?.brokerName === 'Flattrade') {
      fetchFlattradePositions();
      activeFetchFunction.value = 'fetchFlattradePositions';
    } else {
      fetchDhanPositions();
      activeFetchFunction.value = 'fetchDhanPositions';
    }
  } else if (activeTab.value === 'trades') {
    if (selectedBroker.value?.brokerName === 'Flattrade') {
      fetchFlattradeOrdersTradesBook();
      activeFetchFunction.value = 'fetchFlattradeOrdersTradesBook';
    } else {
      fetchDhanOrdersTradesBook();
      activeFetchFunction.value = 'fetchDhanOrdersTradesBook';
    }
  }
});

onBeforeUnmount(() => {
  window.removeEventListener('keydown', handleHotKeys);

});

// Watchers
watch(selectedBroker, (newBroker) => {
  if (newBroker) {
    selectedOrderType.value = orderTypes.value[0];
    previousOrderType.value = orderTypes.value[0];
    selectedProductType.value = getProductTypeValue(productTypes.value[1]); // Default to 'Margin' or 'M'
    fetchFundLimit();
    updateExchangeSymbols();
    setDefaultExchangeAndMasterSymbol();
    fetchTradingData();
  }
});

// Watcher for selectedExpiry to repopulate strike prices
watch(selectedExpiry, async (newExpiry) => {
  await fetchTradingData();
  updateStrikesForExpiry(newExpiry);
});

watch(selectedCallStrike, (newStrike, oldStrike) => {
  console.log('Selected Call Strike changed:', newStrike);
  if (newStrike !== oldStrike && !synchronizeOnLoad.value) {
    updateSecurityIds();
  }
});

watch(selectedPutStrike, (newStrike, oldStrike) => {
  console.log('Selected Put Strike changed:', newStrike);
  if (newStrike !== oldStrike && !synchronizeOnLoad.value) {
    updateSecurityIds();
  }
});

watch(selectedMasterSymbol, () => {
  updateAvailableQuantities();
});

// Watch productTypes to set the default selectedProductType
watch(productTypes, (newProductTypes) => {
  if (newProductTypes.length > 0) {
    selectedProductType.value = getProductTypeValue(newProductTypes[1]); // Default to 'Margin' or 'M'
  }
}, { immediate: true });

// Watch for changes in selectedExchange to update selectedMasterSymbol
watch(selectedExchange, (newExchange) => {
  if (exchangeSymbols.value[newExchange].length > 0) {
    selectedMasterSymbol.value = exchangeSymbols.value[newExchange][0];
  } else {
    selectedMasterSymbol.value = null;
  }
  updateAvailableQuantities();
});

watch(selectedOrderType, (newValue, oldValue) => {
  previousOrderType.value = oldValue;
});

const activeFetchFunction = ref(null);

watch(activeTab, () => {
  // Update activeFetchFunction based on the new broker
  if (activeTab.value === 'positions') {
    if (selectedBroker.value?.brokerName === 'Flattrade') {
      activeFetchFunction.value = 'fetchFlattradePositions';
      fetchFlattradePositions();
    } else {
      activeFetchFunction.value = 'fetchDhanPositions';
      fetchDhanPositions();
    }
  } else if (activeTab.value === 'trades') {
    if (selectedBroker.value?.brokerName === 'Flattrade') {
      activeFetchFunction.value = 'fetchFlattradeOrdersTradesBook';
      fetchFlattradeOrdersTradesBook();
    } else {
      activeFetchFunction.value = 'fetchDhanOrdersTradesBook';
      fetchDhanOrdersTradesBook();
    }
  }
});

</script>
