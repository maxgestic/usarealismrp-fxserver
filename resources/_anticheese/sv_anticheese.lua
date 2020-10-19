-- with this you can turn on/off specific anticheese components, note: you can also turn these off while the script is running by using events, see examples for such below
Components = {
	Teleport = true,
	GodMode = true,
	Speedhack = true,
	WeaponBlacklist = true,
	Invisibility = true,
}
SPAMLIMIT = 5
LOGSUPRESSIONTIMEOUT = SPAMLIMIT * 5 * 1000  -- SPAMLIMIT * secs * ms
LOGSURPRESSTIME = 10 * 60 * 1000  -- mins * secs * ms (10 minutes)

violations = {}
local instancedWarnings = {}
--userLifeChecks = {}

webhook = "https://discordapp.com/api/webhooks/618094411003199509/IeXSWsln5hPo83l5wles9m62kEAKAJQUry6cZvV0MQzCLa6mYgBZOEVdtwwjpC1MUwoh"

AddEventHandler('anticheese:playerDropped', function(userSource)
	local key = tostring(userSource)
	--userLifeChecks[key] = nil
	violations[key] = nil
	instancedWarnings[key] = nil
end)

Citizen.CreateThread(function()
	function SendWebhookMessage(webhook,message)
		if webhook ~= "none" then
			--PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content =  "**Hey,** <@&393914689823965185>\n".. message}), { ['Content-Type'] = 'application/json' })
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content =  message}), { ['Content-Type'] = 'application/json' })
		end
	end

	function WarnPlayer(src)
		local isKnown = false
		local isKnownCount = 1
		local isKnownExtraText = ""
		local vInfo = violations[tostring(src)]
		if vInfo then
			isKnown = true
			if vInfo.count >= 2 then
				isKnownExtraText = " | PROBABLE CHEATER"
			end
			vInfo.count = vInfo.count + 1
			if vInfo.count >= 20 then
				exports["es_admin"]:BanPlayer(src, "Modding. If you feel this was a mistake please let a staff member know.")
			end
			isKnownCount = vInfo.count
		else
			violations[tostring(src)] = { count = 1 }
		end

		return isKnown, "Flag Count:" .. isKnownCount .. isKnownExtraText
	end

	function GetPlayerNeededIdentifiers(player)
		local ids = GetPlayerIdentifiers(player)
		local license, steam
		for i = 1, #ids do
			if string.find(ids[i], "license:") then
				license = ids[i]
			end
			if string.find(ids[i], "steam:") then
				steam = ids[i]
			end
	    end
		return license, steam
	end

	function GetPlayerInfo(src)
		local license, steam = GetPlayerNeededIdentifiers(src)
		local steamName = GetPlayerName(src)
		local char = exports["usa-characters"]:GetCharacter(src)
		local name = "UNDEFINED"
		if char then
			name = char.getFullName()
		end

		if not license then
			license = "No License Found!"
		end
		if not steam then
			steam = "No Steam ID Found!"
		end
		if not steamName then
			steamName = "Could not get player's steam name"
		end
		if not name then
			name = "Could not get player name"
		end

		return license, steam, steamName, name
	end

	-- log formating functions --
	function getTimeString()
		return "** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()) .. " **\n"
	end

	function getUserInfoString(userSource)
		local license, steam, steamName, name = GetPlayerInfo(userSource)
		return name, "ID #: " .. userSource .. "\nUser: " .. name.. "\nSteam Name: " .. steamName .. "\n" .. license .. "\n" .. steam .. "\n"
	end
	-- end log formating functions --

	function roundToNthDecimal(num, n)
		local mult = 10^(n or 0)
		return math.floor(num * mult + 0.5) / mult
	end

	function roundCoords(x, y, z)
		local n = 2
		x = roundToNthDecimal(x, n)
		y = roundToNthDecimal(y, n)
		z = roundToNthDecimal(z, n)
		return x, y, z
	end

	-- Have to use a stupid static variable because I cant find a way to pass information into the callback with parameters...
	-- I have tried CreateThread and SetTimeout with many variations and zero luck. This is ugly but it works.
	CACHE_A = nil
	CACHE_B = nil
	function setAlertTimeoutFor(src, timeout)
		CACHE_A = src
		CACHE_B = timeout
		Citizen.CreateThread(function()
			local cachedSrc = CACHE_A
			Citizen.Wait(CACHE_B)
			violations[tostring(cachedSrc)].flagTable = nil
			violations[tostring(cachedSrc)].limitLogging = false
		end)
	end

	-- Anti spam function for noclip/speedhack alerts
	function limitLogging(userSource)
		local vInfo = violations[tostring(userSource)]
		if vInfo.limitLogging then
			return true  -- player is currently flagged as desyncing
		end
		if not vInfo.flagTable then
			vInfo.flagTable = {}
		end
		for i = 1, SPAMLIMIT do
			if not vInfo.flagTable[i] then
				if i == 1 then
					setAlertTimeoutFor(userSource, LOGSUPRESSIONTIMEOUT)
				end
				vInfo.flagTable[i] = true
				break
			end
		end
		if vInfo.flagTable[SPAMLIMIT] then
			vInfo.limitLogging = true
			setAlertTimeoutFor(userSource, LOGSURPRESSTIME)
			return true
		end
		return false
	end

	function shouldSendAlert(userSource)
		local chance = 1
		if limitLogging(userSource) then
			chance = 10
		end
		if math.random(1, chance) > 1 then
			return false
		end
		return true
	end

	function ExitingProperty(char, newx, newy, newz)
		local property = char.get("property")
		if property then
			if property["houseCoords"] then
				if find_distance({ x = property["houseCoords"][1], y = property["houseCoords"][2], z = property["houseCoords"][3]}, {x = newx, y = newy, z = newz}) < 10 then
					return true
				end
			end
		end
		return false
	end

	RegisterServerEvent('AntiCheese:SpeedFlag')
	AddEventHandler('AntiCheese:SpeedFlag', function(state, distance, oldx,oldy,oldz, newx,newy,newz)
		local userSource = source
		if Components.Speedhack then
			print("*****speed/teleport flag trigged (source: #" .. userSource .. ")!!****")
			if not isStaffMember(userSource) then
				local name, userInfoStr = getUserInfoString(userSource)

				local isKnown, flagStr = WarnPlayer(userSource)
				if not isKnown then  -- don't warn on first offense
					print("**First offense, no alert**")
					return
				end

				if not shouldSendAlert(userSource) then
					return  -- Don't send an alert
				end

				oldx, oldy, oldz = roundCoords(oldx, oldy, oldz)
				newx, newy, newz = roundCoords(newx, newy, newz)

				local msg = "```" .. getTimeString() ..
					"Speed/Teleport hacker detected!\n" ..
					userInfoStr ..
					"Player was " .. math.ceil(distance) .. " units from their last checked location\n" ..
					"Previous coordinates: (" .. oldx .. ", " .. oldy .. ", " .. oldz .. ")\n" ..
					"Current coordinates: (" .. newx .. ", " .. newy .. ", " .. newz .. ")\n" ..
					"Player flagged while " .. state .. "\n" ..
					flagStr .. "```"
				local staff_msg = "^3*Speed/Teleport hacker detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name

				TriggerEvent("usa:notifyStaff", staff_msg)
				SendWebhookMessage(webhook, msg)
			else
				print("**not sending message, was a staff member**")
			end
		end
	end)

	RegisterServerEvent('AntiCheese:NoclipFlag')
	AddEventHandler('AntiCheese:NoclipFlag', function(distance, oldx,oldy,oldz, newx,newy,newz)
		local userSource = source
		if Components.Speedhack then
			print("*****noclip flag trigged (source: #" .. userSource .. ")!!****")
			local char = exports["usa-characters"]:GetCharacter(userSource)
			if not ExitingProperty(char, newx, newy, newz) then
				if not isStaffMember(userSource) then
					local name, userInfoStr = getUserInfoString(userSource)

					local isKnown, flagStr = WarnPlayer(userSource)
					if not isKnown then  -- don't warn on first offense
						print("**First offense, no alert**")
						return
					end

					if not shouldSendAlert(userSource) then
						return  -- Don't send an alert
					end

					oldx, oldy, oldz = roundCoords(oldx, oldy, oldz)
					newx, newy, newz = roundCoords(newx, newy, newz)

					local msg = "```" .. getTimeString() ..
						"Noclip hacker detected!\n" ..
						userInfoStr ..
						"Player was " .. math.ceil(distance) .. " units from their last checked location\n" ..
						"Previous coordinates: (" .. oldx .. ", " .. oldy .. ", " .. oldz .. ")\n" ..
						"Current coordinates: (" .. newx .. ", " .. newy .. ", " .. newz .. ")\n" ..
						flagStr .. "```"
					local staff_msg = "^3*Noclip hacker detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name

					TriggerEvent("usa:notifyStaff", staff_msg)
					SendWebhookMessage(webhook, msg)
				else
					print("**not sending message, was a staff member**")
				end
			end
		end
	end)

	RegisterServerEvent('AntiCheese:HealthFlag')
	AddEventHandler('AntiCheese:HealthFlag', function(invincible, oldHealth, newHealth, curWait)
		local userSource = source
		if Components.GodMode then
			print("*****health flag trigged (source: #" .. userSource .. ")!!****")
			if not isStaffMember(userSource) then
				local name, userInfoStr = getUserInfoString(userSource)

				local isKnown, flagStr = WarnPlayer(userSource)

				local msg, staff_msg = "Error in AntiCheese:HealthFlag"
				if invincible then
					msg = "```" .. getTimeString() ..
						"Health hacker detected!\n" ..
						userInfoStr ..
						"Player was set to invincible! Player reset to mortal.\n" ..
						flagStr .. "```"
					staff_msg = "^3*Health hacker detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name .. "^3 was set to invincible!"
				else
					msg = "```" .. getTimeString() ..
						"Health hacker detected!\n" ..
						userInfoStr ..
						"Regenerated " .. newHealth - oldHealth .. "hp ( to reach " .. newHealth .. "hp ) in " .. curWait .. "ms!\n" ..
						flagStr .. "```"
					staff_msg = "^3*Health hacker detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name
				end

				TriggerEvent("usa:notifyStaff", staff_msg)
				SendWebhookMessage(webhook, msg)
			else
				print("**not sending message, was a staff member**")
			end
		end
	end)

	RegisterServerEvent('AntiCheese:JumpFlag')
	AddEventHandler('AntiCheese:JumpFlag', function(jumplength)
		local userSource = source
		if Components.SuperJump then
			print("*****super jump flag trigged (source: #" .. userSource .. ")!!****")
			local name, userInfoStr = getUserInfoString(userSource)

			local isKnown, flagStr = WarnPlayer(userSource)

			local msg = "```" .. getTimeString() ..
				"Super jump hacker detected!\n" ..
				userInfoStr ..
				flagStr .. "```"
			local staff_msg = "^3*Super jump hacker detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name

			TriggerEvent("usa:notifyStaff", staff_msg)
			SendWebhookMessage(webhook, msg)
		end
	end)

	RegisterServerEvent('AntiCheese:WeaponFlag')
	AddEventHandler('AntiCheese:WeaponFlag', function(weaponHash)
		local userSource = source
		if Components.WeaponBlacklist then
			print("*****blacklisted weapon flag trigged (source: #" .. userSource .. ")!!****")
			local name, userInfoStr = getUserInfoString(userSource)

			local isKnown, flagStr = WarnPlayer(userSource)

			local msg = "```" .. getTimeString() ..
				"Weapon hacker detected!\n" ..
				userInfoStr ..
				"Player caught with a blacklisted weapon!\n" ..
				"Weapon hash: " .. weaponHash .. "\n" ..
				"All weapons were deleted.\n" ..
				flagStr .. "```"
			local staff_msg = "^3*Player with a blacklisted weapon detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name

			TriggerEvent("usa:notifyStaff", staff_msg)
			SendWebhookMessage(webhook, msg)
		end
	end)

	RegisterServerEvent('AntiCheese:InvisibilityFlag')
	AddEventHandler('AntiCheese:InvisibilityFlag', function(coords)
		local userSource = source
		if Components.Invisibility then
			print("*****invisibility flag trigged (source: #" .. userSource .. ")!!****")
			local name, userInfoStr = getUserInfoString(userSource)

			local isKnown, flagStr = WarnPlayer(userSource)

			local msg = "```" .. getTimeString() ..
				"Invisibility hacker detected!\n" ..
				userInfoStr ..
				"Coords: (" .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. ")\n" ..
				"Player was invisible! Player reset to visible.\n" ..
				flagStr .. "```"
			local staff_msg = "^3*Invisibility hacker detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name

			TriggerEvent("usa:notifyStaff", staff_msg)
			SendWebhookMessage(webhook, msg)
		end
	end)
end)

function isStaffMember(src)
	local player = exports["essentialmode"]:getPlayerFromId(src)
	if player.getGroup() ~= "user" then
		return true
	else
		return false
	end
end

AddEventHandler('rconCommand', function(commandName, args)
	if commandName == "makepedskillable" then
        RconPrint("Making all peds killable!")
        TriggerEvent("es:getPlayers", function(players)
            for id, person in pairs(players) do
                if id and person then
                    if person.getGroup() == "owner" or person.getGroup() == "superadmin" then
                        TriggerClientEvent("makepedskillable", id)
                        CancelEvent()
                        return
                    end
                end
            end
        end)
    elseif commandName == "deletenearestobjects" then
		RconPrint("Deleting nearest objects!")
		TriggerEvent("es:getPlayers", function(players)
			for id, person in pairs(players) do
				if id and person then
					if person.getGroup() == "owner" or person.getGroup() == "superadmin" then
						TriggerClientEvent("deletenearestobjects", id)
						CancelEvent()
						return
					end
				end
			end
		end)
	end
end)

TriggerEvent('es:addGroupCommand', 'dnv', 'mod', function(source, args, user)
  TriggerClientEvent("deletenearestvehicles", source)
end, {
	help = "CAUTION: Deletes all the nearest vehicles in a small radius around you. ONLY USE SPARINGLY FOR MODDERS."
})

TriggerEvent('es:addGroupCommand', 'dno', 'mod', function(source, args, user)
  TriggerClientEvent("deletenearestobjects", source)
end, {
	help = "Delete the nearest spawned objects. Useful for getting rid of UFOs and other things modders spawn in."
})

TriggerEvent('es:addGroupCommand', 'mpk', 'admin', function(source, args, user)
  TriggerClientEvent("makepedskillable", source)
end, {
	help = "Make all peds killable. Useful for getting rid of invulnerable peds modders like to sometimes spawn in."
})

function find_distance(coords1, coords2)
  xdistance =  math.abs(coords1.x - coords2.x)

  ydistance = math.abs(coords1.y - coords2.y)

  zdistance = math.abs(coords1.z - coords2.z)

  return nroot(3, (xdistance ^ 3 + ydistance ^ 3 + zdistance ^ 3))
end

function nroot(root, num)
  return num^(1/root)
end

--[[ disabled due to breakage after running event name scrambler (since event name is passed as parameter)
RegisterServerEvent("anticheese:runAfterDisabling")
AddEventHandler("anticheese:runAfterDisabling", function(src, type, event, args)
	TriggerClientEvent("anticheese:runAfterDisabling", src, type, event, args)
end)
--]]

RegisterServerEvent("anticheese:exitPropertyAfterDisabling")
AddEventHandler("anticheese:exitPropertyAfterDisabling", function(src, args)
	TriggerClientEvent("anticheese:exitPropertyAfterDisabling", src, args)
end)

RegisterServerEvent('anticheese:ViolationDetected') -- will ban player and send message to discord
AddEventHandler('anticheese:ViolationDetected', function(reason, src)
	local usource = source
	if src then usource = src end
	local minipunchDiscordID = "<@178016707292561409>"
	local WEBHOOK_URL = "https://discordapp.com/api/webhooks/618094411003199509/IeXSWsln5hPo83l5wles9m62kEAKAJQUry6cZvV0MQzCLa6mYgBZOEVdtwwjpC1MUwoh"
    local msg = 'Player id [' .. usource .. ' / ' .. (GetPlayerIdentifiers(usource)[1] or 'N/A') .. '] was banned for anticheese violation!'
    exports.globals:SendDiscordLog(WEBHOOK_URL, msg .. " " .. minipunchDiscordID)
    exports["es_admin"]:BanPlayer(usource, "Modding (" .. reason .. "). If you feel this was a mistake please let a staff member know.")
end)