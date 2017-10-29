var policeActions = ["Cuff", "Drag", "Search", "MDT", "Place", "Unseat", "Impound"];
var voipOptions = ["Yell", "Normal", "Whisper"];
var emoteOptions = ["Cop", "Sit", "Chair", "Kneel", "Medic", "Notepad","Traffic", "Photo","Clipboard", "Lean", "Hangout", "Pot", "Fish", "Phone", "Yoga", "Bino", "Cheer", "Statue", "Jog",
"Flex", "Sit up", "Push up", "Weld", "Mechanic","Smoke","Drink", "Bum 1", "Bum 2", "Bum 3", "Drill", "Blower", "Chillin'", "Mobile Film", "Planting", "Golf", "Hammer", "Clean", "Musician", "Party", "Prostitute"];
var emoteItemsPerPage = 8;
var playerInventory;
var playerWeapons;
var playerLicenses;
var targetPlayerId = 0;
var targetPlayerName = "";
var currentPlayerJob = "civ";

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
    $(".player-meta-data").show();
}

function emotePageBackBtn() {
    $(".sidenav .emote-page-option").remove();
    // initiliaze home menu
    // show interaction menu items
    $(".sidenav a").show();
    $(".player-meta-data").show();
}

function emoteBackBtn() {
    $(".sidenav .emote-option").remove();
    $(".sidenav .emote-page-option").show();
    $(".player-meta-data").hide();
}

function playEmote(emoteNumber) {
    var emoteName = emoteOptions[emoteNumber];
    //alert("playing emote: " + emoteName);
    // hide emote-option btns
    $(".sidenav .emote-option").remove();
    $(".sidenav .emote-page-option").remove();
    // trigger playEmote callback
    if (typeof emoteName == "undefined") {
        emoteName = "cancel";
    }
    $.post('http://test/playEmote', JSON.stringify({
        emoteName: emoteName.toLowerCase()
    }));
    closeNav();
}

function openEmotePage(pageNumber) {
    $(".sidenav a").hide();
    $(".player-meta-data").hide();
    // Cancel Emote btn
    $(".sidenav").append("<a onclick='playEmote()' class='emote-option'>Cancel Emote</a>");
    // emotes
    if (pageNumber == "1") {
        for(var x = 0; x < emoteItemsPerPage; x++) {
            $(".sidenav").append("<a onclick='playEmote("+(x)+")' class='emote-option'>"+emoteOptions[x]+"</a>");
        }
    } else if (pageNumber == "2") {
        for(var y = emoteItemsPerPage; y < (emoteItemsPerPage*pageNumber); y++) {
            $(".sidenav").append("<a onclick='playEmote("+(y)+")' class='emote-option'>"+emoteOptions[y]+"</a>");
        }
    } else if (pageNumber == "3") {
        for(var z = (emoteItemsPerPage*2); z < (emoteItemsPerPage*pageNumber); z++) {
            $(".sidenav").append("<a onclick='playEmote("+(z)+")' class='emote-option'>"+emoteOptions[z]+"</a>");
        }
    } else if (pageNumber == "4") {
        for(var z = (emoteItemsPerPage*3); z < (emoteItemsPerPage*pageNumber); z++) {
            if (typeof emoteOptions[z] != "undefined") {
                $(".sidenav").append("<a onclick='playEmote("+(z)+")' class='emote-option'>"+emoteOptions[z]+"</a>");
            }
        }
    } else if (pageNumber == "5") {
        for(var z = (emoteItemsPerPage*4); z < (emoteItemsPerPage*pageNumber); z++) {
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
    if (policeActionIndex == "front left" || policeActionIndex == "front right" || policeActionIndex == "back left" || policeActionIndex == "back right") {
        var seat = policeActionIndex;
        $.post('http://test/performPoliceAction', JSON.stringify({
            policeActionIndex: 0,
            policeActionName: "Unseat",
            unseatIndex: seat
        }));
    } else {
        $.post('http://test/performPoliceAction', JSON.stringify({
            policeActionIndex: policeActionIndex,
            policeActionName: policeActions[policeActionIndex],
            unseatIndex: ""
        }));
    }
    closeNav();
}

function showVehicleUnseatOptions() {
    $(".sidenav a").hide();
    $(".sidenav .sidenav-buttons").append("<a onclick='performPoliceAction(\"front left\")' class='police-action'>Front Left</a>");
    $(".sidenav .sidenav-buttons").append("<a onclick='performPoliceAction(\"front right\")' class='police-action'>Front Right</a>");
    $(".sidenav .sidenav-buttons").append("<a onclick='performPoliceAction(\"back left\")' class='police-action'>Back Left</a>");
    $(".sidenav .sidenav-buttons").append("<a onclick='performPoliceAction(\"back right\")' class='police-action'>Back Right</a>");
}

function showPoliceActions() {
    $(".sidenav a").hide();
    $(".player-meta-data").hide();
    for (i in policeActions) {
        if (policeActions[i] == "Unseat") {
            $(".sidenav .sidenav-buttons").append("<a onclick='showVehicleUnseatOptions()' class='police-action'>" + policeActions[i] + "</a>");
        } else {
            $(".sidenav .sidenav-buttons").append("<a onclick='performPoliceAction("+i+")' class='police-action'>" + policeActions[i] + "</a>");
        }
    }
}

function populateInventory(inventory, weapons, licenses) {
    $(".sidenav a").hide();
    for(i in licenses) {
        var licenseName = licenses[i].name;
        $(".sidenav").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x1)</span> " + licenseName + "</a>");
    }
    for(i in inventory) {
        var inventoryItemName = inventory[i].name;
        var inventoryItemQuantity = inventory[i].quantity;
        var inventoryItemLegality = inventory[i].legality;
        if (inventoryItemLegality == "illegal")
            $(".sidenav").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x"+inventoryItemQuantity+")</span> <span class='illegal-item'>" + inventoryItemName + "</span></a>");
        else
            $(".sidenav").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x"+inventoryItemQuantity+")</span> " + inventoryItemName + "</a>");
    }
    for(i in weapons) {
        var weaponName = weapons[i].name;
        var weaponLegality = weapons[i].legality;
        if (typeof weaponLegality != "undefined") {
            if (weaponLegality == "illegal") {
                $(".sidenav").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x1)</span> <span class='illegal-item'>" + weaponName + "</span></a>");
            } else {
                $(".sidenav").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x1)</span> " + weaponName + "</a>");
            }
        } else {
            $(".sidenav").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x1)</span> " + weaponName + "</a>");
        }
    }
    // back btn
    $(".sidenav").append("<a id='inventory-back-btn' class='inventory-item'>Back</a>");

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
    $(".sidenav .inventory-action-item").remove();
    $(".sidenav .inventory-actions-back-btn").remove();
    $(".sidenav .police-btn").remove();
    document.getElementById("mySidenav").style.width = "0";
}

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            cursor.style.display = event.data.enable ? "block" : "none";
            document.body.style.display = event.data.enable ? "block" : "none";
            /* Set the width of the side navigation to 250px */
            document.getElementById("mySidenav").style.width = "410px";
            // show interaction menu items
            $(".sidenav a").show();
            $(".player-meta-data").show();
            if (event.data.enable) {
                handleMenuItemForJob(currentPlayerJob); // set player job specific menu item
                if (event.data.voip == 10) {
                    $("#voip-level-value").text("Normal");
                } else if (event.data.voip == 25) {
                    $("#voip-level-value").text("Yell");
                } else if (event.data.voip == 2) {
                    $("#voip-level-value").text("Whisper");
                }
                targetPlayerId = event.data.playerId;
                targetPlayerName = event.data.playerName;
            }
        } else if (event.data.type == "click") {
            // Avoid clicking the cursor itself, click 1px to the top/left;
            Click(cursorX - 1, cursorY - 1);
        } else if (event.data.type == "inventoryLoaded") {
            playerInventory = event.data.inventory;
            playerWeapons = event.data.weapons;
            playerLicenses = event.data.licenses;
            populateInventory(playerInventory, playerWeapons, playerLicenses);
        } else if (event.data.type == "setPlayerJob") {
            currentPlayerJob = event.data.job;
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
        } else if (data.which == 112) { // F1 key
            $.post('http://test/escape', JSON.stringify({}));
            closeNav();
        }
    };

    $(".sidenav a").click(function() {
        $(".player-meta-data").hide();
    });

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

    $('.sidenav').on('click', '.inventory-item', function() {
        var itemName = $(this).text();
        var playerName = targetPlayerName;
        if (itemName != "Back") {
            $(".sidenav a").hide();
            $(".sidenav").append("<a data-itemName='"+itemName+"' class='inventory-item inventory-action-item'>Use</a>");
            $(".sidenav").append("<a data-itemName='"+itemName+"' class='inventory-item inventory-action-item'>Drop</a>");
            $(".sidenav").append("<a data-itemName='"+itemName+"' class='inventory-item inventory-action-item' id='action-give'>Give to " + playerName + "</span></a>");
            $(".sidenav").append("<a onclick='inventoryActionsBackBtn()' class='inventory-actions-back-btn'>Back</a>");
        } else {
            $(".sidenav .inventory-item").remove();
            $(".sidenav a").show();
            $(".player-meta-data").show();
        }
    });

    $('.sidenav').on('click', '.inventory-action-item', function() {
        var actionName = $(this).text();
        if (typeof actionName == "undefined") {
            //alert("actionName undefined!");
        } else {
            //alert("actionName = " + actionName);
        }
        var itemName = $(this).attr("data-itemName");
        var wholeItem = GetWholeItemByName(itemName);
        //alert("item name = " + itemName);
        if (itemName == "(x1) Driver") {
            itemName = "(x1) Driver's License"
        }
        $.post('http://test/inventoryActionItemClicked', JSON.stringify({
            actionName: actionName.toLowerCase(),
            itemName: itemName,
            playerId: targetPlayerId,
            wholeItem: wholeItem
        }));
        closeNav();
    });

});

function inventoryActionsBackBtn() {
    $(".sidenav .inventory-action-item").remove();
    $(".sidenav .inventory-actions-back-btn").remove();
    $.post('http://test/loadInventory', JSON.stringify({}));
}

function GetWholeItemByName(itemName) {
    itemName = removeQuantityFromName(itemName);
    if (itemName == "Driver") {
        itemName = "Driver's License";
    }
    var inventory = playerInventory;
    var weapons = playerWeapons;
    var licenses = playerLicenses;
    for (var i = 0; i < licenses.length; i++) {
        if (licenses[i].name == itemName) {
            //alert("matching item found in licenses!");
            //alert("type = " + licenses[i].type);
            return licenses[i]
        }
    }
    for (var i = 0; i < weapons.length; i++) {
        if (weapons[i].name == itemName) {
            //alert("matching item found in weapons!");
            //alert("type = " + weapons[i].type);
            return weapons[i]
        }
    }
    for (var i = 0; i < inventory.length; i++) {
        if (inventory[i].name == itemName) {
            //alert("matching item found in inventory!");
            //alert("type = " + inventory[i].type);
            return inventory[i]
        }
    }
}

function removeQuantityFromName(itemName) {
    var index = itemName.indexOf(")");
    index = index + 2;
    var newItemName = itemName.substring(index);
    //alert("new name = " + newItemName);
    return newItemName
}

function handleMenuItemForJob(jobName) {
    if (jobName == "police") {
        $(".sidenav .sidenav-buttons").prepend("<a onclick='showPoliceActions()' class='police-btn'>Police Actions</a>");
    } else if (jobName == "ems") {
        //$("#ems-btn").show();
    } else if (jobName == "taxi") {
        //$("#taxi-btn").show();
    } else if (jobName == "tow") {
        //$("#tow-btn").show();
    }
}
