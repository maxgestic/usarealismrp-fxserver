document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function(event) {
            let msg = event.data
            if (msg.type == "toggle") { // show / hide
                document.body.style.display = msg.doOpen ? "block" : "none";
            }
        })
    }
}

document.onkeydown = function (data) {
    if (data.which == 27 || data.which == 112) { // ESC or F1
        $.post('http://usa_utils/closeStore', JSON.stringify({}))
    }
}
