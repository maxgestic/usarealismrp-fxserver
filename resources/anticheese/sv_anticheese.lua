-- with this you can turn on/off specific anticheese components, note: you can also turn these off while the script is running by using events, see examples for such below
Components = {
	Teleport = true,
	GodMode = true,
	Speedhack = true,
	WeaponBlacklist = true,
	CustomFlag = true,
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


Users = {}
violations = {}





AddEventHandler('anticheese:playerDropped', function(userSource)
	if(Users[userSource])then
		Users[userSource] = nil
	end
end)
--[[
RegisterServerEvent("anticheese:kick")
AddEventHandler("anticheese:kick", function(reason)
	DropPlayer(source, reason)
end)
]]
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

Citizen.CreateThread(function()
	webhook = "https://discordapp.com/api/webhooks/459801084316352519/aYvDyiMOIt1OZJiyOZ3jg73qYsMUYLAP8iBv-EOovSqsDa1QTzwbPi3G3z4kKPwvHraQ"


	function SendWebhookMessage(webhook,message)
		if webhook ~= "none" then
			--PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content =  "**Hey,** <@&393914689823965185>\n".. message}), { ['Content-Type'] = 'application/json' })
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content =  message}), { ['Content-Type'] = 'application/json' })
		end
	end

	function WarnPlayer(playername, reason)
		local isKnown = false
		local isKnownCount = 1
		local isKnownExtraText = ""
		for i,thePlayer in ipairs(violations) do
			if thePlayer.name == playername then
				isKnown = true
				if violations[i].count >= 3 then
					--TriggerEvent("banCheater", source,"Cheating")
					isKnownCount = violations[i].count
					table.remove(violations,i)
					isKnownExtraText = " | PROBABLE CHEATER"
				else
					violations[i].count = violations[i].count+1
					isKnownCount = violations[i].count
				end
			end
		end

		if not isKnown then
			table.insert(violations, { name = name, count = 1 })
		end

		return isKnown, isKnownCount,isKnownExtraText
	end

	function GetPlayerNeededIdentifiers(player)
		local ids = GetPlayerIdentifiers(player)
		for i,theIdentifier in ipairs(ids) do
			if string.find(theIdentifier,"license:") or -1 > -1 then
				license = theIdentifier
			elseif string.find(theIdentifier,"steam:") or -1 > -1 then
				steam = theIdentifier
			end
		end
		if not steam then
			steam = "steam: missing"
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
	AddEventHandler('AntiCheese:SpeedFlag', function(rounds, roundm)
		if Components.Speedhack and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)

			name = GetPlayerName(source)

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Speed Hacking")

			SendWebhookMessage(webhook, "**Speed Hacker detected!** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\nWas travelling "..rounds.. " units. That's "..roundm.." more than normal! \nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
		end
	end)


	-- TODO:
	-- 1) ignore if staff member / done
	-- 2) include server ID and character name for detection alert / done
	-- 3) send in game message to staff / done
	RegisterServerEvent('AntiCheese:NoclipFlag')
	AddEventHandler('AntiCheese:NoclipFlag', function(distance)
		print("*****noclip flag trigged (source: #" .. source .. ")!!****")
		if Components.Speedhack and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			if not isStaffMember(source) then
				license, steam = GetPlayerNeededIdentifiers(source)
				name = exports["essentialmode"]:getPlayerFromId(source).getActiveCharacterData("fullName")

				isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Noclip/Teleport Hacking")

				local msg = "```Noclip/Teleport hacker detected!\nID #: " .. source .. "\nUser: "..name.."\n"..license.."\n"..steam.."\nCaught with "..math.ceil(distance).." units between last checked location\nFlag Count:"..isKnownCount..""..isKnownExtraText.." ```"
				local staff_msg = "^3*Noclip/teleport hacker detected!* ID #: ^0" .. source .. "^3, Name: ^0" .. name

				TriggerEvent("usa:notifyStaff", staff_msg)

				SendWebhookMessage(webhook, msg)
			else
				print("**not sending message, was a staff member**")
			end
		end
	end)


	RegisterServerEvent('AntiCheese:CustomFlag')
	AddEventHandler('AntiCheese:CustomFlag', function(reason,extrainfo)
		if Components.CustomFlag and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)
			if not extrainfo then extrainfo = "no extra informations provided" end
			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,reason)

			SendWebhookMessage(webhook,"**"..reason.."** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\n"..extrainfo.."\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
		end
	end)

	RegisterServerEvent('AntiCheese:HealthFlag')
	AddEventHandler('AntiCheese:HealthFlag', function(invincible,oldHealth, newHealth, curWait)
		print("*****health flag trigged (source: #" .. source .. ")!!****")
		if Components.GodMode and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			if not isStaffMember(source) then
				license, steam = GetPlayerNeededIdentifiers(source)
				name = exports["essentialmode"]:getPlayerFromId(source).getActiveCharacterData("fullName")

				isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Health Hacking")

				local msg = nil
				local staff_msg = nil

				if invincible then
					msg = "```Health hacker detected!\nID #: " .. source .. "\nUser: "..name.."\n"..license.."\n"..steam.."\nRegenerated "..newHealth-oldHealth.."hp ( to reach "..newHealth.."hp ) in "..curWait.."ms! ( PlayerPed was invincible )\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```"
					staff_msg = "^3*Health hacker detected!* ID #: ^0" .. source .. "^3, Name: ^0" .. name .. "^3 made themselves invincible!"
				else
					msg = "```Health hacker detected!\nID #: " .. source .. "\nUser: "..name.."\n"..license.."\n"..steam.."\nRegenerated "..newHealth-oldHealth.."hp ( to reach "..newHealth.."hp ) in "..curWait.."ms! ( Health was Forced )\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```"
					staff_msg = "^3*Health hacker detected!* ID #: ^0" .. source .. "^3, Name: ^0" .. name
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
		if Components.SuperJump and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"SuperJump Hacking")

			SendWebhookMessage(webhook,"**SuperJump Hack!** \n```\nUser: "..name.."\n"..license.."\n"..steam.."\nJumped "..jumplength.."ms long\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
		end
	end)

	RegisterServerEvent('AntiCheese:WeaponFlag')
	AddEventHandler('AntiCheese:WeaponFlag', function(weapon)
		if Components.WeaponBlacklist and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Inventory Cheating")

			SendWebhookMessage(webhook,"**Inventory Hack!** \n```\nUser: "..name.."\n"..license.."\n"..steam.."\nGot Weapon: "..weapon.."( Blacklisted )\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
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

function isStaffMember(src)
	local player = exports["essentialmode"]:getPlayerFromId(src)
	if player.getGroup() ~= "user" then
		return true
	else
		return false
	end
end
