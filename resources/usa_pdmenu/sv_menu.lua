local LEO_VEHICLES = {"code3cvpi","valor18charg", "valorfpis", "valor16fpiu", "valor20fpiu", "valor18tahoe", "valor21durango", "valor21tahoe", "valor15f150", "valorf250", "bwtrail", "pdcvpi", "pdtau", "pdchgr", "pdcharger", "pdexp", "pdfpiu", "sotruck", "hptahoe", "sheriff2", "policeb", "1200RT", "pbike", "chgr","fbi", "fbi2", "police4", "mustang19", "npolstang", "npolchal", "npolchar", "npolvette", "riot", "bearcatrb", "policet", "pbus", "14suvrb"}

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
	if user_job == "sheriff" or user_job == "corrections" or user_job == "ems" or user_job == "doctor" then
		TriggerClientEvent('pdmenu:openGarageMenu', source, JOB_VEHICLES[user_job], user_job)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on duty!.")
	end
end)

RegisterServerEvent("pdmenu:checkWhitelistForCustomization")
AddEventHandler("pdmenu:checkWhitelistForCustomization", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "corrections" or user_job == "ems" or user_job == "doctor" then
		TriggerClientEvent('pdmenu:openCustomizationMenu', source)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on duty!.")
	end
end)
