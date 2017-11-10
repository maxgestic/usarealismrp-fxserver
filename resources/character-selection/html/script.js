var characters = [];

$(function() {
    window.addEventListener('message', function(event) {
        var event = event.data
        if (event.type == "toggleMenu") {
            // rename
            var menuStatus = event.menuStatus
            var menu = event.menu
            // show document
            document.body.style.display = menuStatus ? "block" : "none";
            // check menu type
            if (menu != "") {
                // show the menu
                $("#menu--" + menu + "").show();
                // populate the fields with character data if going to the home menu
                if (menu == "home") {
                    characters = event.data
                    populateHomeMenuCharacters();
                }
            }
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            closeMenus(); // reset html / lui nui focus
        }
    };

    <!-- ==== character selection hover effect ==== -->
    $(".columns").on('mouseover', '.char-card', function() {
        $(this).css("border", "1px solid red");
    });
    $(".columns").on('mouseleave', '.char-card', function() {
        $(this).css("border", "none");
    });
    <!-- ==== end character selection hover effect ==== -->

    <!-- ==== character selection ==== -->
    $(".columns").on('click', '.char-card', function() {
        var slot = $(this).data("slot");
        alert("selecting slot #" + slot + "!");
        $.post('http://character-selection/select-character', JSON.stringify({
            character: characters[slot],
            slot: slot
        }));
    });
    <!-- ==== end character selection ==== -->

    <!-- ==== new character creation form ==== -->
    $("#char--new-character-form").submit(function(e) {
        e.preventDefault(); // Prevent form from submitting

        alert("calling findOpenSlot !!");
        // returns a lua style index for the open slot (+1)
        var openSlot = findOpenSlot("js");

        var newCharData = {
            firstName: $("input[name='first-name']").val(),
            middleName: $("input[name='middle-name']").val(),
            lastName: $("input[name='last-name']").val(),
            dateOfBirth: $("input[name='date-of-birth']").val(),
            slot: findOpenSlot("lua")
        }

        alert("saving character in slot #" + openSlot);
        // subtract 1 for JS style index
        characters[openSlot] = newCharData;

        // call lua nui callback
        $.post('http://character-selection/new-character-submit', JSON.stringify(newCharData));

        // clear fields for next use
        $("input[name='first-name']").val("");
        $("input[name='middle-name']").val("");
        $("input[name='last-name']").val("");
        $("input[name='date-of-birth']").val("");

        // hide this form
        $("#menu--new-character").hide();
        // show the home menu html
        $("#menu--home").show();
        // fill the home menu with character info from the stored characters variable
        populateHomeMenuCharacters();

    });
    <!-- ==== end new character creation form ==== -->

});

function populateHomeMenuCharacters() {
    for (var x = 0; x < characters.length; ++x) {
        if (typeof (characters[x].firstName) != "undefined") {
            // determine which char class # to add to the character card (char-first, char-second, or char-third)
            var asideClasses = "char-card ";
            switch(x) {
                case 0:
                    asideClasses = asideClasses + "char-first";
                    break;
                case 1:
                    asideClasses = asideClasses + "char-second";
                    break;
                case 2:
                    asideClasses = asideClasses + "char-third";
                    break;
                default:
            }
            var html = "<aside data-slot='" + x + "' class='" + asideClasses + "'>" +
            "<header style='text-align:center;'>" +
            "<h4>Character # " + (x + 1) + "</h4>" +
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

function findOpenSlot(style) {
    alert("inside of findOpenSlot()");
    alert("characters.length = " + characters.length);
    var openSlot = 0;
    if (characters.length == 0) { // check if no chars first
        if (style == "js") { // javascript index style
            // do nothing
        } else {
            openSlot++; // lua index style
        }
        alert("findOpenSlot: returning openSlot = " + openSlot + " in [" + style + "] style.");
        return openSlot;
    } else { // player has characters, look for next empty slot
        for (var x = 0; x < characters.length; ++x) {
            alert("characters[x].firstName = " + characters[x].firstName);
            if (typeof (characters[x].firstName) == "undefined" || characters[x].firstName == null) {
                if (style == "js") {
                    openSlot = x;
                } else {
                    openSlot = x + 1;
                }
                alert("findOpenSlot: returning openSlot = " + openSlot + " in [" + style + "] style.");
                return openSlot;
            }
        }
    }
}

function closeMenus() {
    $("#menu--home").hide();
    $("#menu--new-character").hide();
    $(".columns").html("");
    $.post('http://character-selection/escape', JSON.stringify({})); // close lua nui focus
}
