var policeActions = ["Cuff", "Drag", "Search", "MDT", "Place", "Unseat", "Impound", "Seize Veh"];
var voipOptions = ["Yell", "Normal", "Whisper"];
var emoteOptions = ["Cop", "Sit", "Chair", "Kneel", "CPR", "Notepad","Traffic", "Photo","Clipboard", "Lean", "Hangout", "Pot", "Phone", "Yoga", "Cheer", "Statue", "Jog",
"Flex", "Sit up", "Push up", "Weld", "Mechanic","Smoke","Drink", "Prone", "Bum 1", "Bum 2", "Bum 3", "Drill", "Blower", "Chillin'", "Mobile Film", "Planting", "Golf", "Hammer", "Clean", "Musician", "Party", "Prostitute", "High Five", "Wave", "Hug", "Fist bump", "Dance 1", "Dance 2", "Dance 3", "Shag 1", "Shag 2", "Shag 3",
"Whatup", "Kiss", "Handshake", "Surrender", "Cross Arms"];
var playerInventory;
var playerWeapons;
var playerLicenses;
var targetPlayerId = 0;
var targetPlayerName = "";
var currentPlayerJob = "civ";
/*
var target_vehicle = {
  inventory: null,
  plate: null,
  id: null
};
*/
var target_vehicle_plate = "";
var target_vehicle_id = 0;
var target_vehicle_inventory = 0;

function inventoryBackBtn() {
	$("#mySidenav .inventory-item").remove();
	// initiliaze home menu
	// show interaction menu items
	$("#mySidenav a").show();
}

function voipBackBtn() {
	$("#mySidenav .voip-option").remove();
	// initiliaze home menu
	// show interaction menu items
	$("#mySidenav a").show();
	$(".player-meta-data").show();
}

function emotePageBackBtn() {
	$("#mySidenav .emote-page-option").remove();
	// initiliaze home menu
	// show interaction menu items
	$("#mySidenav a").show();
	$(".player-meta-data").show();
}

function emoteBackBtn() {
	$("#mySidenav .emote-option").remove();
	//$("#mySidenav .emote-page-option").show();
	$("#mySidenav a").show();
	$(".player-meta-data").show();
}

function playEmote(emoteNumber) {
	var emoteName = emoteOptions[emoteNumber];
	//alert("playing emote: " + emoteName);
	// hide emote-option btns
	$("#mySidenav .emote-option").remove();
	$("#mySidenav .emote-page-option").remove();
	// trigger playEmote callback
	if (typeof emoteName == "undefined") {
		emoteName = "cancel";
	}
	$.post('http://interaction-menu/playEmote', JSON.stringify({
		emoteName: emoteName.toLowerCase()
	}));
	closeNav();
}

function openEmoteMenu() {
	$("#mySidenav a").hide();
	$(".player-meta-data").hide();
	// Cancel Emote btn
	$("#mySidenav").append("<a onclick='playEmote()' class='emote-option'>Cancel Emote</a>");
	// list all emotes
	for(var x = 0; x < emoteOptions.length; x++) {
		$("#mySidenav").append("<a onclick='playEmote("+(x)+")' class='emote-option'>"+emoteOptions[x]+"</a>");
	}
	//back btn
	$("#mySidenav").append("<a onclick='emoteBackBtn()' id='emote-back-btn' class='emote-option'>Back</a>");
}

function openVoipMenu() {
	$("#mySidenav a").hide();
	for(i in voipOptions) {
		$("#mySidenav").append("<a onclick='setVoip("+i+")' class='voip-option'>" + voipOptions[i] + "</a>");
	}
	// back btn
	$("#mySidenav").append("<a onclick='voipBackBtn()' id='voip-back-btn' class='voip-option'>Back</a>");
}

function setVoip(option) {
	$.post('http://interaction-menu/setVoipLevel', JSON.stringify({
		level: option
	}));

	closeNav();
}

function performPoliceAction(policeActionIndex) {
	if (policeActionIndex == "front left" || policeActionIndex == "front right" || policeActionIndex == "back left" || policeActionIndex == "back right") {
		var seat = policeActionIndex;
		$.post('http://interaction-menu/performPoliceAction', JSON.stringify({
			policeActionIndex: 0,
			policeActionName: "Unseat",
			unseatIndex: seat
		}));
	} else {
		$.post('http://interaction-menu/performPoliceAction', JSON.stringify({
			policeActionIndex: policeActionIndex,
			policeActionName: policeActions[policeActionIndex],
			unseatIndex: ""
		}));
	}
	closeNav();
}

function showVehicleUnseatOptions() {
	$("#mySidenav a").hide();
	$("#mySidenav .sidenav-buttons").append("<a onclick='performPoliceAction(\"front left\")' class='police-action'>Front Left</a>");
	$("#mySidenav .sidenav-buttons").append("<a onclick='performPoliceAction(\"front right\")' class='police-action'>Front Right</a>");
	$("#mySidenav .sidenav-buttons").append("<a onclick='performPoliceAction(\"back left\")' class='police-action'>Back Left</a>");
	$("#mySidenav .sidenav-buttons").append("<a onclick='performPoliceAction(\"back right\")' class='police-action'>Back Right</a>");
}

function showPoliceActions() {
	$("#mySidenav a").hide();
	$(".player-meta-data").hide();
	$("#mySidenav .sidenav-buttons").append("<a class='police-action'>Target: " + targetPlayerName + "</a>");
	for (i in policeActions) {
		if (policeActions[i] == "Unseat") {
			$("#mySidenav .sidenav-buttons").append("<a onclick='showVehicleUnseatOptions()' class='police-action'>" + policeActions[i] + "</a>");
		} else {
			$("#mySidenav .sidenav-buttons").append("<a onclick='performPoliceAction("+i+")' class='police-action'>" + policeActions[i] + "</a>");
		}
	}
}

function getVehicleInventory() {
  $("#mySidenav a").hide();
  $.post('http://interaction-menu/getVehicleInventory', JSON.stringify({
	  target_vehicle_plate: target_vehicle_plate
  }));
}

function populateVehicleInventory(inventory) {
  //alert("populating vehicle inventory...");
  $("#mySidenav a").hide();
  $(".player-meta-data").hide();
  for(i in inventory) {
	if (inventory[i].legality == "illegal")
		$("#mySidenav .sidenav-buttons").append("<a class='vehicle-item'><span class='vehicle-item-quantity'>(x"+inventory[i].quantity+")</span> <span class='illegal-item'>" + inventory[i].name + "</span></a>");
	else
		$("#mySidenav .sidenav-buttons").append("<a class='vehicle-item'><span class='vehicle-item-quantity'>(x"+inventory[i].quantity+")</span> " + inventory[i].name + "</a>");
  }
  // back btn
  $("#mySidenav .sidenav-buttons").append("<a id='vehicle-inventory-back-btn' class='vehicle-item'>Back</a>");
}

function populateInventory(inventory, weapons, licenses) {
	$("#mySidenav a").hide();
	for(i in licenses) {
		var licenseName = licenses[i].name;
		$("#mySidenav .sidenav-buttons").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x"+licenses[i].quantity+")</span> " + licenseName + "</a>");
	}
	for(i in inventory) {
	  var inventoryItemName = inventory[i].name;
	  var inventoryItemQuantity = inventory[i].quantity;
	  var inventoryItemLegality = inventory[i].legality;
	  if (inventoryItemLegality == "illegal")
		$("#mySidenav .sidenav-buttons").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x"+inventoryItemQuantity+")</span> <span class='illegal-item'>" + inventoryItemName + "</span></a>");
	  else
		$("#mySidenav .sidenav-buttons").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x"+inventoryItemQuantity+")</span> " + inventoryItemName + "</a>");
	}
	for(i in weapons) {
		var weaponName = weapons[i].name;
		var weaponLegality = weapons[i].legality;
		if (typeof weaponLegality != "undefined") {
			if (weaponLegality == "illegal") {
				$("#mySidenav .sidenav-buttons").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x"+weapons[i].quantity+")</span> <span class='illegal-item'>" + weaponName + "</span></a>");
			} else {
				$("#mySidenav .sidenav-buttons").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x"+weapons[i].quantity+")</span> " + weaponName + "</a>");
			}
		} else {
			$("#mySidenav .sidenav-buttons").append("<a class='inventory-item'><span class='inventory-item-quantity'>(x"+weapons[i].quantity+")</span> " + weaponName + "</a>");
		}
	}
	// back btn
	$("#mySidenav .sidenav-buttons").append("<a id='inventory-back-btn' class='inventory-item'>Back</a>");

}

var x = 0;
/* Set the width of the side navigation to 0 */
function closeNav() {
	$("#mySidenav .veh-inventory-btn").remove();
	$("#mySidenav .inventory-item").remove();
	$("#mySidenav .vehicle-item").remove();
	$("#mySidenav .voip-option").remove();
	$("#mySidenav .emote-option").remove();
	$("#mySidenav .emote-page-option").remove();
	$("#mySidenav .emote-option").remove();
	$("#mySidenav .emote-option").remove();
	$("#mySidenav .police-action").remove();
	$("#mySidenav .inventory-action-item").remove();
	$("#mySidenav .inventory-actions-back-btn").remove();
	$("#mySidenav .vehicle-item-actions-back-btn").remove();
	$("#mySidenav .police-btn").remove();
	document.getElementsByClassName("sidenav")[0].style.width = "0";
	x = 0; // prevent menu from auto closing (document.keyup firing twice?)
}

$(function() {
	window.addEventListener('message', function(event) {
		if (event.data.type == "enableui") {
			document.body.style.display = event.data.enable ? "block" : "none";
			/* Set the width of the side navigation to 250px */
			document.getElementsByClassName("sidenav")[0].style.width = "410px";
			// show interaction menu items
			$("#mySidenav a").show();
			$(".player-meta-data").show();
			if (event.data.enable) {
				handleMenuItemForJob(currentPlayerJob); // set player job specific menu item
				//alert("setting = " + event.data.voip);
				if (event.data.voip == 8.5) {
					$("#voip-level-value").text("Normal");
				} else if (event.data.voip == 23) {
					$("#voip-level-value").text("Yell");
				} else if (event.data.voip == 2) {
					$("#voip-level-value").text("Whisper");
				}
				targetPlayerId = event.data.playerId;
				targetPlayerName = event.data.playerName;
				// vehicle inventory:
				if (event.data.target_vehicle_plate && typeof event.data.target_vehicle_plate !== "undefined") {
					// alert("target vehicle loaded. Plate #: " + event.data.target_vehicle_plate)
					// add interaction menu item for vehicle inventory:
					$("#mySidenav .sidenav-buttons").prepend("<a onclick='getVehicleInventory()' class='veh-inventory-btn'>Veh Inventory</a>");
					target_vehicle_plate = event.data.target_vehicle_plate;
					//target_vehicle_id = event.data.target_vehicle_id;
				} else {
					//alert("problem loading target veh");
				}
			}
		} else if (event.data.type == "inventoryLoaded") {
				playerInventory = event.data.inventory;
				playerWeapons = event.data.weapons;
				playerLicenses = event.data.licenses;
				populateInventory(playerInventory, playerWeapons, playerLicenses);
		} else if (event.data.type == "vehicleInventoryLoaded") {
				target_vehicle_inventory = event.data.vehicle_inventory;
				populateVehicleInventory(target_vehicle_inventory);
		} else if (event.data.type == "setPlayerJob") {
				currentPlayerJob = event.data.job;
		}
	});

	document.onkeyup = function (data) {
		if (data.which == 27 || data.which == 112 || data.which == 77) { // Escape key or F1 or M
			if (x > 0) {
				$.post('http://interaction-menu/escape', JSON.stringify({}));
				closeNav();
			} else {
				x++;
			}
		}
	};

	$("#mySidenav a").click(function() {
		$(".player-meta-data").hide();
	});

	$("#inventory-btn").click(function(){
		$.post('http://interaction-menu/loadInventory', JSON.stringify({}));
	});

	$("#close-btn").click(function(){
		$.post('http://interaction-menu/escape', JSON.stringify({}));
		closeNav();
	});

	$("#voip-btn").click(function(){
		openVoipMenu();
	});

	$("#emotes-btn").click(function(){
		openEmoteMenu();
	});

	// -----------------
	// normal inventory:
	// -----------------
	$('#mySidenav').on('click', '.inventory-item', function() {
		var itemName = $(this).text();
		var playerName = targetPlayerName;
		if (itemName != "Back") {
			$("#mySidenav a").hide();
			$("#mySidenav").append("<a data-itemName='"+itemName+"' class='inventory-item inventory-action-item'>Use</a>");
			$("#mySidenav").append("<a data-itemName='"+itemName+"' class='inventory-item inventory-action-item' id='action-give'>Give to " + playerName + "</span></a>");
			$("#mySidenav").append("<a data-itemName='"+itemName+"' class='inventory-item inventory-action-item'>Store</a>");
			$("#mySidenav").append("<a data-itemName='"+itemName+"' class='inventory-item inventory-action-item'>Drop</a>");
			$("#mySidenav").append("<a onclick='inventoryActionsBackBtn()' class='inventory-actions-back-btn'>Back</a>");
		} else {
			$("#mySidenav .inventory-item").remove();
			$("#mySidenav a").show();
			$(".player-meta-data").show();
		}
	});

	$('#mySidenav').on('click', '.inventory-action-item', function() {
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
		$.post('http://interaction-menu/inventoryActionItemClicked', JSON.stringify({
			actionName: actionName.toLowerCase(),
			itemName: itemName,
			playerId: targetPlayerId,
			wholeItem: wholeItem
		}));
		closeNav();
	});

	// ------------------
	// vehicle inventory:
	// ------------------
	$('#mySidenav').on('click', '.vehicle-item', function() {
		var itemName = $(this).text();
		if (itemName != "Back") {
			$("#mySidenav a").hide();
			$("#mySidenav").append("<a data-itemName='"+itemName+"' class='vehicle-item vehicle-item-action'>Retrieve</a>");
			$("#mySidenav").append("<a onclick='vehicleInventoryActionsBackBtn()' class='vehicle-item-actions-back-btn'>Back</a>");
		} else {
			$("#mySidenav .vehicle-item").remove();
			$("#mySidenav a").show();
			$(".player-meta-data").show();
		}
	});

	$('#mySidenav').on('click', '.vehicle-item-action', function() {
		var actionName = $(this).text();
		if (typeof actionName == "undefined") {
			//alert("actionName undefined!");
		} else {
			//alert("actionName = " + actionName);
		}
		var itemName = $(this).attr("data-itemName");
		var wholeItem = GetWholeVehicleItemByName(itemName);
		//alert("item name = " + itemName);
		if (itemName == "(x1) Driver") {
			itemName = "(x1) Driver's License"
		}
		$.post('http://interaction-menu/retrieveVehicleItem', JSON.stringify({
			actionName: actionName.toLowerCase(),
			itemName: itemName,
			wholeItem: wholeItem,
			target_vehicle_plate: target_vehicle_plate,
			current_job: currentPlayerJob
		}));
		closeNav();
	});

});

function vehicleInventoryActionsBackBtn() {
	$("#mySidenav .vehicle-item-action").remove();
	$("#mySidenav .vehicle-item-actions-back-btn").remove();
	$.post('http://interaction-menu/getVehicleInventory', JSON.stringify({
		target_vehicle_plate: target_vehicle_plate
	}));
}

function inventoryActionsBackBtn() {
	$("#mySidenav .inventory-action-item").remove();
	$("#mySidenav .inventory-actions-back-btn").remove();
	$.post('http://interaction-menu/loadInventory', JSON.stringify({}));
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

function GetWholeVehicleItemByName(name) {
  name = removeQuantityFromName(name);
  if (name == "Driver") {
	  name = "Driver's License";
  }
  var inventory = target_vehicle_inventory;
  for (var i = 0; i < inventory.length; ++i) {
	  if (inventory[i].name == name) {
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
		$("#mySidenav .sidenav-buttons").prepend("<a onclick='showPoliceActions()' class='police-btn'>Police Actions</a>");
	} else if (jobName == "ems") {
		//$("#ems-btn").show();
	} else if (jobName == "taxi") {
		//$("#taxi-btn").show();
	} else if (jobName == "tow") {
		//$("#tow-btn").show();
	}
}
