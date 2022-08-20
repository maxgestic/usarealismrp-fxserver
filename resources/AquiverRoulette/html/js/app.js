Vue.config.productionTip = false;
Vue.config.devtools = false;

const app = new Vue({
    el: "#app",
    data: {
        opened: false,

        statusmessage: '',
        chipsAmount: '',
        roundBets: '',
        timeLeft: '',
        betInput: '',

        logs: [],
        maxlogs: 1,

        show: true
    },
    mounted: function () { },
    computed: {},
    watch: {
        logOpened() {
            this.SelectEffect();
        },
        opened(state) {
            if (!state) this.show = true;
        },
        show() {
            this.SelectEffect();
        }
    },
    methods: {
        HoverEffect() {
            this.PlaySound('hover.mp3');
        },
        SelectEffect() {
            this.PlaySound('select.mp3');
        },
        PlaySound(sound, volume) {
            new Howl({
                src: [`sounds/${sound}`],
                autoplay: true,
                loop: false,
                volume: volume ? volume : 0.025,
            });
        }
    },
    template: "#app",
});

window.addEventListener("message", (event) => {
    if (event.data.action == 'PlaySound') {
        app.PlaySound(event.data.sound, event.data.volume);
    }
    else if (event.data.action == "setvar") {
        let variable = event.data.variable;
        let value = event.data.value;

        app[variable] = value;
    }
    else if (event.data.action == "pushlog") {
        app.logs.unshift(event.data.log);

        if (app.logs.length > app.maxlogs) {
            app.logs.splice(app.logs.length - 1, 1);
        }
    }
    else if (event.data.action == "showstate") {
        app.show = !app.show;
    }
});