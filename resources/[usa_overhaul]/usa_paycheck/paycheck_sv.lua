local msg

RegisterServerEvent('paycheck:welfare')
AddEventHandler('paycheck:welfare', function()
	local isWelfare = false
  	local paycheckAmount

	--TriggerEvent('es:getPlayerFromId', source, function(user)
 	 local user = exports["essentialmode"]:getPlayerFromId(source)

	local job = user.getActiveCharacterData("job")

		if job == "cop" or job == "sheriff" or job == "highwaypatrol" or job == "fbi" then
			local cop_rank = user.getActiveCharacterData("policeRank")
			paycheckAmount = 60
			  if cop_rank == 2 then
				paycheckAmount = 75
			  elseif cop_rank == 3 then
				paycheckAmount = 80
			  elseif cop_rank == 4 then
				paycheckAmount = 100
			  elseif cop_rank == 5 then
				paycheckAmount = 120
			  elseif cop_rank == 6 then
				paycheckAmount = 150
			  elseif cop_rank == 7 then
				paycheckAmount = 160
			  elseif cop_rank == 8 then
				paycheckAmount = 180
			  elseif cop_rank == 9 then
				paycheckAmount = 200
			  elseif cop_rank == 10 then
				paycheckAmount = 210
			  end
		elseif job == "ems" or job == "fire" then
			local rank = user.getActiveCharacterData("emsRank")
			paycheckAmount = 70
			if rank == 2 then
				paycheckAmount = 90
			  elseif rank == 3 then
				paycheckAmount = 100
			  elseif rank == 4 then
				paycheckAmount = 120
			  elseif rank == 5 then
				paycheckAmount = 140
			  elseif rank == 6 then
				paycheckAmount = 165
			  elseif rank == 7 then
				paycheckAmount = 180
			  end
		elseif job == "security" then
			paycheckAmount = 500
		elseif job == "taxi" then
			paycheckAmount = 30
		elseif job == "tow" then
			paycheckAmount = 30
		elseif job == "reporter" then
			paycheckAmount = 30
		elseif job == "judge" then
			paycheckAmount = 300
		elseif job == "corrections" then
      		paycheckAmount = 95
      	elseif job == "lawyer" then
      		paycheckAmount = 220
      	elseif job == "doctor" then
      		paycheckAmount = 200
      	elseif job == "dai" then
      		paycheckAmount = 175
      	else
			paycheckAmount = 25 -- welfare amount (no job)
			isWelfare = true
		end

		-- Give user the dough!!
		local user_money = user.getActiveCharacterData("bank")
		if user_money then
			user.setActiveCharacterData("bank", user_money + paycheckAmount)
			msg = "You received a "
			if isWelfare then
				msg = msg .. "welfare check "
			else
				msg = msg .. "check "
			end
			if job == "taxi" then
				msg = msg .. "of $" .. paycheckAmount .. " from ~y~Downtown Cab Co.~s~."
			elseif job == "tow" then
				msg = msg .. "of $" .. paycheckAmount .. " from ~y~Bubba's Tow Co.~s~."
			elseif job == "reporter" then
				msg = msg .. "of $" .. paycheckAmount .. " from ~y~Weazel News~s~."
			elseif job == "sheriff" then
				msg = msg .. "of $" .. paycheckAmount .. " from the ~y~San Andreas State Police~s~."
			elseif job == "corrections" then
				msg = msg .. "of $" .. paycheckAmount .. " from the ~y~San Andreas Department of Corrections~s~."
			elseif job == "ems" then
				msg = msg .. "of $" .. paycheckAmount .. " from ~y~Los Santos Fire Department~s~."
			elseif job == "lawyer" then
				msg = msg .. "of $" .. paycheckAmount .. " from the ~y~San Andreas Legal Association~s~."
			elseif job == 'judge' then
				msg = msg .. "of $" .. paycheckAmount .. " from the ~y~San Andreas Court Administration~s~."
			elseif job == 'doctor' then
				msg = msg .. "of $" .. paycheckAmount .. " from the ~y~Pillbox Medical Center~s~."
			elseif job == 'dai' then
				msg = msg .. "of $" .. paycheckAmount .. " from the ~y~District Attorney Investigation Branch~s~."
			else
				msg = msg .. "of $" .. paycheckAmount .. "."
			end
			-- Notify the user
			local user_time = user.getActiveCharacterData("ingameTime")
			user.setActiveCharacterData("ingameTime", user_time + 10)
			TriggerClientEvent('usa:notify', source, msg)
		else
			-- no active char, don't pay
		end
 	--end)

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
		TriggerClientEvent('usa:notify', source, "You do not currently work for any companies.")
	elseif job == "taxi" then
		TriggerClientEvent('usa:notify', source, "You currently work for ~y~Downtown Cab Co~s~.")
	elseif job == "tow" then
		TriggerClientEvent('usa:notify', source, "You currently work for ~y~Bubba's Tow Co.~s~.")
	elseif job == "sheriff" then
		TriggerClientEvent('usa:notify', source, "You currently work for the ~y~San Andreas State Police~s~.")
	elseif job == "police" then
		TriggerClientEvent('usa:notify', source, "You currently work for the ~y~Los Santos Police Department~s~.")
	elseif job == "ems" then
		TriggerClientEvent('usa:notify', source, "You currently work for the ~y~Los Santos Fire Department~s~.")
	elseif job == "fire" then
		TriggerClientEvent('usa:notify', source, "You currently work for the ~y~Los Santos Fire Department~s~.")
  	elseif job == "chickenFactory" then
		TriggerClientEvent('usa:notify', source, "You currently work for ~y~Cluckin' Bell~s~.")
	elseif job == 'corrections' then
		TriggerClientEvent('usa:notify', source, "You currently work for the ~y~San Andreas Department of Corrections~s~.")
	elseif job == 'lawyer' then
		TriggerClientEvent('usa:notify', source, "You currently work for the ~y~San Andreas Legal Association~s~.")
	elseif job == 'judge' then
		TriggerClientEvent('usa:notify', source, 'You are currently working for the ~y~San Andreas Court Administration~s~.')
	elseif job == 'doctor' then
		TriggerClientEvent('usa:notify', source, 'You are currently working for the ~y~Pillbox Medical Center~s~.')
	end
end
