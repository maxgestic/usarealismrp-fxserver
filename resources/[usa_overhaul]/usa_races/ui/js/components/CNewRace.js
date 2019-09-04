const CNewRace = Vue.component("CNewRace", {
    template: 
    `
    <div class="race w3-card">
        <p class="race-title">HOST NEW RACE</p>
        <img src="https://fazewp-fazemediainc.netdna-ssl.com/cms/wp-content/uploads/2014/12/streetracing_2.jpg" height="160px">
        <p class="race-bet"><span></span></p>
        <div style="height: 70px; align-content: center;">
            <p class="race-participants" v-else><small>Host a race that will start where you are now!</small></p>
        </div>
        <button class="w3-btn w3-green w3-margin-top" @click="joinRace(race.host.source)">HOST RACE</button>
    </div>
    `,
    props: ["races"],
    methods: {
        createRace: function() {
            
        }
    }
})