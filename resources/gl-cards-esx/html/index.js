$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        var cardSrc = item.cardSrc;
        
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
                
                document.getElementById("card-displayed-image").src = cardSrc.back
                setTimeout(() => {  document.getElementById("card-displayed-image").src = cardSrc.front }, 2000);
                setTimeout(() => {  $.post('http://gl-cards/main', JSON.stringify({}));return;}, 6000);

            } else {
                display(false)
            }
        } else {
            display(true)
            document.getElementById("card-displayed-image").src = `images/${cardSrc.front}`
            document.getElementById("card-back-image").src = `images/${cardSrc.back}`
        }

    })

    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://gl-cards-esx/exit', JSON.stringify({}));
            return
        }
    };

    $("#card").flip();

})