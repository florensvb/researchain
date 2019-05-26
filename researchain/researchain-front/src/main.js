import Vue from 'vue'
import './plugins/vuetify'
import App from './App.vue'
import VueRouter from 'vue-router';
import Web3 from 'web3';

const web3 = new Web3('ws://localhost:7545');
console.log(web3);

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
