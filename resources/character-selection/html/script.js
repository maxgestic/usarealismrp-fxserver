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
            // rename
            var menuStatus = event.data.menuStatus
            var menu = event.data.menu
            // show document
            document.body.style.display = menuStatus ? "block" : "none";
            // check menu type
            if (menu != "") {
                // show the menu
                $("#menu--" + menu + "").show();
                // populate the fields with character data if going to the home menu
                if (menu == "home") {
                    var characters = event.data.data
                    for (var x = 0; x < characters.length; ++x) {
                        if (characters[x].firstName != "undefined") {
                            //alert("character name = " + characters[x].firstName);
                            var html = "<aside class='char-card char-first'>" +
                            "<header style='text-align:center;'>" +
                            "<h4>Character #1</h4>" +
                            "</header>" +
                            "<section>" +
                            "<ul>" +
                            "<li>Name: " + characters[x].firstName + " " + characters[x].middleName + " " + characters[x].lastName + "</li>" +
                            "<li>DOB: " + characters[x].dateOfBirth + "</li>" +
                            "<li>Money: </li>" +
                            "<li>Bank: </li>" +
                            "</ul>" +
                            "</section>" +
                            "</aside>"
                            $(".columns").append(html);
                        }
                    }
                }
            }
        } /* else if (event.data.type == "click") {
            // Avoid clicking the cursor image itself, click 1px to the top/left;
            //Click(cursorX - 1, cursorY - 1);
        } */
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://character-selection/escape', JSON.stringify({}));
        }
    };

    $(".char-card").hover(function(){
        $(this).css("border", "1px solid red");
    }, function() {
        $(this).css("border", "none");
    });

    $("#char--new-character-form").submit(function(e) {
        e.preventDefault(); // Prevent form from submitting

        // call lua nui callback
        $.post('http://character-selection/new-character-submit', JSON.stringify({
            firstName: $("input[name='first-name']").val(),
            middleName: $("input[name='middle-name']").val(),
            lastName: $("input[name='last-name']").val(),
            dateOfBirth: $("input[name='date-of-birth']").val()
        }));

        // clear fields for next use
        $("input[name='first-name']").val("");
        $("input[name='middle-name']").val("");
        $("input[name='last-name']").val("");
        $("input[name='date-of-birth']").val("");

    });

});
