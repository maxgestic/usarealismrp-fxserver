RegisterServerEvent("towJob:giveReward")
AddEventHandler("towJob:giveReward", function(targetVehicle)
	local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local user_money = user.getActiveCharacterData("money")
		user.setActiveCharacterData("money", user_money + 400)
		TriggerClientEvent("towJob:success", userSource)
	end)
end)

-- pv-tow :

TriggerEvent('es:addCommand', 'tow', function(source, args, user)
	TriggerClientEvent('pv:tow', source)
end)

local timeout = false

RegisterServerEvent("tow:setJob")
AddEventHandler("tow:setJob", function()
	local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local user_job = user.getActiveCharacterData("job")
        if user_job == "tow" then
            print("user " .. GetPlayerName(userSource) .. " just went off duty for Bubba's Tow Co.!")
			user.setActiveCharacterData("job", "civ")
            TriggerClientEvent("tow:offDuty", userSource)
        else
            if not timeout then
                print("user " .. GetPlayerName(userSource) .. " just went on duty for Bubba's Tow Co.!")
				user.setActiveCharacterData("job", "tow")
                TriggerClientEvent("tow:onDuty", userSource)
                timeout = true
                SetTimeout(15000, function()
                    timeout = false
                end)
            else
                print("player is on timeout and cannot go on duty for Bubba's Tow Co.!")
            end
        end
    end)
end)
