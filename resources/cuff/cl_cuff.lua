local lPed
local isCuffed = false

RegisterNetEvent("cuff:Handcuff")
AddEventHandler("cuff:Handcuff", function(cuffer)
	lPed = GetPlayerPed(-1)
	if DoesEntityExist(lPed) then
		Citizen.CreateThread(function()
			RequestAnimDict("mp_arresting")
			while not HasAnimDictLoaded("mp_arresting") do
				Citizen.Wait(100)
			end
			if IsEntityPlayingAnim(lPed, "mp_arresting", "idle", 3) then
				Citizen.Trace("ENTITY WAS ALREADY PLAYING ARRESTED ANIM, UNCUFFING")
				ClearPedSecondaryTask(lPed)
				SetEnableHandcuffs(lPed, false)
				--FreezeEntityPosition(lPed, false)
				DrawCoolLookingNotificationNoPic("You have been ~g~released~w~.")
				isCuffed = false
			else
				Citizen.Trace("ENTITY WAS NOT PLAYING ARRESTED ANIM, CUFFING")
				TaskPlayAnim(lPed, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
				SetEnableHandcuffs(lPed, true)
				-- FreezeEntityPosition(lPed, true)
				DrawCoolLookingNotificationNoPic("You have been ~r~detained~w~.")
				isCuffed = true
			end
		end)
	end
end)

local jailX, jailY, jailZ = 1714.893, 2542.678, 45.565

function getPlayerDistanceFromCoords(x,y,z)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,x,y,z,false)
end

Citizen.CreateThread(function()
	while true do
		Wait(0)

		if getPlayerDistanceFromCoords(jailX, jailY, jailZ) <= 80 then
			isCuffed = false
		end

		if isCuffed then
			--DisableControlAction(1, 245, true) 245 = 5 FOR TEXT CHAT
			DisableControlAction(1, 117, true)
			DisableControlAction(1, 73, true)
			DisableControlAction(1, 29, true)
			DisableControlAction(1, 322, true)

			DisableControlAction(1, 18, true)
			DisableControlAction(1, 24, true)
			DisableControlAction(1, 69, true)
			DisableControlAction(1, 92, true)
			DisableControlAction(1, 106, true)
			DisableControlAction(1, 122, true)
			DisableControlAction(1, 135, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 144, true)
			DisableControlAction(1, 176, true)
			DisableControlAction(1, 223, true)
			DisableControlAction(1, 229, true)
			DisableControlAction(1, 237, true)
			DisableControlAction(1, 257, true)
			DisableControlAction(1, 329, true)
			DisableControlAction(1, 80, true)
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 250, true)
			DisableControlAction(1, 263, true)
			DisableControlAction(1, 310, true)
			--DisableControlAction(0, 288, true) -- interaction menu (F1)

			DisableControlAction(1, 22, true)
			DisableControlAction(1, 55, true)
			DisableControlAction(1, 76, true)
			DisableControlAction(1, 102, true)
			DisableControlAction(1, 114, true)
			DisableControlAction(1, 143, true)
			DisableControlAction(1, 179, true)
			DisableControlAction(1, 193, true)
			DisableControlAction(1, 203, true)
			DisableControlAction(1, 216, true)
			DisableControlAction(1, 255, true)
			DisableControlAction(1, 298, true)
			DisableControlAction(1, 321, true)
			DisableControlAction(1, 328, true)
			DisableControlAction(1, 331, true)
			DisableControlAction(0, 63, false)
			DisableControlAction(0, 64, false)
			DisableControlAction(0, 59, false)
			DisableControlAction(0, 278, false)
			DisableControlAction(0, 279, false)
			DisableControlAction(0, 68, false)
			DisableControlAction(0, 69, false)
			DisableControlAction(0, 75, false)
			DisableControlAction(0, 76, false)
			DisableControlAction(0, 102, false)
			DisableControlAction(0, 81, false)
			DisableControlAction(0, 82, false)
			DisableControlAction(0, 83, false)
			DisableControlAction(0, 84, false)
			DisableControlAction(0, 85, false)
			DisableControlAction(0, 86, false)
			DisableControlAction(0, 106, false)
			DisableControlAction(0, 25, false)

			-- slow down while cuffed
			--SetEntityVelocity(GetPlayerPed(-1), 0.3, 0.3, 0.0)
			DisableControlAction(0, 21, true)

			if not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) then
				RequestAnimDict("mp_arresting")
				while not HasAnimDictLoaded("mp_arresting") do
					Citizen.Wait(100)
				end
				TaskPlayAnim(lPed, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
			end
		end
	end
end)

RegisterNetEvent("cuff:notify")
AddEventHandler("cuff:notify", function(msg)
	DrawCoolLookingNotificationNoPic(msg)
end)

function DrawCoolLookingNotificationWithPic(name, msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	SetNotificationMessage("CHAR_BLOCKED", "CHAR_BLOCKED", true, 1, name, "", msg)
	DrawNotification(0,1)
end

function DrawCoolLookingNotificationNoPic(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

-- new stuff below: --
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local target = GetCurrentTargetCar()
		playerId = 0
		playerName = ""
		for id = 0, 64 do
			if NetworkIsPlayerActive(id) then
				if GetPlayerPed(id) == target then
					playerId = GetPlayerServerId(id)
					playerName = GetPlayerName(id)
				end
			end
		end
		-- Citizen.Trace("target = " .. target)
		if target ~= nil then
			if ( IsControlPressed( 1, 36 ) and IsControlJustPressed( 1, 38 ) ) then -- LCTRL + e to cuff
				--Citizen.Trace("Y DETECTED!")
				--Citizen.Trace("target = " .. target)
				if playerId ~= 0 then
					--Citizen.Trace("SENDING CUFF!")
					TriggerServerEvent("cuff:Handcuff", playerId)
				end
			end
		end
	end
end)

function GetCurrentTargetCar()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)

    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    local rayHandle = CastRayPointToPoint(coords.x, coords.y, coords.z, entityWorld.x, entityWorld.y, entityWorld.z, 2, ped, 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)

	--DrawMarker(4, entityWorld.x, entityWorld.y, entityWorld.z, 0, GetEntityHeading(GetPlayerPed(-1)), 0, 0, 0.0, 0, 1.5, 1.0, 1.25, 255, 255, 255, 200, 0, false, 0, 0)

    return vehicleHandle
end
