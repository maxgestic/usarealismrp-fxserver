local DUTY_FEE = 100
local BASE_PAY = 20

RegisterServerEvent("taxiJob:payDriver")
AddEventHandler("taxiJob:payDriver", function(distance)
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_money = user.getActiveCharacterData("money")
	local amountRewarded = math.ceil(BASE_PAY + (0.04 * distance))
	user.setActiveCharacterData("money", user_money + amountRewarded)
	TriggerClientEvent('usa:notify', userSource, 'Request completed, you have received: ~y~$'..amountRewarded..'.00')
	print("TAXI: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] has received amount["..amountRewarded..'] after distance['..distance..'] for taxi request!')
end)

RegisterServerEvent("taxiJob:setJob")
AddEventHandler("taxiJob:setJob", function()
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_job = user.getActiveCharacterData("job")
	local user_licenses = user.getActiveCharacterData("licenses")
	local user_money = user.getActiveCharacterData("money")
	local has_dl = false
	if user_job == "taxi" then
		print("TAXI: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] is now OFF-DUTY for TAXI")
		user.setActiveCharacterData("job", "civ")
		TriggerClientEvent("taxiJob:offDuty", userSource)
	else
		if user_money <= DUTY_FEE then
			print("TAXI: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] could not afford to go ON-DUTY for TAXI")
			TriggerClientEvent("usa:notify", userSource, "You don't have enough money to pay the security fee!")
			return
		end
		for i = 1, #user_licenses do
		  local item = user_licenses[i]
		  if string.find(item.name, "Driver's License") then
			print("TAXI: Found item[Driver's License] on " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."], checking suspensions...")
			has_dl = true
			if item.status == "valid" then
				print("TAXI: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] is now ON-DUTY for TOW")
				Citizen.CreateThread(function()
					TriggerClientEvent("taxiJob:showHelpText", userSource, "Use ~y~/dispatch [id] [msg]~s~ to respond to a player taxi request!")
					Citizen.Wait(6000)
					TriggerClientEvent("taxiJob:showHelpText", userSource, "Use ~y~/togglerequests~s~ to allow or deny local taxi requests.")
					Citizen.Wait(6000)
					TriggerClientEvent("towJob:showHelpText", userSource, "Use ~y~/ping [id]~s~ to request a person\'s location.")
					Citizen.Wait(6000)
					TriggerClientEvent("taxiJob:showHelpText", userSource, "A taxi is waiting for you, use this vehicle while working.")
				end)
				user.setActiveCharacterData("money", user_money - DUTY_FEE)
				user.setActiveCharacterData("job", "taxi")
				TriggerClientEvent("taxiJob:onDuty", userSource)
				return
			else
				TriggerClientEvent("usa:notify", userSource, "Your driver's license is ~y~suspended~s~!")
				print("TAXI: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] has a suspended license!")
				return
			end
		  end
		end
		if not has_dl then
			TriggerClientEvent("usa:notify", userSource, "You do not have a driver's license!")
			return
		end
	end
end)

TriggerEvent('es:addJobCommand', 'togglerequests', {'taxi'}, function(source, args, user)
	local userSource = source
	print("TAXI: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] is toggling AI taxi requests!")
	TriggerClientEvent("taxiJob:toggleNPCRequests", userSource)
end, {
	help = "Toggle receiving local taxi requests"
})
