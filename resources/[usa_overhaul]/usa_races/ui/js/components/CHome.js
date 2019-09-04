const CHome = Vue.component("CHome", {
    template: 
    `
    <div id="background" class="w3-padding w3-display-container">
        <span id="close-btn" class="w3-button w3-display-topright dt-normal-text" @click="close()">&times;</span>
        <section id="content" class="w3-display-container">
            <header>
                <h2>Browse all races</h2>
            </header>
            <div v-if="races.length <= 0">
                <h3 class="dt-normal-text">There are no races being hosted! Click the green plus below to host one!</h3>
            </div>
            <section class="grid-container">
                <div v-for="(race, index) in races" v-if="race" class="race w3-card w3-display-container">
                    <span v-if="race.host.source == myId" id="delete-race-btn" class="w3-button w3-display-topright" @click="deleteRace(race.host.source)">&times;</span>
                    <p class="race-title">{{race.title}}</p>
                    <img src="https://fazewp-fazemediainc.netdna-ssl.com/cms/wp-content/uploads/2014/12/streetracing_2.jpg" height="160px">
                    <p class="race-bet"><span>Bet Amount: $</span>{{race.bet}}</p>
                    <div style="height: 70px; align-content: center;">
                        <p>Host: {{race.host.name}}</p>
                        <p class="race-participants" v-if="race.participants.length > 0">Participants: <span v-for="participant in race.participants">({{participant.source}}) {{participant.name}}<span v-if="index != race.participants.length-1">, </span></span></p>
                        <p class="race-participants" v-else><small>Be the first to join!</small></p>
                    </div>
                    <button class="w3-btn w3-margin-top dt-btn" @click="joinRace(race.host.source)">Join Race</button>
                    <button v-if="isEnrolledInRace == race.host.source" class="w3-btn w3-margin-top race-leave" @click="leaveRace(race.host.source)">Leave Race</button>
                </div>
                <!-- <CNewRace :races="races"></CNewRace> -->
            </section>
            <!--
            <footer>
                <p>Note: You must reconnect to the server for your purchase to take affect.</p>
            </footer>
            -->
            <button id="new-race-btn" class="w3-button w3-circle w3-display-bottomleft w3-margin-left w3-margin-bottom">+</button>
        </section>
    </div>
    `,
    props: ["races", "myId", "isEnrolledInRace"],
    methods: {
        joinRace: function(host) {
            $.post("http://usa_races/joinRace", JSON.stringify({
                host: host
            }))
        },
        leaveRace: function(host) {
            $.post("http://usa_races/leaveRace", JSON.stringify({
                host: host
            }))
        },
        close: function() {
            $.post("http://usa_races/closeMenu", JSON.stringify({}))
        },
        deleteRace: function(host) {
            $.post("http://usa_races/deleteRace", JSON.stringify({
                host: host
            }))
        }
    }
})