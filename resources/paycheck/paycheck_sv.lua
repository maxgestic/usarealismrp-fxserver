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
			paycheckAmount = 650
		elseif job == "tow" then
			paycheckAmount = 650
		else
			paycheckAmount = 250 -- welfare amount (no job)
		end

		-- Give user the dough!!
		local user_money = user.getActiveCharacterData("bank")
		if user_money then
			user.setActiveCharacterData("bank", user_money + paycheckAmount)
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
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, msg)
		else
			-- no active char, don't pay
		end
 	end)

end)

TriggerEvent('es:addCommand', 'job', function(source, args, user)
	local job = user.getActiveCharacterData("job")
	myJob(job, source)
end, { help = "See what your active job is" })

TriggerEvent('es:addCommand', 'myjob', function(source, args, user)
	local job = user.getActiveCharacterData("job")
	myJob(job, source)
end, { help = "See what your active job is" })

function myJob(job, source)
	if job == "civ" then
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "You do not currently work for any companies.")
	elseif job == "taxi" then
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "You currently work for ^3Downtown Taxi Co^0.")
	elseif job == "tow" then
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "You currently work for ^3Bubba's Tow Co.^0.")
	elseif job == "sheriff" then
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "You currently work for ^3BCSO^0.")
	elseif job == "police" then
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "You currently work for ^4LSPD^0.")
	elseif job == "ems" then
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "You currently work for ^4EMS^0.")
	elseif job == "fire" then
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "You currently work for the ^1Fire Department^0.")
	end
end
