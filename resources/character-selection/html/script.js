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

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "toggleMenu") {
            cursor.style.display = event.data.menuStatus ? "block" : "none";
            document.body.style.display = event.data.menuStatus ? "block" : "none";
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
            $.post('http://character-selection/escape', JSON.stringify({}));
        }
    };

});
