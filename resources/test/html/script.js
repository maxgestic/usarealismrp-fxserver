var policeActions = ["Cuff", "Drag", "Search", "MDT", "Place", "Unseat"];
var voipOptions = ["Yell", "Normal", "Whisper"];
var emoteOptions = ["Cop", "Sit", "Chair", "Kneel", "Medic", "Notepad","Traffic", "Photo","Clipboard", "Lean", "Hangout", "Pot", "Fish", "Phone", "Yoga", "Bino", "Cheer", "Statue", "Jog",
"Flex", "Sit up", "Push up", "Weld", "Mechanic","Smoke","Drink"];
var emoteItemsPerPage = 8;

var disableMouseScroll = true;

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

function inventoryBackBtn() {
    $(".sidenav .inventory-item").remove();
    // initiliaze home menu
    // show interaction menu items
    $(".sidenav a").show();
}

function voipBackBtn() {
    $(".sidenav .voip-option").remove();
    // initiliaze home menu
    // show interaction menu items
    $(".sidenav a").show();
}

function emotePageBackBtn() {
    $(".sidenav .emote-page-option").remove();
    // initiliaze home menu
    // show interaction menu items
    $(".sidenav a").show();
}

function emoteBackBtn() {
    $(".sidenav .emote-option").remove();
    $(".sidenav .emote-page-option").show();
}

function playEmote(emoteNumber) {
    $(".sidenav .emote-option").remove();
    $(".sidenav .emote-page-option").remove();
    if (typeof emoteNumber == "undefined") {
        emoteNumber = "Cancel";
    }
    $.post('http://test/playEmote', JSON.stringify({
        emoteNumber: emoteNumber
    }));
    closeNav();
}

function openEmotePage(pageNumber) {
    $(".sidenav a").hide();
    // Cancel Emote btn
    $(".sidenav").append("<a onclick='playEmote()' class='emote-option'>Cancel Emote</a>");
    // emotes
    if (pageNumber == "1") {
        for(var x = 0; x < emoteItemsPerPage; x++) {
            $(".sidenav").append("<a onclick='playEmote("+(x)+")' class='emote-option'>"+emoteOptions[x]+"</a>");
        }
    } else if (pageNumber == "2") {
        for(var y = emoteItemsPerPage; y < (emoteItemsPerPage*2); y++) {
            $(".sidenav").append("<a onclick='playEmote("+(y)+")' class='emote-option'>"+emoteOptions[y]+"</a>");
        }
    } else if (pageNumber == "3") {
        for(var z = (emoteItemsPerPage*2); z < (emoteItemsPerPage*3); z++) {
            $(".sidenav").append("<a onclick='playEmote("+(z)+")' class='emote-option'>"+emoteOptions[z]+"</a>");
        }
    } else if (pageNumber == "4") {
        for(var z = (emoteItemsPerPage*3); z < (emoteItemsPerPage*4); z++) {
            if (typeof emoteOptions[z] != "undefined") {
                $(".sidenav").append("<a onclick='playEmote("+(z)+")' class='emote-option'>"+emoteOptions[z]+"</a>");
            }
        }
    }
    //back btn
    $(".sidenav").append("<a onclick='emoteBackBtn()' id='emote-back-btn' class='emote-option'>Back</a>");
}

function openEmoteMenu() {
    $(".sidenav a").hide();
    var size = emoteOptions.length;
    var pageCount = Math.ceil(size / emoteItemsPerPage);
    // Cancel Emote btn
    $(".sidenav").append("<a onclick='playEmote()' class='emote-page-option'>Cancel Emote</a>");
    // emote pages
    for(var x = 0; x < pageCount; x++) {
        $(".sidenav").append("<a onclick='openEmotePage("+(x+1)+")' class='emote-page-option'>Emotes "+(x+1)+"</a>");
    }
    // back btn
    $(".sidenav").append("<a onclick='emotePageBackBtn()' id='emote-page-back-btn' class='emote-page-option'>Back</a>");
}

function openVoipMenu() {
    $(".sidenav a").hide();
    for(i in voipOptions) {
        $(".sidenav").append("<a onclick='setVoip("+i+")' class='voip-option'>" + voipOptions[i] + "</a>");
    }
    // back btn
    $(".sidenav").append("<a onclick='voipBackBtn()' id='voip-back-btn' class='voip-option'>Back</a>");
}

function setVoip(option) {
    $.post('http://test/setVoipLevel', JSON.stringify({
        level: option
    }));

    closeNav();
}

function performPoliceAction(policeActionIndex) {
    $.post('http://test/performPoliceAction', JSON.stringify({
        policeActionIndex: policeActionIndex
    }));
    closeNav();
}

function showPoliceActions() {
    $(".sidenav a").hide();
    for (i in policeActions) {
        $(".sidenav").append("<a onclick='performPoliceAction("+i+")' class='police-action'>" + policeActions[i] + "</a>");
    }
}

function populateInventory(inventory, weapons, licenses) {
    $(".sidenav a").hide();
    for(i in licenses) {
        var licenseName = licenses[i].name;
        $(".sidenav").append("<a class='inventory-item'>" + licenseName + "</a>");
    }
    for(i in inventory) {
        var inventoryItemName = inventory[i].name;
        $(".sidenav").append("<a class='inventory-item'>" + inventoryItemName + "</a>");
    }
    for(i in weapons) {
        var weaponName = weapons[i].name;
        $(".sidenav").append("<a class='inventory-item'>" + weaponName + "</a>");
    }
    // back btn
    $(".sidenav").append("<a onclick='inventoryBackBtn()' id='inventory-back-btn' class='inventory-item'>Back</a>");
}

/* Set the width of the side navigation to 0 */
function closeNav() {
    $(".sidenav .inventory-item").remove();
    $(".sidenav .voip-option").remove();
    $(".sidenav .emote-option").remove();
    $(".sidenav .emote-page-option").remove();
    $(".sidenav .emote-option").remove();
    $(".sidenav .emote-option").remove();
    $(".sidenav .police-action").remove();
    $("#police-btn").remove();
    document.getElementById("mySidenav").style.width = "0";
}

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            cursor.style.display = event.data.enable ? "block" : "none";
            document.body.style.display = event.data.enable ? "block" : "none";
            /* Set the width of the side navigation to 250px */
            document.getElementById("mySidenav").style.width = "350px";
            // show interaction menu items
            $(".sidenav a").show();
            // show targetted player name
            //$("#player-name").html(event.data.playerName);
            /*
            if (event.data.enable) {
                $.post('http://test/checkPlayerJob', JSON.stringify({}));
            }
            */
        } else if (event.data.type == "click") {
            // Avoid clicking the cursor itself, click 1px to the top/left;
            Click(cursorX - 1, cursorY - 1);
        } else if (event.data.type == "inventoryLoaded") {
            var inventory = event.data.inventory;
            var weapons = event.data.weapons;
            var licenses = event.data.licenses;
            //alert("inventory.length = " + inventory.length);
            //alert("weapons.length = " + weapons.length);
            //alert("licenses.length = " + licenses.length);
            populateInventory(inventory, weapons, licenses);
        } else if (event.data.type == "receivedPlayerJob") {
            var job = event.data.job;
            //alert("job = " + job);

            if (job == "sheriff") {
                $("#mySidenav").prepend("<a onclick='showPoliceActions()' id='police-btn'>Police Actions</a>");
            } else if (job == "ems") {
                $("#ems-btn").show();
            } else if (job == "taxi") {
                $("#taxi-btn").show();
            } else if (job == "tow") {
                $("#tow-btn").show();
            }

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

    $("#inventory-btn").click(function(){
        $.post('http://test/loadInventory', JSON.stringify({}));
    });

    $("#close-btn").click(function(){
        $.post('http://test/escape', JSON.stringify({}));
        closeNav();
    });

    $("#voip-btn").click(function(){
        openVoipMenu();
    });

    $("#emotes-btn").click(function(){
        openEmoteMenu();
    });

});
