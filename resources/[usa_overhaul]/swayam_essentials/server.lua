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
TriggerEvent('es:addGroupCommand', 'setwp', 'admin', function(source, args, user)
	if args[2] and args[3] and args[4] and args[5] and args[6] and args[7] then
		TriggerEvent("swayam:SetWayPoint_s", source, args[2], args[3], args[4], args[5], args[6], args[7])
	else
		TriggerClientEvent('usa:notify', source, "USAGE: /setwp x y z sprite route_color wp_name")
	end
end)

TriggerEvent('es:addGroupCommand', 'setwpad', 'admin', function(source, args, user)
	if args[2] and args[3] and args[4] and args[5] and args[6] and args[7] then
		TriggerEvent("swayam:SetWayPointWithAutoDisable_s", source, args[2], args[3], args[4], args[5], args[6], args[7])
	else
		TriggerClientEvent('usa:notify', source, "USAGE: /setwpad x y z sprite route_color wp_name")
	end
end)

TriggerEvent('es:addGroupCommand', 'setwpp', 'admin', function(source, args, user)
	if args[2] and args[3] and args[4] and args[5] then
		TriggerEvent("swayam:SetWayPointToPlayer_s", source, args[2], args[3], args[4], args[6])
	else
		TriggerClientEvent('usa:notify', source, "USAGE: /setwpp sprite route_color playerid wp_name")
	end
end)

TriggerEvent('es:addGroupCommand', 'removewp', 'admin', function(source, args, user)
	TriggerEvent("swayam:RemoveWayPoint_s", source)
end)

TriggerEvent('es:addGroupCommand', 'mypos', 'admin', function(source, args, user)
	TriggerClientEvent("swayam:getCoords", source)
end)

----------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'setskin', 'superadmin', function(source, args, user)
		if args[2] then
			TriggerClientEvent("swayam:SetSkin", source, args[2])
		else
			TriggerClientEvent('usa:notify', source, "USAGE: /setskin model")
		end
end, {
	help = "Change your skin.",
	params = {
		{ name = "model", help = "The model name" }
	}
})
----------------------------------------------------------------

----------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'gotowp', 'mod', function(source, args, user)
	TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has teleported to waypoint.')
	TriggerClientEvent("swayam:gotoWP", source)
end, {help = "Teleport to a set waypoint."})
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

----------------------------------------------------------------
--//https://wiki.gtanet.work/index.php?title=Notification_Pictures

RegisterServerEvent("swayam:notification_s")
AddEventHandler("swayam:notification_s", function(playerid)
	TriggerClientEvent("swayam:notification", playerid, name, msg, icon)
end)

----------------------------------------------------------------
