--# Created by: minipunch
--# for USA REALISM rep
--# requres 'globals' resource to send notifications and usa_rp to change their model, check their jail time on join, and stuff like that

-- Each cell block floor starts from the leftmost cell and wraps around until finished (cell numbers)
local CELLS = {
	{x = 1700.0605, y = 2462.5879, z = 45.8467, occupant = nil, security = "low"}, -- Low Cell 1
	{x=1696.7504, y=2463.1870, z=45.8465, occupant = nil, security = "low"},
	{x = 1763.8583, y = 2499.2280, z = 45.8226, occupant = nil, security = "high"}, -- Medium Cell 1
	{x = 1590.2433, y = 2542.5283, z = 45.9880, occupant = nil, security = "solitary"}, -- Solitary Cell 1
}

local tempcells = {
	["low"]= {x = 1700.0605, y = 2462.5879, z = 45.8467, occupant = nil, security = "low", tempcell = true},
	["high"]= {x = 1763.8583, y = 2499.2280, z = 45.8226, occupant = nil, security = "high", tempcell = true},
	["solitary"]= {x = 1590.2433, y = 2542.5283, z = 45.9880, occupant = nil, security = "solitary", tempcell = true}
}

TriggerEvent('es:addJobCommand', 'listcells', {"corrections"}, function(source, args, char)
	TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^1^*[BOLINGBROKE PENITENTIARY] " .. #CELLS)
	for i,v in ipairs(CELLS) do
		if v.occupant ~= nil then
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, " - "..v.security.." Inmate: "..v.occupant.name)
		end
	end
end, {
	help = "See Occpupied Cells"
})


local default_low = nil
local default_high = nil
local default_solitary = nil

for i,v in ipairs(CELLS) do
	if v.security == "low" and default_low == nil then
		default_low = i
	end
	if v.security == "high" and default_high == nil then
		default_high = i
	end
	if v.security == "solitary" and default_solitary == nil then
		default_solitary = i
	end
end

print(default_low, default_high, default_solitary)

local Prison_Locations = {
	{ coords = vector3(1689.3699951172, 2592.8100585938, 45.668334960938), distance = 140 },
	{ coords = vector3(1691.1254882813, 2540.8515625, 45.564823150635), distance = 100 },
	{ coords = vector3(1841.5126953125, 2594.3278808594, 46.014324188232), distance = 10 }
}

local alarm_on = false

local DB_NAME = "prisonitemstorage"

exports["globals"]:PerformDBCheck("usa_jail", DB_NAME)

local function isAtPrisonLocation(coords)
	for i = 1, #Prison_Locations do
		if #(coords - Prison_Locations[i].coords) < Prison_Locations[i].distance then
			return true
		end
	end
	return false
end

-- V2
TriggerEvent('es:addCommand', 'jail', function(source, args, char)
	local job = char.get("job")
	local jailtime = char.get("jailTime")
	if job == "sasp" or job == "bcso" or job == "corrections" or job == "judge" then
		if isAtPrisonLocation(GetEntityCoords(GetPlayerPed(source))) then
			TriggerClientEvent("jail:openMenu", tonumber(source))
		else
			TriggerClientEvent("usa:notify", source, "You are not at the Prison!")
		end
	elseif jailtime > 0 then
		TriggerClientEvent("usa:notify", tonumber(source), "You have ~y~" .. jailtime .. " month(s) ~w~left in your jail sentence.")
	end
end, {
	help = "See how much time you have left in jail / jail a player (police)"
})

-- Check inmates remaining jail time --
TriggerEvent('es:addJobCommand', 'roster', {"sasp", "bcso", "corrections", "da", "judge"}, function(source, args, char)
	local hasInmates = false
	TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^1^*[BOLINGBROKE PENITENTIARY]")
	local inmates = get_inmates()
	for id, char in pairs(inmates) do
		local time = char.get("jailTime")
		if time then
			if time > 0 then
				hasInmates = true
				local security = getInmateSecurity(char.get("source"))
				security = security:gsub("^%l", string.upper)
				TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^1 - ^0" .. char.getFullName() .. " (".. char.get("source") ..") ^1^*|^r^0 " .. time .. " month(s) ^1^*|^r^0 Security: "..security)
			end
		end
	end
	if not hasInmates then
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^1 - ^0There are no inmates at this time")
	end
end, {
	help = "See who is booked into the prison."
})

-- Check inmates remaining jail time --
TriggerEvent('es:addJobCommand', 'rebook', {"corrections"}, function(source, args, char)
	local id = args[2]
	local data = nil
	if id ~= nil then
		local inmates = get_inmates()
		local isInmate = false
		for i,v in ipairs(inmates) do
			if v.get("source") == tonumber(id) then
				isInmate = true
			end
		end
		if isInmate then
			local char = exports["usa-characters"]:GetCharacter(tonumber(id))
			local time = char.get("jailTime")
			local security = char.get("jailSecurity")
			data = {
				id = id,
				time = time,
				security = security,
			}
			TriggerClientEvent("jail:openMenu", tonumber(source), true, data)
		else
			TriggerClientEvent("usa:notify", source, "That person is not in jail!")
		end
	else
		TriggerClientEvent("jail:openMenu", tonumber(source), true, data)
	end
end, {
	help = "Rebook an inmate to make changes to sentence",
	params = {
		{ name = "id (optional)", help = "id of innmate" },
	}
})

TriggerEvent('es:addJobCommand', 'release', { "corrections"}, function(source, args, char)
	local co = exports["usa-characters"]:GetCharacter(source)
	local rank = co.get("correctionsRank")
	if rank >= 4 then
		local inmate_id = args[2]
		local tp
		if args[3] == "true" then
		  	tp=true
		else 
			tp=false
		end
		table.remove(args,1) -- remove /command
		table.remove(args,1) -- remove inmate id arg
		table.remove(args,1) -- remove inmate id arg
		local reason = table.concat(args, " ")
		if inmate_id ~= nil then
			inmate_id = tonumber(inmate_id)
			if tp ~= nil then
				if reason ~= nil then
					local inmates = get_inmates()
					local isInmate = false
					for i,v in ipairs(inmates) do
						if v.get("source") == inmate_id then
							isInmate = true
						end
					end
					if isInmate then
						local inmate = exports["usa-characters"]:GetCharacter(inmate_id)
						TriggerClientEvent("usa:notify", source, "Releasing " .. inmate.getFullName() .. "!", "Releasing " .. inmate.getFullName() .. " with " .. inmate.get("jailTime") .. " months remaining for reason: "..reason)
						-- TODO Discord log
						release_inmate(inmate_id, inmate, tp, reason)
					else
						TriggerClientEvent("usa:notify", source, "That person is not in jail!")
					end
				else
					TriggerClientEvent("usa:notify", source, "Please provide the reason of release!")
				end
			else
				TriggerClientEvent("usa:notify", source, "Please specify if the inmate will be brought to reception!")
			end
		else
			TriggerClientEvent("usa:notify", source, "Please provide the inmate ID!")
		end
	else
		TriggerClientEvent("usa:notify", source, "Only SGT+ can release inmates!")
	end
end, {
	help = "Release a prisoner from the prison early (Corrections)",
	params = {
		{ name = "id", help = "id of innmate" },
		{ name = "bring to reception", help = "true = tp's the inmate to reception, false = does not TP the prisoner to reception"},
		{ name = "reason", help = "Reason of Release"}
	}
})

TriggerEvent('es:addJobCommand', 'togglealarm', { "corrections", "sasp", "bcso"}, function(source, args, char)
	if alarm_on == false then
		alarm_on = true
	    TriggerClientEvent('chat:addMessage', source, { args = { '^1PRISON SYSTEM', 'Prison Alarm Activated!' } })
	    TriggerEvent("jail:startalarmSV")
	else
		alarm_on = false
		TriggerClientEvent('chat:addMessage', source, { args = { '^1PRISON SYSTEM', 'Prison Alarm Deactivated!' } })
		TriggerEvent("jail:stopalarmSV")
	end
end, {
	help = "Toggle the Prison Alarm on or off (Police/Corrections)"
})

TriggerEvent('es:addJobCommand', 'lockdoors', {"corrections"}, function(source, args, char)
	TriggerEvent("doormanager:lockPrisonDoors")
	TriggerClientEvent("usa:notify", source, "All Jail Doors have been locked!")
end, {
	help = "Lock all Cell Doors (Corrections)"
})

RegisterServerEvent("jail:jailPlayerFromMenu")
AddEventHandler("jail:jailPlayerFromMenu", function(data)
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get('job')
	if job == 'sasp' or job == 'bcso' or job == 'corrections' or job == "judge" then
		local arrestingOfficerName = char.getFullName()
		jailPlayer(source, data, arrestingOfficerName, data.gender)
	else
		DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
		TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for LUA injection, please intervene^0!')
	end
end)

RegisterServerEvent("jail:rebookPlayerFromMenu")
AddEventHandler("jail:rebookPlayerFromMenu", function(data)
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get('job')
	if job == 'sasp' or job == 'bcso' or job == 'corrections' or job == "judge" then
		local arrestingOfficerName = char.getFullName()
		rebookPlayer(source, data, arrestingOfficerName)
	else
		DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
		TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for LUA injection, please intervene^0!')
	end
end)

RegisterServerEvent("jail:rebookWakeup")
AddEventHandler("jail:rebookWakeup", function(targetPlayer, security)
	local inmate = exports["usa-characters"]:GetCharacter(targetPlayer)
	-- assign an open cell --
	local assigned_cell = nil

	for i = 1, #CELLS do
		if security == CELLS[i].security then
			if not CELLS[i].occupant then
				CELLS[i].occupant = {
					source = inmate.get("source"),
					name = inmate.getFullName()
				}
				assigned_cell = CELLS[i]
				print("assigned cell "..i)
				break
			end
		end
	end

	if assigned_cell == nil then
		assigned_cell = tempcells[security]
		assigned_cell.occupant = {
			source = inmate.get("source"),
			name = inmate.getFullName()
		}
		table.insert(CELLS, assigned_cell)
	end

	TriggerClientEvent("jail:jail", targetPlayer, assigned_cell)
end)

function rebookPlayer(src, data, officerName)
	local targetPlayer = tonumber(data.id)
	if not GetPlayerName(targetPlayer) then TriggerClientEvent("usa:notify", src, 'Player to jail not found!') return end
	local inmates = get_inmates()
	local isInmate = false
	for i,v in ipairs(inmates) do
		if v.get("source") == targetPlayer then
			isInmate = true
		end
	end
	if isInmate then
		local sentence = tonumber(data.sentence)
		local reason = data.charges
		local fine = data.fine
		if sentence == nil then
			TriggerClientEvent("usa:notify", src, 'Invalid jail time!')
			CancelEvent()
			return
		elseif not tonumber(fine) then
			TriggerClientEvent("usa:notify", src, 'Invalid fine!')
			CancelEvent()
			return
		end
		if tonumber(fine) then
			fine = tonumber(fine)
			fine = math.ceil(fine)
			print("after rounding, fine: " .. fine)
		end
		local inmate = exports["usa-characters"]:GetCharacter(targetPlayer)
		print(getInmateSecurity(targetPlayer),data.security)
		if (getInmateSecurity(targetPlayer) ~= data.security) then
			-- assign an open cell --
			local assigned_cell = nil

			for i = 1, #CELLS do
				if data.security == CELLS[i].security then
					if not CELLS[i].occupant then
						for i = 1, #CELLS do
							if CELLS[i].occupant then
								if CELLS[i].occupant.source == targetPlayer then
									print("evicting person from cell #: " .. i .. "!")
									CELLS[i].occupant = nil
									break
								end
							end
						end
						CELLS[i].occupant = {
							source = inmate.get("source"),
							name = inmate.getFullName()
						}
						assigned_cell = CELLS[i]
						print("new cell: "..i)
						break
					end
				end
			end

			if assigned_cell == nil then
				TriggerClientEvent("usa:notify", src, 'Cellblock Full!')
				return
			end

		end
		-- send to assigned cell --
		local inmate_name = inmate.getFullName()

		exports["globals"]:notifyPlayersWithJobs({"sasp", "bcso", "corrections"}, "^3Jail: ^0".. inmate_name .. " has been rebooked for ^3" .. sentence .. "^0 month(s).")
		exports["globals"]:notifyPlayersWithJobs({"sasp", "bcso", "corrections"}, "^3Charges:^0 " .. reason)
		exports["globals"]:notifyPlayersWithJobs({"sasp", "bcso", "corrections"}, "^3Fine:^0 $" .. fine)

		inmate.set("jailTime", sentence)
		inmate.set("jailSecurity", data.security)
		inmate.set("job", "civ")
		inmate.removeBank(fine)

		if inmate.get("bank") < 0 then
			TriggerClientEvent("usa:notify", src, "Person owes money to the state!", "^3INFO: ^0The person you jailed now owes $" .. inmate.get("bank") .. " to the state. They can now legally have their assets (vehicles, properties, etc) worth that amount seized now unless they can pay the amount they owe.")
		end

		TriggerClientEvent("usa:notify", targetPlayer, "You have been fined: $" .. fine)
		-- add to criminal history --
		local playerCriminalHistory = inmate.get("criminalHistory")
		local record = {
			sentence = sentence,
			charges = reason,
			arrestingOfficer = officerName,
			timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time()),
			type = "arrest",
			number = 'A'..math.random(10000000, 99999999)
		}

		table.insert(playerCriminalHistory, record)
		inmate.set("criminalHistory", playerCriminalHistory)
		TriggerEvent("warrants:removeAnyActiveWarrants", inmate.get("name"), inmate.get("dateOfBirth"))

		local suspensions = ""
		if GetDLSuspensionDays(reason) > 0 then
			TriggerEvent("dmv:setLicenseStatus", "suspended", targetPlayer, GetDLSuspensionDays(reason))
			TriggerClientEvent("usa:notify", targetPlayer, "Your driver's license has been suspended for " .. GetDLSuspensionDays(reason) .. " day(s)")
			suspensions = "\nDL suspended for " .. GetDLSuspensionDays(reason) .. " day(s)"
		end
		-- suspend gun permit if necessary --
		if GetFPRevoked(reason) then
			TriggerEvent("police:revokeFirearmPermit", targetPlayer)
			-- If we revoke FP permit, revoke the pilot license too
			TriggerEvent("police:suspendPilotLicense", targetPlayer)
			TriggerClientEvent("usa:notify", targetPlayer, "Your firearm permit has been revoked!")
			suspensions = suspensions .. "\nFP revoked permanently"
		end
		-- send to discord #jail-logs --
		local url = GetConvar("jail-log-webhook", "")
		if not suspensions then suspensions = "None" end
		PerformHttpRequest(url, function(err, text, headers)
			if text then
				print(text)
			end
		end, "POST", json.encode({
			embeds = {
				{
					description = "**Rebooking**\n**Name:** " .. inmate_name .. " \n**Sentence:** " .. sentence .. " months" .. " \n**Charges:** " ..reason.. "\n**Fine:** $" .. fine .. "\n**Suspensions:** " .. (suspensions or "None") .. "\n**Arresting Officer:** " ..officerName.."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
					color = 263172,
					author = {
						name = "Blaine County Correctional Facility"
					}
				}
			}
		}), { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
	else
		TriggerClientEvent("usa:notify", src, "That person is not in jail!")
	end
end

function jailPlayer(src, data, officerName, gender)
	local targetPlayer = tonumber(data.id)
	if not GetPlayerName(targetPlayer) then TriggerClientEvent("usa:notify", src, 'Player to jail not found!') return end
	local sentence = tonumber(data.sentence)
	local reason = data.charges
	local fine = data.fine
	if sentence == nil then
		TriggerClientEvent("usa:notify", src, 'Invalid jail time!')
		CancelEvent()
		return
	elseif not tonumber(fine) then
		TriggerClientEvent("usa:notify", src, 'Invalid fine!')
		CancelEvent()
		return
	end
	if tonumber(fine) then
		fine = tonumber(fine)
		fine = math.ceil(fine)
		print("after rounding, fine: " .. fine)
	end
	local inmate = exports["usa-characters"]:GetCharacter(targetPlayer)
	-- assign an open cell --
	local assigned_cell = nil

	for i = 1, #CELLS do
		if data.security == CELLS[i].security then
			if not CELLS[i].occupant then
				CELLS[i].occupant = {
					source = inmate.get("source"),
					name = inmate.getFullName()
				}
				assigned_cell = CELLS[i]
				print("assinged cell "..i)
				break
			end
		end
	end

	if assigned_cell == nil then
		TriggerClientEvent("usa:notify", src, 'Cellblock Full!')
		return
	end

	-- send to assigned cell --
	local inmate_name = inmate.getFullName()

	exports["globals"]:notifyPlayersWithJobs({"sasp", "bcso", "corrections"}, "^3Jail: ^0".. inmate_name .. " has been jailed for ^3" .. sentence .. "^0 month(s).")
	exports["globals"]:notifyPlayersWithJobs({"sasp", "bcso", "corrections"}, "^3Charges:^0 " .. reason)
	exports["globals"]:notifyPlayersWithJobs({"sasp", "bcso", "corrections"}, "^3Fine:^0 $" .. fine)

	TriggerClientEvent("jail:jail", targetPlayer, assigned_cell, gender)
	inmate.removeWeapons()
	inmate.removeIllegalItems()

	if inmate.get("jailTime") == 0 then

		local inv = inmate.get("inventory")
		for i = 0, inv.MAX_CAPACITY do
			i = tostring(i)
			if inv.items[i] and inv.items[i].type and inv.items[i].type == "license" then
				inv.items[i] = nil
			end
		end
		local invtable = {
			inventory = inv,
			storedAt = os.time()
		}
		local charid = inmate.get("_id")
		TriggerEvent('es:exposeDBFunctions', function(db)
			db.createDocumentWithId(DB_NAME, invtable, charid, function(cb1)
				if cb1 then
					inmate.removeAllItems("license")
					TriggerClientEvent("usa:notify", targetPlayer, "Your belongings have been stored until your release!")
				else
					db.updateDocument(DB_NAME, charid, invtable, function(cb2)
						if cb2 then
							inmate.removeAllItems("license")
							TriggerClientEvent("usa:notify", targetPlayer, "Your belongings have been stored until your release!")
						else 
							TriggerClientEvent("usa:notify", targetPlayer, "There was an issue with taking your belongings automatically, please inform a CO about this.")
						end
					end)
				end
			end)
		end)
	end

	inmate.set("jailTime", sentence)
	inmate.set("jailSecurity", data.security)
	inmate.set("job", "civ")
	inmate.removeBank(fine)

	if inmate.get("bank") < 0 then
		TriggerClientEvent("usa:notify", src, "Person owes money to the state!", "^3INFO: ^0The person you jailed now owes $" .. inmate.get("bank") .. " to the state. They can now legally have their assets (vehicles, properties, etc) worth that amount seized now unless they can pay the amount they owe.")
	end

	TriggerClientEvent("usa:notify", targetPlayer, "You have been fined: $" .. fine)
	-- add to criminal history --
	local playerCriminalHistory = inmate.get("criminalHistory")
	local record = {
		sentence = sentence,
		charges = reason,
		arrestingOfficer = officerName,
		timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time()),
		type = "arrest",
		number = 'A'..math.random(10000000, 99999999)
	}

	table.insert(playerCriminalHistory, record)
	inmate.set("criminalHistory", playerCriminalHistory)
	TriggerEvent("warrants:removeAnyActiveWarrants", inmate.get("name"), inmate.get("dateOfBirth"))

	local suspensions = ""
	if GetDLSuspensionDays(reason) > 0 then
		TriggerEvent("dmv:setLicenseStatus", "suspended", targetPlayer, GetDLSuspensionDays(reason))
		TriggerClientEvent("usa:notify", targetPlayer, "Your driver's license has been suspended for " .. GetDLSuspensionDays(reason) .. " day(s)")
		suspensions = "\nDL suspended for " .. GetDLSuspensionDays(reason) .. " day(s)"
	end
	-- suspend gun permit if necessary --
	if GetFPRevoked(reason) then
		TriggerEvent("police:revokeFirearmPermit", targetPlayer)
		-- If we revoke FP permit, revoke the pilot license too
		TriggerEvent("police:suspendPilotLicense", targetPlayer)
		TriggerClientEvent("usa:notify", targetPlayer, "Your firearm permit has been revoked!")
		suspensions = suspensions .. "\nFP revoked permanently"
	end
	-- send to discord #jail-logs --
	local url = GetConvar("jail-log-webhook", "")
	if not suspensions then suspensions = "None" end
	PerformHttpRequest(url, function(err, text, headers)
		if text then
			print(text)
		end
	end, "POST", json.encode({
		embeds = {
			{
				description = "**Name:** " .. inmate_name .. " \n**Sentence:** " .. sentence .. " months" .. " \n**Charges:** " ..reason.. "\n**Fine:** $" .. fine .. "\n**Suspensions:** " .. (suspensions or "None") .. "\n**Arresting Officer:** " ..officerName.."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
				color = 263172,
				author = {
					name = "Blaine County Correctional Facility"
				}
			}
		}
	}), { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end

AddEventHandler("playerDropped", function(reason)
	for i,v in ipairs(CELLS) do
		if v.occupant ~= nil then
			if v.occupant.source == source then
				TriggerEvent("jail:clearCell", v)
			end
		end
	end
end)

RegisterServerEvent("jail:clearCell")
AddEventHandler("jail:clearCell", function(cell, clearJailTime)
	for i = 1, #CELLS do
		if CELLS[i].occupant and cell.occupant then
			if CELLS[i].occupant.name == cell.occupant.name then
				if CELLS[i].tempcell then
					table.remove(CELLS, i)
					print("Removing cell", #CELLS)
				else
					print("evicting person from cell #: " .. i .. "!")
					CELLS[i].occupant = nil
				end
				break
			end
		end
	end
	-- clear jail time --
	if clearJailTime then
		local char = exports["usa-characters"]:GetCharacter(source)
		char.set("jailTime", 0)
		char.set("jailSecurity", nil)
	end
end)

RegisterServerEvent("jail:notifyEscapee")
AddEventHandler("jail:notifyEscapee", function()
	local WEBHOOK_URL = GetConvar("detention-webhook", "")
	local char = exports["usa-characters"]:GetCharacter(source)
	local inmate_name = char.getFullName()
	local charid = char.get("_id")
	exports["globals"]:notifyPlayersWithJobs({"sasp", "bcso", "corrections"}, "^3INFO: ^0A person has escaped from Bolingbroke Penitentiary! ^3Inmate info: ^0" .. inmate_name)

	exports.globals:SendDiscordLog(WEBHOOK_URL, "An inmate escaped! Name: `" .. inmate_name .. "`")

	TriggerEvent('es:exposeDBFunctions', function(db)
		db.deleteDocument(DB_NAME, charid, function(ok)
			-- print(ok) --debug
		end)
	end)

	alarm_on = true
	TriggerEvent("jail:startalarmSV", -1)
	SetTimeout(5 * 60 * 1000, function ()
		if alarm_on then
			alarm_on = false
			TriggerClientEvent("jail:stopalarmCL", -1)
		end
	end)
end)

RegisterServerEvent("jail:startalarmSV")
AddEventHandler('jail:startalarmSV', function()
	TriggerClientEvent("jail:startalarmCL", -1)
	TriggerEvent("doormanager:lockPrisonDoors")
end)

RegisterServerEvent("jail:stopalarmSV")
AddEventHandler('jail:stopalarmSV', function()
	TriggerClientEvent("jail:stopalarmCL", -1)
end)

RegisterServerEvent("jail:checkalarm")
AddEventHandler('jail:checkalarm', function()
	if alarm_on then
		TriggerClientEvent("jail:startalarmCL", source)
	else
		TriggerClientEvent("jail:stopalarmCL", source)
	end
end)

function GetFPRevoked(charges) -- firearm permit
	local numbers = {
		'187', '192', '206', '207', '211', '215', '245', '600', '487', '836.6', '26500', '11392', '16590', '18720', '29800', '30605', '33410', '2331', '2800.2', '2800.3', '2800.4', '51-50', '5150', '186.22', '18 U.S. Code § 922', '18 U.S. Code § 842'
	}

	for _, code in pairs(numbers) do
		if string.find(charges, code) then
			return true
		end
	end
	return false
end

function GetDLSuspensionDays(charges) -- driver license
	local codes = {
		['2800.1'] = 3,
		['2800.2'] = 14,
		['2800.3'] = 20,
		['2800.4'] = 20,
		["20001"] = 5,
		["20002"] = 3,
		["23103(b)"] = 4,
		["23153"] = 30,
		["10851"] = 4,
		["14601"] = 2,
	}
	local daysTotal = 0
	for code, days in pairs(codes) do
		if string.find(charges, code) then
			daysTotal = daysTotal + days
		end
	end
	return daysTotal
end

function jailStatusLoop()
	SetTimeout(60000, function()
		exports["usa-characters"]:GetCharacters(function(characters)
			for id, char in pairs(characters) do
				local jailtime = char.get("jailTime")
				if not jailtime then
					jailtime = 0
				end
				if jailtime > 0 then
					local newJailTime = jailtime - 1
					char.set("jailTime", newJailTime)
					if newJailTime <= 0 then
						release_inmate(id, char, true)
					end
				end
			end
			jailStatusLoop()
		end)
	end)
end

function release_inmate(inmate_id, char, tp_out, reason)
	if reason == nil then
		reason = "Served Sentence"
	else
		reason = reason .. " | They had " .. char.get("jailTime") .. " months left on their sentence."
	end
	char.set("jailTime", 0)
	char.set("jailSecurity", nil)
	TriggerClientEvent("jail:release", tonumber(inmate_id), char.get("appearance"), tp_out)
	exports["globals"]:notifyPlayersWithJob("corrections", "^3CORRECTIONS:^0 " .. char.getName() .. " has been released. Reason: "..reason)
end

function get_inmates()
	local inmates = {}
	local done = false
	while not done do
		Wait(1)
		exports["usa-characters"]:GetCharacters(function(characters)
			for id, char in pairs(characters) do
				local time = char.get("jailTime")
				if time then
					if time > 0 then
						print(char.getFullName())
						table.insert(inmates, char)
					end
				end
			end
			done = true
		end)
	end
	return inmates
end

function getInmateSecurity(id)
	for i,v in ipairs(CELLS) do
		if v.occupant ~= nil then
			if v.occupant.source == id then
				return v.security
			end
		end
	end
	return "Unknown"
end

jailStatusLoop()