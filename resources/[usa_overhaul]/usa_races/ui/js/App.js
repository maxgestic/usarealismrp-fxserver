const App = new Vue({
    el: "#app",
    data: {
        currentTab: 'Home',
        tabs: ['Home'],
        races: []
    },
    computed: {
        currentTabComponent: function () {
            return 'C' + this.currentTab
        }
    }
})