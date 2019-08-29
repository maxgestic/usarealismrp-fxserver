const CHome = Vue.component("CHome", {
    template: 
    `
    <div id="background" class="w3-main w3-content w3-padding w3-light-grey">
        <div id="logo-container"><img src="https://fontmeme.com/permalink/190204/49bb075d378719bbd20b0040eef07af3.png" alt="USARRP"></div>
        <div class="grid-container">
            <div class="item1">1</div>
            <div class="item2">2</div>
            <div class="item3">3</div>  
            <div class="item4">4</div>
            <div class="item5">5</div>
            <div class="item6">6</div>
            <div class="item7">7</div>
            <div class="item8">8</div>
        </div>
    </div>
    `,
    methods: {
        purchase: function(id) {
            console.log("attempting purchase of item: " + id);
            $.post("http://usa_utils/purchase", JSON.stringify({
                id: id
            }))
        }
    }
})

/*
<!-- Item Grid
        <div class="w3-row-padding w3-padding-16 w3-center" id="food">
            <div class="w3-quarter">
                <div class="w3-card-4 w3-btn" data-id="15" @click="purchase(15)">
                    <img src="https://static.thenounproject.com/png/693309-200.png" alt="Screenshots">
                    <div class="w3-container w3-center">
                        <p>Unlimited screenshots</p>
                    </div>
                </div>
            </div>
        </div>
        -->
        */