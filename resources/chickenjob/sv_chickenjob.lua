local PAY_PER_CHICKEN_MEAT = 7
local KILL = {}

local chickenItems = {
	{name = "Chicken", type = "chicken", legality = "legal", weight = 20},
	{name = "Chicken carcass", type = "chicken", legality = "legal", weight = 10},
	{name = "Featherless chicken carcass", type = "chicken", legality = "legal", weight = 10},
	{name = "Raw chicken meat", type = "chicken", legality = "legal", weight = 1}
}

--need an intermediary function to pass parameters to a callback in LUA
function endItemRetrieval(user, userSource, chickenItemToGive, quantityToGive, chickenItemToRemove, quantityToRemove, endMessage)
	return function()
		if KILL[userSource] then -- KILL flag is set if player walks too far away from a chicken factory circle while processing
			-- remove KILL flag for player
			KILL[userSource] = nil
			return
		end

		if math.random(1,80) <= 1 then
			TriggerClientEvent("chickenJob:endProcessingAnimation", userSource)
			TriggerClientEvent("usa:notify", userSource, "The chicken escaped!")
			TriggerClientEvent("chickenJob:spawnChicken", userSource)
			return
		end

		TriggerClientEvent("chickenJob:endProcessingAnimation", userSource)
		TriggerClientEvent("usa:notify", userSource, endMessage)

		local inventory = user.getActiveCharacterData("inventory")
		-- remove item if necessary
		if chickenItemToRemove then
			for i = 1, #inventory do
				if inventory[i].name == chickenItemToRemove.name then -- found item to manipulate
					if inventory[i].quantity <= 1 then
						table.remove(inventory, i)
					else
						inventory[i].quantity = inventory[i].quantity - quantityToRemove
					end
					break
				end
			end
		end

		-- give item to player
		for key, item in pairs(inventory) do
			if item.name == chickenItemToGive.name then -- found item to manipulate
				item.quantity = item.quantity + quantityToGive
				user.setActiveCharacterData("inventory", inventory)
				return
			end
		end
		-- item not in inventory
		chickenItemToGive.quantity = quantityToGive
		table.insert(inventory, chickenItemToGive)
		user.setActiveCharacterData("inventory", inventory)
	end
end

RegisterServerEvent("chickenJob:toggleDuty")
AddEventHandler("chickenJob:toggleDuty", function()
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_job = user.getActiveCharacterData("job")
	if user_job == "chickenFactory" then
		print("user " .. GetPlayerName(userSource) .. " just went off duty for Cluckin' Bell!")
		TriggerClientEvent("chickenJob:notify", userSource, "You are now clocked out!")
		user.setActiveCharacterData("job", "civ")

		-- set a timeout to avoid spamming the job
		timeout = true
		SetTimeout(10000, function()
			timeout = false
		end)
	else
		if not timeout then
			print("user " .. GetPlayerName(userSource) .. " just went on duty for Cluckin' Bell!")
			TriggerClientEvent("chickenJob:notify", userSource, "You are now clocked in!")
			user.setActiveCharacterData("job", "chickenFactory")
		else
			print("user " .. GetPlayerName(userSource) .. " tried to go on duty with the Cluckin' Bell while on timeout")
			TriggerClientEvent("usa:notify", userSource, "You are clocking in and out too fast!")
		end
	end
end)

RegisterServerEvent("chickenJob:getChicken")
AddEventHandler("chickenJob:getChicken", function()
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)

	local user_job = user.getActiveCharacterData("job")
	if user_job ~= "chickenFactory" then
		TriggerClientEvent("chickenJob:notify", userSource, "You aren't clocked in!")
		return
	end

	if not user.getCanActiveCharacterHoldItems(chickenItems[1], 1) then
		TriggerClientEvent("usa:notify", userSource, "You dont have room to hold that!")
		return
	end

	TriggerClientEvent("usa:notify", userSource, "You reach into the cage to grab a chicken...")
	TriggerClientEvent("chickenJob:startProcessingAnimation", userSource)
	SetTimeout(5000, endItemRetrieval(user, userSource, chickenItems[1], 1, nil, 0, "You've caught a chicken!"))
end)

RegisterServerEvent("chickenJob:killChicken")
AddEventHandler("chickenJob:killChicken", function()
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)

	local user_job = user.getActiveCharacterData("job")
	if user_job ~= "chickenFactory" then
		TriggerClientEvent("chickenJob:notify", userSource, "You aren't clocked in!")
		return
	end

	-- no check for inventory space because chicken carcass weighs less than a Chicken

	local inventory = user.getActiveCharacterData("inventory")
	for key, item in pairs(inventory) do
		if item.name == chickenItems[1].name then -- user has item
			TriggerClientEvent("usa:notify", userSource, "You snap the chicken's neck and begin to cut off the head...")
			TriggerClientEvent("chickenJob:startProcessingAnimation", userSource)
			SetTimeout(2000, endItemRetrieval(user, userSource, chickenItems[2], 1, chickenItems[1], 1, "The bloodied chicken head falls into the bin."))
			return
		end
	end
	-- player doesn't have a Chicken
	TriggerClientEvent("usa:notify", userSource, "You dont have a Chicken to kill!")
end)

RegisterServerEvent("chickenJob:pluckChicken")
AddEventHandler("chickenJob:pluckChicken", function()
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)

	local user_job = user.getActiveCharacterData("job")
	if user_job ~= "chickenFactory" then
		TriggerClientEvent("chickenJob:notify", userSource, "You aren't clocked in!")
		return
	end

	-- no check for inventory space because chicken carcass weighs the same as a featherless chicken

	local inventory = user.getActiveCharacterData("inventory")
	for key, item in pairs(inventory) do
		if item.name == chickenItems[2].name then -- user has item
			TriggerClientEvent("usa:notify", userSource, "You begin to pluck the feathers from the chicken's skin...")
			TriggerClientEvent("chickenJob:startProcessingAnimation", userSource)
			SetTimeout(30000, endItemRetrieval(user, userSource, chickenItems[3], 1, chickenItems[2], 1, "You pluck the last feather from the body."))
			return
		end
	end
	-- player doesn't have a Chicken carcass
	TriggerClientEvent("usa:notify", userSource, "You dont have a dead chicken to pluck!")
end)

RegisterServerEvent("chickenJob:chopChicken")
AddEventHandler("chickenJob:chopChicken", function()
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)

	local user_job = user.getActiveCharacterData("job")
	if user_job ~= "chickenFactory" then
		TriggerClientEvent("chickenJob:notify", userSource, "You aren't clocked in!")
		return
	end

	-- no check for inventory space because 10 chicken meat weighs the same as a featherless chicken

	local inventory = user.getActiveCharacterData("inventory")
	for key, item in pairs(inventory) do
		if item.name == chickenItems[3].name then -- user has item
			TriggerClientEvent("usa:notify", userSource, "You begin to gut and cut raw meat from the chicken")
			TriggerClientEvent("chickenJob:startProcessingAnimation", userSource)
			SetTimeout(30000, endItemRetrieval(user, userSource, chickenItems[4], 10, chickenItems[3], 1, "You finish harvesting the chicken meat"))
			return
		end
	end
	-- player doesn't have a Featherless Chicken
	TriggerClientEvent("usa:notify", userSource, "You dont have a plucked chicken!")
end)

RegisterServerEvent("chickenJob:depositChickenMeat")
AddEventHandler("chickenJob:depositChickenMeat", function()
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)

	local user_job = user.getActiveCharacterData("job")
	if user_job ~= "chickenFactory" then
		TriggerClientEvent("chickenJob:notify", userSource, "You aren't clocked in!")
		return
	end

	local inventory = user.getActiveCharacterData("inventory")
	for i = 1, #inventory do
		if inventory[i].name == chickenItems[4].name then -- found item to manipulate
			local quantity = inventory[i].quantity
			if quantity > 0 then
				TriggerClientEvent("usa:notify", userSource, "You throw all of the raw meat into the bin")
				table.remove(inventory, i)
				local user_money = user.getActiveCharacterData("money")
				user.setActiveCharacterData("money", user_money + (PAY_PER_CHICKEN_MEAT * quantity))
			else
				TriggerClientEvent("usa:notify", userSource, "You dont have any chicken meat!")
			end
			break
		end
	end
	user.setActiveCharacterData("inventory", inventory)
end)

RegisterServerEvent("chickenJob:killTask")
AddEventHandler("chickenJob:killTask", function()
	local userSource = source
	KILL[userSource] = true
end)
