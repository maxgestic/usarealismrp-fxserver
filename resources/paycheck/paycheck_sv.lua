local isWelfare
local msg

RegisterServerEvent('paycheck:welfare')
AddEventHandler('paycheck:welfare', function()

  	local paycheckAmount

	TriggerEvent('es:getPlayerFromId', source, function(user)

		local job = user.getActiveCharacterData("job")

		if job == "cop" or job == "sheriff" or job == "highwaypatrol" or job == "fbi" then
			local cop_rank = user.getActiveCharacterData("policeRank")
			paycheckAmount = 750
			  if cop_rank == 2 then
				paycheckAmount = 1100
			  elseif cop_rank == 3 then
				paycheckAmount = 1500
			  elseif cop_rank == 4 then
				paycheckAmount = 1600
			  elseif cop_rank == 5 then
				paycheckAmount = 1800
			  elseif cop_rank == 6 then
				paycheckAmount = 2100
			  elseif cop_rank == 7 then
				paycheckAmount = 2600
			  elseif cop_rank == 8 then
				paycheckAmount = 2900
			  elseif cop_rank == 9 then
				paycheckAmount = 3100
			  elseif cop_rank == 10 then
				paycheckAmount = 3500
			  end
		elseif job == "ems" or job == "fire" then
			local rank = user.getActiveCharacterData("emsRank")
			paycheckAmount = 750
			if rank == 2 then
				paycheckAmount = 1100
			  elseif rank == 3 then
				paycheckAmount = 1500
			  elseif rank == 4 then
				paycheckAmount = 1600
			  elseif rank == 5 then
				paycheckAmount = 1800
			  elseif rank == 6 then
				paycheckAmount = 2100
			  elseif rank == 7 then
				paycheckAmount = 2600
			  end
		elseif job == "security" then
			paycheckAmount = 500
		elseif job == "taxi" then
			paycheckAmount = 650
		elseif job == "tow" then
			paycheckAmount = 650
		elseif job == "reporter" then
			paycheckAmount = 650
		elseif job == "judge" then
			paycheckAmount = 2600
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
			elseif job == "reporter" then
				msg = msg .. "of $" .. paycheckAmount .. " from ^3Weazel News^0!"
			elseif job == "sheriff" then
				msg = msg .. "of $" .. paycheckAmount .. " from the ^3Blaine County Sheriff's Office^0!"
			elseif job == "ems" then
				msg = msg .. "of $" .. paycheckAmount .. " from ^3American Medical Response^0!"
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
