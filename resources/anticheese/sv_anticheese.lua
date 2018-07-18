-- with this you can turn on/off specific anticheese components, note: you can also turn these off while the script is running by using events, see examples for such below
Components = {
	Teleport = true,
	GodMode = true,
	Speedhack = true,
	WeaponBlacklist = true,
	Invisibility = true,
}

--[[
event examples are:

anticheese:SetComponentStatus( component, state )
	enables or disables specific components
		component:
			an AntiCheese component, such as the ones listed above, must be a string
		state:
			the state to what the component should be set to, accepts booleans such as "true" for enabled and "false" for disabled


anticheese:ToggleComponent( component )
	sets a component to the opposite mode ( e.g. enabled becomes disabled ), there is no reason to use this.
		component:
			an AntiCheese component, such as the ones listed above, must be a string

anticheese:SetAllComponents( state )
	enables or disables **all** components
		state:
			the state to what the components should be set to, accepts booleans such as "true" for enabled and "false" for disabled


These can be used by triggering them like following:
	TriggerEvent("anticheese:SetComponentStatus", "Teleport", false)

Triggering these events from the clientside is not recommended as these get disabled globally and not just for one player.


]]


--Users = {}
violations = {}
userLifeChecks = {}

webhook = "https://discordapp.com/api/webhooks/459801084316352519/aYvDyiMOIt1OZJiyOZ3jg73qYsMUYLAP8iBv-EOovSqsDa1QTzwbPi3G3z4kKPwvHraQ"




AddEventHandler('anticheese:playerDropped', function(userSource)
	userLifeChecks[userSource] = nil
	if(violations[userSource])then
		violations[userSource] = nil
	end
end)
--[[
RegisterServerEvent("anticheese:kick")
AddEventHandler("anticheese:kick", function(reason)
	DropPlayer(source, reason)
end)
]]
--[[  DISABLING THESE TO KEEP A CLEVER ATTACKER FROM DISABLING THEM FOR US
AddEventHandler("anticheese:SetComponentStatus", function(component, state)
	if type(component) == "string" and type(state) == "boolean" then
		Components[component] = state -- changes the component to the wished status
	end
end)

AddEventHandler("anticheese:ToggleComponent", function(component)
	if type(component) == "string" then
		Components[component] = not Components[component]
	end
end)

AddEventHandler("anticheese:SetAllComponents", function(state)
	if type(state) == "boolean" then
		for i,theComponent in pairs(Components) do
			Components[i] = state
		end
	end
end)
]]
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
			isKnownCount = vInfo.count
		else
			violations[tostring(src)] = { count = 1 }
		end

		return isKnown, isKnownCount, isKnownExtraText
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

	--[[ DISABLED FOR NOW, UNTIL SPEED BECOMES A NOTICABLE ISSUE
	RegisterServerEvent("anticheese:timer")
	AddEventHandler("anticheese:timer", function()
		if Users[source] then
			if (os.time() - Users[source]) < 15 and Components.Speedhack then -- prevent the player from doing a good old cheat engine speedhack
				license, steam = GetPlayerNeededIdentifiers(source)
				name = GetPlayerName(source)
				isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Speed Hacking")
				SendWebhookMessage(webhook, "**Speed Hacker!** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\nWas travelling "..rounds.. " units. That's "..roundm.." more than normal! \nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
			else
				Users[source] = os.time()
			end
		else
			Users[source] = os.time()
		end
	end)
	--]]

	RegisterServerEvent('AntiCheese:SpeedFlag')
	AddEventHandler('AntiCheese:SpeedFlag', function(distance)
		local userSource = source
		if Components.Speedhack then
			print("*****speed flag trigged (source: #" .. userSource .. ")!!****")
			if not isStaffMember(userSource) then
				local license, steam = GetPlayerNeededIdentifiers(userSource)
				local player = exports["essentialmode"]:getPlayerFromId(userSource)
				local name = player.getActiveCharacterData("fullName")
				local steamName = GetPlayerName(userSource)

				local isKnown, isKnownCount, isKnownExtraText = WarnPlayer(userSource)
				if not isKnown then  -- don't warn on first offense
					print("**First offense, no alert**")
					return
				end

				if not license then
					license = "No License Found!"
				end
				if not steam then
					steam = "No Steam ID Found!"
				end
				if not name then
					name = "Could not get player name"
				end
				if not steamName then
					steamName = "Could not get player's steam name"
				end

				local msg = "```Speed/Teleport hacker detected!\nID #: " .. userSource .. "\nUser: "..name.."\nSteam Name: "..steamName.."\n"..license.."\n"..steam.."\nCaught with "..math.ceil(distance).." units between last checked location\nFlag Count:"..isKnownCount..""..isKnownExtraText.." ```"
				local staff_msg = "^3*Speed/Teleport hacker detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name

				TriggerEvent("usa:notifyStaff", staff_msg)
				SendWebhookMessage(webhook, msg)
			else
				print("**not sending message, was a staff member**")
			end
		end
	end)

	RegisterServerEvent('AntiCheese:NoclipFlag')
	AddEventHandler('AntiCheese:NoclipFlag', function(distance)
		local userSource = source
		if Components.Speedhack then
			print("*****noclip flag trigged (source: #" .. userSource .. ")!!****")
			if not isStaffMember(userSource) then
				local license, steam = GetPlayerNeededIdentifiers(userSource)
				local player = exports["essentialmode"]:getPlayerFromId(userSource)
				local name = player.getActiveCharacterData("fullName")
				local steamName = GetPlayerName(userSource)

				local isKnown, isKnownCount, isKnownExtraText = WarnPlayer(userSource)
				if not isKnown then  -- don't warn on first offense
					print("**First offense, no alert**")
					return
				end

				if not license then
					license = "No License Found!"
				end
				if not steam then
					steam = "No Steam ID Found!"
				end
				if not name then
					name = "Could not get player name"
				end
				if not steamName then
					steamName = "Could not get player's steam name"
				end

				local msg = "```Noclip/Teleport hacker detected!\nID #: " .. userSource .. "\nUser: "..name.."\nSteam Name: "..steamName.."\n"..license.."\n"..steam.."\nCaught with "..math.ceil(distance).." units between last checked location\nFlag Count:"..isKnownCount..""..isKnownExtraText.." ```"
				local staff_msg = "^3*Noclip/Teleport hacker detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name

				TriggerEvent("usa:notifyStaff", staff_msg)
				SendWebhookMessage(webhook, msg)
			else
				print("**not sending message, was a staff member**")
			end
		end
	end)

	RegisterServerEvent('AntiCheese:HealthFlag')
	AddEventHandler('AntiCheese:HealthFlag', function(invincible,oldHealth, newHealth, curWait)
		local userSource = source
		if Components.GodMode then
			print("*****health flag trigged (source: #" .. userSource .. ")!!****")
			if not isStaffMember(userSource) then
				local license, steam = GetPlayerNeededIdentifiers(userSource)
				local player = exports["essentialmode"]:getPlayerFromId(userSource)
				local name = player.getActiveCharacterData("fullName")
				local steamName = GetPlayerName(userSource)

				local isKnown, isKnownCount, isKnownExtraText = WarnPlayer(userSource)

				if not license then
					license = "No License Found!"
				end
				if not steam then
					steam = "No Steam ID Found!"
				end
				if not name then
					name = "Could not get player name"
				end
				if not steamName then
					steamName = "Could not get player's steam name"
				end

				local msg, staff_msg = nil
				if invincible then
					msg = "```Health hacker detected!\nID #: " .. userSource .. "\nUser: "..name.."\nSteam Name: "..steamName.."\n"..license.."\n"..steam.."\nPlayer was set to invincible! Player reset to mortal.\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```"
					staff_msg = "^3*Health hacker detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name .. "^3 made themselves invincible!"
				else
					msg = "```Health hacker detected!\nID #: " .. userSource .. "\nUser: "..name.."\nSteam Name: "..steamName.."\n"..license.."\n"..steam.."\nRegenerated "..newHealth-oldHealth.."hp ( to reach "..newHealth.."hp ) in "..curWait.."ms! ( Health was Forced )\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```"
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
			local license, steam = GetPlayerNeededIdentifiers(userSource)
			local player = exports["essentialmode"]:getPlayerFromId(userSource)
			local name = player.getActiveCharacterData("fullName")
			local steamName = GetPlayerName(userSource)

			local isKnown, isKnownCount, isKnownExtraText = WarnPlayer(userSource)

			if not license then
				license = "No License Found!"
			end
			if not steam then
				steam = "No Steam ID Found!"
			end
			if not name then
				name = "ERROR: Could not get player name"
			end
			if not steamName then
				steamName = "Could not get player's steam name"
			end

			local msg = "```Super jump hacker detected!\nID #: " .. userSource .. "\nUser: "..name.."\nSteam Name: "..steamName.."\n"..license.."\n"..steam.."\nFlag Count:"..isKnownCount..""..isKnownExtraText.." ```"
			local staff_msg = "^3*Super jump hacker detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name	

			TriggerEvent("usa:notifyStaff", staff_msg)
			SendWebhookMessage(webhook, msg)
		end
	end)

	RegisterServerEvent('AntiCheese:WeaponFlag')
	AddEventHandler('AntiCheese:WeaponFlag', function(weapon)
		local userSource = source
		if Components.WeaponBlacklist then
			print("*****blacklisted weapon flag trigged (source: #" .. userSource .. ")!!****")
			local license, steam = GetPlayerNeededIdentifiers(userSource)
			local player = exports["essentialmode"]:getPlayerFromId(userSource)
			local name = player.getActiveCharacterData("fullName")
			local steamName = GetPlayerName(userSource)

			local isKnown, isKnownCount, isKnownExtraText = WarnPlayer(userSource)

			if not license then
				license = "No License Found!"
			end
			if not steam then
				steam = "No Steam ID Found!"
			end
			if not name then
				name = "Could not get player name"
			end
			if not steamName then
				steamName = "Could not get player's steam name"
			end

			local msg = "```Weapon hacker detected!\nID #: " .. userSource .. "\nUser: "..name.."\nSteam Name: "..steamName.."\n"..license.."\n"..steam.."\nPlayer caught with a blacklisted weapon!\nWeapon hash: "..weapon.."\nAll weapons were deleted.\nFlag Count:"..isKnownCount..""..isKnownExtraText.." ```"
			local staff_msg = "^3*Player with a blacklisted weapon detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name

			TriggerEvent("usa:notifyStaff", staff_msg)
			SendWebhookMessage(webhook, msg)
		end
	end)
	
	RegisterServerEvent('AntiCheese:InvisibilityFlag')
	AddEventHandler('AntiCheese:InvisibilityFlag', function()
		local userSource = source
		if Components.Invisibility then
			print("*****invisibility flag trigged (source: #" .. userSource .. ")!!****")
			local license, steam = GetPlayerNeededIdentifiers(userSource)
			local player = exports["essentialmode"]:getPlayerFromId(userSource)
			local name = player.getActiveCharacterData("fullName")
			local steamName = GetPlayerName(userSource)

			local isKnown, isKnownCount, isKnownExtraText = WarnPlayer(userSource)

			if not license then
				license = "No License Found!"
			end
			if not steam then
				steam = "No Steam ID Found!"
			end
			if not name then
				name = "Could not get player name"
			end
			if not steamName then
				steamName = "Could not get player's steam name"
			end

			local msg = "```Invisibility hacker detected!\nID #: " .. userSource .. "\nUser: "..name.."\nSteam Name: "..steamName.."\n"..license.."\n"..steam.."\nFlag Count:"..isKnownCount..""..isKnownExtraText.." ```"
			local staff_msg = "^3*Invisibility hacker detected!* ID #: ^0" .. userSource .. "^3, Name: ^0" .. name	

			TriggerEvent("usa:notifyStaff", staff_msg)
			SendWebhookMessage(webhook, msg)
		end
	end)
end)

local verFile = LoadResourceFile(GetCurrentResourceName(), "version.json")
local curVersion = json.decode(verFile).version
Citizen.CreateThread( function()
	local updatePath = "/Bluethefurry/anticheese-anticheat"
	local resourceName = "AntiCheese ("..GetCurrentResourceName()..")"
	PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version.json", function(err, response, headers)
		local data = json.decode(response)


		if curVersion ~= data.version and tonumber(curVersion) < tonumber(data.version) then
			print("\n--------------------------------------------------------------------------")
			print("\n"..resourceName.." is outdated.\nCurrent Version: "..data.version.."\nYour Version: "..curVersion.."\nPlease update it from https://github.com"..updatePath.."")
			print("\nUpdate Changelog:\n"..data.changelog)
			print("\n--------------------------------------------------------------------------")
		elseif tonumber(curVersion) > tonumber(data.version) then
			print("Your version of "..resourceName.." seems to be higher than the current version.")
		else
			print(resourceName.." is up to date!")
		end
	end, "GET", "", {version = 'this'})
end)

RegisterServerEvent('AntiCheese:LifeCheck')
AddEventHandler('AntiCheese:LifeCheck', function()
	local userSource = source
	userLifeChecks[userSource] = os.time()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		players = GetPlayers()
		for _, id in pairs(players) do
			-- if the last check in from a client was over a minute ago, anticheese resource must not be running
			if userLifeChecks[id] and os.time() - userLifeChecks[id] > 60 then
				print("*****Player disabled Anticheese (source: #" .. id .. ")!!****")
				local license, steam = GetPlayerNeededIdentifiers(id)
				local player = exports["essentialmode"]:getPlayerFromId(id)
				local name = player.getActiveCharacterData("fullName")
				local steamName = GetPlayerName(userSource)

				local isKnown, isKnownCount, isKnownExtraText = WarnPlayer(userSource)

				if not license then
					license = "No License Found!"
				end
				if not steam then
					steam = "No Steam ID Found!"
				end
				if not name then
					name = "Could not get player name"
				end
				if not steamName then
					steamName = "Could not get player's steam name"
				end

				local msg = "```Hacker disabled Anticheese!\nID #: " .. id .. "\nUser: "..name.."\nSteam Name: "..steamName.."\n"..license.."\n"..steam.."\nFlag Count:"..isKnownCount..""..isKnownExtraText.." ```"
				local staff_msg = "^3*Hacker disabled Anticheese!* ID #: ^0" .. id .. "^3, Name: ^0" .. name

				TriggerEvent("usa:notifyStaff", staff_msg)
				SendWebhookMessage(webhook, msg)
			end
		end
	end
end)

--[[
Citizen.CreateThread(function()
	while true do
		--Citizen.Wait(1000)
		Citizen.Wait(60000)
		TriggerEvent("es:getPlayers", function(players)
			if players then
				for id, player in pairs(players) do
					userMemChecks[id] = true
					TriggerClientEvent("AntiCheese:memoryHackCheck", id)
				end
			end
		end)
	end
end)

RegisterServerEvent('AntiCheese:memoryHackCheckResponse')
AddEventHandler('AntiCheese:memoryHackCheckResponse', function(weapon)
	
end)
]]
function isStaffMember(src)
	local player = exports["essentialmode"]:getPlayerFromId(src)
	if player.getGroup() ~= "user" then
		return true
	else
		return false
	end
end
