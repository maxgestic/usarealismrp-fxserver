import Vue from 'vue'
import App from './App'

Vue.config.productionTip = false

/* Routes */
import Phone from './components/apps/Phone'
const routes = [
  { path: '/phone', component: Phone }
]


const router = new VueRouter({
  routes // short for `routes: routes`
})

/* eslint-disable no-new */
/* Root Vue Instance */
new Vue({
  el: '#app',
  template: '<App/>',
  components: { App }
  router
  render: h => h(App)
})

$(function() {
  console.log("adding event listener")
  window.addEventListener('message', function(event) {
    console.log("handling message event")
      if (event.data.type == "enableui") {
        console.log("getting app element...");
        var appElement = document.getElementById("app");
        appElement.style.display = event.data.enable ? "block" : "none";
        /*
          if (event.data.enable) {
              phone.number = event.data.number;
              phone.owner = event.data.owner;
          }
          */
      } else if (event.data.type == "textMessage") {

      } else if (event.data.type == "messagesHaveLoaded") {
      } else if (event.data.type == "loadedContacts") {

      }
  });
});
