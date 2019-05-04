local DROPPED_ITEMS = {}

local ITEM_EXPIRE_CHECK_INTERVAL = 5000 -- miliseconds
local ITEM_EXPIRE_TIME = 45 -- minutes

RegisterServerEvent("interaction:getDroppedItems")
AddEventHandler("interaction:getDroppedItems", function()
  TriggerClientEvent("interaction:getDroppedItems", source, DROPPED_ITEMS)
end)

RegisterServerEvent("interaction:addDroppedItem")
AddEventHandler("interaction:addDroppedItem", function(item)
  item.dropTime = os.time()
  table.insert(DROPPED_ITEMS, item)
  TriggerClientEvent("interaction:addDroppedItem", -1, item)
end)

RegisterServerEvent("interaction:attemptPickup")
AddEventHandler("interaction:attemptPickup", function(item)
  local usource = source
  for i = 1, #DROPPED_ITEMS do
    if item.x == DROPPED_ITEMS[i].x and item.y == DROPPED_ITEMS[i].y and item.z == DROPPED_ITEMS[i].z and item.name == DROPPED_ITEMS[i].name then
      attemptPickup(usource, DROPPED_ITEMS[i], function(success)
        if success then
          table.remove(DROPPED_ITEMS, i)
          TriggerClientEvent("interaction:removeDroppedItem", -1, i)
        end
      end)
      break
    end
  end
end)

function attemptPickup(src, item, cb)
	local user = exports["essentialmode"]:getPlayerFromId(src)
	if user then
	  if user.getCanActiveCharacterHoldItem(item) then
		  if item.type == "weapon" then
  			local weapons = user.getActiveCharacterData("weapons")
  			if #weapons < 3 then
  			  table.insert(weapons, item)
  			  user.setActiveCharacterData("weapons", weapons)
  			  TriggerClientEvent("interaction:equipWeapon", src, item, true)
          local anim = { dict = "anim@move_m@trash", name = "pickup" }
          TriggerClientEvent("usa:playAnimation", src, anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 2)
          cb(true)
  			else
  			  TriggerClientEvent("usa:notify", src, "Can't hold anymore weapons!")
          cb(false)
  			end
		  else
  			local found = false
  			local inventory = user.getActiveCharacterData("inventory")
  			for i = 1, #inventory do
  			  if inventory[i].name == item.name then
    				found = true
    				inventory[i].quantity = inventory[i].quantity + 1
    				user.setActiveCharacterData("inventory", inventory)
            break
  			  end
  			end
  			if not found then
  			  item.quantity = 1
  			  table.insert(inventory, item)
  			  user.setActiveCharacterData("inventory", inventory)
  			end
    		TriggerClientEvent("usa:notify", src, "You picked up (x1) " .. item.name)
    		local anim = { dict = "anim@move_m@trash", name = "pickup" }
    		TriggerClientEvent("usa:playAnimation", src, anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 2)

        cb(true)
      end
	  else
		   TriggerClientEvent("usa:notify", src, "You can't hold that item! Inventory full.")
       cb(false)
	  end
	end
end

function getMinutesFromTime(t)
  local reference = t
  local minutesfrom = os.difftime(os.time(), reference) / 60
  local minutes = math.floor(minutesfrom)
  return minutes
end

-- remove dropped items after ITEM_EXPIRE_TIME minutes --
Citizen.CreateThread(function()
  while true do
    if #DROPPED_ITEMS > 0 then
      for i = #DROPPED_ITEMS, 1, -1 do 
        if (getMinutesFromTime(DROPPED_ITEMS[i].dropTime) > ITEM_EXPIRE_TIME) or (string.find(DROPPED_ITEMS[i].name, 'Key') and getMinutesFromTime(DROPPED_ITEMS[i].dropTime) > 1) then
          table.remove(DROPPED_ITEMS, i)
          TriggerClientEvent("interaction:removeDroppedItem", -1, i)
          break
        end
      end
    end
    Wait(ITEM_EXPIRE_CHECK_INTERVAL)
  end
end) 