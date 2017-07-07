-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'jail', function(source, args, user)

	local pw = args[2]
	local targetPlayer, sentence, reason
	local targetPlayerPreviousClothing

	if pw == "poopie" and user.getJob() == "sheriff" then

		targetPlayer = args[3] -- target id to jail
		sentence = args[4] -- length of jail time in seconds
		if tonumber(sentence) == nil then
			TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1Error: ^0YOU FORGOT TO ADD THE JAIL TIME SILLY GOOSE!!")
			CancelEvent()
			return
		end
		table.remove(args, 1)
		table.remove(args, 1)
		table.remove(args, 1)
		table.remove(args, 1)
		reason = table.concat(args, " ")

		-- store clothing
		TriggerEvent('es:getPlayerFromId', tonumber(targetPlayer), function(user)
			targetPlayerPreviousClothing = user.getModel()

			-- jail player
			TriggerClientEvent('chatMessage', -1, "SYSTEM", {255,180,0}, GetPlayerName(targetPlayer) .. " has been jailed for ^3" .. sentence .. "^0 months.")
			TriggerClientEvent('chatMessage', -1, "SYSTEM", {255,180,0}, "Charges: " .. reason)
			TriggerClientEvent("jail:jail", targetPlayer, reason, sentence)

			-- remove items from player
			TriggerClientEvent("jail:removeWeapons", targetPlayer) -- take from ped
			user.setWeapons({})
			user.setInventory({})

			-- give inmate clothing
			TriggerClientEvent("jail:changeClothes", targetPlayer)

			SetTimeout(sentence * 60000, function() -- release after amount of time
				TriggerClientEvent('chatMessage', -1, "SYSTEM", {255,180,0}, GetPlayerName(targetPlayer) .. " has been released from jail.")
				TriggerClientEvent("jail:release", targetPlayer, targetPlayerPreviousClothing)

			end)
		end)

	else
		TriggerClientEvent("jail:wrongPw")
	end

end)

function table_copy(t)
	local u = { }
	for k, v in pairs(t) do u[k] = v end
	return setmetatable(u, getmetatable(t))
end
