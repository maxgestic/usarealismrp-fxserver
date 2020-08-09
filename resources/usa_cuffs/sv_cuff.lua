TriggerEvent('es:addJobCommand', 'cuff', { "police", "sheriff", "corrections" }, function(src, args, char, location)
	if args[2] then -- id was passed as param
		local tPID = tonumber(args[2])
		if GetPlayerName(tPID) then
			local ped = GetPlayerPed(tPID)
			local callerPed = GetPlayerPed(src)
			local coords = GetEntityCoords(ped)
			local callerCoords = GetEntityCoords(callerPed)
			if exports.globals:getCoordDistance(coords, callerCoords) > 1.0 then
				TriggerClientEvent("usa:notify", src, "Too far to cuff!")
				return
			end
			local heading = GetEntityHeading(ped)
			local x, y, z = table.unpack(coords)
			TriggerEvent("cuff:Handcuff", tPID, x, y, z - 0.9, heading, src)
		end
	else -- no ID, find nearest person to target
		TriggerClientEvent("cuff:attemptToCuffNearest", src)
	end
	local msg = "handcuffs person"
	exports["globals"]:sendLocalActionMessage(src, msg)
end, {help = "Cuff the nearest player.", id = "ID # (Optional)"})

RegisterServerEvent("cuff:Handcuff")
AddEventHandler("cuff:Handcuff", function(id, x, y, z, playerHeading, src)
	if src then
		source = src -- allow to be called from server
	end
	local job = exports["usa-characters"]:GetCharacterField(source, "job")
	if job == "sheriff" or job == "corrections" then
		print("CUFFS: "..GetPlayerName(id).."["..GetPlayerIdentifier(id).."] has been cuffed/uncuffed by "..GetPlayerName(source).."["..GetPlayerIdentifier(source).."]")
		TriggerClientEvent("cuff:Handcuff", tonumber(id), source, x, y, z, playerHeading)
	end
end)

RegisterServerEvent('cuff:triggerSuspectAnim')
AddEventHandler('cuff:triggerSuspectAnim', function(pedsource,x,y,z,heading)
    TriggerClientEvent('cuff:playSuspectAnim', pedsource,x,y,z,heading)
end)

RegisterServerEvent('cuff:triggerAnimType')
AddEventHandler('cuff:triggerAnimType', function(id, type)
	TriggerClientEvent("cuff:playPoliceAnim", id, type)
end)

TriggerEvent('es:addJobCommand', 'hc', {"police", "sheriff", "corrections"}, function(source, args, char, location)
	if args[2] then
		local sourceToHardcuff = tonumber(args[2])
		if GetPlayerName(sourceToHardcuff) then
			TriggerClientEvent('cuff:toggleHardcuff', sourceToHardcuff, true)
			local anim = {
		    dict = "anim@move_m@trash",
		    name = "pickup"
		    }
		    TriggerClientEvent("usa:playAnimation", source, anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 1.5)
		end
	end
end, {help = 'Hardcuff the player specified, player must be cuffed first.', params = {{name = "id", help = "Target player ID #"}}})

TriggerEvent('es:addJobCommand', 'sc', {"police", "sheriff", "corrections"}, function(source, args, char, location)
	if args[2] then
		local sourceToSoftcuff = tonumber(args[2])
		if GetPlayerName(sourceToSoftcuff) then
			TriggerClientEvent('cuff:toggleHardcuff', sourceToSoftcuff, false)
			local anim = {
		    dict = "anim@move_m@trash",
		    name = "pickup"
		    }
		    TriggerClientEvent("usa:playAnimation", source, anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 1.5)
		end
	end
end, {help = 'Softcuff the player specified, player must be cuffed first.', params = {{name = "id", help = "Target player ID #"}}})

RegisterServerEvent("cuff:checkWhitelistForPlace")
AddEventHandler("cuff:checkWhitelistForPlace", function()
  local job = exports["usa-characters"]:GetCharacterField(source, "job")
  if job == "sheriff" or job == "corrections" or job == "ems" then
    TriggerClientEvent("place:attemptToPlaceNearest", source)
  end
end)

RegisterServerEvent("cuff:checkWhitelistForUnseat")
AddEventHandler("cuff:checkWhitelistForUnseat", function()
  local job = exports["usa-characters"]:GetCharacterField(source, "job")
  if job == "sheriff" or job == "corrections" or job == "ems" then
    TriggerClientEvent('place:attemptToUnseatNearest', source)
  end
end)

RegisterServerEvent("cuff:checkWhitelistForCuff")
AddEventHandler("cuff:checkWhitelistForCuff", function()
  local job = exports["usa-characters"]:GetCharacterField(source, "job")
  if job == "sheriff" or job == "corrections" then
    TriggerClientEvent('cuff:attemptToCuffNearest', source)
  end
end)