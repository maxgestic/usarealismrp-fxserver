------------------------------------------
--	iEnsomatic RealisticVehicleFailure  --
------------------------------------------
--
--	Created by Jens Sandalgaard
--
--	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--
--	https://github.com/iEns/RealisticVehicleFailure
--



local function checkWhitelist(id)
	for key, value in pairs(RepairWhitelist) do
		if id == value then
			return true
		end
	end	
	return false
end

--[[
AddEventHandler('chatMessage', function(source, _, message)
	local msg = string.lower(message)
	local identifier = GetPlayerIdentifiers(source)[1]
	if msg == "/repair" then
		CancelEvent()
		if RepairEveryoneWhitelisted == true then
			TriggerClientEvent('iens:repair', source)
		else
			if checkWhitelist(identifier) then
				TriggerClientEvent('iens:repair', source)
			else
				TriggerClientEvent('iens:notAllowed', source)
			end
		end
	end
end)
--]]

RegisterServerEvent("carDamage:checkForRepairKit")
AddEventHandler("carDamage:checkForRepairKit", function(vehicle)
print("checking for repair kit!!!!!")
    local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
        local inventory = user.getActiveCharacterData("inventory")
        for i = 1, #inventory do
            if i <= #inventory and i ~= 0 then
                if inventory[i].name == "Repair Kit" then
                    if math.random(100) <= 80 then -- 80% chance to repair
                        TriggerClientEvent("carDamage:repairKit", userSource, vehicle)
                    else
						TriggerClientEvent("usa:notify", userSource, "Repair ~r~failed~w~!")
                    end
                    if inventory[i].quantity > 1 then
                        inventory[i].quantity = inventory[i].quantity - 1
                        user.setActiveCharacterData("inventory", inventory)
                    else
                        table.remove(inventory, i)
                        user.setActiveCharacterData("inventory", inventory)
                    end
                    CancelEvent()
                    return
                end
            end
        end
		TriggerClientEvent("usa:notify", userSource, "No repair kit!")
end)
