local timeout = false

local DUTY_FEE = 300

local BASE_PAY = 200

RegisterServerEvent("taxi:payDriver")
AddEventHandler("taxi:payDriver", function(distance)
	local reward = math.ceil(BASE_PAY + (0.40 * distance))
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local user_money = user.getActiveCharacterData("money")
	user.setActiveCharacterData("money", user_money + reward)
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "^0You were payed: ^2$" .. reward)
end)

RegisterServerEvent("taxi:setJob")
AddEventHandler("taxi:setJob", function(property)
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local first, last = user.getActiveCharacterData("firstName"), user.getActiveCharacterData("lastName")
	if not first then
		first = ""
	end
	if not last then
		last = ""
	end
	local name = first .. " " .. last
	local user_licenses = user.getActiveCharacterData("licenses")
	local user_money = user.getActiveCharacterData("money")
	if user.getActiveCharacterData("job") == "taxi" then
		print("user " .. GetPlayerName(userSource) .. " just went off duty for downtown taxi cab co.!")
		user.setActiveCharacterData("job", "civ")
		TriggerClientEvent("taxi:offDuty", userSource)
	else
		if user_money < DUTY_FEE then
			print("player did not have enough money to go on duty for taxi!")
			TriggerClientEvent("usa:notify", userSource, "You don't have enough money to pay the security fee!")
			return
		end

		if timeout then
			print("player is on timeout and cannot go on duty for downtown taxi co!")
			TriggerClientEvent("usa:notify", userSource, "Can't retrieve another car! Please wait a little.")
			return
		end

		print("user " .. name .. " just is trying to go on duty for downtown taxi cab co.!")
		for i = 1, #user_licenses do
			local item = user_licenses[i]
			if string.find(item.name, "Driver") then
				print("DL found! checking validity")
				if item.status ~= "valid" then
					TriggerClientEvent("usa:notify", userSource, "Your license is suspended!")
					return
				end
				TriggerClientEvent("chatMessage", userSource, "", {}, "^3HELP: ^0You can use /dispatch [id] [msg] to set a waypoint to the caller id of the last taxi request.")
				user.setActiveCharacterData("job", "taxi")
				TriggerClientEvent("taxi:onDuty", userSource, name)
				-- take money --
				user.setActiveCharacterData("money", user_money - DUTY_FEE)
				-- give money to taxi shop owner --
				if property then
					TriggerEvent("properties:addMoney", property.name, DUTY_FEE)
				end

				timeout = true
				SetTimeout(15000, function()
					timeout = false
				end)
				return
			end
		end
		-- at this point, no valid DL was found
		TriggerClientEvent("usa:notify", userSource, "You don't have a valid driver's license!")
	end
end)
