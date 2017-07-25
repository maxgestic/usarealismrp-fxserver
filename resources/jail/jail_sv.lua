TriggerEvent('es:addCommand', 'jail', function(source, args, user)
	if user.getJob() == "sheriff" or user.getJob() == "cop" then
		TriggerClientEvent("jail:openMenu", source)
	end
end)

RegisterServerEvent("jail:jailPlayerFromMenu")
AddEventHandler("jail:jailPlayerFromMenu", function(data)
	print("jailing player...")
	print("data.sentence = " .. data.sentence)
	print("data.charges = " .. data.charges)
	print("data.id = " .. data.id)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if user.getJob() == "sheriff" or user.getJob() == "cop" then
			jailPlayer(data)
		end
	end)
end)

function jailPlayer(data)
	local userSource = source
	local targetPlayer = tonumber(data.id)
	local sentence = tonumber(data.sentence)
	local reason = data.charges
	local targetPlayerPreviousClothing
		if sentence == nil then
			TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1Error: ^0YOU FORGOT TO ADD THE JAIL TIME SILLY GOOSE!!")
			CancelEvent()
			return
		end
		-- store clothing
		TriggerEvent('es:getPlayerFromId', targetPlayer, function(user)
			targetPlayerPreviousClothing = user.getModel()

			-- jail player
			TriggerClientEvent('chatMessage', -1, "SYSTEM", {255,180,0}, GetPlayerName(targetPlayer) .. " has been jailed for ^3" .. sentence .. "^0 months.")
			TriggerClientEvent('chatMessage', -1, "SYSTEM", {255,180,0}, "Charges: " .. reason)
			TriggerClientEvent("jail:jail", targetPlayer, reason, sentence)

			-- remove items from player
			TriggerClientEvent("jail:removeWeapons", targetPlayer) -- take from ped
			user.setWeapons({})
			user.setInventory({})

			-- add to criminal history
			local playerCriminalHistory = user.getCriminalHistory()
			local record = {
				sentence = sentence,
				charges = reason,
				arrestingOfficer = GetPlayerName(userSource),
				timestamp = os.date("%c", os.time())
			}
			table.insert(playerCriminalHistory, record)
			user.setCriminalHistory(playerCriminalHistory)

			-- give inmate clothing
			TriggerClientEvent("jail:changeClothes", targetPlayer)

			SetTimeout(sentence * 60000, function() -- release after amount of time
				TriggerClientEvent('chatMessage', -1, "SYSTEM", {255,180,0}, GetPlayerName(targetPlayer) .. " has been released from jail.")
				TriggerClientEvent("jail:release", targetPlayer, targetPlayerPreviousClothing)

			end)
		end)
end

--[[ Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'jail', function(source, args, user)

	local userSource = source

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

			-- add to criminal history
			local playerCriminalHistory = user.getCriminalHistory()
			local record = {
				sentence = sentence,
				charges = reason,
				arrestingOfficer = GetPlayerName(userSource),
				timestamp = os.date("%c", os.time())
			}
			table.insert(playerCriminalHistory, record)
			user.setCriminalHistory(playerCriminalHistory)

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

--]]

function table_copy(t)
	local u = { }
	for k, v in pairs(t) do u[k] = v end
	return setmetatable(u, getmetatable(t))
end
