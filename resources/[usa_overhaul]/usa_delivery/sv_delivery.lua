local BASE_PAY = 30

RegisterServerEvent('gopostal:toggleDuty')
AddEventHandler('gopostal:toggleDuty', function(location)
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_job = user.getActiveCharacterData("job")
	local user_licenses = user.getActiveCharacterData("licenses")
	local has_dl = false
	if user_job == "gopostal" then
		print("DELIVERY: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] is now OFF-DUTY for DELIVERY")
		user.setActiveCharacterData("job", "civ")
		TriggerClientEvent("gopostal:onDuty", userSource, false, location)
	else
		for i = 1, #user_licenses do
		  local item = user_licenses[i]
		  if string.find(item.name, "Driver's License") then
			print("DELIVERY: Found item[Driver's License] on " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."], checking suspensions...")
			has_dl = true
			if item.status == "valid" then
				print("DELIVERY: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] is now ON-DUTY for DELIVERY")
				user.setActiveCharacterData("job", "gopostal")
				TriggerClientEvent("gopostal:onDuty", userSource, true, location)
				return
			else
				TriggerClientEvent("usa:notify", userSource, "Your driver's license is ~y~suspended~s~!")
				print("DELIVERY: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] has a suspended license!")
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

RegisterServerEvent('gopostal:payDriver')
AddEventHandler('gopostal:payDriver', function(distance)
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_money = user.getActiveCharacterData("money")
	local amountRewarded = math.ceil(BASE_PAY + (0.03 * distance))
	user.setActiveCharacterData("money", user_money + amountRewarded)
	TriggerClientEvent('usa:notify', userSource, 'Delivery completed, you have received: ~y~$'..amountRewarded..'.00')
	print("DELIVERY: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] has received amount["..amountRewarded..'] after distance['..distance..'] for delivery!')
end)

TriggerEvent('es:addJobCommand', 'quitdelivery', { "gopostal" }, function(source, args, user)
	TriggerClientEvent('gopostal:quitJob', source)
	local user_bank = user.getActiveCharacterData("bank")
	user.setActiveCharacterData("bank", user_bank - 200)
	TriggerClientEvent('usa:notify', source, 'You have been charged ~y~$200.0~s~ in loses.')
	print("DELIVERY: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] has quit their delivery job!")
end, {
	help = "Forcefully quit the current GoPostal job."
})