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
				exports["essentialmode"]:getPlayerFromId(usource).setActiveCharacterData("job", "corrections")
				TriggerClientEvent("usa:notify", usource, "You clocked in!")
				TriggerClientEvent("doc:open", usource)
				TriggerClientEvent("ptt:isEmergency", usource, true)
			end
			return
		end
	end
	print("DOC EMPLOYEE DID NOT EXIST")
	TriggerClientEvent("usa:notify", source, "You don't work here!")
end)

RegisterServerEvent("doc:clockOut")
AddEventHandler("doc:clockOut", function()
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(usource)
	local job = user.getActiveCharacterData("job")
	-------------------------
	-- put back to civ job --
	-------------------------
	user.setActiveCharacterData("job", "civ")
	TriggerClientEvent("usa:notify", usource, "You have clocked out!")
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
		TriggerEvent("doc:loadUniform", usource)
		TriggerClientEvent("usa:notify", usource, "You have clocked in!")
		TriggerClientEvent("ptt:isEmergency", usource, true)
	end
end)

RegisterServerEvent("doc:refreshEmployees")
AddEventHandler("doc:refreshEmployees", function()
	loadDOCEmployees()
end)

RegisterServerEvent("doc:saveUniform")
AddEventHandler("doc:saveUniform", function(uniform)
	local usource = source
	local player_identifer = GetPlayerIdentifiers(usource)[1]
	TriggerEvent('es:exposeDBFunctions', function(usersTable)
		usersTable.getDocumentByRow("correctionaldepartment", "identifier" , player_identifer, function(result)
			docid = result._id
			usersTable.updateDocument("correctionaldepartment", docid, {uniform = uniform}, function()
				TriggerClientEvent("usa:notify", usource, "Uniform saved!")
			end)
		end)
	end)
end)

RegisterServerEvent("doc:loadUniform")
AddEventHandler("doc:loadUniform", function(id)
	if id then source = id end
	local usource = source
	local player_identifer = GetPlayerIdentifiers(usource)[1]
	TriggerEvent('es:exposeDBFunctions', function(usersTable)
		usersTable.getDocumentByRow("correctionaldepartment", "identifier" , player_identifer, function(result)
			TriggerClientEvent("doc:uniformLoaded", usource, result.uniform or nil)
		end)
	end)
end)

-- weapon rank check --
RegisterServerEvent("doc:checkRankForWeapon")
AddEventHandler("doc:checkRankForWeapon", function(weapon)
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(usource)
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
