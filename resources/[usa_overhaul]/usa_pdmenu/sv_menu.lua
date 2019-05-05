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
	[1] = {'chrg18b', 'chrg14b', 'cvpi11b', 'bison19', 'sheriff2', 'scorcher'},
	[2] = {'chrg18b', 'chrg14b', 'cvpi11b', 'bison19', 'sheriff2','scorcher', 'policet', 'tahoe'},
	[3] = {'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb'},
	[4] = {'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[5] = {'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[6] = {'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[7] = {'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[8] = {'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[9] = {'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[10] = {'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	}

RegisterServerEvent('pdmenu:returnAllowedVehicles')
AddEventHandler('pdmenu:returnAllowedVehicles', function()
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_rank = tonumber(user.getActiveCharacterData("policeRank"))
	local allowedVehicles = VEH_RANKS[user_rank]
	TriggerClientEvent('pdmenu:sendAllowedVehicles', userSource, allowedVehicles)
end)
