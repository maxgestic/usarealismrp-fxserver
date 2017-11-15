-- Sprites & Route Colors: https://wiki.gtanet.work/index.php?title=Blips

RegisterServerEvent("swayam:SetWayPoint_s")
AddEventHandler("swayam:SetWayPoint_s", function(playerid, x, y, z, sprite, route_color, wp_name)
	TriggerClientEvent("swayam:SetWayPoint", playerid, x, y, z, sprite, route_color, wp_name)
end)

RegisterServerEvent("swayam:SetWayPointWithAutoDisable_s")
AddEventHandler("swayam:SetWayPointWithAutoDisable_s", function(playerid, x, y, z, sprite, route_color, wp_name)
	TriggerClientEvent("swayam:SetWayPointWithAutoDisable", playerid, x, y, z, sprite, route_color, wp_name)
end)

RegisterServerEvent("swayam:SetWayPointToPlayer_s")
AddEventHandler("swayam:SetWayPointToPlayer_s", function(playerid, sprite, route_color, serverid, wp_name)
	TriggerClientEvent("swayam:SetWayPointToPlayer", playerid, sprite, route_color, serverid, wp_name)
end)

RegisterServerEvent("swayam:RemoveWayPoint_s")
AddEventHandler("swayam:RemoveWayPoint_s", function(playerid)
	TriggerClientEvent("swayam:RemoveWayPoint", playerid)
end)

--DEBUG COMMANDS
TriggerEvent('es:addCommand', 'setwp', function(source, args, user)
	if user.getGroup() == "admin" or user.getGroup() == "superadmin" or user.getGroup() == "owner" then
		if args[2] and args[3] and args[4] and args[5] and args[6] and args[7] then
			TriggerEvent("swayam:SetWayPoint_s", source, args[2], args[3], args[4], args[5], args[6], args[7])
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "USAGE: /setwp x y z sprite route_color wp_name")		
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You're not authorized to use this command!")		
	end
end)

TriggerEvent('es:addCommand', 'setwpad', function(source, args, user)
	if user.getGroup() == "admin" or user.getGroup() == "superadmin" or user.getGroup() == "owner" then
		if args[2] and args[3] and args[4] and args[5] and args[6] and args[7] then
			TriggerEvent("swayam:SetWayPointWithAutoDisable_s", source, args[2], args[3], args[4], args[5], args[6], args[7])
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "USAGE: /setwpad x y z sprite route_color wp_name")		
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You're not authorized to use this command!")		
	end
end)

TriggerEvent('es:addCommand', 'setwpp', function(source, args, user)
	if user.getGroup() == "admin" or user.getGroup() == "superadmin" or user.getGroup() == "owner" then
		if args[2] and args[3] and args[4]and args[5] then
			TriggerEvent("swayam:SetWayPointToPlayer_s", source, args[2], args[3], args[4], args[6])
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "USAGE: /setwpp sprite route_color playerid wp_name")		
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You're not authorized to use this command!")		
	end
end)

TriggerEvent('es:addCommand', 'removewp', function(source, args, user)
	if user.getGroup() == "admin" or user.getGroup() == "superadmin" or user.getGroup() == "owner" then
		TriggerEvent("swayam:RemoveWayPoint_s", source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You're not authorized to use this command!")		
	end
end)

TriggerEvent('es:addCommand', 'mypos', function(source, args, user)
	if user.getGroup() == "admin" or user.getGroup() == "superadmin" or user.getGroup() == "owner" then
		TriggerEvent('es:getPlayerFromId', source, function(user)
			if user then
				local mPos = user.getCoords()
				TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "x = " .. mPos.x .. " | y = " .. mPos.y .. " | z = " .. mPos.z)				
			end
		end)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You're not authorized to use this command!")		
	end
end)

----------------------------------------------------------------
TriggerEvent('es:addCommand', 'setskin', function(source, args, user)
	if user.getGroup() == "admin" or user.getGroup() == "superadmin" or user.getGroup() == "owner" then
		if args[2] then
			TriggerClientEvent("swayam:SetSkin", source, args[2])
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "USAGE: /setskin model")		
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You're not authorized to use this command!")		
	end
end)
----------------------------------------------------------------

----------------------------------------------------------------
--[[local weather = "CLEAR"

RegisterServerEvent("swayam:GetWeather")
AddEventHandler("swayam:GetWeather", function()
	TriggerClientEvent("swayam:SetWeather", source, weather)
end)

TriggerEvent('es:addCommand', 'setweather', function(source, args, user)
	if user.getGroup() == "admin" or user.getGroup() == "superadmin" or user.getGroup() == "owner" then
		if args[2] then
			weather = args[2]
			TriggerClientEvent("swayam:SetWeather", -1, args[2])
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "USAGE: /setweather weather")
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "EXAMPLES: /setweather [CLEAR,EXTRASUNNY,OVERCAST,RAIN,CLEARING,THUNDER,SMOG,FOGGY,XMAS,SNOWLIGHT,BLIZZARD,NEUTRAL,HALLOWEEN,CLOUDS,SNOW]")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You're not authorized to use this command!")		
	end
end)]]--
----------------------------------------------------------------

