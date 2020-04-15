--# Created by: minipunch
--# for USA REALISM rep
--# requres 'globals' resource to send notifications and usa_rp to change their model, check their jail time on join, and stuff like that

-- Each cell block floor starts from the leftmost cell and wraps around until finished (cell numbers)
local CELLS = {
	{x = 1746.0, y = 2632.1, z = 45.6, occupant = nil},
	{x = 1727.3, y = 2624.0, z = 45.6, occupant = nil},
	{x = 1727.5, y = 2632.1, z = 45.6, occupant = nil},
	{x = 1746.4, y = 2636.1, z = 45.6, occupant = nil},
	{x = 1727.1, y = 2636.2, z = 45.6, occupant = nil},
	{x = 1746.7, y = 2640.0, z = 45.6, occupant = nil},
	{x = 1726.0, y = 2640.3, z = 45.6, occupant = nil},
	{x = 1746.5, y = 2644.5, z = 45.6, occupant = nil},
	{x = 1727.4, y = 2644.4, z = 45.6, occupant = nil},
	{x = 1746.4, y = 2648.3, z = 45.6, occupant = nil} -- last cell on first floor
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
	}), { ["Content-Type"] = 'application/json' })
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

function GetFPRevoked(charges) -- firearm permit
	local numbers = {
		'118', '135', '187', '192', '207', '215', '245', '16590', '29800', '33410', '2800.2', '2800.3', '2800.4', '51-50', '5150'
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
		['2800.1'] = 14,
		['2800.2'] = 30,
		['2800.3'] = 60,
		['2800.4'] = 60,
		["20001"] = 45,
		["20002"] = 30,
		["23103(b)"] = 7,
		["23153"] = 30,
		["14601"] = 14,
		["10851"] = 7
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
