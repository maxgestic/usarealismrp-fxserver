RegisterServerEvent("dmv:checkMoney")
AddEventHandler("dmv:checkMoney", function(price)
	print("inside check money")
	local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		if user.getMoney() >= price then
			local licenses = user.getLicenses()
			for i = 1, #licenses do
				local license =  licenses[i]
				if  license.name == "Driver's License" then
					TriggerClientEvent("dmv:notify", userSource, "You already have a driver's license!")
					return
				end
			end
			print("no drivers license found! buying a new one!")
			-- no license found at this point, give player a license
			user.removeMoney(tonumber(price))
			local timestamp = os.date("*t", os.time())
			local license = {
				name = "Driver's License",
				number = "F" .. tostring(math.random(1, 2543678)),
				quantity = 1,
				ownerName = GetPlayerName(userSource),
				expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
				status = "valid"
			}
			table.insert(licenses, license)
			user.setLicenses(licenses)
			TriggerClientEvent("dmv:notify", userSource, "You have ~g~successfully~w~ purchased a driver's license.")
		else
			TriggerClientEvent("dmv:notify", userSource, "You don't have enough money to purchase a driver's license!")
		end
	end)
end)
