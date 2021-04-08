RegisterServerEvent("interaction:checkJailedStatusBeforeEmote")
AddEventHandler("interaction:checkJailedStatusBeforeEmote", function(scenario)
	local jailTime = exports["usa-characters"]:GetCharacterField(source, "jailTime")
	if jailTime > 0 then
		TriggerClientEvent("usa:notify", source, "Can't use that while imprisoned!")
	else
		local scenario_name = ""
		if scenario == "mechanic" then scenario_name = "WORLD_HUMAN_VEHICLE_MECHANIC" end
		if scenario == "sit" then scenario_name = "WORLD_HUMAN_PICNIC" end
		if scenario == "drill" then scenario_name = "WORLD_HUMAN_CONST_DRILL" end
		if scenario == "chillin'" then scenario_name = "WORLD_HUMAN_DRUG_DEALER_HARD" end
		if scenario == "golf" then scenario_name = "WORLD_HUMAN_GOLF_PLAYER" end
		TriggerClientEvent("usa:playScenario", source, scenario_name)
	end
end)


RegisterServerEvent("interaction:tackle")
AddEventHandler("interaction:tackle", function(targetId, fwdVectorX, fwdVectorY, fwdVectorZ)
	TriggerClientEvent("interaction:tackleMe", targetId, fwdVectorX, fwdVectorY, fwdVectorZ)
end)

RegisterServerEvent("test:cuff")
AddEventHandler("test:cuff", function(playerId, playerName)
	local playerJob = exports["usa-characters"]:GetCharacterField(source, "job")
	if playerJob == "sheriff" or playerJob == "cop" then
		TriggerClientEvent("cuff:Handcuff", tonumber(playerId), GetPlayerName(source))
	end
end)

RegisterServerEvent("interaction:loadVehicleInventory")
AddEventHandler("interaction:loadVehicleInventory", function(plate)
	local userSource = tonumber(source)
	exports["usa_vehinv"]:GetVehicleInventory(plate, function(inv)
		local isLocked = exports["_locksystem"]:isLocked(plate)
		TriggerClientEvent("interaction:vehicleInventoryLoaded", userSource, inv, isLocked)
	end)
end)

RegisterServerEvent("interaction:loadInventoryForInteraction")
AddEventHandler("interaction:loadInventoryForInteraction", function()
	local inventory = exports["usa-characters"]:GetCharacterField(source, "inventory")
	TriggerClientEvent("interaction:inventoryLoaded", source, inventory)
end)

RegisterServerEvent("interaction:checkForPhone")
AddEventHandler("interaction:checkForPhone", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local item = char.getItem("Cell Phone")
	if item then
		TriggerClientEvent("interaction:playerHadPhone", userSource)
	else
		TriggerClientEvent("interaction:notify", userSource, "You have no cell phone to open!")
	end
end)

RegisterServerEvent("interaction:removeItemFromPlayer")
AddEventHandler("interaction:removeItemFromPlayer", function(itemName)
	itemName = removeQuantityFromItemName(itemName)
	local char = exports["usa-characters"]:GetCharacter(source)
	char.removeItem(itemName, 1)
end)

RegisterServerEvent("interaction:bodyArmor")
AddEventHandler("interaction:bodyArmor", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local armor = char.getItem("Body Armor")
	if armor then
		char.removeItem("Body Armor", 1)
		TriggerClientEvent("interaction:equipArmor", source)
	end
end)

RegisterServerEvent("interaction:policeBodyArmor")
AddEventHandler("interaction:policeBodyArmor", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local armor = char.getItem("Police Armor")
	if armor then
		char.removeItem("Police Armor", 1)
		TriggerClientEvent("interaction:equipPoliceArmor", source)
	end
end)

function removeQuantityFromItemName(itemName)
	if string.find(itemName,"%)") then
		local i = string.find(itemName, "%)")
		i = i + 2
		itemName = string.sub(itemName, i)
	end
	return itemName
end

RegisterServerEvent("interaction:giveItemToPlayer")
AddEventHandler("interaction:giveItemToPlayer", function(item, targetPlayerId)
	local toChar = exports["usa-characters"]:GetCharacter(targetPlayerId)
	local fromChar = exports["usa-characters"]:GetCharacter(source)
	if toChar.canHoldItem(item) then
		if not item.type or item.type == "license" then
			TriggerClientEvent("usa:notify", targetPlayerId, "Can't trade licenses. Sorry!")
			return
		end
		if item.type == "weapon" then
			toChar.giveItem(item)
			if item.uuid then
				fromChar.removeItemWithField("uuid", item.uuid)
			else 
				fromChar.removeItem(item, 1)
			end
			TriggerClientEvent("interaction:equipWeapon", targetPlayerId, item, true)
			TriggerClientEvent("interaction:equipWeapon", source, item, false)
		else
			item.quantity = 1
			toChar.giveItem(item)
			fromChar.removeItem(item, 1)
			TriggerClientEvent("usa:notify", source, "You gave " .. GetPlayerName(targetPlayerId) .. ": (x1) " .. item.name)
			TriggerClientEvent("usa:notify", targetPlayerId, GetPlayerName(source) .. " has given you " .. ": (x1) " .. item.name)
		end
		TriggerClientEvent("usa:playAnimation", source, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 2)
	else
		TriggerClientEvent("usa:notify", source, "Player can't hold anymore items! Inventory full.")
		TriggerClientEvent("usa:notify", targetPlayerId, "You can't hold that item! Inventory full.")
	end
end)

RegisterServerEvent("inventory:moveItem")
AddEventHandler("inventory:moveItem", function(data)
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(usource)
	local quantity = tonumber(data.quantity) or 1
	if data.fromType == "primary" and data.toType == "primary" then
		char.moveItemSlots(data.fromSlot, data.toSlot)
		TriggerClientEvent("interaction:sendNUIMessage", usource, { type = "inventoryLoaded", inventory = char.get("inventory")})
	elseif data.fromType == "primary" and data.toType == "secondary" then
		-- get item being moved --
		local item = char.getItemByIndex(data.fromSlot)
		-- validate item move --
		if quantity <= 0 or quantity > item.quantity then
			return
		end
		if item.type and item.type == "license" then
			TriggerClientEvent("usa:notify", usource, "Can't move licenses!")
			-- todo: send msg to NUI to give some UI feedback for failed move
			return
		end
			-- perform move --
		if item then
			TriggerEvent("vehicle:storeItem", usource, data.plate, item, quantity, data.toSlot, function(success, inv) -- make export?
				if success then
					char.removeItemByIndex(data.fromSlot, quantity)
					TriggerClientEvent("interaction:sendNUIMessage", usource, { type = "updateBothInventories", inventory = { primary = char.get("inventory"), secondary = inv}})
					--TriggerClientEvent("interaction:sendNUIMessage", usource, { type = "inventoryLoaded", inventory = char.get("inventory")})
					TriggerEvent("vehicle:updateForOthers", data.plate, inv)
				end
			end)
		end
	elseif data.fromType == "secondary" and data.toType == "primary" then
		if not exports["usa_vehinv"]:getVehicleBusy(data.plate) then
			exports["usa_vehinv"]:setVehicleBusy(data.plate)
			-- perform move --
			TriggerEvent("vehicle:moveItemToPlayerInv", usource, data.plate, data.fromSlot, data.toSlot, quantity, char, function(inv)
				if inv then
					--TriggerClientEvent("interaction:sendNUIMessage", usource, { type = "updateBothInventories", inventory = { primary = char.get("inventory"), secondary = inv}})
					TriggerClientEvent("interaction:sendNUIMessage", usource, { type = "inventoryLoaded", inventory = char.get("inventory")})
					TriggerEvent("vehicle:updateForOthers", data.plate, inv)
				end
			end)
		else
			TriggerClientEvent("usa:notify", usource, "Please wait a moment!")
		end
	elseif data.fromType == "secondary" and data.toType == "secondary" then
		if not exports["usa_vehinv"]:getVehicleBusy(data.plate) then
			exports["usa_vehinv"]:setVehicleBusy(data.plate)
			TriggerEvent("vehicle:moveInventorySlots", data.plate, data.fromSlot, data.toSlot, function(inv)
				local isLocked = exports["_locksystem"]:isLocked(data.plate)
				TriggerEvent("vehicle:updateForOthers", data.plate, inv, isLocked)
			end)
		else
			TriggerClientEvent("usa:notify", usource, "Please wait a moment!")
		end
	end
end)

RegisterServerEvent("inventory:dropItem")
AddEventHandler("inventory:dropItem", function(name, index, posX, posY, posZ)
	--------------------
	-- play animation --
	--------------------
	TriggerClientEvent("usa:playAnimation", source, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 2)
	DroppedActionMessage(source, name)
	local coords = {
		x = posX,
		y = posY,
		z = posZ - 0.9
	}
	local char = exports["usa-characters"]:GetCharacter(source)
	local item = char.getItemByIndex(index)
	item.quantity = 1 -- only drop 1
	item.coords = coords
	if item.type == "weapon" then
		TriggerClientEvent("interaction:equipWeapon", source, item, false)
	end
	if not item.invisibleWhenDropped then
		TriggerEvent("interaction:addDroppedItem", item)
	end
	char.removeItemByIndex(index, 1)
end)

-- /e [emoteName]
--[[
TriggerEvent('es:addCommand', 'e', function(source, args, char)
	if args[2] then
		table.remove(args, 1)
		TriggerClientEvent('emotes:playEmote', source, table.concat(args, ' '))
	else
		TriggerClientEvent('emotes:showHelp', source)
	end
end, {
	help = "Play an emote",
	params = {
		{ name = "name", help = "The name of the emote to play" }
	}
})
--]]

function DroppedActionMessage(source, name)
	-- 1/3 chance to print notification message to all players in the area
	math.randomseed(GetGameTimer())
	if math.random(1, 3) == 1 then
		local grammar = "a "
		local iName = name
		if string.sub(iName, 1, 3) == "Key" then  -- check if the item is a key
			iName = "key"
		elseif string.sub(iName, 1, 10) == "Cell Phone" then  -- check if the item is a phone
			iName = "phone"
		elseif string.sub(iName, -1) == ")" then  -- check if the item is alcohol or has info at the end
			local i = string.find(iName, "(", 1, true)
			iName = string.sub(iName, 1, i - 2)
		end
		if string.sub(iName, -1) == "s" then  -- check if the item name is plural
			grammar = ""
		end
		local msg = "Discards " .. grammar .. iName .. " on the ground."
		--exports["globals"]:sendLocalActionMessage(source, msg)
	end
end
