-- repair vehicle
-- todo: change price based on body damage instead of only engine damage?
RegisterServerEvent("customs:checkRepairMoney")
AddEventHandler("customs:checkRepairMoney", function(engineHealth)
	local userSource = tonumber(source)
	print("engine health = " .. engineHealth)
	local REPAIR_COST = 0
	-- add base service fee
	REPAIR_COST = REPAIR_COST + 150
	-- add fee for engine damage
	if engineHealth < 850 then
		REPAIR_COST = REPAIR_COST + 2500
	elseif engineHealth < 900 then
		REPAIR_COST = REPAIR_COST + 1500
	elseif engineHealth < 930 then
		REPAIR_COST = REPAIR_COST + 1000
	elseif engineHealth < 950 then
		REPAIR_COST = REPAIR_COST + 700
	elseif engineHealth < 970 then
		REPAIR_COST = REPAIR_COST + 600
	elseif engineHealth < 1000 then
		REPAIR_COST = REPAIR_COST + 385
	end
	-- charge the player if they have enough money
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		if user then
			local user_money = user.getActiveCharacterData("money")
			if user_money >= REPAIR_COST then
				-- charge player
				user.setActiveCharacterData("money", user_money - REPAIR_COST)
				-- repair vehicle
				TriggerClientEvent("customs:playerHadEnoughMoneyToRepair", userSource)
				-- notify
				TriggerClientEvent("usa:notify", userSource, "~y~Thanks for your business!~w~ Repair Cost: $" .. REPAIR_COST)
			else
				TriggerClientEvent("usa:notify", userSource, "~y~Sorry, we can't help you!~w~ Repair Cost: $" .. REPAIR_COST)
			end
		end
	end)
end)

RegisterServerEvent("customs:saveCarData")
AddEventHandler("customs:saveCarData", function(data, plate)
	local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
		if user then
			local userVehicles = user.getActiveCharacterData("vehicles")
			for i = 1, #userVehicles do
				local vehicle = userVehicles[i]
				if string.match(plate,tostring(vehicle.plate)) ~= nil or plate == vehicle.plate then -- player actually owns car that is being stored
					print("player vehicle found.. saving data")
					vehicle.customizations = data
					userVehicles[i] = vehicle
					user.setActiveCharacterData("vehicles", userVehicles)
				end
			end
		end
	end)
end)

RegisterServerEvent("customs:check")
AddEventHandler("customs:check",function(title, data, cost, value)
	local source = tonumber(source)
    TriggerEvent('es:getPlayerFromId', source, function(user)
		local user_money = user.getActiveCharacterData("money")
	    if (tonumber(user_money) >= tonumber(cost)) then
			user.setActiveCharacterData("money", user_money - cost)
	    	TriggerClientEvent("customs:receive", source, title, data, value)
	    else
	    	TriggerClientEvent("pNotify:SendNotification", source, {text = "Insufficient funds!",type = "error",queue = "left",timeout = 2500,layout = "centerRight"})
	    end
	end)
end)

RegisterServerEvent("customs:check2")
AddEventHandler("customs:check2",function(title, data, cost, value, back)
	local source = tonumber(source)
    TriggerEvent('es:getPlayerFromId', source, function(user)
		local user_money = user.getActiveCharacterData("money")
	    if (tonumber(user.getMoney()) >= tonumber(cost)) then
	    	user.setActiveCharacterData("money", user_money - cost)
	    	TriggerClientEvent("customs:receive2", source, title, data, value, back)
	    else
	    	TriggerClientEvent("pNotify:SendNotification", source, {text = "Insufficient funds!",type = "error",queue = "left",timeout = 2500,layout = "centerRight"})
	    end
	end)
end)

RegisterServerEvent("customs:check3")
AddEventHandler("customs:check3",function(title, data, cost, mod, back, name, wtype)
	local source = tonumber(source)
    TriggerEvent('es:getPlayerFromId', source, function(user)
		local user_money = user.getActiveCharacterData("money")
	    if (tonumber(user_money) >= tonumber(cost)) then
	    	user.setActiveCharacterData("money", user_money - cost)
	    	TriggerClientEvent("customs:receive3", source, title, data, mod, back, name, wtype)
	    else
	    	TriggerClientEvent("pNotify:SendNotification", source, {text = "Insufficient funds!",type = "error",queue = "left",timeout = 2500,layout = "centerRight"})
	    end
	end)
end)

local tbl = {
[1] = {locked = false},
[2] = {locked = false},
[3] = {locked = false},
[4] = {locked = false},
[5] = {locked = false},
}

local ingarage = false
local currentgarage = nil
RegisterServerEvent('customs:lock')
AddEventHandler('customs:lock', function(b,garage)
	ingarage = b
	currentgarage = garage
	tbl[tonumber(garage)].locked = b
	TriggerClientEvent('customs:lock',-1,tbl)
	print("LS Customs status: "..json.encode(tbl))
end)
RegisterServerEvent('customs:getgarageinfos')
AddEventHandler('customs:getgarageinfos', function()
TriggerClientEvent('customs:lock',-1,tbl)
print("LS Customs status: "..json.encode(tbl))
end)

AddEventHandler('playerDropped', function()
	if ingarage == true then
		tbl[tonumber(currentgarage)].locked = false
		TriggerClientEvent('customs:lock',-1,tbl)
		print("LS Customs status: "..json.encode(tbl))
	end
end)
