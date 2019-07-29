local VEHICLE_RANKS = {
	["sheriff"] = {
		["pdcvpi"] = 1,
		["pdtau"] = 2,
		["pdchrg"] = 1,
		["pdchgr"] = 1,
		["pdexp"] = 2,
		["pdtahoe"] = 2,
		["pdchrgum"] = 5,
		["riot"] = 5,
		["policeb"] = 3
	},
	["ems"] = {
		["ambulance"] = 1,
		["paraexp"] = 2,
		["sheriff2"] = 2,
		["firetruk"] = 1,
		["lguard2"] = 1,
		["blazer"] = 1
	},
	["doctor"] = {
		["paraexp"] = 1,
		["sheriff2"] = 1
	}
}

local MODIFICATION_RANKS = {
	[11] = 2
}

RegisterServerEvent("pdmenu:checkRankForVehMod")
AddEventHandler("pdmenu:checkRankForVehMod", function(index, val, name)
	local rank = exports["usa-characters"]:GetCharacterField(source, "policeRank")
	if rank >= MODIFICATION_RANKS[index] then 
		TriggerClientEvent("pdmenu:checkRankForVehMod", source, index, val, name)
	else 
		TriggerClientEvent("usa:notify", source, "Must be trooper rank or above")
	end
end)

RegisterServerEvent("pdmenu:checkWhitelist")
AddEventHandler("pdmenu:checkWhitelist", function(clientevent)
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "cop" then
		TriggerClientEvent(clientevent, source)
	else
	TriggerClientEvent("usa:notify", source, "~y~You are not on-duty for POLICE.")
	end
end)

RegisterServerEvent('pdmenu:returnAllowedVehicles')
AddEventHandler('pdmenu:returnAllowedVehicles', function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	local myRank = char.get("policeRank")
    local vehs = GetAllowedVehicles(user_job, myRank)
	TriggerClientEvent('pdmenu:sendAllowedVehicles', source, vehs)
end)

function GetAllowedVehicles(job, myRank)
    local vehs = {}
	for veh, rank in pairs(VEHICLE_RANKS[job]) do
		if myRank >= rank then
			table.insert(vehs, veh)
		end
    end
    return vehs
end
