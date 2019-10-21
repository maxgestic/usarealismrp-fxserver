const App = new Vue({
    el: "#app",
    data: {
        currentTab: 'Home',
        tabs: ['Home']
    },
    computed: {
        currentTabComponent: function () {
            return 'C' + this.currentTab
        }
    }
})