const CNewRace = Vue.component("CNewRace", {
    template: 
    `
    <div id="new-race-wrap" class="background w3-display-container">
        <div class="w3-display-middle">
            <h3 class="dt-normal-text w3-margin">Host a new race</h3>
            <form>
                <div class="w3-group">
                    <input class="w3-input w3-margin new-race-input" type="text" name="title" placeholder="Race title" v-model="newRace.title">
                </div>
                <div class="w3-group">
                    <input class="w3-input w3-margin new-race-input" type="number" name="bet" placeholder="Betting amount" v-model="newRace.bet">
                </div>
                <div class="w3-group">
                    <input class="w3-input w3-margin new-race-input" type="number" name="time" placeholder="Minutes from now race should start" v-model="newRace.time">
                </div>
                <div class="w3-btn w3-margin dt-btn" @click="createRace()"><span>HOST RACE</span></div>
                <div class="w3-btn w3-margin dt-btn" @click="back()" style="background-color: red"><span>BACK</span></div>
            </form>
        </div>
    </div>
    `,
    props: [],
    data: function() {
        return {
            newRace: {
                title: "",
                bet: 0,
                time: 0
            }
        }
    },
    methods: {
        createRace: function() {
            $.post("http://usa_races/createRace", JSON.stringify({
                newRace: this.newRace
            }))
            App.currentTab = "Home"
        },
        back: function() {
            App.currentTab = "Home"
        }
    }
})