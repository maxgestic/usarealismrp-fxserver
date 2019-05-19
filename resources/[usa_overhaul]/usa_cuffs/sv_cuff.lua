TriggerEvent('es:addJobCommand', 'cuff', { "police", "sheriff", "corrections", "dai" }, function(source, args, user, location)
	local userSource = tonumber(source)
	if args[2] then -- id was passed as param
		local tPID = tonumber(args[2])
		if GetPlayerName(tPID) then
			TriggerClientEvent("cuff:Handcuff", tPID)
			TriggerClientEvent('cuff:playPoliceAnim', userSource, 2) -- play the 'other' anim
		end
	else -- no ID, find nearest person to target
		TriggerClientEvent("cuff:attemptToCuffNearest", userSource)
	end
		--play anim:
		--local anim = {
		--	dict = "anim@move_m@trash",
		--	name = "pickup"
		--}
		--TriggerClientEvent("usa:playAnimation", userSource, anim.name, anim.dict, 2)
		--TriggerClientEvent("usa:playAnimation", userSource, anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 1.5)]
		local msg = "handcuffs person"
		exports["globals"]:sendLocalActionMessage(userSource, msg)
end, {help = "Cuff the nearest player.", id = "ID # (Optional)"})

RegisterServerEvent("cuff:Handcuff")
AddEventHandler("cuff:Handcuff", function(id)
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(usource)
	--TriggerEvent("es:getPlayerFromId", usource, function(user)
	local playerJob = user.getActiveCharacterData("job")
		if playerJob == "sheriff" or playerJob == "cop" or playerJob == "corrections" then
			print("CUFFS: "..GetPlayerName(id).."["..GetPlayerIdentifier(id).."] has been cuffed/uncuffed by "..GetPlayerName(usource).."["..GetPlayerIdentifier(usource).."]")
			TriggerClientEvent("cuff:Handcuff", tonumber(id))
		end
	--end)
end)

RegisterServerEvent('cuff:triggerSuspectAnim')
AddEventHandler('cuff:triggerSuspectAnim', function(pedsource,x,y,z,heading)
    TriggerClientEvent('cuff:playSuspectAnim', pedsource,x,y,z,heading)
end)

TriggerEvent('es:addJobCommand', 'hc', {"police", "sheriff", "corrections", "dai"}, function(source, args, user, location)
	local userSource = tonumber(source)
	if args[2] then
		local sourceToHardcuff = tonumber(args[2])
		if GetPlayerName(sourceToHardcuff) then
			TriggerClientEvent('cuff:toggleHardcuff', sourceToHardcuff, true)
			local anim = {
		    dict = "anim@move_m@trash",
		    name = "pickup"
		    }
		    TriggerClientEvent("usa:playAnimation", userSource, anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 1.5)
		end
	end
end, {help = 'Hardcuff the player specified, player must be cuffed first.', params = {{name = "id", help = "Target player ID #"}}})

TriggerEvent('es:addJobCommand', 'sc', {"police", "sheriff", "corrections", "dai"}, function(source, args, user, location)
	local userSource = tonumber(source)
	if args[2] then
		local sourceToSoftcuff = tonumber(args[2])
		if GetPlayerName(sourceToSoftcuff) then
			TriggerClientEvent('cuff:toggleHardcuff', sourceToSoftcuff, false)
			local anim = {
		    dict = "anim@move_m@trash",
		    name = "pickup"
		    }
		    TriggerClientEvent("usa:playAnimation", userSource, anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 1.5)
		end
	end
end, {help = 'Softcuff the player specified, player must be cuffed first.', params = {{name = "id", help = "Target player ID #"}}})

RegisterServerEvent("cuff:checkWhitelist")
AddEventHandler("cuff:checkWhitelist", function(clientevent)
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_job = user.getActiveCharacterData("job")
  if user_job == "sheriff" or user_job == "cop" or user_job == "corrections" then
    TriggerClientEvent(clientevent, userSource)
  end
end)