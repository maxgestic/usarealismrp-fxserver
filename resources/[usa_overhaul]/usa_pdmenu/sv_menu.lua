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


---------- GARAGE MENU POLICE VEHICLES  ------------

local VEH_RANKS = {
	[1] = {'taurus16b', 'chrg18b', 'chrg14b', 'cvpi11b', 'bison19', 'sheriff2', 'scorcher'},
	[2] = {'taurus16b', 'chrg18b', 'chrg14b', 'cvpi11b', 'bison19', 'sheriff2','scorcher', 'policet', 'tahoe'},
	[3] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb'},
	[4] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[5] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[6] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[7] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[8] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[9] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	[10] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19'},
	['dai'] = {'schafter19', 'buffalo19', 'baller19', 'oracle19', 'taurus16a', 'chrg14a', 'chrg18a', 'cvpi11a'}
}

RegisterServerEvent('pdmenu:returnAllowedVehicles')
AddEventHandler('pdmenu:returnAllowedVehicles', function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "dai" then
		TriggerClientEvent('pdmenu:sendAllowedVehicles', source, VEH_RANKS['dai'])
	else
		local user_rank = tonumber(char.get("policeRank"))
		local allowedVehicles = VEH_RANKS[user_rank]
		TriggerClientEvent('pdmenu:sendAllowedVehicles', source, allowedVehicles)
	end
end)
