var voipOptions = ["Yell", "Normal", "Whisper"];

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

});
