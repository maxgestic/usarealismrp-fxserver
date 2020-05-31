--# Created by: minipunch
--# for USA REALISM rep
--# requres 'globals' resource to send notifications and usa_rp to change their model, check their jail time on join, and stuff like that

-- Each cell block floor starts from the leftmost cell and wraps around until finished (cell numbers)
local CELLS = {
	{x = 1789.84, y = 2586.21, z = 45.8, occupant = nil},
	{x = 1789.79, y = 2582.03, z = 45.8, occupant = nil},
	{x = 1789.47, y = 2578.59, z = 45.8, occupant = nil},
	{x = 1789.92, y = 2574.67, z = 45.8, occupant = nil},
	{x = 1768.73, y = 2573.49, z = 45.8, occupant = nil},
	{x = 1769.41, y = 2577.74, z = 45.8, occupant = nil},
	{x = 1769.22, y = 2581.41, z = 45.8, occupant = nil},
	{x = 1769.21, y = 2585.43, z = 45.8, occupant = nil}, -- last lower cell
	{x = 1769.26, y = 2573.5, z = 50.55, occupant = nil}, -- first upper cell
	{x = 1769.73, y = 2577.66, z = 50.55, occupant = nil},
	{x = 1769.27, y = 2581.5, z = 50.55, occupant = nil},
	{x = 1769.8, y = 2585.53, z = 50.55, occupant = nil},
	{x = 1769.6, y = 2589.24, z = 50.55, occupant = nil},
	{x = 1769.66, y = 2593.24, z = 50.55, occupant = nil},
	{x = 1769.71, y = 2597.22, z = 50.55, occupant = nil},
	{x = 1785.16, y = 2602.04, z = 50.55, occupant = nil},
	{x = 1789.52, y = 2598.19, z = 50.55, occupant = nil},
	{x = 1789.54, y = 2594.22, z = 50.55, occupant = nil},
	{x = 1789.44, y = 2590.13, z = 50.55, occupant = nil},
	{x = 1789.72, y = 2586.0, z = 50.55, occupant = nil},
	{x = 1789.45, y = 2582.4, z = 50.55, occupant = nil},
	{x = 1789.73, y = 2577.97, z = 50.55, occupant = nil},
	{x = 1785.85, y = 2568.26, z = 50.55, occupant = nil},
	{x = 1781.75, y = 2568.45, z = 50.55, occupant = nil},
	{x = 1778.07, y = 2568.4, z = 50.55, occupant = nil},
	{x = 1774.32, y = 2568.13, z = 50.55, occupant = nil},
}

-- V2
TriggerEvent('es:addCommand', 'jail', function(source, args, char)
	local job = char.get("job")
	local jailtime = char.get("jailTime")
	if job == "sheriff" or job == "cop" or job == "corrections" or job == "judge" then
		TriggerClientEvent("jail:openMenu", tonumber(source))
	elseif jailtime > 0 then
		TriggerClientEvent("usa:notify", tonumber(source), "You have ~y~" .. jailtime .. " month(s) ~w~left in your jail sentence.")
	end
end, {
	help = "See how much time you have left in jail / jail a player (police)"
})

RegisterServerEvent("jail:jailPlayerFromMenu")
AddEventHandler("jail:jailPlayerFromMenu", function(data)
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get('job')
	if job == 'sheriff' or job == 'corrections' or job == "judge" then
		local arrestingOfficerName = char.getFullName()
		jailPlayer(source, data, arrestingOfficerName, data.gender)
	else
		DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
		TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for LUA injection, please intervene^0!')
	end
end)

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
	local assigned_cell = CELLS[1] -- use CELLS[1] just in case there are no open cells (lol)
	for i = 1, #CELLS do
		if not CELLS[i].occupant then
			CELLS[i].occupant = {
				name = inmate.getFullName()
			}
			assigned_cell = CELLS[i]
			break
		end
	end
	-- send to assigned cell --
	local inmate_name = inmate.getFullName()

	exports["globals"]:notifyPlayersWithJobs({"sheriff", "corrections"}, "^3Jail: ^0".. inmate_name .. " has been jailed for ^3" .. sentence .. "^0 month(s).")
	exports["globals"]:notifyPlayersWithJobs({"sheriff", "corrections"}, "^3Charges:^0 " .. reason)
	exports["globals"]:notifyPlayersWithJobs({"sheriff", "corrections"}, "^3Fine:^0 $" .. fine)

	TriggerClientEvent("jail:jail", targetPlayer, assigned_cell, gender)
	inmate.removeWeapons()
	inmate.removeIllegalItems()
	inmate.set("jailTime", sentence)
	inmate.set("job", "civ")

	local property = inmate.get("property")

	if inmate.get("bank") > 0 or not property then
		inmate.removeBank(fine)
	else
		if property["money"] > 0 then
			property["money"] = property["money"] - fine
			inmate.set("property", property)
		else 
			TriggerClientEvent("usa:notify", src, "Person is not able to pay their fine!", "^3INFO: ^0The person you jailed now owes $" .. fine .. " to the state. Consider seizing assets worth that amount if they cannot pay it back.")
		end
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
	local url = 'https://discordapp.com/api/webhooks/617497481466478603/j-6d89PaZNtZYohmBVgHMATb5WvjfHogZBX9CtRscJQY91ybNWDi1hyZ7uSVV0la50MR'
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

RegisterServerEvent("jail:clearCell")
AddEventHandler("jail:clearCell", function(cell, clearJailTime)
	for i = 1, #CELLS do
		if CELLS[i].occupant and cell.occupant then
			if CELLS[i].occupant.name == cell.occupant.name then
				print("evicting person from cell #: " .. i .. "!")
				CELLS[i].occupant = nil
				break
			end
		end
	end
	-- clear jail time --
	if clearJailTime then
		local char = exports["usa-characters"]:GetCharacter(source)
		char.set("jailTime", 0)
	end
end)

RegisterServerEvent("jail:notifyEscapee")
AddEventHandler("jail:notifyEscapee", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	exports["globals"]:notifyPlayersWithJobs({"sheriff", "corrections"}, "^3INFO: ^0A person has escaped from Bolingbroke Penitentiary! ^3Inmate info: ^0" .. char.getFullName())
end)

function GetFPRevoked(charges) -- firearm permit
	local numbers = {
		'187', '192', '206', '207', '211', '215', '245', '600', '487', '836.6', '26500', '23153', '11392', '646.9', '16590', '18720', '29800', '30605', '33410', '2331', '2800.3', '2800.4', '51-50', '5150'
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
		['2800.1'] = 2,
		['2800.2'] = 4,
		['2800.3'] = 7,
		['2800.4'] = 7,
		["20001"] = 5,
		["20002"] = 3,
		["23103(b)"] = 1,
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
					if newJailTime == 0 then
						TriggerClientEvent("jail:release", tonumber(id), char.get("appearance"))
						exports["globals"]:notifyPlayersWithJob("corrections", "^3CORRECTIONS:^0 " .. char.getName() .. " has been released.")
					end
				end
			end
			jailStatusLoop()
		end)
	end)
end

jailStatusLoop()
