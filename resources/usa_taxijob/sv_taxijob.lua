local DUTY_FEE = 100
local BASE_PAY = 150

RegisterServerEvent("taxiJob:payDriver")
AddEventHandler("taxiJob:payDriver", function(distance)
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("job") == "taxi" then
		local amountRewarded = math.ceil(BASE_PAY + (0.095 * distance))
		char.giveMoney(amountRewarded)
		TriggerClientEvent('usa:notify', source, 'Request completed, you have received: ~g~$'..amountRewarded..'.00')
		print("TAXI: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] has received amount["..amountRewarded..'] after distance['..distance..'] for taxi request!')
	else
		--DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
		--TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for attempting to exploit taxiJob:payDriver event, please intervene^0!')
		print("TAXI: SKETCHY TAXI payDriver event trigged by source " .. source .. "!!")
	end
end)

RegisterServerEvent("taxiJob:setJob")
AddEventHandler("taxiJob:setJob", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("job") == "taxi" then
		TriggerClientEvent("taxiJob:offDuty", source)
		char.set("job", "civ")
	else
		local money = char.get("money")
		if money <= DUTY_FEE then
			TriggerClientEvent("usa:notify", source, "You don't have enough money to pay the security fee!")
			return
		else
			local drivers_license = char.getItem("Driver's License")
			if drivers_license then
				if drivers_license.status == "valid" then
					char.removeMoney(DUTY_FEE)
					char.set("job", "taxi")
					TriggerClientEvent("taxiJob:onDuty", source)
					return
				else
					TriggerClientEvent("usa:notify", source, "Your driver's license is ~y~suspended~s~!")
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
	TriggerClientEvent("taxi:toggleNPCRequests", source)
end, {
	help = "Toggle receiving local taxi requests"
})
