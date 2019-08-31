const CHome = Vue.component("CHome", {
    template: 
    `
    <div id="background" class="w3-main w3-content w3-padding w3-display-container">
        <span id="close-btn" class="w3-button w3-display-topright" @click="close()">&times;</span>
        <header>
        RACES
        </header>
        <section class="grid-container">
            <div v-for="race in races" class="race w3-card">
                <p>{{race.title}}</p>
                <img src="https://fazewp-fazemediainc.netdna-ssl.com/cms/wp-content/uploads/2014/12/streetracing_2.jpg" height="160px">
                <p class="race-bet"><span>Bet Amount:</span> {{race.bet}}</p>
                <div style="height: 70px; align-content: center;">
                    <p class="race-description"><span v-for="participant in race.participants">{{participant.name}},</span></p>
                </div>
                <button class="w3-btn w3-green" @click="joinRace(race.host)">Join Race</button>
            </div>
        </section>
        <!--
        <footer>
            <p>Note: You must reconnect to the server for your purchase to take affect.</p>
        </footer>
        -->
    </div>
    `,
    props: ["races"],
    methods: {
        joinRace: function(host) {
            $.post("http://usa_races/joinRace", JSON.stringify({
                host: host
            }))
        },
        close: function() {
            $.post("http://usa_races/closeMenu", JSON.stringify({}))
        }
    }
})