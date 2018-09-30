local activeJobs = {}

RegisterServerEvent("go-postal:checkLicense")
AddEventHandler("go-postal:checkLicense", function()
	local userSource = source
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local user_licenses = user.getActiveCharacterData("licenses")
		for i = 1, #user_licenses do
          local item = user_licenses[i]
          if string.find(item.name, "Driver") then
            print("DL found! checking validity")
			print("item.status: " .. item.status)
            if item.status == "valid" then
				print("calling had DL!")
				TriggerClientEvent("go-postal:hadDL", userSource)
				return
            else
				TriggerClientEvent("usa:notify", userSource, "Your license is suspended!")
				return
			end
          end
        end
		-- no license at this point
		TriggerClientEvent("usa:notify", userSource, "You don't have a driver's license! Try the DMV.")
	end)
end)

RegisterServerEvent("transport:giveMoney")
AddEventHandler("transport:giveMoney", function(amount, job)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local user_money = user.getActiveCharacterData("money")
		-- give money to shop owner (if any within 50m nearby)--
		print("checking job closest property!")
		if job.closest_property then
			print("existed! name: " .. job.closest_property.name)
			TriggerEvent("properties:addMoney", job.closest_property.name, math.ceil(0.09 * amount))
		end
		user.setActiveCharacterData("money", user_money + amount)
end)

RegisterServerEvent("transport:addJob")
AddEventHandler("transport:addJob", function(job)
	activeJobs[source] = job
end)

RegisterServerEvent("go_postal:setActiveJob")
AddEventHandler("go_postal:setActiveJob", function(source, coords, name)
	if not activeJobs[source] then
		activeJobs[source] = {name = name, x = coords.x, y = coords.y}
	end
end)

RegisterServerEvent("go_postal:removeActiveJob")
AddEventHandler("go_postal:removeActiveJob", function(source)
	if activeJobs[source] then
		activeJobs[source] = nil
	end
end)

AddEventHandler('playerDropped', function()
	if activeJobs[source] then
		print("player dropped, setting activeJob of " .. activeJobs[source].name .. " to nil")
		activeJobs[source] = nil
	end
end)

TriggerEvent('es:addCommand', 'quitjob', function(source, args, user)
	if activeJobs[source] then
		activeJobs[source] = nil
		TriggerClientEvent("transport:quitJob", source)
		TriggerClientEvent('chatMessage', source, "", {}, "^3You have quit your active transport job!")
		print("player used /quitjob, setting activeJob to nil")
	end
end, {help = "Quit current transport job"})

local COCAINE_PED_BUSY = false
local RETREIVAL_COORDS = {x = 32.4, y = -1927.5, z = 21.8}
local STANDING_COORDS = {x = 29.8, y = -1924.4, z = 21.6}

RegisterServerEvent("cocaine:checkPedBusy")
AddEventHandler("cocaine:checkPedBusy", function()
	local src = source
	local wait_time_seconds = 35
	if not COCAINE_PED_BUSY then
		TriggerClientEvent("usa:notify", source, "I'll be right back.")
		TriggerClientEvent("cocaine:makePedWalk", src, RETREIVAL_COORDS)
		COCAINE_PED_BUSY = true
		SetTimeout(wait_time_seconds * 1000, function()
			TriggerClientEvent("cocaine:continuePickingUpCocaine", src)
			COCAINE_PED_BUSY = false
			TriggerClientEvent("cocaine:makePedWalk", src, STANDING_COORDS)
		end)
	else
		TriggerClientEvent("usa:notify", source, "Francisco is busy! Please wait!")
	end
end)

RegisterServerEvent("cocaine:sellCocaine")
AddEventHandler("cocaine:sellCocaine", function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local user_money = user.getActiveCharacterData("money")
	local inventory = user.getActiveCharacterData("inventory")
	local coke_payment_per_package = 525
	for i = #inventory, 1, -1 do
		local item = inventory[i]
		if item then
			if item.name == "Uncut Cocaine" then
					local coke_reward_total = coke_payment_per_package * item.quantity
					user.setActiveCharacterData("money", user_money + coke_reward_total)
					TriggerClientEvent("usa:notify", source, "Thanks, here is $" .. coke_reward_total)
					print("coke reward: $" .. coke_reward_total)
					table.remove(inventory, i)
					user.setActiveCharacterData("inventory", inventory)
					return
			end
		end
	end
	TriggerClientEvent("usa:notify", source, "You have nothing to sell.")
end)

RegisterServerEvent("cocaine:givePackage")
AddEventHandler("cocaine:givePackage", function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local cocainePackage = {
		name = "Uncut Cocaine",
		quantity = 1,
		type = "drug",
		legality = "illegal",
		weight = 7.0
	}
	if user.getCanActiveCharacterHoldItem(cocainePackage) then
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == "Uncut Cocaine" then
				inventory[i].quantity = item.quantity + 1
				user.setActiveCharacterData("inventory", inventory)
				return
			end
		end
		-- not already in inventory at this point, so add it
		table.insert(inventory, cocainePackage)
		user.setActiveCharacterData("inventory", inventory)
	else
		TriggerClientEvent("usa:notify", source, "Inventory full!")
	end
end)
