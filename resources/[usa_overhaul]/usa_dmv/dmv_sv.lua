local DL_PRICE = 250

RegisterServerEvent("dmv:buyLicense")
AddEventHandler("dmv:buyLicense", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local money = char.get("money")
	if money >= DL_PRICE then
		if char.hasItem("Driver's License") then
			TriggerClientEvent("usa:notify", source, "You already have a driver's license!")
			return
		end
		char.removeMoney(DL_PRICE)
		local timestamp = os.date("*t", os.time())
		local license = {
			name = "Driver\'s License",
			number = "F" .. tostring(math.random(1, 2543678)),
			quantity = 1,
			ownerName = char.getFullName(),
			ownerDob = char.get("dateOfBirth"),
			issued_by = 'Department of Motor Vehicles',
			expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
			status = "valid",
			notDroppable = true,
			type = "license",
			weight = 2.0
		}
		char.giveItem(license, 1)
		TriggerClientEvent("usa:notify", source, "You have ~g~successfully~w~ purchased a Driver's License.")
	else
		TriggerClientEvent("usa:notify", source, "You don't have enough money to purchase a Driver's License!")
	end
end)

RegisterServerEvent("dmv:setLicenseStatus")
AddEventHandler("dmv:setLicenseStatus", function(status, target_id, days)
	local char = exports["usa-characters"]:GetCharacter(source)
	local license = char.getItem("Driver's License")
	if license then
		char.modifyItem("Driver's License", "status", status)
		if license.status == "suspended" then
			char.modifyItem("Driver's License", "suspension_start", os.time())
			char.modifyItem("Driver's License", "suspension_days", days)
			char.modifyItem("Driver's License", "suspension_start_date", os.date('%m-%d-%Y %H:%M:%S', os.time()))
		end
	end
end)

RegisterServerEvent("dmv:getLicenseStatus")
AddEventHandler("dmv:getLicenseStatus", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local license = char.getItem("Driver's License")
	if license then
		if license.status == "suspended" then
			TriggerClientEvent("usa:notify", source, "Your license was suspended for ~y~" .. license.suspension_days .. " day(s)~s~ starting on ~y~" .. license.suspension_start_date)
		else
			TriggerClientEvent("usa:notify", source, "Your license is ~g~valid~w~!")
		end
	else
		TriggerClientEvent("usa:notify", source, "You do not own a Driver's License!")
	end
end)
