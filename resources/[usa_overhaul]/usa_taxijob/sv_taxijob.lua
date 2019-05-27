local DUTY_FEE = 100
local BASE_PAY = 20

RegisterServerEvent("taxiJob:payDriver")
AddEventHandler("taxiJob:payDriver", function(distance)
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("job") == "taxi" then
		local amountRewarded = math.ceil(BASE_PAY + (0.04 * distance))
		char.giveMoney("money", amountRewarded)
		TriggerClientEvent('usa:notify', source, 'Request completed, you have received: ~g~$'..amountRewarded..'.00')
		print("TAXI: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] has received amount["..amountRewarded..'] after distance['..distance..'] for taxi request!')
	else
		DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
    	TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for attempting to exploit taxiJob:payDriver event, please intervene^0!')
    end
end)

RegisterServerEvent("taxiJob:setJob")
AddEventHandler("taxiJob:setJob", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("job") == "taxi" then
		print("TAXI: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] is now OFF-DUTY for TAXI")
		TriggerClientEvent("taxiJob:offDuty", source)
		char.set("job", "civ")
	else
		local money = char.get("money")
		if money <= DUTY_FEE then
			print("TAXI: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] could not afford to go ON-DUTY for TAXI")
			TriggerClientEvent("usa:notify", source, "You don't have enough money to pay the security fee!")
			return
		else
			local drivers_license = char.getItem("Driver's License")
			if drivers_license then
				print("TAXI: Found item[Driver's License] on " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."], checking suspensions...")
				if drivers_license.status == "valid" then
					print("TAXI: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] is now ON-DUTY for TOW")
					Citizen.CreateThread(function()
						TriggerClientEvent("taxiJob:showHelpText", source, "Use ~y~/dispatch [id] [msg]~s~ to respond to a player taxi request!")
						Citizen.Wait(6000)
						TriggerClientEvent("taxiJob:showHelpText", source, "Use ~y~/togglerequests~s~ to allow or deny local taxi requests.")
						Citizen.Wait(6000)
						TriggerClientEvent("towJob:showHelpText", source, "Use ~y~/ping [id]~s~ to request a person\'s location.")
						Citizen.Wait(6000)
						TriggerClientEvent("taxiJob:showHelpText", source, "A taxi is waiting for you, use this vehicle while working.")
					end)
					char.removeMoney(DUTY_FEE)
					char.set("job", "taxi")
					TriggerClientEvent("taxiJob:onDuty", source)
					return
				else
					TriggerClientEvent("usa:notify", source, "Your driver's license is ~y~suspended~s~!")
					print("TAXI: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] has a suspended license!")
					return
				end
			else
				TriggerClientEvent("usa:notify", source, "You do not have a driver's license!")
				return
			end
		end
	end
end)

TriggerEvent('es:addJobCommand', 'togglerequests', {'taxi'}, function(source, args, char)
	print("TAXI: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] is toggling AI taxi requests!")
	TriggerClientEvent("taxiJob:toggleNPCRequests", source)
end, {
	help = "Toggle receiving local taxi requests"
})
