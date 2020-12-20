local LEO_VEHICLES = {"pdcvpi", "pdtau", "pdchrg", "pdchgr", "pdexp", "pdtahoe", "pdchrgum", "riot", "policeb", "fbi", "fbi2", "police4", "sheriff2", "1200RT"}

local JOB_VEHICLES = {
	["sheriff"] = LEO_VEHICLES,
	["corrections"] = LEO_VEHICLES,
	["ems"] = {"ambulance", "paraexp", "firetruk", "lguard2", "blazer"},
	["doctor"] = {"paraexp"}
}

RegisterServerEvent("pdmenu:checkWhitelistForGarage")
AddEventHandler("pdmenu:checkWhitelistForGarage", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "corrections" then
		TriggerClientEvent('pdmenu:openGarageMenu', source, JOB_VEHICLES[user_job])
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on-duty for POLICE.")
	end
end)

RegisterServerEvent("pdmenu:checkWhitelistForCustomization")
AddEventHandler("pdmenu:checkWhitelistForCustomization", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "corrections" then
		TriggerClientEvent('pdmenu:openCustomizationMenu', source)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on-duty for POLICE.")
	end
end)
