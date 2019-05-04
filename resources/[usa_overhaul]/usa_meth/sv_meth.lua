--
--  MADE BY MINIPUNCH
-- A player will get close to a designated blip on the map within this script, press "E", and begin gathering.
-- This same concept within the script will handle all aspects of a job from getting supplies, processing, to selling, etc.
--

function removeOrDecrementItem(itemNameBeingGiven)
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		if user then
			local inventory = user.getActiveCharacterData("inventory")
			if itemNameBeingGiven == "Meth" then
				for i = 1, #inventory do
					if inventory[i].name == "Pseudoephedrine" then
						if inventory[i].quantity > 1 then
							inventory[i].quantity = inventory[i].quantity - 1
							user.setActiveCharacterData("inventory", inventory)
							print("decremented Pseudoephedrine! at: " .. inventory[i].quantity)
							return
						else
							print("removing Pseudoephedrine from inventory! at: " .. inventory[i].quantity)
							table.remove(inventory, i)
							user.setActiveCharacterData("inventory", inventory)
							return
						end
					end
				end
			end
		end
	--end)
end

-- give's meth to person --
RegisterServerEvent("usa_rp:giveItem")
AddEventHandler("usa_rp:giveItem", function(itemToGive)
  print("inside of usa_rp:giveItem!")
  local userSource = tonumber(source)
  --TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user then
	  print("seeing if user can carry more weight of: " .. itemToGive.weight * itemToGive.quantity)
	  if user.getCanActiveCharacterHoldItem(itemToGive) then
		local inventory = user.getActiveCharacterData("inventory")
		--removeOrDecrementItem(itemToGive.name)
		for i = 1, #inventory do
		  local item = inventory[i]
		  if item.name == itemToGive.name then -- player already has one of this item in inventory, so increment
			inventory[i].quantity = inventory[i].quantity + itemToGive.quantity -- increment item in inventory
			user.setActiveCharacterData("inventory", inventory) -- save the inventory
			if itemToGive.name == 'Meth Rock' or itemToGive.name == 'Blue Meth Rock' then
				TriggerClientEvent("usa_rp:notify", userSource, "You have successfully proccessed the materials into a meth rock!")
				print("meth quantity added! at: " .. inventory[i].quantity)
			elseif itemToGive.name == 'Packaged Meth' or itemToGive.name == 'Packaged Blue Meth' then
				TriggerClientEvent("usa_rp:notify", userSource, "You have successfully processed meth rock into packaged product!")
			end
			return
		  end
		end
		-- user does not have that item yet, so give it to them
		table.insert(inventory, itemToGive)
		user.setActiveCharacterData("inventory", inventory)
		print("gave meth rock/packaged meth to user!")
	  else
		TriggerClientEvent("usa_rp:notify", userSource, "Your inventory is full. Can't carry anymore!")
	  end
	end
  --end)
end)

RegisterServerEvent("usa_rp:checkUserJobSupplies")
AddEventHandler("usa_rp:checkUserJobSupplies", function(supply, supply2)
	local userSource = tonumber(source)
	local hasBasicSupply = false
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user then
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == supply then -- player already has one of this item in inventory
				if item.quantity > 1 then
					inventory[i].quantity = item.quantity - 1
					user.setActiveCharacterData("inventory", inventory)
					TriggerClientEvent('usa_rp:doesUserHaveJobSupply', userSource, true, supply)
					print("player had job supply!!")
					return
				else
					table.remove(inventory, i)
					user.setActiveCharacterData("inventory", inventory)
					TriggerClientEvent('usa_rp:doesUserHaveJobSupply', userSource, true, supply)
					print("player had job supply!!")
					return
				end
			elseif supply2 and item.name == supply2 then
				if item.quantity > 1 then
					inventory[i].quantity = item.quantity - 1
					user.setActiveCharacterData("inventory", inventory)
					TriggerClientEvent('usa_rp:doesUserHaveJobSupply', userSource, true, supply2)
					print("player had job supply!!")
					return
				else
					table.remove(inventory, i)
					user.setActiveCharacterData("inventory", inventory)
					TriggerClientEvent('usa_rp:doesUserHaveJobSupply', userSource, true, supply2)
					print("player had job supply!!")
					return
				end
			end
		end
		-- does not have job supply at this point
		TriggerClientEvent("usa_rp:doesUserHaveJobSupply", userSource, false, supply, supply2)
		print('player did not have job supply: '..supply, supply2)
	end
end)

RegisterServerEvent("usa_rp:giveChemicals")
AddEventHandler("usa_rp:giveChemicals", function(chemicalToGive)
	print('returning chemical: '..chemicalToGive)
	local chemical = {
		name = chemicalToGive,
		legality = "illegal",
		quantity = 1,
		type = "chemical",
		weight = 10,
		objectModel = "bkr_prop_meth_acetone"
	}
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user then
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == chemicalToGive then -- player already has one of this item in inventory
				if item.quantity >= 1 then
					inventory[i].quantity = item.quantity + 1
					print('upping quantity')
					user.setActiveCharacterData("inventory", inventory)
					return
				else
					print('upping quantity')
					table.insert(inventory, chemical)
					user.setActiveCharacterData("inventory", inventory)
					return
				end
			end
		end
		local chemical = {
			name = chemicalToGive,
			legality = "illegal",
			quantity = 1,
			type = "chemical",
			weight = 10,
			objectModel = "bkr_prop_meth_acetone"
		}
		table.insert(inventory, chemical)
		user.setActiveCharacterData("inventory", inventory)
		print('added a chemical!')
	end
end)

RegisterServerEvent("usa_rp:giveRock")
AddEventHandler("usa_rp:giveRock", function(rockToGive)
	print('returning rock: '..rockToGive)
	local rock = {
		name = rockToGive,
		legality = "illegal",
		quantity = 1,
		type = "drug",
		weight = 4,
		objectModel = 'bkr_prop_meth_scoop_01a'
	}
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user then
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == rockToGive then -- player already has one of this item in inventory
				if item.quantity >= 1 then
					inventory[i].quantity = item.quantity + 1
					print('upping quantity')
					user.setActiveCharacterData("inventory", inventory)
					return
				else
					print('upping quantity')
					table.insert(inventory, rock)
					user.setActiveCharacterData("inventory", inventory)
					return
				end
			end
		end
		local rock = {
			name = rockToGive,
			legality = "illegal",
			quantity = 1,
			type = "drug",
			weight = 4,
			objectModel = 'bkr_prop_meth_scoop_01a'
		}
		table.insert(inventory, rock)
		user.setActiveCharacterData("inventory", inventory)
		print("added rock!")
	end
end)

RegisterServerEvent("usa_rp:startTimer")
AddEventHandler("usa_rp:startTimer", function(timerType)
	local userSource = tonumber(source)
	local messages = {
		"Sup! You can chill out here while I get your stuff.",
		"Long time no see!",
		"What's up good lookin!",
		"Back already?",
		"Miss me already?"
	}
	TriggerClientEvent("usa_rp:notify", userSource, messages[math.random(1, tonumber(#messages))])
	if timerType == "meth_supplies_ped" then
		local seconds = 17
		local time = seconds * 1000
		SetTimeout(time, function()
			TriggerClientEvent("usa_rp:notify", userSource, "Here are the basic chemicals needed for cooking, red phosphorus might increase quality!")
			-- return ped to start position
			TriggerClientEvent("usa_rp:returnPedToStartPosition", userSource, timerType)
			-- give loot
			--TriggerEvent("es:getPlayerFromId", userSource, function(user)
			local user = exports["essentialmode"]:getPlayerFromId(userSource)
			if user then
				local inventory = user.getActiveCharacterData("inventory")
				for i = 1, #inventory do
					local item = inventory[i]
					if item.name == "Pseudoephedrine" then
						inventory[i].quantity = inventory[i].quantity + 1
						user.setActiveCharacterData("inventory", inventory)
						print("Pseudoephedrine quantity increased at: " .. inventory[i].quantity)
						return
					end
				end
				local suspiciousChemicals = {
					name = "Pseudoephedrine",
					legality = "illegal",
					quantity = 1,
					type = "chemical",
					weight = 10,
					objectModel = "bkr_prop_meth_acetone"
				}
				table.insert(inventory, suspiciousChemicals)
				user.setActiveCharacterData("inventory", inventory)
				print("added Pseudoephedrine!")
			end
		end)
	elseif timerType == "meth_supplies_ped_quality" then
		local seconds = 25
		local time = seconds * 1000
		SetTimeout(time, function()
			TriggerClientEvent("usa_rp:notify", userSource, "Here are the extra chemicals needed for good produce!")
			-- return ped to start position
			TriggerClientEvent("usa_rp:returnPedToStartPosition", userSource, timerType)
			-- give loot
			--TriggerEvent("es:getPlayerFromId", userSource, function(user)
			local user = exports["essentialmode"]:getPlayerFromId(userSource)
			if user then
				local inventory = user.getActiveCharacterData("inventory")
				for i = 1, #inventory do
					local item = inventory[i]
					if item.name == "Red Phosphorus" then
						inventory[i].quantity = inventory[i].quantity + 1
						user.setActiveCharacterData("inventory", inventory)
						print("Red Phosphorus quantity increased at: " .. inventory[i].quantity)
						return
					end
				end
				local suspiciousChemicals = {
					name = "Red Phosphorus",
					legality = "illegal",
					quantity = 1,
					type = "chemical",
					weight = 10,
					objectModel = "bkr_prop_meth_ammonia"
				}
				table.insert(inventory, suspiciousChemicals)
				user.setActiveCharacterData("inventory", inventory)
				print("added Red Phosphorus!")
			end
		end)
	end
end)

RegisterServerEvent("methJob:checkUserMoney")
AddEventHandler("methJob:checkUserMoney", function(supplyType)
	if supplyType == 'Red Phosphorus' then
		amount = 500
	elseif
		supplyType == 'Pseudoephedrine' then
		amount = 300
	end
	local MAX_CHEMICALS = 10
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local suspicious_chems = {
	name = "chems bruh",
	weight = 10,
	quantity = 1,
	type = "chemicals"
	}
	if user.getCanActiveCharacterHoldItem(suspicious_chems) then
		local userMoney = user.getActiveCharacterData("money")
		local inventory = user.getActiveCharacterData("inventory")
		-- check for max item quantity
		if hasItem(supplyType, inventory, MAX_CHEMICALS) then
			TriggerClientEvent("usa_rp:notify", userSource, "You can't carry more than " .. MAX_CHEMICALS .. " "..supplyType"!")
			return
		else
			-- money check
			if userMoney >= amount then
			  -- continue with transaction
			  TriggerClientEvent("methJob:getSupplies", userSource, supplyType)
			  user.setActiveCharacterData("money", userMoney - amount)
			elseif userMoney < amount then
			  -- not enough funds to continue
			  TriggerClientEvent("usa_rp:notify", userSource, "Come back when you have ~y~$" .. amount .. "~w~ to get the supplies!")
			end
		end
	else
		TriggerClientEvent("usa_rp:notify", userSource, "Inventory is full.")
	end
  --end)
end)

function hasItem(itemName, inventory, quantity)
  for i = 1, #inventory do
	local item = inventory[i]
	if item then
	  if item.name == itemName then
		if quantity then
		  if type(tonumber(quantity)) ~= nil then
			if item.quantity >= quantity then
			  print("inventory item found with the searched quantity!")
			  return true
			else
			  print("did not find item with that quantity")
			  return false
			end
		  end
		end
		print("FOUND: " .. itemName .. " in player's inventory")
		return true
	  end
	end
  end
  print("did not find item")
  return false
end
