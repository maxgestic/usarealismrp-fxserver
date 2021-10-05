local JOB_NAME = "corrections"

local WEAPONS = {
	{ hash = "WEAPON_NIGHTSTICK", type = "weapon", name = "Nightstick", rank = 1, weight = 4, price = 50},
    { hash = "WEAPON_FLASHLIGHT", type = "weapon", name = "Flashlight", rank = 1, weight = 4, price = 50},
    { hash = "WEAPON_STUNGUN", type = "weapon", name = "Stun Gun", rank = 1, weight = 5, price = 200},
    { hash = 1593441988, type = "weapon", name = "Glock", rank = 1, weight = 5, price = 200},
	{ name = "Heavy Pistol", type = "weapon", hash = GetHashKey("WEAPON_HEAVYPISTOL"), rank = 1, price = 400, weight = 7 },
	{ hash = -1600701090, type = "weapon", name = "Tear Gas", rank = 2, weight = 5, price = 150},
	{ name = "SMG", type = "weapon", hash = 736523883, rank = 2, price = 500, weight = 25 },
	{ name = "MK2 Pump Shotgun", type = "weapon", hash = 1432025498, rank = 2, price = 500, weight = 25 },
	{ name = "MK2 Carbine Rifle", type = "weapon", hash = 4208062921, rank = 2, price = 500, weight = 25},
	{ name = "SMG MK2", type = "weapon", hash = 0x78A97CD0, price = 750, rank = 2, weight = 20 },
	{ hash = 100416529,  type = "weapon", name = "Sniper Rifle", rank = 2, weight = 30, price = 2000},
	{ name = "Spike Strips", type = "misc", rank = 3 },
    { name = "Police Radio", type = "misc", rank = 1, price = 300, type = "misc", weight = 5 },
	{ name = "Stretcher", type = "misc", rank = 1, price = 400, type = "misc", weight = 35, invisibleWhenDropped = true },
	{ name = "7.62mm Bullets", type = "ammo", price = 50, weight = 0.5, quantity = 10 },
	{ name = "Empty 7.62mm Mag [10]", type = "magazine", price = 50, weight = 3, receives = "7.62mm", MAX_CAPACITY = 10, currentCapacity = 0 },
	{ name = "9mm Bullets", type = "ammo", price = 50, weight = 0.5, quantity = 10 },
	{ name = ".45 Bullets", type = "ammo", price = 50, weight = 0.5, quantity = 10 },
	{ name = "Empty .45 Mag [18]", type = "magazine", price = 50, weight = 3, receives = ".45", MAX_CAPACITY = 18, currentCapacity = 0 },
    { name = "Empty 9mm Mag [12]", type = "magazine", price = 50, weight = 3, receives = "9mm", MAX_CAPACITY = 12, currentCapacity = 0 },
    { name = "Empty 9mm Mag [30]", type = "magazine", price = 50, weight = 3, receives = "9mm", MAX_CAPACITY = 30, currentCapacity = 0 },
	{ name = "5.56mm Bullets", type = "ammo", price = 50, weight = 0.5, quantity = 20 },
    { name = "Empty 5.56mm Mag [30]", type = "magazine", price = 50, weight = 3, receives = "5.56mm", MAX_CAPACITY = 30, currentCapacity = 0 },
	{ name = "12 Gauge Shells", type = "ammo", price = 50, weight = 0.5, quantity = 10 }
}

for i = 1, #WEAPONS do
	WEAPONS[i].legality = "legal"
	if WEAPONS[i].type == "weapon" then
		WEAPONS[i].serviceWeapon = true
		WEAPONS[i].notStackable = true
	end
	if WEAPONS[i].type == "magazine" then
        WEAPONS[i].notStackable = true
    end
	if not WEAPONS[i].quantity then
		WEAPONS[i].quantity = 1
	end
end

local function GetWeaponAttachments(name)
    local attachments = {}
    if name == "MK2 Carbine Rifle" then
        table.insert(attachments, 'COMPONENT_AT_SIGHTS')
        table.insert(attachments, 'COMPONENT_AT_AR_FLSH')
        table.insert(attachments, 'COMPONENT_AT_AR_AFGRIP_02')
        --table.insert(attachments, 'COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ')
        table.insert(attachments, 'COMPONENT_AT_CR_BARREL_02')
        table.insert(attachments, 'COMPONENT_AT_MUZZLE_06')
    elseif name == "MK2 Pump Shotgun" then
        table.insert(attachments, 'COMPONENT_AT_SIGHTS')
        table.insert(attachments, 'COMPONENT_AT_AR_FLSH')
        --table.insert(attachments, 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT')
    elseif name == "Glock" then
        table.insert(attachments, 0x359B7AAE)
    elseif name == "SMG MK2" then
        table.insert(attachments, "COMPONENT_AT_AR_FLSH")
        table.insert(attachments, "COMPONENT_AT_SIGHTS_SMG")
    end
    return attachments
end

function getBCSORank(id, cb)
	TriggerEvent('es:exposeDBFunctions', function(db)
		db.getDocumentByRow("correctionaldepartment", "identifier" , GetPlayerIdentifiers(id)[1], function(doc)
			if doc and doc.rank then
				cb(doc.rank)
			else
				cb(nil)
			end
		end)
	end)
end

RegisterServerEvent("doc:getWeapons")
AddEventHandler("doc:getWeapons", function()
	TriggerClientEvent("doc:getWeapons", source, WEAPONS)
end)

-- Check inmates remaining jail time --
TriggerEvent('es:addJobCommand', 'roster', {"sheriff", "corrections", "da", "judge"}, function(source, args, char)
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

TriggerEvent('es:addJobCommand', 'c', {JOB_NAME}, function(source, args, char)
	cellblockOpen = not cellblockOpen
	print("cellblock is now: " .. tostring(cellblockOpen))
	TriggerClientEvent('toggleJailDoors', -1, cellblockOpen)
end)

RegisterServerEvent("jail:checkJobForWarp")
AddEventHandler("jail:checkJobForWarp", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")
	if job == "sheriff" or job == "ems" or job == "fire" or job == JOB_NAME or job == "doctor" then
		TriggerClientEvent("jail:continueWarp", source)
	else
		TriggerClientEvent("usa:notify", source, "That area is prohibited!")
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
	end, "GET", "", { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end

-- PERFORM FIRST TIME DB CHECK--
exports["globals"]:PerformDBCheck("correctionaldepartment", "correctionaldepartment", loadDOCEmployees)

RegisterServerEvent("doc:refreshEmployees")
AddEventHandler("doc:refreshEmployees", function()
	loadDOCEmployees()
end)

RegisterServerEvent("doc:checkWhitelist")
AddEventHandler("doc:checkWhitelist", function(loc)
	for i = 1, #DOC_EMPLOYEES do
		if DOC_EMPLOYEES[i].identifier == GetPlayerIdentifiers(source)[1] then
			if tonumber(DOC_EMPLOYEES[i].rank) <= 0 then
				print("DOC EMPLOYEE DID NOT EXIST")
				TriggerClientEvent("usa:notify", source, "You don't work here!")
			else
				print("DOC EMPLOYEE EXISTED")
				TriggerClientEvent("doc:open", source, loc)
			end
			return
		end
	end
	TriggerClientEvent("usa:notify", source, "You don't work here!")
end)

RegisterServerEvent("doc:offduty")
AddEventHandler("doc:offduty", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")
	-------------------------
	-- put back to civ job --
	-------------------------
	if job == JOB_NAME then
		TriggerEvent('job:sendNewLog', source, JOB_NAME, false)
	end
	--exports["usa_ems"]:RemoveServiceWeapons(char)
	char.set("job", "civ")
	TriggerClientEvent("usa:notify", source, "You have clocked out!")
	TriggerEvent("eblips:remove", source)
	TriggerClientEvent("interaction:setPlayersJob", source, "civ")
	local playerWeapons = char.getWeapons()
	local appearance = char.get("appearance")
	TriggerClientEvent("doc:setciv", source, appearance, playerWeapons)
	-----------------------------------
	-- change back into civ clothing --
	-----------------------------------
	--print("closing DOC menu!")
	TriggerClientEvent("doc:close", source)
	TriggerClientEvent("ptt:isEmergency", source, false)
	TriggerClientEvent("radio:unsubscribe", source)
end)

RegisterServerEvent("doc:forceDuty")
AddEventHandler("doc:forceDuty", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")
	if job ~= JOB_NAME then
		----------------------------
		-- set to corrections job --
		----------------------------
		char.set("job", JOB_NAME)
		TriggerEvent("doc:loadUniform", 1, source)
		TriggerClientEvent("usa:notify", source, "You have clocked in!")
		TriggerEvent('job:sendNewLog', source, JOB_NAME, true)
		TriggerClientEvent("ptt:isEmergency", source, true)
		TriggerClientEvent("interaction:setPlayersJob", source, JOB_NAME)
		TriggerEvent("eblips:add", {name = char.getName(), src = source, color = 82})
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
	TriggerEvent('es:exposeDBFunctions', function(db)
		db.getDocumentByRow("correctionaldepartment", "identifier" , player_identifer, function(result)
			local uniforms = result.uniform or {}
			uniforms[tostring(slot)] = uniform
			db.updateDocument("correctionaldepartment", result._id, {uniform = uniforms}, function()
				TriggerClientEvent("usa:notify", usource, "Uniform saved!")
			end)
		end)
	end)
end)

RegisterServerEvent("doc:loadOutfit")
AddEventHandler("doc:loadOutfit", function(slot, id)
	if id then source = id end
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(usource)
	local job = char.get("job")
	local player_identifer = GetPlayerIdentifiers(usource)[1]
	if job ~= JOB_NAME then
		char.set("job", JOB_NAME)
		TriggerEvent('job:sendNewLog', source, JOB_NAME, true)
		TriggerClientEvent("usa:notify", usource, "You have clocked in!")
		TriggerClientEvent("ptt:isEmergency", usource, true)
		TriggerClientEvent("interaction:setPlayersJob", usource, JOB_NAME)
		TriggerEvent("eblips:add", {name = char.getName(), src = usource, color = 82})
	end
	TriggerEvent('es:exposeDBFunctions', function(usersTable)
		usersTable.getDocumentByRow("correctionaldepartment", "identifier" , player_identifer, function(result)
			if result and result.uniform then
				TriggerClientEvent("doc:uniformLoaded", usource, result.uniform[tostring(slot)] or nil)
			end
		end)
	end)
end)

RegisterServerEvent("doc:spawnVehicle")
AddEventHandler("doc:spawnVehicle", function(veh)
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")
	if job == JOB_NAME then
		TriggerClientEvent("doc:spawnVehicle", source, veh)
	else
		TriggerClientEvent("usa:notify", source, "You are not on-duty!")
	end
end)

-- weapon rank check --
RegisterServerEvent("doc:checkRankForWeapon")
AddEventHandler("doc:checkRankForWeapon", function(weapon)
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(usource)
	local job = char.get("job")
	if job == JOB_NAME then
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			GetDoc.getDocumentByRow("correctionaldepartment", "identifier" , GetPlayerIdentifiers(usource)[1], function(result)
				if type(result) ~= "boolean" then
					weapon.rank = (weapon.rank or 1)
					if result.rank >= weapon.rank then
						if weapon.name == "Spike Strips" then
							TriggerEvent("spikestrips:equip", true, usource)
						else
							if char.canHoldItem(weapon) then
								if char.get("money") < weapon.price then
									TriggerClientEvent("usa:notify", usource, "Not enough money!")
									return
								end
								char.removeMoney(weapon.price)
								weapon.serialNumber = exports.globals:generateID()
								weapon.uuid = weapon.serialNumber
								weapon.components = GetWeaponAttachments(weapon.name)
								TriggerClientEvent("doc:equipWeapon", usource, weapon)
								char.giveItem(weapon)
								local weaponDB = {}
								weaponDB.name = weapon.name
								weaponDB.serialNumber = weapon.uuid
								weaponDB.ownerName = char.getFullName()
								weaponDB.ownerDOB = char.get('dateOfBirth')
								local timestamp = os.date("*t", os.time())
								weaponDB.issueDate = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year
								TriggerEvent('es:exposeDBFunctions', function(db)
								db.createDocumentWithId("legalweapons", weaponDB, weaponDB.serialNumber, function(success)
									if success then
										print("* Weapon created serial["..weaponDB.serialNumber.."] name["..weaponDB.name.."] owner["..weaponDB.ownerName.."] *")
									else
										print("* Error: Weapon failed to be created!! *")
									end
								end)
								end)
							else
								TriggerClientEvent("usa:notify", usource, "Inventory full!")
							end
						end
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

			local target = exports["usa-characters"]:GetCharacter(tonumber(args[2]))
			local employee = {
				identifier = GetPlayerIdentifiers(tonumber(args[2]))[1],
				name = target.getFullName(),
				rank = tonumber(args[3])
			}

			GetDoc.getDocumentByRow("correctionaldepartment", "identifier" , employee.identifier, function(result)
				if type(result) ~= "boolean" then
					GetDoc.updateDocument("correctionaldepartment", result._id, {rank = employee.rank}, function()
						TriggerClientEvent('chatMessage', usource, "", {255, 255, 255}, "^0Employee " .. employee.name .. "updated, rank: " .. employee.rank .. "!")
						loadDOCEmployees()
					end)
				else
					-- insert into db --
					GetDoc.createDocument("correctionaldepartment", employee, function()
						-- notify:
						TriggerClientEvent('chatMessage', usource, "", {255, 255, 255}, "^0Employee " .. employee.name .. "created, rank: " .. employee.rank .. "!")
						-- refresh employees:
						loadDOCEmployees()
					end)
				end
			end)
		end)
	end)
	
end, {
	help = "Whitelist a player for corrections",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "rank", help = "Rank" }
	}
})