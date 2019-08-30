const CHome = Vue.component("CHome", {
    template: 
    `
    <div id="background" class="w3-main w3-content w3-padding w3-display-container">
        <span id="close-btn" class="w3-button w3-display-topright" @click="close()">&times;</span>
        <div id="logo-container">
            <img src="https://fontmeme.com/permalink/190204/49bb075d378719bbd20b0040eef07af3.png" alt="USARRP">
        </div>
        <section class="grid-container">
            <div v-for="item in items" class="item w3-card">
                <p>{{item.name}}</p>
                <img v-bind:src="item.img" v-bind:alt="item.name" height="160px">
                <p class="item-price"><span>€</span>{{item.price}}</p>
                <div style="height: 70px; align-content: center;">
                    <p class="item-description">{{item.description}}</p>
                </div>
                <button class="w3-btn w3-green" @click="purchase(item.sku)">Buy Now</button>
            </div>
        </section>
        <footer>
            <p>Note: You must reconnect to the server for your purchase to take affect.</p>
        </footer>
    </div>
    `,
    data: function() {
        return {
            items: [
                {
                    name: "Unlimited Screenshots",
                    img: "https://www.rawshorts.com/freeicons/wp-content/uploads/2017/01/media-pict-camera.png",
                    description: "One time purchase for unlimited access to the /screenshot command! Use it whenever, forever!",
                    price: 5,
                    sku: 15
                },
                {
                    name: "Premium Walkstyle Pack",
                    img: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIJ1oLZJ0bs2dx90UKs-57kTBc51qXYFi8ZfR5K9q14arMF90-Ew",
                    description: "Want to upgrade your swagger? Get 10+ premium walk styles with this one time purchase.",
                    price: 5,
                    sku: 16
                }
                
            ]
        }
    },
    methods: {
        purchase: function(id) {
            console.log("attempting purchase of item: " + id);
            $.post("http://usa_utils/purchase", JSON.stringify({
                id: id
            }))
        },
        close: function() {
            $.post("http://usa_utils/closeStore", JSON.stringify({}))
        }
    }
})