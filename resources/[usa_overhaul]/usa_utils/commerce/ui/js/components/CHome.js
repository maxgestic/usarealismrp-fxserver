const CHome = Vue.component("CHome", {
    template:
    `<div class="w3-main w3-content w3-padding w3-dark-grey" style="max-width:1200px;margin-top:100px">
        <!-- Item Grid-->
        <div class="w3-row-padding w3-padding-16 w3-center" id="food">
            <div class="w3-quarter">
                <div class="w3-card-4 w3-button" data-id="15" @click="purchase(15)">
                    <img src="https://static.thenounproject.com/png/693309-200.png" alt="Screenshots">
                    <div class="w3-container w3-center">
                        <p>Unlimited screenshots</p>
                    </div>
                </div>
            </div>
        </div>
    </div>`,
    methods: {
        purchase: function(id) {
            console.log("attempting purchase of item: " + id);
            $.post("http://usa_utils/purchase", JSON.stringify({
                id: id
            }))
        }
    }
})