--
--  MADE BY MINIPUNCH
-- A player will get close to a designated blip on the map within this script, press "E", and begin gathering.
-- This same concept within the script will handle all aspects of a job from getting supplies, processing, to selling, etc.
--

-- give's cocaine to person --
RegisterServerEvent("cocaineJob:giveItem")
AddEventHandler("cocaineJob:giveItem", function(itemToGive)
  print("inside of cocaineJob:giveItem!")
  local userSource = tonumber(source)
  --TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user then
	  print("seeing if user can carry more weight of: " .. itemToGive.weight * itemToGive.quantity)
	  if user.getCanActiveCharacterHoldItem(itemToGive) then
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
		  local item = inventory[i]
		  if item.name == itemToGive.name then -- player already has one of this item in inventory, so increment
			inventory[i].quantity = inventory[i].quantity + itemToGive.quantity -- increment item in inventory
			user.setActiveCharacterData("inventory", inventory) -- save the inventory
			if itemToGive.name == 'Packaged Cocaine' then
				TriggerClientEvent("usa:notify", userSource, "You have successfully proccessed the uncut cocaine into packaged product!")
				print("cocaine quantity added! at: " .. inventory[i].quantity)
			return
			end
		  end
		end
		-- user does not have that item yet, so give it to them
		table.insert(inventory, itemToGive)
		user.setActiveCharacterData("inventory", inventory)
		if itemToGive.name == 'Packaged Cocaine' then
			TriggerClientEvent("usa:notify", userSource, "You have successfully proccessed the uncut cocaine into packaged product!")
			print("gave packaged cocaine to user!")
		end
	  else
		TriggerClientEvent("usa:notify", userSource, "Your inventory is full. Can't carry anymore!")
	  end
	end
  --end)
end)

RegisterServerEvent('cocaineJob:completeDelivery')
AddEventHandler('cocaineJob:completeDelivery', function(productToRemove)
	print('Player ID['..source..'] has completed a cocaine delivery.')
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local reward = math.random(850, 1100)
	-- bonus when police are online --
	local policeOnline = 0
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerJob = player.getActiveCharacterData("job")
					if playerJob == "sheriff" or playerJob == "police" or playerJob == "cop" then
						policeOnline = policeOnline + 1
					end
				end
			end
		end
	end)
	local bonus = 0
	if policeOnline >= 2 then
		bonus = math.floor((reward * 1.10) - reward)
	end
	----------------------------------
	if user then
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == productToRemove then
				if item.quantity > 1 then
					inventory[i].quantity = item.quantity - 1
					user.setActiveCharacterData("inventory", inventory)
				else
					table.remove(inventory, i)
					user.setActiveCharacterData("inventory", inventory)
				end

				if bonus > 0 then
					TriggerClientEvent('usa:notify', userSource, 'You have been paid ~y~$'..reward..'.00~s~ with a bonus of $'..bonus..'.00~s~.')	
				else
					TriggerClientEvent('usa:notify', userSource, 'You have been paid ~y~$'..reward..'.00~s~.')
				end
				user.setActiveCharacterData("money", user.getActiveCharacterData("money") + (reward + bonus))

				return
			end
		end
		-- does not have job supply at this point
		print('player did not have cocaine yet completed delivery, possible cheater!!!! (id = '..userSource..')')
	end
end)

RegisterServerEvent('cocaineJob:residueRazor')
AddEventHandler('cocaineJob:residueRazor', function()
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user then
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == 'Razor Blade' then
				if not item.residue then item.residue = true TriggerClientEvent('usa:notify', userSource, 'Your Razor Blade has traces of cocaine.') end
				user.setActiveCharacterData("inventory", inventory)
				--print('residue on razor!')
				return
			end
		end
		-- does not have job supply at this point
	end
end)

RegisterServerEvent("cocaineJob:checkUserJobSupplies")
AddEventHandler("cocaineJob:checkUserJobSupplies", function(jobItem, jobSupply)
	local userSource = tonumber(source)
	local hasJobItem = false
	local hasJobSupply = false
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user then
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == jobItem then -- player already has one of this item in inventory
				hasJobItem = true
			end
		end
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == jobSupply then
				if item.quantity > 1 then
					hasJobSupply = true
					if hasJobItem then
						inventory[i].quantity = item.quantity - 1
						user.setActiveCharacterData("inventory", inventory)
					end
					TriggerClientEvent('cocaineJob:doesUserHaveJobSupply', userSource, hasJobItem, hasJobSupply)
					return
				else
					hasJobSupply = true
					if hasJobItem then
						table.remove(inventory, i)
						user.setActiveCharacterData("inventory", inventory)
					end
					TriggerClientEvent('cocaineJob:doesUserHaveJobSupply', userSource, hasJobItem, hasJobSupply)
					return
				end
			end
		end
		-- does not have job supply at this point
		TriggerClientEvent("cocaineJob:doesUserHaveJobSupply", userSource, hasJobItem, hasJobSupply)
	end
end)

RegisterServerEvent('cocaineJob:doesUserHaveProductToSell')
AddEventHandler('cocaineJob:doesUserHaveProductToSell', function()
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user then
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == 'Packaged Cocaine' then -- player already has one of this item in inventory
				TriggerClientEvent('cocaineJob:doesUserHaveProductToSell', userSource, true)
				return
			end
		end
		TriggerClientEvent('cocaineJob:doesUserHaveProductToSell', userSource, false)
	end
end)


RegisterServerEvent("cocaineJob:startTimer")
AddEventHandler("cocaineJob:startTimer", function(timerType)
	local userSource = tonumber(source)
	local messages = {
		"Hurdle on friend, just wait up here...",
		"In the market for this junk? Interesting, wait here.",
		"Lester, the molester. Be right back.",
		"This'll kill you before your genes do, but I don't judge. Be right back.",
		"Perfect, we're on our heads. Just wait here."
	}
	TriggerClientEvent("usa:notify", userSource, messages[math.random(1, tonumber(#messages))])
	if timerType == "coke_supplies_ped" then
		local seconds = 20
		local time = seconds * 1000
		SetTimeout(time, function()
			TriggerClientEvent("usa:notify", userSource, "Alright, let me know if you need more. I'll send the delivery location now.")
			TriggerClientEvent('cocaineJob:setDelivery', userSource)
			-- return ped to start position
			TriggerClientEvent("cocaineJob:returnPedToStartPosition", userSource, timerType)
			-- give loot
			--TriggerEvent("es:getPlayerFromId", userSource, function(user)
			local user = exports["essentialmode"]:getPlayerFromId(userSource)
			if user then
				local inventory = user.getActiveCharacterData("inventory")
				for i = 1, #inventory do
					local item = inventory[i]
					if item.name == "Uncut Cocaine" then
						inventory[i].quantity = inventory[i].quantity + 1
						user.setActiveCharacterData("inventory", inventory)
						print("Uncut Cocaine quantity increased at: " .. inventory[i].quantity)
						return
					end
				end
				local uncutCocaine = {
					name = "Uncut Cocaine",
					legality = "illegal",
					quantity = 1,
					type = "chemical",
					weight = 10
				}
				table.insert(inventory, uncutCocaine)
				user.setActiveCharacterData("inventory", inventory)
				print("added uncut cocaine!")
			end
		end)
	end
end)

RegisterServerEvent("cocaineJob:checkUserMoney")
AddEventHandler("cocaineJob:checkUserMoney", function(supplyType)
	if supplyType == 'Uncut Cocaine' then
		amount = 800
	end
	local MAX_COCAINE = 3
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local uncut_cocaine = {
		name = "coke bruh",
		weight = 10,
		quantity = 1,
		type = "drug"
		}
	if user.getCanActiveCharacterHoldItem(uncut_cocaine) then
		local userMoney = user.getActiveCharacterData("money")
		local inventory = user.getActiveCharacterData("inventory")
		-- check for max item quantity
		if hasItem(supplyType, inventory, MAX_COCAINE) then
			TriggerClientEvent("usa:notify", userSource, "You can't carry more than " .. MAX_COCAINE .. " "..supplyType.."!")
			return
		else
			-- money check
			if userMoney >= amount then
			  -- continue with transaction
			  TriggerClientEvent("cocaineJob:getSupplies", userSource)
			  user.setActiveCharacterData("money", userMoney - amount)
			elseif userMoney < amount then
			  -- not enough funds to continue
			  TriggerClientEvent("usa:notify", userSource, "Come back when you have ~y~$" .. amount .. "~w~ to get the cocaine!")
			end
		end
	else
		TriggerClientEvent("usa:notify", userSource, "Inventory is full.")
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
