document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function(event) {
            let msg = event.data
            if (msg.type == "toggle") { // show / hide
                document.body.style.display = msg.doOpen ? "block" : "none";
                if (msg.doOpen) {
                    App.races = msg.races
                    App.myId = msg.myId
                }
            }
        })
    }
}

document.onkeydown = function (data) {
    if (data.which == 27 || data.which == 112) { // ESC or F1
        $.post('http://usa_races/closeMenu', JSON.stringify({}))
    }
}