var characters = [{},{},{}];

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
    $("#menu--home .columns").on('click', '.char-card', function() {
        var slot = $(this).data("slot");
        //alert("selecting slot #" + slot + "!");
        $.post('http://character-selection/select-character', JSON.stringify({
            character: characters[slot],
            slot: slot
        }));
    });
    <!-- ==== end character selection ==== -->

    <!-- ==== new character selection ==== -->
    $(".columns").on('click', '.char--create-char-card', function() {
        $("#menu--home").hide();
        $("#menu--new-character").show();
        $(".columns").html("");
    });
    <!-- ==== end new character selection ==== -->

    <!-- ==== character deletion ==== -->
    $("#menu--delete-character .columns").on('click', '.char-card', function() {
        var confirmed = confirm("Are you sure you want to permanently delete that character?");
        if (confirmed) {
            var slot = $(this).data("slot");
            alert("deleting char at slot #" + slot);
            for (var i = 0; i < characters.length; ++i) {
                alert("characters at " + i + " name = " + characters[i].firstName);
            }
            characters[slot] = {};
            alert("just finished setting characters[slot] = {}...");
            for (var i = 0; i < characters.length; ++i) {
                alert("characters at " + i + " name = " + characters[i].firstName);
            }
            $.post('http://character-selection/delete-character', JSON.stringify({
                slot: slot
            }));
            // send to homepage
            $("#menu--delete-character .columns").html("");
            $("#menu--delete-character").hide();
            $("#menu--home").show();
            populateHomeMenuCharacters();
        }
    });
    <!-- ==== end character deletion ==== -->

    $("#char--new-character-form").on('click', "button[type='button']", function() {
        $("#menu--new-character").hide();
        $("#menu--home").show();
        populateHomeMenuCharacters();
    });

    <!-- ==== new character creation form ==== -->
    $("#char--new-character-form").submit(function(e) {
        e.preventDefault(); // Prevent form from submitting

        //alert("calling findOpenSlot !!");
        // returns a lua style index for the open slot (+1)
        var openSlot = findOpenSlot("js");
        //alert("lua open slot = " + findOpenSlot("lua"));

        var newCharData = {
            firstName: $("input[name='first-name']").val(),
            middleName: $("input[name='middle-name']").val(),
            lastName: $("input[name='last-name']").val(),
            dateOfBirth: $("input[name='date-of-birth']").val(),
            slot: findOpenSlot("lua"),
            active: false
        }

        //alert("saving JS character in array at slot #" + openSlot);
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

    <!-- ==== character deletion ==== -->
    $(".buttons").on('click', '#home--delete-button', function() {
        $("#menu--home .columns").html("");
        $("#menu--home").hide();
        $("#menu--delete-character").show();
        populateDeleteCharacterPage();
    });

    $(".buttons").on('click', '#delete-character--back-button', function() {
        $("#menu--delete-character .columns").html("");
        $("#menu--delete-character").hide();
        $("#menu--home").show();
        populateHomeMenuCharacters();
    });
    <!-- ==== end character deletion ==== -->

});

function populateDeleteCharacterPage() {
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
            "<li><b>Name:</b> " + characters[x].firstName + " " + characters[x].middleName + " " + characters[x].lastName + "</li>" +
            "<li><b>DOB:</b> " + characters[x].dateOfBirth + "</li>" +
            "<li><b>Money:</b> $" + parseFloat(characters[x].money).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,') + " </li>" +
            "<li><b>Bank:</b> $" + parseFloat(characters[x].bank).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,') + "</li>" +
            "</ul>" +
            "</section>" +
            "</aside>"
            $("#menu--delete-character .columns").append(html);
        }
    }
}

function populateHomeMenuCharacters() {
    var less_than_three_characters = false;
    var empty_char_index = 0;
    var first = false;
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
            "<li><b>Name:</b> " + characters[x].firstName + " " + characters[x].middleName + " " + characters[x].lastName + "</li>" +
            "<li><b>DOB:</b> " + characters[x].dateOfBirth + "</li>" +
            "<li><b>Money:</b> $" + parseFloat(characters[x].money).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,') + " </li>" +
            "<li><b>Bank:</b> $" + parseFloat(characters[x].bank).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,') + "</li>" +
            "</ul>" +
            "</section>" +
            "</aside>"
            $("#menu--home .columns").append(html);
        } else {
            alert("setting empty char index to: " + empty_char_index);
            if (!first) {
                // pending new char button
                less_than_three_characters = true;
                empty_char_index = x;
                first = true;
            }
        }
    }
    // append new char button
    if (less_than_three_characters) {
        alert("user has less than 3 charactes, adding the new char button!")
        var asideClasses = "";
        switch(empty_char_index) {
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
        // todo: when this char card is clicked, trigger the create new char buttn in this slot #
        var html = "<aside data-slot='" + x + "' class='" + asideClasses + " char--create-char-card'>" +
        "<header style='text-align:center;'>" +
        "<h4>Character # " + (empty_char_index + 1) + "</h4>" +
        "</header>" +
        "<section>" +
        "<span style='font-size:24px;'><b>+</b></span>" +
        "</section>" +
        "</aside>"
        $("#menu--home .columns").append(html);
    }
}

function findOpenSlot(style) {
    //alert("inside of findOpenSlot()");
    //alert("characters.length = " + characters.length);
    var openSlot = 0;
    if (characters.length == 0) { // check if no chars first
        if (style == "js") { // javascript index style
            // do nothing
        } else {
            openSlot++; // lua index style
        }
        //alert("findOpenSlot: returning openSlot = " + openSlot + " in [" + style + "] style.");
        return openSlot;
    } else { // player has characters, look for next empty slot
        for (var x = 0; x < characters.length; ++x) {
            //alert("characters[x].firstName = " + characters[x].firstName);
            if (typeof (characters[x].firstName) == "undefined" || characters[x].firstName == null) {
                if (style == "js") {
                    openSlot = x;
                } else {
                    openSlot = x + 1;
                }
                //alert("findOpenSlot: returning openSlot = " + openSlot + " in [" + style + "] style.");
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
