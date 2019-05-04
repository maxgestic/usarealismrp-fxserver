local DL_PRICE = 500

RegisterServerEvent("dmv:buyLicense")
AddEventHandler("dmv:buyLicense", function()
	print("inside check money")
	local userSource = source
	--TriggerEvent('es:getPlayerFromId', userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local user_money = user.getActiveCharacterData("money")
		if user_money >= DL_PRICE then
			local licenses = user.getActiveCharacterData("licenses")
			for i = 1, #licenses do
				local license =  licenses[i]
				if  license.name == "Driver's License" then
					TriggerClientEvent("usa:notify", userSource, "You already have a driver's license!")
					return
				end
			end
			print("no drivers license found! buying a new one!")
			-- no license found at this point, give player a license
			user.setActiveCharacterData("money", user_money - DL_PRICE)
			local timestamp = os.date("*t", os.time())
			local license = {
				name = "Driver\'s License",
				number = "F" .. tostring(math.random(1, 2543678)),
				quantity = 1,
				ownerName = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName"),
				ownerDob = user.getActiveCharacterData("dateOfBirth"),
				issued_by = 'Department of Motor Vehicles',
				expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
				status = "valid",
				notDroppable = true,
				type = "license"
			}
			table.insert(licenses, license)
			user.setActiveCharacterData("licenses", licenses)
			TriggerClientEvent("usa:notify", userSource, "You have ~g~successfully~w~ purchased a driver's license.")
		else
			TriggerClientEvent("usa:notify", userSource, "You don't have enough money to purchase a driver's license!")
		end
end)

RegisterServerEvent("dmv:setLicenseStatus")
AddEventHandler("dmv:setLicenseStatus", function(status, target_id, days)
	local user = exports["essentialmode"]:getPlayerFromId(target_id)
	local licenses = user.getActiveCharacterData("licenses")
	for i = 1, #licenses do
		local license =  licenses[i]
		if  license.name == "Driver's License" then
			licenses[i].status = status
			if status == "suspended" then
				licenses[i].suspension_start = os.time()
				licenses[i].suspension_days = days
				licenses[i].suspension_start_date = os.date('%m-%d-%Y %H:%M:%S', os.time())
			end
			print("license set to: " .. status)
			user.setActiveCharacterData("licenses", licenses)
			return
		end
	end
	print("person had no DL!")
end)

RegisterServerEvent("dmv:getLicenseStatus")
AddEventHandler("dmv:getLicenseStatus", function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local licenses = user.getActiveCharacterData("licenses")
	for i = 1, #licenses do
		local license =  licenses[i]
		if  license.name == "Driver's License" then
			if license.status == "suspended" then
				TriggerClientEvent("usa:notify", source, "Your license was suspended for ~y~" .. license.suspension_days .. " day(s)~s~ starting on ~y~" .. license.suspension_start_date)
			else
				TriggerClientEvent("usa:notify", source, "Your license is ~g~valid~w~!")
			end
			return
		end
	end
end)
