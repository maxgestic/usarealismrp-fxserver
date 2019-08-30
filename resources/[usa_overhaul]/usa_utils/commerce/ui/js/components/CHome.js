const CHome = Vue.component("CHome", {
    template: 
    `
    <div id="background" class="w3-main w3-content w3-padding w3-light-grey">
        <div id="logo-container"><img src="https://fontmeme.com/permalink/190204/49bb075d378719bbd20b0040eef07af3.png" alt="USARRP"></div>
        <div class="items-container w3-row">
            <div class="item w3-half w3-container">
                <div class="item-content">
                    <p>ITEM NAME HERE</p>
                    <img src="" alt="">
                    <p>Description of the item here</p>
                    <button>BUY NOW</button>
                </div>
            </div>
            <div class="item w3-half w3-container">
                <div class="item-content">
                    <p>ITEM NAME HERE</p>
                    <img src="" alt="">
                    <p>Description of the item here</p>
                    <button>BUY NOW</button>
                </div>
            </div>
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