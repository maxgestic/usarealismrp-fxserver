--[[
	Route Colors: http://gtaforums.com/topic/864881-all-blip-color-ids-pictured/
	Blips: https://marekkraus.sk/gtav/blips/list.html
]]--

function splitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

--local BLIP
local myblip = nil
local clientid = -1

RegisterNetEvent("swayam:SetWayPoint")
AddEventHandler("swayam:SetWayPoint", function(x, y, z, sprite, route_color, wp_name)

	--Citizen.Trace("Sprite: " .. sprite .. " | Route Color: " .. route_color)
	if myblip ~= "" then
		RemoveBlip(myblip)
	end
	myblip = AddBlipForCoord(tonumber(x),  tonumber(y), tonumber(z))
	SetBlipSprite(myblip, tonumber(sprite))
	SetBlipRoute(myblip, true)
	SetBlipRouteColour(myblip,tonumber(route_color))
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(wp_name)
	EndTextCommandSetBlipName(myblip)

end)

--Waypoint that disables when you reach it
RegisterNetEvent("swayam:SetWayPointWithAutoDisable")
AddEventHandler("swayam:SetWayPointWithAutoDisable", function(x, y, z, sprite, route_color, wp_name)

	--Citizen.Trace("Sprite: " .. sprite .. " | Route Color: " .. route_color)
	if myblip ~= nil then
		RemoveBlip(myblip)
	end
	myblip = AddBlipForCoord(tonumber(x),  tonumber(y), tonumber(z))
	SetBlipSprite(myblip, tonumber(sprite))
	SetBlipRoute(myblip, true)
	SetBlipRouteColour(myblip,tonumber(route_color))
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(wp_name)
	EndTextCommandSetBlipName(myblip)


	Citizen.CreateThread(function()

		local playerReachedWayPoint = true
		while playerReachedWayPoint do

			--DrawMarker(1, tonumber(x),  tonumber(y), tonumber(z), 0, 0, 0, 0, 0, 0, 10.0, 10.0, 1.0, 0, 0, 255, 90, 0, 0, 2, 0, 0, 0, 0)
			local ply = GetPlayerPed(-1)
			local plyCoords = GetEntityCoords(ply, 0)
			local distance = GetDistanceBetweenCoords(tonumber(x),  tonumber(y), tonumber(z),  plyCoords["x"], plyCoords["y"], plyCoords["z"], false)
			--Citizen.Trace("Current Distance: " .. distance)
			if(distance <= 10) then
				playerReachedWayPoint = false
			end
			Wait(0)

		end
		--Citizen.Trace("Reached...disabling wp")
		TriggerEvent("swayam:RemoveWayPoint")
	end)

end)

RegisterNetEvent("swayam:SetWayPointToPlayer")
AddEventHandler("swayam:SetWayPointToPlayer", function(sprite, route_color, serverid, wp_name)
	--Citizen.Trace("Sprite: " .. sprite .. " | Route Color: " .. route_color)
	--[[Citizen.Trace("DEBUG: Inside swayam:SetWayPointToPlayer client event" )
	if tonumber(serverid) ~= -1 then
		if myblip ~= "" then
			Citizen.Trace("DEBUG: Blip exists, removing" )
			RemoveBlip(myblip)
		end
		for id = 0, 255 do
		if NetworkIsPlayerActive(id) and GetPlayerServerId(id) == tonumber(serverid) then
				clientid = id
			end
		end
		if clientid ~= -1 then
			Citizen.CreateThread(function()
				while clientid ~= -1 do
					local ply = GetPlayerPed(clientid)
					local plyCoords = GetEntityCoords(ply, 0)
					if myblip ~= "" then
						RemoveBlip(myblip)
					end
					myblip = AddBlipForCoord(plyCoords["x"], plyCoords["y"], plyCoords["z"])
					SetBlipSprite(myblip, tonumber(sprite))
					SetBlipRoute(myblip, true)
					SetBlipRouteColour(myblip,tonumber(route_color))
					Wait(0)
				end
			end)
		end
	else
		clientid = -1
	end]]--
	for id = 0, 255 do
		if NetworkIsPlayerActive(id) and GetPlayerServerId(id) == tonumber(serverid) then
			clientid = id
		end
	end
	if clientid ~= -1 then
		Citizen.CreateThread(function()
			while clientid ~= -1 do
				if myblip ~= nil then
					RemoveBlip(myblip)
				end
				local ply = GetPlayerPed(clientid)
				local plyCoords = GetEntityCoords(ply, 0)
				myblip = AddBlipForCoord(tonumber(plyCoords["x"]), tonumber(plyCoords["y"]), tonumber(plyCoords["z"]))
				SetBlipSprite(myblip, tonumber(sprite))
				SetBlipRoute(myblip, true)
				SetBlipRouteColour(myblip,tonumber(route_color))
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(wp_name)
				EndTextCommandSetBlipName(myblip)
				Wait(500)
			end
		end)
	end

end)

RegisterNetEvent("swayam:RemoveWayPoint")
AddEventHandler("swayam:RemoveWayPoint", function()
	if myblip ~= nil then
		RemoveBlip(myblip)
	end
	clientid = -1
end)

-------------------------------------------------------------------
RegisterNetEvent("swayam:SetSkin")
AddEventHandler("swayam:SetSkin", function(model)
	Citizen.CreateThread(function()
		local modelhashed = GetHashKey(model)
		Citizen.Trace(modelhashed)
		RequestModel(modelhashed)
		while not HasModelLoaded(modelhashed) do
			Citizen.Wait(100)
		end
		SetPlayerModel(PlayerId(), modelhashed)
		SetPedDefaultComponentVariation(PlayerId());
		local ply = GetPlayerPed(-1)
		SetModelAsNoLongerNeeded(modelhashed)
	end)
end)
-------------------------------------------------------------------


-------------------------------------------------------------------
RegisterNetEvent("swayam:gotoWP")
AddEventHandler("swayam:gotoWP", function(model)
	local targetPed = GetPlayerPed(-1)
	if(IsPedInAnyVehicle(targetPed))then
		targetPed = GetVehiclePedIsUsing(targetPed)
	end

	if(not IsWaypointActive())then
		TriggerEvent('usa:notify', "Waypoint not found!")
		return
	end

	local waypointBlip = GetFirstBlipInfoId(8) -- 8 = Waypoint ID
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector()))



	-- Ensure Entity teleports above the ground
	local ground
	local groundFound = false
	local groundCheckHeights = {0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}


	for i,height in ipairs(groundCheckHeights) do
		RequestCollisionAtCoord(x, y, height)
		Wait(0)
		SetEntityCoordsNoOffset(targetPed, x,y,height, 0, 0, 1)
		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if(ground) then
			z = z + 3
			groundFound = true
			break;
		end
	end

	if(not groundFound)then
		z = 1000
		GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- Parachute
	end

	SetEntityCoordsNoOffset(targetPed, x,y,z, 0, 0, 1)

end)
-------------------------------------------------------------------


-------------------------------------------------------------------
--[[local weather = "none"

RegisterNetEvent("swayam:SetWeather")
AddEventHandler("swayam:SetWeather", function(weather_sv)
	weather = weather_sv
	setweather()
end)

function setweather()
	if weather ~= "none" then
		SetWeatherTypePersist( weather )
		SetWeatherTypeNowPersist( weather )
		SetWeatherTypeNow( weather )
		SetOverrideWeather( weather )
	else
		TriggerServerEvent("swayam:GetWeather")
	end
end

Citizen.CreateThread(function()
	while true do
		setweather()
	Wait(0)
	end
end)]]--

-------------------------------------------------------------------
--//https://wiki.gtanet.work/index.php?title=Notification_Pictures

RegisterNetEvent("swayam:notification")
AddEventHandler("swayam:notification", function(name, msg, icon)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	SetNotificationMessage(icon, icon, true, 1, name, "", msg)
	DrawNotification(0,1)
end)

RegisterNetEvent("swayam:getCoords")
AddEventHandler("swayam:getCoords", function()
	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
  TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^0x = " .. x .. " | y = " .. y .. " | z = " .. z)
end)

-------------------------------------------------------------------
