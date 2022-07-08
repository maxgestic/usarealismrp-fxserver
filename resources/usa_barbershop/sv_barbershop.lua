--# made by: minipunch
--# for: USA REALISM RP

local BARBER_FEE = 75

RegisterServerEvent("barber:loadCustomizations")
AddEventHandler("barber:loadCustomizations", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	TriggerEvent("es:exposeDBFunctions", function(db)
		db.getDocumentById("character-appearance", char.get("_id"), function(doc)
			if doc ~= false then
				local customizations = {
					headBlend = doc.headBlend,
					faceFeatures = doc.faceFeatures,
					headOverlays = doc.headOverlays,
					hair = doc.hair,
					eyeColor = doc.eyeColor
				}
				TriggerClientEvent("barber:loadCustomizations", char.get("source"), customizations)
			end
		end)
	end)
end)

RegisterServerEvent("barber:save")
AddEventHandler("barber:save", function(appearance, business)
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("money") >= BARBER_FEE then
		TriggerClientEvent("usa:notify", source, "~y~You paid: ~w~$" .. BARBER_FEE)
		if business then
			exports["usa-businesses"]:GiveBusinessCashPercent(business, BARBER_FEE)
		end
		saveAppearance(char.get("_id"), appearance)
	else
		TriggerClientEvent("usa:notify", source, "You don't have enough money to pay the total: $" .. BARBER_FEE)
	end
end)

function saveAppearance(charID, appearance)
	TriggerEvent("es:exposeDBFunctions", function(db)
		db.updateDocument("character-appearance", charID, appearance, function(doc) end, true)
	end)
end

exports["globals"]:PerformDBCheck("usa_barbershop", "character-appearance", nil)