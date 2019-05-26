import Vue from 'vue'
import './plugins/vuetify'
import App from './App.vue'
import VueRouter from 'vue-router';
import Web3 from 'web3';

const web3 = new Web3('ws://localhost:7545');
const abi = require('./ABIs/Papers.js').default;
const papersContract = new web3.eth.Contract(abi, 0xee52a37bEFf7cBD9E64bBc7E6cb7761284DB733a);
papersContract.methods.papers().call(0x720cC2afC99e3459534c66A389774c983d14a8a2).then(console.log);

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
