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

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            cursor.style.display = event.data.enable ? "block" : "none";
            document.body.style.display = event.data.enable ? "block" : "none";
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
            $.post('http://jail/escape', JSON.stringify({}));
            disableMouseScroll = true
            $("#cursor").show();
            $("#jail-form-wrap").show();
            $("#chargesWrap").hide();
        } else if (data.which == 8) { // BACKSPACE
            disableMouseScroll = true
            $("#jail-form-wrap").show();
            $("#chargesWrap").hide();
            $("#cursor").show();
        }
    };

    $("#jail-form").submit(function(e) {
        e.preventDefault(); // Prevent form from submitting

        $.post('http://jail/submit', JSON.stringify({
            id: $("#id").val(),
            sentence: $("#sentence").val(),
            charges: $("#charges").val()
        }));

        $("#id").val("");
        $("#name").val("");
        $("#sentence").val("");
        $("#charges").val("");
        $("#medications").val("");
        $("#disorders").val("");

    });

    // show list of criminal/vehicle/hs codes
    $("#chargesList").click(function(){
        $("#jail-form-wrap").hide();
        $("#chargesWrap").show();
        disableMouseScroll = false
        $("#cursor").hide();
    });

});
