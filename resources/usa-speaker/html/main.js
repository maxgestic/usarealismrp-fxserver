let speakerId = null

$(function() {
    /* To talk with LUA */
    window.addEventListener('message', function(event) {
        if (event.data.type == "toggle") {
            /* Display */
            let mainAppDiv = document.querySelector("main");
            if (mainAppDiv.style.display == "flex") {
                mainAppDiv.style.display = "none";
            } else {
                mainAppDiv.style.display = "flex";
                speakerId = event.data.speakerId
            }
        }
    });
    
    /* Close Menu */
    document.onkeydown = function(data) {
        if (data.which == 27) { // Escape key
            close();
        }
    };

    function close() {
        let mainAppDiv = document.querySelector("main");
        mainAppDiv.style.display = "none";
        $.post('http://usa-speaker/close', JSON.stringify({}));
    }

    $("#play").click(function(){
        let dist = $("#distance").val()

        if (!Number.isInteger(parseInt(dist))) {
            $("#distance").effect("shake")
            return
        }

        if (parseInt(dist) > 50) {
            $("#distance").effect("shake")
            return
        }

        $.post('http://usa-speaker/play', JSON.stringify({
            id: speakerId,
            url: $("#url").val(),
            distance: $("#distance").val()
        }));
        close();
    });

    $("#stop").click(function(){
        $.post('http://usa-speaker/stop', JSON.stringify({
            id: speakerId
        }));
        close();
    });

    $("#pickUp").click(function(){
        $.post('http://usa-speaker/pickUp', JSON.stringify({
            id: speakerId
        }));
        close();
    });

    $("#close").click(function(){
        close();
    });
});