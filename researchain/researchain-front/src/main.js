import dotenv from 'dotenv';
dotenv.config();
import Vue from 'vue'
import './plugins/vuetify'
import App from './App.vue'
import VueRouter from 'vue-router';
import Web3 from 'web3';
import * as ipfsClient from 'ipfs-http-client';

// connect to ipfs daemon API server
const ipfs = ipfsClient(process.env.VUE_APP_IPFS_ADDRESS, '5001', { protocol: 'http' }); // leaving out the arguments will default to these values
Vue.prototype.ipfs = ipfs;

// connect to blockchain via web3
const web3 = new Web3('ws://localhost:7545');
web3.defaultAccount = process.env.VUE_APP_ACCOUNT;
web3.defaultGas = 900000;
const abi = require('./ABIs/Papers.js').default;
const papersContract = new web3.eth.Contract(abi, process.env.VUE_APP_ADDRESS);
papersContract.options.address = process.env.VUE_APP_ADDRESS;
Vue.prototype.papers = papersContract;

Vue.use(VueRouter);

Vue.config.productionTip = false;

const routes = [
  { path: '/', component: require('./components/LandingPage').default },
  { path: '/shop', component: require('./components/Shop').default },
];

const router = new VueRouter({
  routes,
});

new Vue({
  router,
  render: h => h(App),
}).$mount('#app');
