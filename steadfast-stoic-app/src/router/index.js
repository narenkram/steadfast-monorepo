import { createRouter, createWebHistory } from 'vue-router'
import TradeView from '../views/TradeView.vue'
import ManageBrokers from '../views/ManageBrokers.vue'
import AddBroker from '../views/AddBroker.vue'
import RedirectView from '../views/RedirectView.vue'; 


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'trade-view',
      component: TradeView
    },
    {
      path: '/manage-brokers',
      name: 'manage-brokers',
      component: ManageBrokers
    },
    {
      path: '/add-broker',
      name: 'add-broker',
      component: AddBroker
    },
    {
      path: '/redirect',
      component: RedirectView
    },
  ]
})
export default router

