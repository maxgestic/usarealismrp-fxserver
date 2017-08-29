var disableMouseScroll = true

var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;

var cursor = document.getElementById("cursor");
var cursorX = documentWidth / 2;
var cursorY = documentHeight / 2;

function UpdateCursorPos() {
    cursor.style.left = cursorX;
    cursor.style.top = cursorY;
}

function Click(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
}

/* Set the width of the side navigation to 0 */
function closeNav() {
    document.getElementById("mySidenav").style.width = "0";
}

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            cursor.style.display = event.data.enable ? "block" : "none";
            document.body.style.display = event.data.enable ? "block" : "none";
            /* Set the width of the side navigation to 250px */
            document.getElementById("mySidenav").style.width = "250px";
            $("#player-name").text(event.data.playerName);
        } else if (event.data.type == "click") {
            // Avoid clicking the cursor itself, click 1px to the top/left;
            Click(cursorX - 1, cursorY - 1);
        }
    });

        $(document).mousemove(function(event) {
            if (disableMouseScroll == true) {
                cursorX = event.pageX;
                cursorY = event.pageY;
                UpdateCursorPos();
            }
        });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://test/escape', JSON.stringify({}));
            closeNav();
        }
    };

    $("#phone-btn").click(function(){
        $.post('http://test/showPhone', JSON.stringify({}));
        closeNav();
    });

});
