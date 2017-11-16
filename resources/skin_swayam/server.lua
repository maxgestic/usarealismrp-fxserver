function getPlayerIdentifierEasyMode(source)
	local rawIdentifiers = GetPlayerIdentifiers(source)
	if rawIdentifiers then
		for key, value in pairs(rawIdentifiers) do
			playerIdentifier = value
		end
    else
		print("IDENTIFIERS DO NOT EXIST OR WERE NOT RETIREVED PROPERLY")
	end
	return playerIdentifier -- should usually be only 1 identifier according to the wiki
end

RegisterServerEvent("mini:save")
AddEventHandler("mini:save", function(appearance)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local characters = user.getCharacters()
		for i = 1, #characters do
			print("characters[i].active = " .. tostring(characters[i].active))
			if characters[i].active == true then
				characters[i].appearance = appearance
				user.setCharacter(characters[i], i)
				print("PLAYER MODEL SAVED")
				TriggerClientEvent("chatMessage", source, "SYSTEM", {0, 128, 255}, "Your player character has been saved.")
				return
			end
		end
		--TriggerEvent("mini:giveMeMyWeaponsPlease")
	end)
end)

RegisterServerEvent("mini:giveMeMyWeaponsPlease")
AddEventHandler("mini:giveMeMyWeaponsPlease", function()

    local inventory

    print("inside of giveMeMyWeaponsPlease now!!")
	print("source = " .. source)
	print("typeof source = " .. type(source))

    -- Gives the loaded user corresponding to the given player id(second argument).
    TriggerEvent('es:getPlayerFromId', source, function(user)
		if user then
            local playerWeapons = user.getActiveCharacterData("weapons")
            print("#playerWeapons = " .. #playerWeapons)
            -- todo: ADD A CHECK FOR PLAYER JOB, ONLY GIVE WEAPONS IF POLICE
            TriggerClientEvent("CS:giveWeapons", source, playerWeapons)
		else
			print("no user found!")
		end
    end)

end)
