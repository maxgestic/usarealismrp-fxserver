local TOW_REWARD = 700

RegisterServerEvent("towJob:giveReward")
AddEventHandler("towJob:giveReward", function(property)
	local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local user_money = user.getActiveCharacterData("money")
		user.setActiveCharacterData("money", user_money + TOW_REWARD)
		-- give property owner money --
		if property then
			TriggerEvent("properties:addMoney", property.name, math.ceil(0.70 * TOW_REWARD))
		end
		TriggerClientEvent("towJob:success", userSource)
	end)
end)

-- pv-tow :

TriggerEvent('es:addJobCommand', 'tow', { "tow" }, function(source, args, user)
	TriggerClientEvent('pv:tow', source)
end, {
	help = "Load or unload the car in front of you onto a flatbed."
})

local timeout = false

RegisterServerEvent("tow:setJob")
AddEventHandler("tow:setJob", function(coords)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local user_job = user.getActiveCharacterData("job")
		local user_licenses = user.getActiveCharacterData("licenses")
		local has_dl = false
		if user_job == "tow" then
			print("user " .. GetPlayerName(userSource) .. " just went off duty for Bubba's Tow Co.!")
			user.setActiveCharacterData("job", "civ")
			TriggerClientEvent("tow:offDuty", userSource)
		else
			if not timeout then
				print("user " .. GetPlayerName(userSource) .. " just went on duty for Bubba's Tow Co.!")
				for i = 1, #user_licenses do
				  local item = user_licenses[i]
				  if string.find(item.name, "Driver") then
					has_dl = true
					print("DL found! checking validity")
					if item.status == "suspended" then
						TriggerClientEvent("usa:notify", userSource, "Your license is suspended!")
						return
					end
				  end
				end
				if has_dl then
					TriggerClientEvent("chatMessage", userSource, "", {}, "^3HELP: ^0You can use /dispatch [id] [msg] to set a waypoint to the caller id of the last tow request.")
					TriggerClientEvent("chatMessage", userSource, "", {}, "^3HELP: ^0You can use /tow when you face a vehicle to load and unload it onto your vehicle.")
					user.setActiveCharacterData("job", "tow")
					TriggerClientEvent("tow:onDuty", userSource, coords)
					timeout = true
					SetTimeout(15000, function()
						timeout = false
						TriggerClientEvent("tow:onTimeout", userSource, false)
					end)
				else
					TriggerClientEvent("usa:notify", userSource, "You don't have a driver's license!")
					return
				end
			else
				print("player is on timeout and cannot go on duty for Bubba's Tow Co.!")
				TriggerClientEvent("tow:onTimeout", userSource, true)
			end
		end
	end)
end)
