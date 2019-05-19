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
TriggerEvent('es:addCommand', 'jail', function(source, args, user)
	local user_job = user.getActiveCharacterData("job")
	local user_jailtime = user.getActiveCharacterData("jailtime")
	if user_job == "sheriff" or user_job == "cop" or user_job == "corrections" then
		TriggerClientEvent("jail:openMenu", tonumber(source))
	elseif user_jailtime > 0 then
		TriggerClientEvent("usa:notify", tonumber(source), "You have ~y~" .. user_jailtime .. " month(s) ~w~left in your jail sentence.")
	end
end, {
	help = "See how much time you have left in jail / jail a player (police)."
})

RegisterServerEvent("jail:jailPlayerFromMenu")
AddEventHandler("jail:jailPlayerFromMenu", function(data)
	local userSource = tonumber(source)
	if tonumber(data.id) == userSource then
		TriggerClientEvent('usa:notify', userSource, 'You cannot jail yourself!')
		return
	end
	print("jailing player... from source: " .. userSource .. " with name " .. GetPlayerName(userSource))
	print("data.sentence: " .. data.sentence)
	print("data.charges: " .. data.charges)
	print("data.id: " .. data.id)
	print("data.fine: " .. data.fine)
	if data.gender then
		print("data.gender: " .. data.gender)
	end
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_job = user.getActiveCharacterData('job')
	if user_job == 'sheriff' or user_job == 'corrections' then
		local player_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
		local arrestingOfficerName = player_name
		jailPlayer(data, arrestingOfficerName, data.gender)
	else
		DropPlayer(userSource, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
		TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for memory editing at a Los Santos Customs, please intervene^0!')
	end
end)

function jailPlayer(data, officerName, gender)
	local targetPlayer = tonumber(data.id)
	if not GetPlayerName(targetPlayer) then TriggerClientEvent("usa:notify", source, 'Player to jail not found!') return end
	local sentence = tonumber(data.sentence)
	local reason = data.charges
	local fine = data.fine
	if sentence == nil then
		TriggerClientEvent("usa:notify", source, 'Invalid jail time!')
		CancelEvent()
		return
	elseif not tonumber(fine) then
		TriggerClientEvent("usa:notify", source, 'Invalid fine!')
		CancelEvent()
		return
	end
	if tonumber(fine) then
		fine = tonumber(fine)
		fine = round(fine, 0)
		print("after rounding, fine: " .. fine)
	end
	--TriggerEvent("es:getPlayerFromId", targetPlayer, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(targetPlayer)
		-- assign an open cell --
		local assigned_cell = CELLS[1] -- use CELLS[1] just in case there are no open cells (lol)
		for i = 1, #CELLS do
			if not CELLS[i].occupant then
				CELLS[i].occupant = {
					name = user.getActiveCharacterData("fullName")
				}
				assigned_cell = CELLS[i]
				break
			end
		end
		-- send to assigned cell --
		local inmate_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")

		exports["globals"]:notifyPlayersWithJobs({"sheriff", "corrections"}, "^3Jail: ^0".. inmate_name .. " has been jailed for ^3" .. sentence .. "^0 month(s).")
		exports["globals"]:notifyPlayersWithJobs({"sheriff", "corrections"}, "^3Charges:^0 " .. reason)
		exports["globals"]:notifyPlayersWithJobs({"sheriff", "corrections"}, "^3Fine:^0 $" .. fine)

		TriggerClientEvent("jail:jail", targetPlayer, assigned_cell, gender)
		user.setActiveCharacterData("weapons", {})
		user.setActiveCharacterData("jailtime", sentence)
		user.setActiveCharacterData("job", "civ")
		-- fine the player using amount supplied from the form
		local user_bank = user.getActiveCharacterData("bank")
		local bank_after_fine = user_bank - fine
		--if  bank_after_fine >= 0 then
			user.setActiveCharacterData("bank", user_bank - fine)
		--else
			--user.setActiveCharacterData("bank", 0)
		--end
		-- notify of fine:
		TriggerClientEvent("usa:notify", targetPlayer, "You have been fined: $" .. fine)
		-- add to criminal history --
		local playerCriminalHistory = user.getActiveCharacterData("criminalHistory")
		local record = {
			sentence = sentence,
			charges = reason,
			arrestingOfficer = officerName,
			timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time()),
			type = "arrest",
			number = 'A'..math.random(10000000, 99999999)
		}
		if #playerCriminalHistory > 10 then table.remove(playerCriminalHistory, 1) end -- temporary patch until criminal history is moved into separate DB
		table.insert(playerCriminalHistory, record)
		user.setActiveCharacterData("criminalHistory", playerCriminalHistory)
		TriggerEvent("warrants:removeAnyActiveWarrants", inmate_name)
		-- suspend license if necessary --
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
		local url = 'https://discordapp.com/api/webhooks/343037167821389825/yDdmSBi-ODYPcAbTzb0DaPjWPnVOhh232N78lwrQvlhbrvN8mV5TBfNOmnxwMZfQnttl'
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
	--end)
end

RegisterServerEvent("jail:clearCell")
AddEventHandler("jail:clearCell", function(cell, clearJailTime)
	local usource = source
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
		local user = exports["essentialmode"]:getPlayerFromId(usource)
		user.setActiveCharacterData("jailtime", 0)
	end
end)

function GetFPRevoked(charges) -- firearm permit
	local numbers = {
		'2003', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2017', '2019', '2020',
		'2103', '2014', '2201', 
		'2202', '2203', '2204', '2205', '2206',
		'2301', '2303', '2304', '2307',
		'2401', '2403', '2409', '2410', '2411',
		'2502', '2503', '2504', '2505', '2506', '2508',
		'2601', '2603', '2604', '2606', '2607', '2608', '2613',
		'2701', '2703', '2705', '2711', '2715', '2716', '2724'
	}
	for _, code in pairs(numbers) do
		if string.find(charges, code) then
			return true
		end
	end
	return false
end

function GetDLSuspensionDays(charges) -- driver license
	local words = {
		['2701'] = 5,
		['2703'] = 4,
		['2705'] = 8,
		['2704'] = 2,
		['2711'] = 4,
		['2715'] = 1
	}
	local daysTotal = 0
	for code, days in pairs(words) do
		if string.find(charges, code) then
			daysTotal = daysTotal + days
		end
	end
	return daysTotal
end

function jailStatusLoop()
	SetTimeout(60000, function()
		TriggerEvent("es:getPlayers", function(players)
			if players then
				for id, player in pairs(players) do
					if player then
					local player_jailtime = player.getActiveCharacterData("jailtime")
					if not player_jailtime then
						player_jailtime = 0
					end
						if player_jailtime == 0 then
							-- do nothing?
						else
							if player_jailtime > 1 then
								player.setActiveCharacterData("jailtime", player_jailtime - 1)
							else
								player.setActiveCharacterData("jailtime", player_jailtime - 1)
								print("player jail time was 0! releasing this player!")
								local chars = player.getCharacters()
								for i = 1, #chars do
									if chars[i].active == true then
										-- release person from custody --
										TriggerClientEvent("jail:release", tonumber(id), chars[i].appearance) -- need to test
										-- notify corrections of release --
										exports["globals"]:notifyPlayersWithJob("corrections", "^3CORRECTIONS:^0 " .. chars[i].firstName .. " " .. chars[i].lastName .. " has been released.")
										break
									end
								end
							end
						end
					end
				end
			end
		end)
		jailStatusLoop()
	end)
end

jailStatusLoop()

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end
