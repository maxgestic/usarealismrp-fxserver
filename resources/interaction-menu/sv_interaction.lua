RegisterServerEvent("interaction:checkJailedStatusBeforeEmote")
AddEventHandler("interaction:checkJailedStatusBeforeEmote", function(scenario)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if user.getActiveCharacterData("jailtime") > 0 then
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
AddEventHandler("interaction:tackle", function(targetId)
	TriggerClientEvent("interaction:ragdoll", targetId)
end)

RegisterServerEvent("test:cuff")
AddEventHandler("test:cuff", function(playerId, playerName)
	--print("going to cuff " .. playerName .. " with id of " .. playerId)
	--TriggerClientEvent("cuff:Handcuff", tonumber(1), GetPlayerName(source))
	--TriggerEvent("es:getPlayerFromId", source, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(source)
		if user then
			playerJob = user.getActiveCharacterData("job")
			if playerJob == "sheriff" or playerJob == "cop" then
				--print("cuffing player " .. GetPlayerName(source) .. "...")
				TriggerClientEvent("cuff:Handcuff", tonumber(playerId), GetPlayerName(source))
			else
				--print("player was not on duty to cuff")
			end
		else
			--print("player with that ID # did not exist...")
		end
	--end)
end)

RegisterServerEvent("interaction:loadVehicleInventoryForInteraction")
AddEventHandler("interaction:loadVehicleInventoryForInteraction", function(plate)
	--print("loading vehicle inventory with plate #: " .. plate)
	local userSource = tonumber(source)
	GetVehicleInventory(plate, function(inv)
		--print("found a matching plate! sending inventory to client!")
		TriggerClientEvent("interaction:vehicleInventoryLoaded", userSource, inv)
	end)
end)

function GetVehicleInventory(plate, cb)
	-- query for the information needed from each vehicle --
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehicleInventoryByPlate"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local inventory = {}
			--print("veh inventory: " .. responseText)
			local data = json.decode(responseText)
			if data.rows[1] then
				inventory = data.rows[1].value[1] -- inventory
			end
			cb(inventory)
		end
	end, "POST", json.encode({
		keys = { plate }
		--keys = { "86CSH075" }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end

RegisterServerEvent("interaction:loadInventoryForInteraction")
AddEventHandler("interaction:loadInventoryForInteraction", function()
	--print("loading inventory for interaction menu...")
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user then
		local inventory = user.getActiveCharacterData("inventory")
		local weapons = user.getActiveCharacterData("weapons")
		local licenses = user.getActiveCharacterData("licenses")
		TriggerClientEvent("interaction:inventoryLoaded", userSource, inventory, weapons, licenses)
	else
		--print("interaction: user did not exist")
	end
end)

RegisterServerEvent("interaction:checkForPhone")
AddEventHandler("interaction:checkForPhone", function()
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local inventory = user.getActiveCharacterData("inventory")
	for i = 1, #inventory do
		local item = inventory[i]
		if item.name == "Cell Phone" then
			TriggerClientEvent("interaction:playerHadPhone", userSource)
			return
		end
	end
	TriggerClientEvent("interaction:notify", userSource, "You have no cell phone to open!")
end)

RegisterServerEvent("interaction:removeItemFromPlayer")
AddEventHandler("interaction:removeItemFromPlayer", function(itemName)
	itemName = removeQuantityFromItemName(itemName)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local inventory = user.getActiveCharacterData("inventory")
	for i = 1, #inventory do
		local item = inventory[i]
		if item.name == itemName then
			if item.quantity > 1 then
				inventory[i].quantity = item.quantity - 1
				user.setActiveCharacterData("inventory", inventory)
				return
			else
				table.remove(inventory, i)
				user.setActiveCharacterData("inventory", inventory)
				return
			end
		end
	end
end)

RegisterServerEvent("interaction:dropItem")
AddEventHandler("interaction:dropItem", function(itemName, posX, posY, posZ)
	local userSource = tonumber(source)
	itemName = removeQuantityFromItemName(itemName)
	--------------------
	-- play animation --
	--------------------
	local anim = {
		dict = "anim@move_m@trash",
		name = "pickup"
	}
	--TriggerClientEvent("usa:playAnimation", userSource, anim.name, anim.dict, 1)
	TriggerClientEvent("usa:playAnimation", userSource, anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 1.5)
	----------------
	-- drop item  --
	----------------
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local location = {
		[1] = posX,
		[2] = posY,
		[3] = posZ
	}

	-- 1/3 chance to print notification message to all players in the area
	math.randomseed(GetGameTimer())
	if math.random(1, 3) == 1 then
		local grammar = "a "
		local iName = itemName
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
		exports["globals"]:sendLocalActionMessage(userSource, msg)
	end

	-- TODO: just use usa:removeItem and check for chicken first instead of below code

	-- inventory
	local inventory = user.getActiveCharacterData("inventory")
	for i = 1, #inventory do
		local item = inventory[i]
		if item.name == itemName then
			if item.quantity > 1 then
				inventory[i].quantity = item.quantity - 1
				user.setActiveCharacterData("inventory", inventory)
				return
			else
				if inventory[i].name == "Chicken" then
					TriggerClientEvent("chickenJob:spawnChicken", userSource)
				end
				table.remove(inventory, i)
				user.setActiveCharacterData("inventory", inventory)
				return
			end
		end
	end
	-- weapons
	local weapons = user.getActiveCharacterData("weapons")
	for i = 1, #weapons do
		local item = weapons[i]
		if item.name == itemName then
			--print("found matching item to drop!")
			table.remove(weapons, i)
			user.setActiveCharacterData("weapons", weapons)
			TriggerClientEvent("interaction:equipWeapon", userSource, item, false)
			return
		end
	end
	-- licenses
	local licenses = user.getActiveCharacterData("licenses")
	for i = 1, #licenses do
		local item = licenses[i]
		if item.name == itemName then
			--print("found matching item to drop!")
			table.remove(licenses, i)
			user.setActiveCharacterData("licenses", licenses)
			return
		end
	end
end)

function removeQuantityFromItemName(itemName)
	if string.find(itemName,"%)") then
		local i = string.find(itemName, "%)")
		i = i + 2
		itemName = string.sub(itemName, i)
		--print("new item name = " .. itemName)
	end
	return itemName
end

RegisterServerEvent("interaction:giveItemToPlayer")
AddEventHandler("interaction:giveItemToPlayer", function(item, targetPlayerId)
  local userSource = tonumber(source)
  --print("inside of interaction:giveItemToPlayer with target id = " .. targetPlayerId .. ", item: " .. item.name)
  -- give item to nearest player
	local user = exports["essentialmode"]:getPlayerFromId(targetPlayerId)
	if user then
	  if user.getCanActiveCharacterHoldItem(item) then
		if not item.type or item.type == "license" then
		  -- must be a license (no item.type)
			--print("tried to give a license!")
			TriggerClientEvent("usa:notify", targetPlayerId, "Can't trade licenses. Sorry!")
			return
			--[[ prevent trading licenses for now
		  local licenses = user.getActiveCharacterData("licenses")
		  table.insert(licenses, item)
			user.setActiveCharacterData("licenses", licenses)
			--]]
		else
		  if item.type == "weapon" then
			--print("giving a weapon!")
			local weapons = user.getActiveCharacterData("weapons")
			if #weapons < 3 then
			  table.insert(weapons, item)
			  user.setActiveCharacterData("weapons", weapons)
			  TriggerClientEvent("interaction:equipWeapon", targetPlayerId, item, true)
			  TriggerClientEvent("interaction:equipWeapon", userSource, item, false)
			else
			  TriggerClientEvent("interaction:notify", userSource, GetPlayerName(targetPlayerId) .. " can't hold anymore weapons!")
			  return
			end
		  else
			local found = false
			--print("giving an inventory item!")
			local inventory = user.getActiveCharacterData("inventory")
			for i = 1, #inventory do
			  if inventory[i].name == item.name then
				found = true
				inventory[i].quantity = inventory[i].quantity + 1
				user.setActiveCharacterData("inventory", inventory)
			  end
			end
			if not found then
			  item.quantity = 1
			  table.insert(inventory, item)
			  user.setActiveCharacterData("inventory", inventory)
			end
		  end
		end
		-- remove from source player
		removeItemFromPlayer(item, userSource)
		TriggerClientEvent("usa:notify", userSource, "You gave " .. GetPlayerName(targetPlayerId) .. ": (x1) " .. item.name)
		TriggerClientEvent("usa:notify", targetPlayerId, GetPlayerName(userSource) .. " has given you " .. ": (x1) " .. item.name)
		-- play animation:
		local anim = {
		  dict = "anim@move_m@trash",
		  name = "pickup"
		}
		--TriggerClientEvent("usa:playAnimation", userSource, anim.name, anim.dict, 2)
		--TriggerClientEvent("usa:playAnimation", userSource, anim.dict, anim.name, 5, 1, 2000, 31, 0, 0, 0, 0)
		TriggerClientEvent("usa:playAnimation", userSource, anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 2)

	  else
		TriggerClientEvent("usa:notify", userSource, "Player can't hold anymore items! Inventory full.")
		TriggerClientEvent("usa:notify", targetPlayerId, "You can't hold that item! Inventory full.")
	  end
	else
	  --print("player with id #" .. targetPlayerId .. " is not in game!")
	  return
	end
end)

function removeItemFromPlayer(item, userSource)
	-- remove item from player
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		if user then
			if not item.type then
				-- must be a license (no item.type)
				--print("removing a license!")
				local licenses = user.getActiveCharacterData("licenses")
				for i = 1, #licenses do
					if licenses[i].name == item.name and licenses[i].ownerName == item.ownerName then
						--print("found a matching licenses to remove!!")
						table.remove(licenses, i)
						user.setActiveCharacterData("licenses", licenses)
						return
					end
				end
			else
				if item.type == "weapon" then
					--print("removing a weapon!")
					local weapons = user.getActiveCharacterData("weapons")
					for i = 1, #weapons do
						if weapons[i].name == item.name then
							--print("found a matching weapon to remove!")
							table.remove(weapons,i)
							user.setActiveCharacterData("weapons", weapons)
							return
						end
					end
				else
					--print("removing an inventory item!")
					local inventory = user.getActiveCharacterData("inventory")
					for i = 1, #inventory do
						if inventory[i].name == item.name then
							--print("found matching item to remove!")
							if inventory[i].quantity > 1 then
								inventory[i].quantity = inventory[i].quantity - 1
								user.setActiveCharacterData("inventory", inventory)
								return
							else
								table.remove(inventory,i)
								user.setActiveCharacterData("inventory", inventory)
								return
							end
						end
					end
				end
			end
		else
			--print("player with id #" .. targetPlayerId .. " is not in game!")
		end
	--end)
end

-- /e [emoteName]
TriggerEvent('es:addCommand', 'e', function(source, args, user)
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
