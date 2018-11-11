RegisterServerEvent("emsstation2:loadDefaultUniform")
AddEventHandler("emsstation2:loadDefaultUniform", function()
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
		character = user.getEmsCharacter()
		TriggerClientEvent("emsstation2:setCharacter", userSource, character)
		TriggerClientEvent("emsstation2:giveDefaultLoadout", userSource)
    user.setActiveCharacterData("job", "ems")
    TriggerEvent("eblips:add", {name = user.getActiveCharacterData("fullName"), src = userSource, color = 1}, true)
	--end)
end)

RegisterServerEvent("emsstation2:saveasdefault")
AddEventHandler("emsstation2:saveasdefault", function(character)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local user_job = user.getActiveCharacterData("job")
		if user_job == "ems" or user_job == "fire" then
			--user.setCharacters(character)
			--print("PLAYER MODEL SAVED")
			user.setEmsCharacter(character) -- this is right... right??
			TriggerClientEvent("usa:notify", userSource, "Default ~b~EMS~w~ uniform saved.")
			--TriggerEvent("mini:giveMeMyWeaponsPlease")
		else
			TriggerClientEvent("usa:notify", userSource, "You need to be ~y~on duty~w~ to save default uniform.")
		end
	--end)
end)

RegisterServerEvent("emsstation2:onduty")
AddEventHandler("emsstation2:onduty", function()
    local userSource = tonumber(source)
    --TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local user = exports["essentialmode"]:getPlayerFromId(userSource)
        if user.getActiveCharacterData("job") ~= "ems" then
            user.setActiveCharacterData("job", "ems")
            TriggerEvent("eblips:add", {name = user.getActiveCharacterData("fullName"), src = userSource, color = 1}, true)
        end
    --end)
end)

RegisterServerEvent("emsstation2:offduty")
AddEventHandler("emsstation2:offduty", function()
    local userSource = tonumber(source)
		local user = exports["essentialmode"]:getPlayerFromId(userSource)
    --TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local playerWeapons = user.getActiveCharacterData("weapons")
        local chars = user.getCharacters()
        for i = 1, #chars do
          if chars[i].active == true then
            TriggerClientEvent("emsstation2:setciv", userSource, chars[i].appearance, playerWeapons) -- need to test
            break
          end
        end
        user.setActiveCharacterData("job", "civ")
        TriggerEvent("eblips:remove", userSource)
    --end)
end)

RegisterServerEvent("emsstation2:checkWhitelist")
AddEventHandler("emsstation2:checkWhitelist", function(clientevent)
	local playerIdentifiers = GetPlayerIdentifiers(source)
	local playerGameLicense = ""
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user.getActiveCharacterData("emsRank") > 0 then
			--TriggerClientEvent("policestation2:isWhitelisted", userSource)
			TriggerClientEvent(clientevent, userSource)
		else
			TriggerClientEvent("emsstation2:notify", userSource, "~y~You are not whitelisted for EMS. Apply at ~b~https://www.usarrp.net~w~.")
		end
	--end)

end)
