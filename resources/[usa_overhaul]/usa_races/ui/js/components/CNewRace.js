const CNewRace = Vue.component("CNewRace", {
    template: 
    `
    <div id="new-race-wrap" class="background w3-display-container">
        <div class="w3-display-middle">
            <h3 class="dt-normal-text w3-margin">Host a new race</h3>
            <form>
                <div class="w3-group">
                    <input class="w3-input w3-margin new-race-input" type="text" name="title" placeholder="Race title">
                </div>
                <div class="w3-group">
                    <input class="w3-input w3-margin new-race-input" type="number" name="bet" placeholder="Betting amount">
                </div>
                <div class="w3-group">
                    <input class="w3-input w3-margin new-race-input" type="number" name="time" placeholder="Minutes from now race should start">
                </div>
                <button class="w3-btn w3-margin" id="new-race-submit-btn" type="submit"><span>HOST RACE</span></button>
            </form>
        </div>
    </div>
    `,
    props: [],
    methods: {}
})