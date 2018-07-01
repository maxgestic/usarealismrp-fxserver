RegisterServerEvent("interaction:checkJailedStatusBeforeEmote")
AddEventHandler("interaction:checkJailedStatusBeforeEmote", function(scenario)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if user.getActiveCharacterData("jailtime") > 0 then
		TriggerClientEvent("usa:notify", source, "Can't use that while imprisoned!")
	else
		local scenario_name = ""
		if scenario == "mechanic" then scenario_name = "WORLD_HUMAN_VEHICLE_MECHANIC" end
		if scenario == "chair" then scenario_name = "PROP_HUMAN_SEAT_CHAIR" end
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
	print("going to cuff " .. playerName .. " with id of " .. playerId)
	--TriggerClientEvent("cuff:Handcuff", tonumber(1), GetPlayerName(source))
	TriggerEvent("es:getPlayerFromId", source, function(user)
		if user then
			playerJob = user.getActiveCharacterData("job")
			if playerJob == "sheriff" or playerJob == "cop" then
				print("cuffing player " .. GetPlayerName(source) .. "...")
				TriggerClientEvent("cuff:Handcuff", tonumber(playerId), GetPlayerName(source))
			else
				print("player was not on duty to cuff")
			end
		else
			print("player with that ID # did not exist...")
		end
	end)
end)

RegisterServerEvent("interaction:loadVehicleInventoryForInteraction")
AddEventHandler("interaction:loadVehicleInventoryForInteraction", function(plate)
	print("loading vehicle inventory with plate #: " .. plate)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				local player_vehicles = player.getActiveCharacterData("vehicles")
				if player_vehicles then
					for i = 1, #player_vehicles do
						local veh = player_vehicles[i]
						if string.find(plate, tostring(veh.plate)) then
							print("found a matching plate! sending inventory to client!")
							TriggerClientEvent("interaction:vehicleInventoryLoaded", userSource, veh.inventory)
						end
					end
				end
			end
		end
	end)
end)

RegisterServerEvent("interaction:loadInventoryForInteraction")
AddEventHandler("interaction:loadInventoryForInteraction", function()
	print("loading inventory for interaction menu...")
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user then
			local inventory = user.getActiveCharacterData("inventory")
			local weapons = user.getActiveCharacterData("weapons")
			local licenses = user.getActiveCharacterData("licenses")
			TriggerClientEvent("interaction:inventoryLoaded", userSource, inventory, weapons, licenses)
		else
			print("interaction: user did not exist")
		end
	end)
end)

RegisterServerEvent("interaction:checkForPhone")
AddEventHandler("interaction:checkForPhone", function()
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
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
end)

RegisterServerEvent("interaction:removeItemFromPlayer")
AddEventHandler("interaction:removeItemFromPlayer", function(itemName)
	itemName = removeQuantityFromItemName(itemName)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
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
end)

RegisterServerEvent("interaction:dropItem")
AddEventHandler("interaction:dropItem", function(itemName)
	local userSource = tonumber(source)
	itemName = removeQuantityFromItemName(itemName)
	--------------------
	-- play animation --
	--------------------
	local anim = {
		dict = "anim@move_m@trash",
		name = "pickup"
	}
	TriggerClientEvent("usa:playAnimation", userSource, anim.name, anim.dict, 1)
	----------------
	-- drop item  --
	----------------
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		-- inventory
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == itemName then
				--print("found matching item to drop!")
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
  print("inside of interaction:giveItemToPlayer with target id = " .. targetPlayerId)
  print("item.name = " .. item.name)
  -- give item to nearest player
  TriggerEvent("es:getPlayerFromId", targetPlayerId, function(user)
	if user then
	  if user.getCanActiveCharacterHoldItem(item) then
		if not item.type or item.type == "license" then
		  -- must be a license (no item.type)
			print("tried to give a license!")
			TriggerClientEvent("usa:notify", targetPlayerId, "Can't trade licenses. Sorry!")
			return
			--[[ prevent trading licenses for now
		  local licenses = user.getActiveCharacterData("licenses")
		  table.insert(licenses, item)
			user.setActiveCharacterData("licenses", licenses)
			--]]
		else
		  if item.type == "weapon" then
			print("giving a weapon!")
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
			print("giving an inventory item!")
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
		TriggerClientEvent("usa:playAnimation", userSource, anim.name, anim.dict, 2)
	  else
		TriggerClientEvent("usa:notify", userSource, "Player can't hold anymore items! Inventory full.")
		TriggerClientEvent("usa:notify", targetPlayerId, "You can't hold that item! Inventory full.")
	  end
	else
	  print("player with id #" .. targetPlayerId .. " is not in game!")
	  return
	end
  end)
end)

function removeItemFromPlayer(item, userSource)
	-- remove item from player
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user then
			if not item.type then
				-- must be a license (no item.type)
				print("removing a license!")
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
					print("removing a weapon!")
					local weapons = user.getActiveCharacterData("weapons")
					for i = 1, #weapons do
						if weapons[i].name == item.name then
							print("found a matching weapon to remove!")
							table.remove(weapons,i)
							user.setActiveCharacterData("weapons", weapons)
							return
						end
					end
				else
					print("removing an inventory item!")
					local inventory = user.getActiveCharacterData("inventory")
					for i = 1, #inventory do
						if inventory[i].name == item.name then
							print("found matching item to remove!")
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
			print("player with id #" .. targetPlayerId .. " is not in game!")
		end
	end)
end

--[[ hug emote
TriggerEvent('es:addJobCommand', 'e', { "police", "sheriff" }, function(source, args, user)
	local userSource = tonumber(source)
	if args[2] ~= nil then
		local tPID = tonumber(args[2])
		TriggerClientEvent("cuff:Handcuff", tPID)
		-- play anim:
		local anim = {
			dict = "anim@move_m@trash",
			name = "pickup"
		}
		TriggerClientEvent("usa:playAnimation", userSource, anim.name, anim.dict, 2)
	end
end, {
	help = "Cuff a player.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})
--]]
