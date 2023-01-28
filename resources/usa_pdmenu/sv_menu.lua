local LEO_VEHICLES = {"pcvpi","p14tesla","p16tau", "p18char", "p18xl", "p20exp", "p18tah", "p21dur", "p21tah", "sotruck", "1200RT", "policebikerb", "intchar", "npolstang", "npolchal", "npolvette", "tolplam", "fbi2", "bearcatrb", "14suvrb", "pbus", "policet", "police4"}

local JOB_VEHICLES = {
	["sasp"] = LEO_VEHICLES,
	["bcso"] = LEO_VEHICLES,
	["corrections"] = {"pdcvpi", "pbus"}
	["ems"] = {"fordambo", "e20exp", "p21tah", "pierce1", "lguard2", "blazer", "sotruck"},
	["doctor"] = {"p21tah"}
}

RegisterServerEvent("pdmenu:checkWhitelistForGarage")
AddEventHandler("pdmenu:checkWhitelistForGarage", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sasp" or user_job == "corrections" or user_job == "bcso" or user_job == "ems" or user_job == "doctor" then
		TriggerClientEvent('pdmenu:openGarageMenu', source, JOB_VEHICLES[user_job], user_job)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on duty!.")
	end
end)

RegisterServerEvent("pdmenu:checkWhitelistForCustomization")
AddEventHandler("pdmenu:checkWhitelistForCustomization", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sasp" or user_job == "corrections" or user_job == "bcso" or user_job == "ems" or user_job == "doctor" then
		TriggerClientEvent('pdmenu:openCustomizationMenu', source)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on duty!.")
	end
end)
