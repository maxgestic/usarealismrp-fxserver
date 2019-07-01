local VEHICLE_RANKS = {
	["sheriff"] = {
		["pdcvpi"] = 1,
		["pdtau"] = 2,
		["pdchrg"] = 2,
		["pdexp"] = 2,
		["pdtahoe"] = 2,
		["pdchrgum"] = 4
	},
	["ems"] = {
		["ambulance"] = 1,
		["pdexp"] = 2,
		["pranger"] = 2,
		["firetruk"] = 1,
		["polmav"] = 1
	},
	["dai"] = {
		["pdchrgum"] = 1
	}
}

RegisterServerEvent("pdmenu:checkWhitelist")
AddEventHandler("pdmenu:checkWhitelist", function(clientevent)
  local char = exports["usa-characters"]:GetCharacter(source)
  local user_job = char.get("job")
  if user_job == "sheriff" or user_job == "cop" or user_job == "dai" then
      TriggerClientEvent(clientevent, source)
  else
    TriggerClientEvent("usa:notify", source, "~y~You are not on-duty for POLICE.")
  end
end)

RegisterServerEvent('pdmenu:returnAllowedVehicles')
AddEventHandler('pdmenu:returnAllowedVehicles', function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
    local vehs = GetAllowedVehicles(user_job)
	TriggerClientEvent('pdmenu:sendAllowedVehicles', source, vehs)
end)

function GetAllowedVehicles(job)
    local vehs = {}
    for veh, rank in pairs(VEHICLE_RANKS[job]) do
        table.insert(vehs, veh)
    end
    return vehs
end
