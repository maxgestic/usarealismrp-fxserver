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

RegisterServerEvent("mini:randomizeCharacter")
AddEventHandler("mini:randomizeCharacter", function()

	local upperBoundary = #(LOADOUTS["civ"].skins) or 0
	local skinName = LOADOUTS["civ"].skins[math.random(1, upperBoundary +1)] -- random civ skin

	TriggerClientEvent("mini:changeSkin", source, skinName)

end)

RegisterServerEvent("clothingStore:selectSkin")
AddEventHandler("clothingStore:selectSkin", function(index)

    if index > #LOADOUTS["civ"].skins then
        index = 1 -- first index (front)
        TriggerClientEvent("clothingStore:resetIndex", source)
    elseif index < 1 then
        index = #LOADOUTS["civ"].skins -- last index (back)
    end

    local skinName = LOADOUTS["civ"].skins[index]

    TriggerClientEvent("mini:changeSkin", source, skinName)

end)

RegisterServerEvent("mini:save")
AddEventHandler("mini:save", function(model)
	local userSource = source
	local idents = GetPlayerIdentifiers(userSource)
	TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            docid = result._id
            usersTable.updateDocument("essentialmode", docid ,{model = model},function() end)
			print("PLAYER MODEL SAVED = " .. model)
			TriggerClientEvent("clothingStore:notify", userSource, "Your player model has been ~y~saved!")
        end)
    end)
end)

RegisterServerEvent("mini:giveMeMyWeaponsPlease")
AddEventHandler("mini:giveMeMyWeaponsPlease", function()
	-- TODO: ADD A CHECK FOR PLAYER JOB, ONLY GIVE WEAPONS IF CIVILIAN
    print("inside of giveMeMyWeaponsPlease now!!")
	local playerWeapons
	local userSource = source
	local idents = GetPlayerIdentifiers(userSource)
	TriggerEvent('es:exposeDBFunctions', function(usersTable)
		usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
			docid = result._id
			playerWeapons = result.weapons
			print("#playerWeapons = " .. #playerWeapons)
			-- todo: ADD A CHECK FOR PLAYER JOB, ONLY GIVE WEAPONS IF CIVILIAN
			TriggerClientEvent("mini:giveWeapons", userSource, playerWeapons)
		end)
	end)
end)
