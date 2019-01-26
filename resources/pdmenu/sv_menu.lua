RegisterServerEvent("pdmenu:checkWhitelist")
AddEventHandler("pdmenu:checkWhitelist", function(clientevent)
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_job = user.getActiveCharacterData("job")
  if user_job == "sheriff" or user_job == "cop" then
    TriggerClientEvent(clientevent, userSource)
  else
    TriggerClientEvent("usa:notify", userSource, "~y~You are not on-duty for POLICE.")
  end
end)


---------- GARAGE MENU POLICE VEHICLES  ------------

local VEH_RANKS = {
	[1] = {"police", "police2", "police3", "police5", "scorcher", "police7", "pbus", "policet", "sheriff"},
	[2] = {"police", "police2", "police3", "police5", "scorcher", "police7", "policeb", "police6", "unmarked7", "pbus", "policet", "sheriff", "sheriff2"},
	[3] = {"police", "police2", "police3", "police5", "scorcher", "police7", "policeb", "police6", "unmarked7", "pbus", "policet", "sheriff", "sheriff2", "fbi2"},
	[4] = {"pranger", "police", "police2", "police3", "police5", "scorcher", "police7", "policeb", "police6", "unmarked1", "unmarked7", "unmarked8", "fbi", "fbi2", "police4", "sheriff", "pbus", "policet", "riot", "sheriff", "sheriff2"},
	[5] = {"pranger", "police", "police2", "police3", "police5", "scorcher", "police7", "policeb", "police6", "unmarked1", "unmarked6", "unmarked7", "unmarked8", "fbi", "fbi2", "police4", "sheriff", "unmarked3", "unmarked9", "pbus", "policet", "riot", "sheriff", "sheriff2"},
	[6] = {"pranger", 'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2','riot','scorcher','unmarked1','unmarked3','unmarked6','unmarked7','unmarked8','unmarked9', "sheriff", "sheriff2"},
	[7] = {"pranger", 'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2','riot','scorcher','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9', "sheriff", "sheriff2"},
	[8] = {"pranger", 'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2','riot','scorcher','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9', "sheriff", "sheriff2"},
	[9] = {"pranger", 'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2','riot','scorcher','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9', "sheriff", "sheriff2"},
	[10] = {"pranger", 'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2','riot','scorcher','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9', "sheriff", "sheriff2"}
	}

RegisterServerEvent('pdmenu:returnAllowedVehicles')
AddEventHandler('pdmenu:returnAllowedVehicles', function()
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_rank = tonumber(user.getActiveCharacterData("policeRank"))
	local allowedVehicles = VEH_RANKS[user_rank]
	TriggerClientEvent('pdmenu:sendAllowedVehicles', userSource, allowedVehicles)
end)
