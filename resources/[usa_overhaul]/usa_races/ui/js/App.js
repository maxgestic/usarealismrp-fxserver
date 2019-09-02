const App = new Vue({
    el: "#app",
    data: {
        currentTab: 'Home',
        tabs: ['Home'],
        races: [
            /*
            {
                host: {
                    source: 1,
                    name: "test"
                },
                title: "Default Race Title",
                participants: [],
                bet: 420
            }
            */
        ],
        myId: -1
    },
    computed: {
        currentTabComponent: function () {
            return 'C' + this.currentTab
        }
    }
})