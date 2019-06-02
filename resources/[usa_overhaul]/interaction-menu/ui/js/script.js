var emoteOptions = ["Cancel", "Cop", "Sit", "Cross Arms", "Kneel", "CPR", "Notepad","Traffic", "Photo","Clipboard", "Lean", "Hangout", "Pot", "Phone", "Damn", "Yoga", "Cheer", "Statue", "Jog",
"Flex", "Sit up", "Push up", "Peace", "Mechanic", "Smoke 1", "Smoke 2", "Drink", "Gang 1", "Gang 2", "Prone", "Weld", "Bum 1", "Bum 2", "Bum 3", "Drill", "Blower", "Chillin'", "Mobile Film", "Planting", "Golf", "Hammer", "Clean", "Musician", "Party", "Prostitute", "High Five", "Wave", "Hug", "Fist bump", "Salute", "Dance 1", "Dance 2", "Dance 3", "Dance 4", "Dance 5", "Shag 1", "Shag 2", "Shag 3",
"Whatup", "Kiss", "Handshake", "Surrender", "Aim", "Fail", "No", "Palm", "Finger"];

var menuItems = [
  {
    name: "Actions",
    children: [
      { name: "Show ID" },
      { name: "Give cash" },
      { name: "Bank" },
      { name: "Phone number" },
      { name: "Glasses" },
      { name: "Mask" },
      { name: "Hat" },
      { name: "Tie" },
      { name: "Untie" },
      { name: "Drag" },
      { name: "Blindfold" },
      { name: "Remove blindfold" },
      { name: "Place" },
      { name: "Unseat" },
      { name: "Rob" },
      { name: "Search" },
      { name: "Roll dice" },
      { name: "Walkstyle" }
    ]
  },
  {
    name: "Inventory" // will get it's own UI
  },
	{
    name: "Emotes" // children built below
  },
	{
    name: "VOIP",
    children: [
      { name: "Yell" },
      { name: "Normal" },
			{ name: "Whisper" }
    ]
  }
];

/* build list of emotes */
var temp = [];
for (var i = 0; i < menuItems.length; i++) {
  if (menuItems[i].name == "Emotes") {
    for (var k = 0; k < emoteOptions.length; k++) {
      var child = { name: emoteOptions[k]};
      temp.push(child);
    }
    menuItems[i].children = temp;
    break;
  }
}

var vehicleActions = [
  { name: "Engine", children: [
    { name: "On" },
    { name: "Off" }
  ]},
  { name: "Open", children: [
    { name: "Hood" },
    { name: "Front Left" },
    { name: "Back Left" },
    { name: "Front Right" },
    { name: "Back Right" },
    { name: "Trunk" },
  ]},
  { name: "Close", children: [
    { name: "Hood" },
    { name: "Front Left" },
    { name: "Back Left" },
    { name: "Front Right" },
    { name: "Back Right" },
    { name: "Trunk" },
  ]},
  { name: "Shuffle" },
  { name: "Brakelights" }
];

/* Helps navigate backwards when going into multiple submenus (stack) */
var navigationHistory = [{ name: "Home", children: menuItems }];

var interactionMenu = new Vue({
  el: "#app",
  data: {
    menuItems: menuItems,
    currentPage: "Home",
    currentSubmenuItems: [],
    targetVehiclePlate: null,
    showSecondaryInventory: false,
    inputBox: {
      show: false,
      value: null
    },
    inventory: {
      currentWeight: 0,
      MAX_CAPACITY: 25,
      items: {}
    },
    vehicleInventory: {
      MAX_ITEMS: 25,
      MAX_CAPACITY: 0.0,
      currentWeight: 0.0,
      items: {}
    },
    isInsideVehicle: false,
    contextMenu: {
      showContextMenu: false,
      top: 0,
      left: 0,
      clickedInventoryIndex: 0,
      openMenu: function(clickedInventoryIndex) {
        /* Show context menu */
        this.showContextMenu = true
        /* Open next to mouse: */
        this.top = event.y;
        this.left = event.x;
        /* Saved clicked inventory index */
        this.clickedInventoryIndex = clickedInventoryIndex;
      }
    },
    nearestPlayer: {
      id: 0, // 0 if nobody near
      name: "no one"
    },
    dropHelper: {
      originIndex: null,
      targetIndex: null,
      fromType: null,
      toType: null
    },
    locked: null, // to be moved into vehicleInventory property (since it pertains to veh inv)
    profiler: {
      startTime: null
    }
  },
  methods: {
    onClick: function(item) {
      /* Navigate to page if submenu */
      if (item.children) {
        this.currentSubmenuItems = item.children;
        this.currentPage = item.name;
        navigationHistory.push(item);
      /* Perform action if not submenu */
      } else {
        switch (item.name) {
          case "Inventory": {
            /* load inventory items */
            $.post('http://interaction-menu/loadInventory', JSON.stringify({}));
            /* Set page */
            this.currentPage = "Inventory";
            /* Toggle veh inv */
            if (this.targetVehiclePlate) {
              $.post("http://interaction-menu/loadVehicleInventory", JSON.stringify({
                plate: this.targetVehiclePlate
              }));
              this.showSecondaryInventory = true;
            }
            break;
          }
        }
      }
    },
    onSubmenuItemClick: function(item) {
      switch(this.currentPage) {
        case "Actions": {
          $.post('http://interaction-menu/performAction', JSON.stringify({
            action: item.name,
            isVehicleAction: false
          }));
          break;
        }
        case "Emotes": {
          $.post('http://interaction-menu/playEmote', JSON.stringify({
            emoteName: item.name
          }));
          break;
        }
        case "VOIP": {
          $.post('http://interaction-menu/setVoipLevel', JSON.stringify({
            level: item.name
          }));
          break;
        }
        case "Vehicle Actions": {
          /* Navigate into submenu */
          if (item.children) {
            this.currentSubmenuItems = item.children;
            navigationHistory.push(item);
            return; // don't close menu
          /* No more submenus, perform action */
          } else {
            var parentMenu = navigationHistory[navigationHistory.length - 1];
            $.post('http://interaction-menu/performAction', JSON.stringify({
              action: item.name,
              isVehicleAction: true,
              parentMenu: parentMenu.name // helps index into Lua table of vehicle actions
            }));
          }
          break;
        }
      }
      /* Close Menu after click */
      CloseMenu();
    },
    showVehicleActions: function() {
      this.currentSubmenuItems = vehicleActions;
      this.currentPage = "Vehicle Actions";
      navigationHistory.push({ name: "Vehicle Actions", children: vehicleActions });
    },
    contextMenuClicked: function(event, action) {
      var index = this.contextMenu.clickedInventoryIndex;
      var item = this.inventory.items[index];
      /* Perform Action */
      if (action == "Drop") {
        /* Perform Action */
        $.post('http://interaction-menu/dropItem', JSON.stringify({
          index: index,
          itemName: item.name,
          objectModel: item.objectModel
        }));
      } else {
        $.post('http://interaction-menu/inventoryActionItemClicked', JSON.stringify({
          wholeItem: item,
          itemName: item.name,
          actionName: action.toLowerCase(),
          playerId: interactionMenu.nearestPlayer.id
        }));
      }
      /* Close context menu */
      CloseMenu();
    },
    back: function() {
      if (navigationHistory[navigationHistory.length - 1].name !== "Home") {
        navigationHistory.pop();
        this.currentPage = navigationHistory[navigationHistory.length - 1].name;
        this.currentSubmenuItems = navigationHistory[navigationHistory.length - 1].children;
      }
    },
    closeMenu: function() {
      CloseMenu();
    },
    continueInventoryMove: function(doInputCheck) {
      /* Hide input */
      this.inputBox.show = false;
      if (doInputCheck) {
        /* Make input quantity valid */
        if (this.inputBox.value <= 0) {
          this.inputBox.value = 0;
          return;
        }
        else if (this.dropHelper.fromType == "primary" && this.inputBox.value > this.inventory.items[this.dropHelper.originIndex].quantity)
          this.inputBox.value = this.inventory.items[this.dropHelper.originIndex].quantity;
        else if (this.dropHelper.fromType == "secondary" && this.inputBox.value > this.vehicleInventory.items[this.dropHelper.originIndex].quantity)
          this.inputBox.value = this.vehicleInventory.items[this.dropHelper.originIndex].quantity;
      }
      /* Update player */
      $.post('http://interaction-menu/moveItem', JSON.stringify({
        fromSlot: parseInt(this.dropHelper.originIndex),
        toSlot: parseInt(this.dropHelper.targetIndex),
        fromType: this.dropHelper.fromType,
        toType: this.dropHelper.toType,
        quantity: this.inputBox.value,
        plate: this.targetVehiclePlate
      }));
      /* Reset quantity input box value */
      this.inputBox.value = 1;
      //console.log("Took: " + (performance.now() - this.profiler.startTime) + "ms to run");
    },
    isItemIllegal: function(item) {
      if (item.legality) {
        if (item.legality == "illegal")
          return true;
        else
          return false;
      } else {
        return false;
      }
    }
  },
  computed: {},
  directives: { /* used for primary inventory items (see 'updated' for secondary inventory items)*/
    draggable: {
      bind: function(el, binding, vnode) {
        if ($(el).draggable("instance") == undefined)
          $(el).draggable({
            //revert: false,
            /*
            revert: function (socketObj) {
              if (socketObj === true) {
                // Drag success :)
                alert("Success!");
                return false;
              }
              else {
                // Drag fail :(
                alert("Reverting!");
                return true;
              }
            }
            */
            scroll: true,
            helper: "clone",
            start: function(event, ui) {
              //console.log("started dragging!");
            },
            stop: function(event, ui) {
              //console.log("stopped dragging!");
            }
          });
        //else
          //console.log("did not make draggable");
      }
    },
    droppable: {
      bind: function(el, binding, vnode) {
        var componentInstance = vnode.context;
        //console.log("instance: " + $(el).droppable("instance"));
        if ($(el).droppable("instance") == undefined)
          $(el).droppable({
          classes: {
            "ui-droppable-hover": "ui-item-hover"
          },
          drop: function(event, ui) {
            //componentInstance.profiler.startTime = performance.now();
            /* Origin/Target Inventory Indexes */
            var originIndex = $(ui.draggable).attr("id");
            var targetIndex = $(this).attr("id");

            /* Target/Destination Inventory Types */
            var fromType = $(ui.draggable).attr("data-inventory-type");
            var toType = $(this).attr("data-inventory-type");

            if (originIndex == targetIndex && fromType == toType)
              return;

            componentInstance.dropHelper.originIndex = originIndex;
            componentInstance.dropHelper.targetIndex = targetIndex;
            componentInstance.dropHelper.fromType = fromType;
            componentInstance.dropHelper.toType = toType;

            if (fromType != toType && ((fromType == "primary" && componentInstance.inventory.items[originIndex].quantity > 1) || fromType == "secondary" && componentInstance.vehicleInventory.items[originIndex].quantity > 1)) {
              /* Get user input for quantity to move */
              componentInstance.inputBox.show = true;
            } else {
              componentInstance.continueInventoryMove(false);
            }
          }
        });
      }
    }
  },
  updated: function() {
    //var t1 = performance.now();

    /* Resize item name text */
    jQuery(".inventory-item footer span").fitText(1.0, { minFontSize: '9px', maxFontSize: '40px' });

	  var app = this;
    $(".secondary-inv-slot").each(function(index) {
      if ($(this).droppable("instance") == undefined)
        $(this).droppable({
            classes: {
              "ui-droppable-hover": "ui-item-hover"
            },
            drop: function(event, ui) {

              //app.profiler.startTime = performance.now();

              /* Origin/Target Inventory Indexes */
              var originIndex = $(ui.draggable).attr("id");
              var targetIndex = $(this).attr("id");

              /* Target/Destination Inventory Types */
              var fromType = $(ui.draggable).attr("data-inventory-type");
              var toType = $(this).attr("data-inventory-type");

              if (originIndex == targetIndex && fromType == toType)
                return;

              app.dropHelper.originIndex = originIndex;
              app.dropHelper.targetIndex = targetIndex;
              app.dropHelper.fromType = fromType;
              app.dropHelper.toType = toType;

              if (fromType != toType && ((fromType == "primary" && app.inventory.items[originIndex].quantity > 1) || fromType == "secondary" && app.vehicleInventory.items[originIndex].quantity > 1)) {
                /* Get user input for quantity to move */
                app.inputBox.show = true;
              } else {
                app.continueInventoryMove(false);
              }
            }
          });
    });
    //$(".secondary-inv-slot").droppable("enable");

    /* prevent access to veh inv items of a locked vehicle unless inside it */
    //console.log("seeing if this.locked is undefined...");
    if (typeof this.locked != "undefined" && this.locked != null) {
      $(".secondary-inv-slot").css("filter", "none");
  		if (this.locked && !this.isInVehicle) {
  			$(".secondary-inv-slot").droppable("disable");
        $(".secondary-inv-slot").css("filter", "blur(5px)");
  		}
		  //console.log("# items in veh inv:" + $(".secondary-inv-item").size());
      if ($(".secondary-inv-item").size() > 0) {
        $(".secondary-inv-item").each(function(index) {
          if ($(this).draggable("instance") == undefined)
            $(this).draggable({
            //revert: false,
            /*
            revert: function (socketObj) {
              if (socketObj === true) {
                // Drag success :)
                alert("Success!");
                return false;
              }
              else {
                // Drag fail :(
                alert("Reverting!");
                return true;
              }
            }
            */
            scroll: true,
            helper: "clone",
            start: function(event, ui) {
              //console.log("started dragging veh item!");
            },
            stop: function(event, ui) {
              //console.log("stopped dragging veh item!");
            }
          });
        });
        //$(".secondary-inv-item").draggable("enable");
        if (this.locked && !this.isInVehicle) {
          $(".secondary-inv-item").draggable("disable");
        }
      }
    }

    //var t2 = performance.now();

    //console.log("took: " + (t2 - t1) + "ms to run");
  }
});

function CloseMenu() {
  document.body.style.display = "none";
  $.post('http://interaction-menu/escape', JSON.stringify({
    vehicle: {
      plate: interactionMenu.targetVehiclePlate
    }
  }));
  interactionMenu.currentPage = "Home";
  interactionMenu.currentSubmenuItems = [];
  interactionMenu.showSecondaryInventory = false;
  interactionMenu.contextMenu.showContextMenu = false;
  interactionMenu.inputBox.show = false;
  interactionMenu.locked = false;
  navigationHistory = [{ name: "Home", children: menuItems }];
  /* Clean up jQuery UI stuff! (causes mem leak if not cleaned up) */
  $(".draggable").draggable("destroy");
  $(".droppable").droppable("destroy");
  $(".secondary-inv-slot").droppable("destroy");
  $(".secondary-inv-item").draggable("destroy");
}

$(function() {
  /* To talk with LUA */
	window.addEventListener('message', function(event) {
		if (event.data.type == "enableui") {
      /* Display */
			document.body.style.display = event.data.enable ? "block" : "none";
      /* Set targetted / occupied in vehicle */
      if (event.data.target_vehicle_plate && typeof event.data.target_vehicle_plate !== "undefined")
        interactionMenu.targetVehiclePlate = event.data.target_vehicle_plate;
      else
        interactionMenu.targetVehiclePlate = null;
      /* Set nearest player */
      interactionMenu.nearestPlayer = event.data.nearestPlayer;
      if (!interactionMenu.nearestPlayer) {
        interactionMenu.nearestPlayer = {
          id: 0,
          name: "no one"
        }
      }
      /* Set whether in vehicle or not */
      interactionMenu.isInVehicle = event.data.isInVehicle;
		} else if (event.data.type == "inventoryLoaded") {
      interactionMenu.inventory = event.data.inventory;
      for (var i = 0; i < interactionMenu.inventory.MAX_CAPACITY; i++)
        if (interactionMenu.inventory.items[i] && !interactionMenu.inventory.items[i].image)
          interactionMenu.inventory.items[i].image = "http://icons.iconarchive.com/icons/pixelkit/tasty-bites/256/hamburger-icon.png";
		} else if (event.data.type == "vehicleInventoryLoaded") {
      /* null check */
      if (!event.data.inventory.items)
        event.data.inventory.items = {};
      /* set items */
      interactionMenu.vehicleInventory = event.data.inventory;
      /* prevent access to veh inv items of a locked vehicle unless inside it */
      if (event.data.locked) {
        interactionMenu.locked = event.data.locked;
      }
		} else if (event.data.type == "updateBothInventories") {
      interactionMenu.inventory = event.data.inventory.primary;
      interactionMenu.vehicleInventory = event.data.inventory.secondary;
    } else if (event.data.type == "updateNearestPlayer") {
      var nearest = event.data.nearest;
      if (nearest.name == "") {
        nearest = {
          id: 0,
          name: "no one"
        }
      }
      interactionMenu.nearestPlayer = nearest;
		}
	});
  /* Close Menu */
	document.onkeydown = function (data) {
		if (data.which == 27 || data.which == 77) { // Escape key or M
      CloseMenu();
		}
	};
});
