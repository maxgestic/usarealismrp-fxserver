local isWelfare
local msg

RegisterServerEvent('paycheck:welfare')
AddEventHandler('paycheck:welfare', function()

  	local paycheckAmount

	TriggerEvent('es:getPlayerFromId', source, function(user)

		if user.job == "cop" or user.job == "sheriff" or user.job == "highwaypatrol" or user.job == "fbi" then
			paycheckAmount = 700
		elseif user.job == "ems" or user.job == "fire" then
			paycheckAmount = 775
		else
			paycheckAmount = 250 -- welfare amount (no job)
		end

		-- Give user the dough!!
		user.addMoney(paycheckAmount)

 	end)

	msg = "You received a "
	if isWelfare then
		msg = msg .. "welfare "
	else
		msg = msg .. "check "
	end
	msg = msg .. "of $" .. paycheckAmount .. "."

	-- Notify the user
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, msg)

end)
