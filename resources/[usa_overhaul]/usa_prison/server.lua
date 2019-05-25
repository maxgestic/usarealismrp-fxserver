-- Check inmates remaining jail time --
TriggerEvent('es:addJobCommand', 'roster', {"corrections"}, function(source, args, user)
	local hasInmates = false
	TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^1^*[BOLINGBROKE PENITENTIARY]")
	TriggerEvent("es:getPlayers", function(players)
		for id, player in pairs(players) do
			if id and player then
				local time = player.getActiveCharacterData("jailtime")
				if time > 0 then
					hasInmates = true
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^1 - ^0" .. player.getActiveCharacterData("fullName") .. " ^1^*|^r^0 " .. time .. " month(s)")
				end
			end
		end
		if not hasInmates then
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^1 - ^0There are no inmates at this time")
		end
	end)
end)

----------------
-- the prison --
----------------
local cellblockOpen = false

TriggerEvent('es:addJobCommand', 'c', {"corrections"}, function(source, args, user)
	cellblockOpen = not cellblockOpen
	print("cellblock is now: " .. tostring(cellblockOpen))
	TriggerClientEvent('toggleJailDoors', -1, cellblockOpen)
end)

RegisterServerEvent("jail:checkJobForWarp")
AddEventHandler("jail:checkJobForWarp", function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local user_job = user.getActiveCharacterData("job")
	if user_job == "sheriff" or user_job == "ems" or user_job == "fire" or user_job == "corrections" then
		TriggerClientEvent("jail:continueWarp", source)
	else
		TriggerClientEvent("usa:notify", source, "That area is prohibited!")
		print("user tried to enter prohibited prison area! job was: " .. user_job)
	end
end)

------------------------------
-- correctional officer job --
------------------------------
local DOC_EMPLOYEES = {}

function loadDOCEmployees()
	print("Fetching all DOC employees.")
	PerformHttpRequest("http://127.0.0.1:5984/correctionaldepartment/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		print("Finished getting DOC employees.")
		print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			DOC_EMPLOYEES = {} -- reset table
			print("#(response.rows) = " .. #(response.rows))
			-- insert all warrants from 'warrants' db into lua table
			for i = 1, #(response.rows) do
				table.insert(DOC_EMPLOYEES, response.rows[i].doc)
			end
			print("Finished loading DOC employees.")
			print("# of DOC employees: " .. #DOC_EMPLOYEES)
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end

-- PERFORM FIRST TIME DB CHECK--
exports["globals"]:PerformDBCheck("correctionaldepartment", "correctionaldepartment", loadDOCEmployees)

RegisterServerEvent("doc:refreshEmployees")
AddEventHandler("doc:refreshEmployees", function()
	loadDOCEmployees()
end)

RegisterServerEvent("doc:checkWhitelist")
AddEventHandler("doc:checkWhitelist", function(loc)
	local usource = source
	for i = 1, #DOC_EMPLOYEES do
		if DOC_EMPLOYEES[i].identifier == GetPlayerIdentifiers(usource)[1] then
			if tonumber(DOC_EMPLOYEES[i].rank) <= 0 then
				print("DOC EMPLOYEE DID NOT EXIST")
				TriggerClientEvent("usa:notify", usource, "You don't work here!")
			else
				print("DOC EMPLOYEE EXISTED")
				local user = exports["essentialmode"]:getPlayerFromId(usource)
				TriggerClientEvent("doc:open", usource)
			end
			return
		end
	end
	print("DOC EMPLOYEE DID NOT EXIST")
	TriggerClientEvent("usa:notify", source, "You don't work here!")
end)

RegisterServerEvent("doc:offduty")
AddEventHandler("doc:offduty", function()
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(usource)
	local job = user.getActiveCharacterData("job")
	-------------------------
	-- put back to civ job --
	-------------------------
	if job == "corrections" then
		TriggerEvent('job:sendNewLog', source, 'corrections', false)
	end
	user.setActiveCharacterData("job", "civ")
	TriggerClientEvent("usa:notify", usource, "You have clocked out!")
	TriggerEvent("eblips:remove", usource)
	TriggerClientEvent("interaction:setPlayersJob", usource, "civ")
	local playerWeapons = user.getActiveCharacterData("weapons")
	local chars = user.getCharacters()
	for i = 1, #chars do
		if chars[i].active == true then
			TriggerClientEvent("doc:setciv", usource, chars[i].appearance, playerWeapons)
			break
		end
	end
	-----------------------------------
	-- change back into civ clothing --
	-----------------------------------
	--print("closing DOC menu!")
	TriggerClientEvent("doc:close", usource)
	-- PTT --
	TriggerClientEvent("ptt:isEmergency", usource, false)
end)

RegisterServerEvent("doc:forceDuty")
AddEventHandler("doc:forceDuty", function()
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(usource)
	local job = user.getActiveCharacterData("job")
	if job ~= "corrections" then
		----------------------------
		-- set to corrections job --
		----------------------------
		user.setActiveCharacterData("job", "corrections")
		TriggerEvent("doc:loadUniform", 1, usource)
		TriggerClientEvent("usa:notify", usource, "You have clocked in!")
		TriggerEvent('job:sendNewLog', source, 'corrections', true)
		TriggerClientEvent("ptt:isEmergency", usource, true)
		TriggerClientEvent("interaction:setPlayersJob", usource, "corrections")
		TriggerEvent("eblips:add", {name = user.getActiveCharacterData("fullName"), src = usource, color = 82})
	end
end)

RegisterServerEvent("doc:refreshEmployees")
AddEventHandler("doc:refreshEmployees", function()
	loadDOCEmployees()
end)

RegisterServerEvent("doc:saveOutfit")
AddEventHandler("doc:saveOutfit", function(uniform, slot)
	local usource = source
	local player_identifer = GetPlayerIdentifiers(usource)[1]
	TriggerEvent('es:exposeDBFunctions', function(usersTable)
		usersTable.getDocumentByRow("correctionaldepartment", "identifier" , player_identifer, function(result)
			local uniforms = result.uniform or {}
			uniforms[slot] = uniform
			TriggerEvent('es:exposeDBFunctions', function(usersTable)
				usersTable.getDocumentByRow("correctionaldepartment", "identifier" , player_identifer, function(result)
					docid = result._id
					usersTable.updateDocument("correctionaldepartment", docid, {uniform = uniforms}, function()
						TriggerClientEvent("usa:notify", usource, "Uniform saved!")
					end)
				end)
			end)
		end)
	end)
end)

RegisterServerEvent("doc:loadOutfit")
AddEventHandler("doc:loadOutfit", function(slot, id)
	if id then source = id end
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(usource)
	local job = user.getActiveCharacterData("job")
	local player_identifer = GetPlayerIdentifiers(usource)[1]
	if job ~= "corrections" then
		user.setActiveCharacterData("job", "corrections")
		TriggerEvent('job:sendNewLog', source, 'corrections', true)
		TriggerClientEvent("usa:notify", usource, "You have clocked in!")
		TriggerClientEvent("ptt:isEmergency", usource, true)
		TriggerClientEvent("interaction:setPlayersJob", usource, "corrections")
		TriggerEvent("eblips:add", {name = user.getActiveCharacterData("fullName"), src = usource, color = 82})
	end
	TriggerEvent('es:exposeDBFunctions', function(usersTable)
		usersTable.getDocumentByRow("correctionaldepartment", "identifier" , player_identifer, function(result)
			if result and result.uniform then
				TriggerClientEvent("doc:uniformLoaded", usource, result.uniform[slot] or nil)
			end
		end)
	end)
end)

RegisterServerEvent("doc:spawnVehicle")
AddEventHandler("doc:spawnVehicle", function(hash)
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(usource)
	local job = user.getActiveCharacterData("job")
	if job == "corrections" then
		TriggerClientEvent("doc:spawnVehicle", usource, hash)
	else
		TriggerClientEvent("usa:notify", usource, "You are not on-duty!")
	end
end)

-- weapon rank check --
RegisterServerEvent("doc:checkRankForWeapon")
AddEventHandler("doc:checkRankForWeapon", function(weapon)
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(usource)
	local job = user.getActiveCharacterData("job")
	if job == "corrections" then
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			GetDoc.getDocumentByRow("correctionaldepartment", "identifier" , GetPlayerIdentifiers(usource)[1], function(result)
				if type(result) ~= "boolean" then
					print("result.rank: " .. result.rank)
					print("weapon.rank: " .. weapon.rank)
					if result.rank >= weapon.rank then
						TriggerClientEvent("doc:equipWeapon", usource, weapon)
						return
					else
						TriggerClientEvent("usa:notify", usource, "Not a high enough rank!")
					end
				else
					print("Error: failed to get employee from db")
				end
			end)
		end)
	else
		TriggerClientEvent("usa:notify", usource, "You are not on-duty!")
	end
end)

-- adding new DOC employees --
TriggerEvent('es:addJobCommand', 'setcorrectionsrank', {"corrections"}, function(source, args, user)
	local usource = source
	if not GetPlayerName(tonumber(args[2])) or not tonumber(args[3]) then
		TriggerClientEvent("usa:notify", source, "Error: bad format!")
		return
	end
	local whitelister_identifier = GetPlayerIdentifiers(usource)[1]
	TriggerEvent('es:exposeDBFunctions', function(GetDoc)
		GetDoc.getDocumentByRow("correctionaldepartment", "identifier" , whitelister_identifier, function(result)

			if type(result) == "boolean" then
				return
			end

			if result.rank < 4 then
				TriggerClientEvent("usa:notify", usource, "Not a high enough rank!")
				return
			end

			if result.rank <= tonumber(args[3]) then
				TriggerClientEvent("usa:notify", usource, "Not a high enough rank!")
				return
			end

			local target = exports["essentialmode"]:getPlayerFromId(tonumber(args[2]))
			local employee = {
				identifier = GetPlayerIdentifiers(tonumber(args[2]))[1],
				name = target.getActiveCharacterData("fullName"),
				rank = tonumber(args[3])
			}

			GetDoc.getDocumentByRow("correctionaldepartment", "identifier" , employee.identifier, function(result)
				print("type: " .. type(result))
				if type(result) ~= "boolean" then
					GetDoc.updateDocument("correctionaldepartment", result._id, {rank = employee.rank}, function()
						print("rank updated to: " .. employee.rank)
						TriggerClientEvent('chatMessage', usource, "", {255, 255, 255}, "^0Employee " .. employee.name .. "updated, rank: " .. employee.rank .. "!")
						loadDOCEmployees()
					end)
				else
					-- insert into db --
					GetDoc.createDocument("correctionaldepartment", employee, function()
						print("employee created!")
						-- notify:
						TriggerClientEvent('chatMessage', usource, "", {255, 255, 255}, "^0Employee " .. employee.name .. "created, rank: " .. employee.rank .. "!")
						-- refresh employees:
						loadDOCEmployees()
					end)
				end
			end)

		end)
	end)
end)
