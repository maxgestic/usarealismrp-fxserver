local DB_NAME1 = "correctional_uniforms"
exports.globals:PerformDBCheck("usa_prison", DB_NAME1)
local DB_NAME2 = "bcso_uniforms"
exports.globals:PerformDBCheck("usa_prison", DB_NAME2)

TriggerEvent("es:exposeDBFunctions", function(db)
	db.getAllDocumentsFromDbLimit(DB_NAME2, 1, function(docs)
		if docs[1] == nil then
			db.getAllDocumentsFromDbLimit("correctionaldepartment", 100000, function(docs)
				for i,v in ipairs(docs) do
					print(i,v)
					local data = {
						["_id"] = docs[i]._id,
						["uniform"] = docs[i].uniform,
						["name"] = docs[i].name,
						["identifier"] = docs[i].identifier
					}
					exports.essentialmode:updateDocument(DB_NAME2, data._id, data, true)
				end
			end)
		end
	end)
end)

-- Check inmates remaining jail time --
TriggerEvent('es:addJobCommand', 'roster', {"sasp", "bcso", "corrections", "da", "judge"}, function(source, args, char)
	local hasInmates = false
	TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^1^*[BOLINGBROKE PENITENTIARY]")
	exports["usa-characters"]:GetCharacters(function(characters)
		for id, char in pairs(characters) do
			local time = char.get("jailTime")
			if time then
				if time > 0 then
					hasInmates = true
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^1 - ^0" .. char.getFullName() .. " ^1^*|^r^0 " .. time .. " month(s)")
				end
			end
		end
		if not hasInmates then
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^1 - ^0There are no inmates at this time")
		end
	end)
end, {
	help = "See who is booked into the prison."
})

----------------
-- the prison --
----------------
local cellblockOpen = false

TriggerEvent('es:addJobCommand', 'c', {"corrections"}, function(source, args, char)
	cellblockOpen = not cellblockOpen
	print("cellblock is now: " .. tostring(cellblockOpen))
	TriggerClientEvent('toggleJailDoors', -1, cellblockOpen)
end)

RegisterServerEvent("jail:checkJobForWarp")
AddEventHandler("jail:checkJobForWarp", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")
	if job == "sasp" or job == "ems" or job == "bcso" or job == "fire" or job == "corrections" or job == "doctor" then
		TriggerClientEvent("jail:continueWarp", source)
	else
		TriggerClientEvent("usa:notify", source, "That area is prohibited!")
	end
end)

RegisterServerEvent("prison:retrieveItems")
AddEventHandler("prison:retrieveItems", function()
	print("retrieving items!")
	local src = source
	local char = exports["usa-characters"]:GetCharacter(src)
	char.dropAllItems("license")
	local charid = char.get("_id")
	TriggerEvent('es:exposeDBFunctions', function(db)
		db.getDocumentById("prisonitemstorage", charid, function(inv)
			if not inv then
				print("error")
			else
				for i = 0, inv.inventory.MAX_CAPACITY do
					i = tostring(i)
					if inv.inventory.items[i] then
						char.giveItem(inv.inventory.items[i])
						inv.inventory.items[i] = nil
					end
				end
				TriggerClientEvent("usa:notify", src, "Here are your belongings back! Stay out of trouble!")
				db.deleteDocument("prisonitemstorage", charid, function(ok) end)
			end
		end)
	end)
end)

RegisterServerCallback {
	eventName = "jail:isInPrison",
	eventCallback = function(source)
		local char = exports["usa-characters"]:GetCharacter(source)
		return char.get("jailTime") > 0
	end
}