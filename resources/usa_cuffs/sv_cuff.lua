TriggerEvent('es:addJobCommand', 'cuff', { "police", "sheriff", "corrections", "dai" }, function(source, args, char, location)
	if args[2] then -- id was passed as param
		local tPID = tonumber(args[2])
		if GetPlayerName(tPID) then
			TriggerClientEvent("cuff:Handcuff", tPID)
			TriggerClientEvent('cuff:playPoliceAnim', source, 2) -- play the 'other' anim
		end
	else -- no ID, find nearest person to target
		TriggerClientEvent("cuff:attemptToCuffNearest", source)
	end
	local msg = "handcuffs person"
	exports["globals"]:sendLocalActionMessage(source, msg)
end, {help = "Cuff the nearest player.", id = "ID # (Optional)"})

RegisterServerEvent("cuff:Handcuff")
AddEventHandler("cuff:Handcuff", function(id)
	local job = exports["usa-characters"]:GetCharacterField(source, "job")
	if job == "sheriff" or job == "cop" or job == "corrections" or job == "dai" then
		print("CUFFS: "..GetPlayerName(id).."["..GetPlayerIdentifier(id).."] has been cuffed/uncuffed by "..GetPlayerName(source).."["..GetPlayerIdentifier(source).."]")
		TriggerClientEvent("cuff:Handcuff", tonumber(id))
	end
end)

RegisterServerEvent('cuff:triggerSuspectAnim')
AddEventHandler('cuff:triggerSuspectAnim', function(pedsource,x,y,z,heading)
    TriggerClientEvent('cuff:playSuspectAnim', pedsource,x,y,z,heading)
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
  if job == "sheriff" or job == "cop" or job == "corrections" or job == "dai" then
    TriggerClientEvent("place:attemptToPlaceNearest", source)
  end
end)

RegisterServerEvent("cuff:checkWhitelistForUnseat")
AddEventHandler("cuff:checkWhitelistForUnseat", function()
  local job = exports["usa-characters"]:GetCharacterField(source, "job")
  if job == "sheriff" or job == "cop" or job == "corrections" or job == "dai" then
    TriggerClientEvent('place:attemptToUnseatNearest', source)
  end
end)