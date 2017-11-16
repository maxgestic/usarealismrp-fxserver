local isWelfare
local msg

RegisterServerEvent('paycheck:welfare')
AddEventHandler('paycheck:welfare', function()

  	local paycheckAmount

	TriggerEvent('es:getPlayerFromId', source, function(user)

        local job = user.getActiveCharacterData("job")

		if job == "cop" or job == "sheriff" or job == "highwaypatrol" or job == "fbi" then
			paycheckAmount = 1000
		elseif job == "ems" or job == "fire" then
			paycheckAmount = 1000
		elseif job == "security" then
			paycheckAmount = 500
		elseif job == "taxi" then
            paycheckAmount = 250
        elseif job == "tow" then
            paycheckAmount = 250
        else
			paycheckAmount = 250 -- welfare amount (no job)
		end

		-- Give user the dough!!
    local user_money = user.getActiveCharacterData("money")
		user.setActiveCharacterData("money", user_money + paycheckAmount)

        msg = "You received a "
        if isWelfare then
            msg = msg .. "welfare "
        else
            msg = msg .. "check "
        end
        if job == "taxi" then
            msg = msg .. "of $" .. paycheckAmount .. " from ^3Downtown Taxi Co.^0!"
        elseif job == "tow" then
            msg = msg .. "of $" .. paycheckAmount .. " from ^3Bubba's Tow Co.^0!"
        else
            msg = msg .. "of $" .. paycheckAmount .. "."
        end

        -- Notify the user
          local user_time = user.getActiveCharacterData("ingameTime")
		      user.setActiveCharacterData("ingameTime", user_time + 10)
        TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, msg)

 	end)

end)

TriggerEvent('es:addCommand', 'job', function(source, args, user)
    local job = user.getActiveCharacterData("job")
    if job == "civ" then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "You do not currently work for any companies.")
    elseif job == "taxi" then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "You currently work for ^3Downtown Taxi Co.^0.")
    elseif job == "tow" then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "You currently work for ^3Bubba's Tow Co.^0.")
    end
end)

TriggerEvent('es:addCommand', 'myjob', function(source, args, user)
    local job = user.getActiveCharacterData("job")
    if job == "civ" then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "You do not currently work for any companies.")
    elseif job == "taxi" then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "You currently work for ^3Downtown Taxi Co.^0.")
    elseif job == "tow" then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "You currently work for ^3Bubba's Tow Co.^0.")
    end
end)
