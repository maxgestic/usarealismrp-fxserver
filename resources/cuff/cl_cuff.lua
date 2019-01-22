local lPed
local isCuffed = false
local isHardcuffed = false
local cuffanimplaying = false
local awaitingHandsDown = false
local prevMaleVariation = 0
local prevFemaleVariation = 0

RegisterNetEvent("cuff:attemptToCuffNearest")
AddEventHandler("cuff:attemptToCuffNearest", function()
	TriggerEvent("usa:getClosestPlayer", 1.65, function(player)
		if player then
			if tonumber(player.id) ~= 0 then
				local x,y,z=table.unpack(GetEntityCoords(GetPlayerPed(-1)))
    			local heading = GetEntityHeading(GetPlayerPed(-1))
				TriggerServerEvent("cuff:Handcuff", player.id, true)
				TriggerServerEvent("cuff:triggerSuspectAnim", player.id, x, y, z, heading)
				TriggerEvent('cuff:playPoliceAnim', 1)
			else
				DrawCoolLookingNotificationNoPic("No target found to cuff!")
			end
		end
	end)
end)

RegisterNetEvent('cuff:playPoliceAnim')
AddEventHandler('cuff:playPoliceAnim', function(animType)
	if animType == 1 then
		local ped = GetPlayerPed(-1)
	    RequestAnimDict('mp_arrest_paired')
	    RequestAnimDict('missprologueig_2')
	    while not HasAnimDictLoaded('mp_arrest_paired') do
	        Citizen.Wait(0)
	    end
	    while not HasAnimDictLoaded('missprologueig_2') do
	        Citizen.Wait(0)
	    end
	    FreezeEntityPosition(ped, true)
	    TaskPlayAnim(ped, "mp_arrest_paired", "cop_p2_back_right", 8.0, -8, -1, 48, 0, 0, 0, 0)
	    Citizen.Wait(2000)
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1, 'cuffing', 1.0)
        Citizen.Wait(1600)
	    ClearPedTasks(ped)
	elseif animType == 2 then
		local anim = {
			dict = "anim@move_m@trash",
			name = "pickup"
		}
		TriggerEvent("usa:playAnimation", anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 1.5)
	end
end)

RegisterNetEvent('cuff:playSuspectAnim')
AddEventHandler('cuff:playSuspectAnim', function(x,y,z,heading)
    ped = GetPlayerPed(-1)
    RequestAnimDict('mp_arrest_paired')
    while not HasAnimDictLoaded('mp_arrest_paired') do
        Citizen.Wait(0)
    end
    cuffanimplaying = true
    TaskPlayAnim(ped, "mp_arrest_paired", "crook_p2_back_right", 8.0, -8, -1, 32, 0, 0, 0, 0)
    Citizen.Wait(3000)
    cuffanimplaying = false
end)

RegisterNetEvent("cuff:unCuff")
AddEventHandler("cuff:unCuff", function()
	ClearPedSecondaryTask(lPed)
	SetEnableHandcuffs(lPed, false)
	--FreezeEntityPosition(lPed, false)
	DrawCoolLookingNotificationNoPic("You have been ~g~released~w~.")
	isCuffed = false
	if IsPedModel(lPed,"mp_m_freemode_01") or IsPedModel(lPed,"mp_f_freemode_01") then
		SetPedComponentVariation(lPed, 7, 0, 0, 2)
	end
end)

RegisterNetEvent("cuff:Handcuff")
AddEventHandler("cuff:Handcuff", function()
	TriggerServerEvent('cuff:forceHandsDown')
	Citizen.Wait(100)
	lPed = GetPlayerPed(-1)
	if DoesEntityExist(lPed) then
		Citizen.CreateThread(function()
			RequestAnimDict("mp_arresting")
			while not HasAnimDictLoaded("mp_arresting") do
				Citizen.Wait(100)
			end
			--if IsEntityPlayingAnim(lPed, "mp_arresting", "idle", 3) then
			if isCuffed then
				Citizen.Trace("ENTITY WAS ALREADY PLAYING ARRESTED ANIM, UNCUFFING")
				ClearPedSecondaryTask(lPed)
				SetEnableHandcuffs(lPed, false)
				--FreezeEntityPosition(lPed, false)
				DrawCoolLookingNotificationNoPic("You have been ~g~released~w~.")
				isCuffed = false
				isHardcuffed = false
				if IsPedModel(lPed,"mp_f_freemode_01") then
	            	SetPedComponentVariation(lPed, 7, prevFemaleVariation, 0, 0)
	        	elseif IsPedModel(lPed, "mp_m_freemode_01") then
	            	SetPedComponentVariation(lPed, 7, prevMaleVariation, 0, 0)
	        	end
			else
				while IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arrest_paired", "crook_p2_back_right", 3) or cuffanimplaying do
					Citizen.Wait(5)
				end
				Citizen.Trace("ENTITY WAS NOT PLAYING ARRESTED ANIM, CUFFING")
				TaskPlayAnim(lPed, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
				SetEnableHandcuffs(lPed, true)
				SetCurrentPedWeapon(lPed, GetHashKey("WEAPON_UNARMED"), true)
				-- FreezeEntityPosition(lPed, true)
				DrawCoolLookingNotificationNoPic("You have been ~r~detained~w~.")
				isCuffed = true
				isHardcuffed = false
				if IsPedModel(lPed,"mp_f_freemode_01") then
			  		prevFemaleVariation = GetPedDrawableVariation(lPed, 7)
					SetPedComponentVariation(lPed, 7, 25, 0, 0)
				elseif IsPedModel(lPed,"mp_m_freemode_01") then
					prevMaleVariation = GetPedDrawableVariation(lPed, 7)
            		SetPedComponentVariation(lPed, 7, 41, 0, 0)
				end
			end
		end)
	end
end)

function getPlayerDistanceFromCoords(x,y,z)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,x,y,z,false)
end

local uncuff_locations = {
	{x = -533.3, y = 5291.5, z = 74.2}
}

Citizen.CreateThread(function()
	while true do
		Wait(0)
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

			if isHardcuffed then
				DisableControlAction(0, 30, true)
				DisableControlAction(0, 31, true)
				DisableControlAction(0, 19, true)
			end

			if not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) then
				RequestAnimDict("mp_arresting")
				while not HasAnimDictLoaded("mp_arresting") do
					Citizen.Wait(100)
				end
				TaskPlayAnim(lPed, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
			end

			----------------------
			-- uncuffing circle --
			----------------------
			for i = 1, #uncuff_locations do
				DrawMarker(27, uncuff_locations[i].x, uncuff_locations[i].y, uncuff_locations[i].z - 0.9, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 3.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
				local playercoords = GetEntityCoords(GetPlayerPed(-1))
				if Vdist(uncuff_locations[i].x, uncuff_locations[i].y, uncuff_locations[i].z, playercoords.x, playercoords.y, playercoords.z) < 5.0 then
					TriggerEvent("usa:notify", "Cutting off your cuffs! Stay nearby!")
					local start = GetGameTimer()
					while GetGameTimer() - start < 45000 do
						Wait(45000)
					end
					if Vdist(uncuff_locations[i].x, uncuff_locations[i].y, uncuff_locations[i].z, playercoords.x, playercoords.y, playercoords.z) > 5.0 then
						TriggerClientEvent("usa:notify", "You went out of range!")
					else
						TriggerEvent("cuff:unCuff")
					end
					break
				end
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        if not isCuffed and IsControlPressed(0, 19) and IsControlJustPressed(0, 38) and not IsPedRagdoll(ped) and not IsEntityDead(ped) and DoesEntityExist(ped) and not IsPedSittingInAnyVehicle( ped ) and not IsPedInMeleeCombat(ped) then
        	TriggerServerEvent('pdmenu:checkWhitelist', 'cuff:triggerHotkeyCuff')
        end
    end
end)

RegisterNetEvent('cuff:triggerHotkeyCuff')
AddEventHandler('cuff:triggerHotkeyCuff', function()
	local pedtocuff = GetPedInFront()
    local pedsource = GetPlayerServerId(GetPlayerFromPed(pedtocuff))
    local x,y,z=table.unpack(GetEntityCoords(GetPlayerPed(-1)))
    local heading = GetEntityHeading(GetPlayerPed(-1))
    local px,py,pz=table.unpack(GetEntityCoords(pedtocuff))
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z)
    if dist < 1 and not IsPedInMeleeCombat(pedtocuff) and not IsPedSprinting(pedtocuff) and not IsPedJumping(pedtocuff) and not IsPedRunning(pedtocuff) and IsPedAPlayer(pedtocuff) then
        TriggerEvent('cuff:playPoliceAnim', 1)
        TriggerServerEvent('cuff:triggerSuspectAnim', pedsource, x,y,z,heading)
        TriggerServerEvent('cuff:Handcuff', pedsource)
    end
end)

RegisterNetEvent('cuff:toggleHardcuff')
AddEventHandler('cuff:toggleHardcuff', function(value)
	isHardcuffed = value
	if isHardcuffed then
		DrawCoolLookingNotificationNoPic("You have been hardcuffed to an object!")
	else
		DrawCoolLookingNotificationNoPic("You are free to walk...")
	end
end)

function GetPedInFront()
    local player = PlayerId()
    local plyPed = GetPlayerPed(player)
    local plyPos = GetEntityCoords(plyPed, false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
    local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
    local _, _, _, _, ped = GetShapeTestResult(rayHandle)
    return ped
end

function GetPlayerFromPed(ped)
    for a = 0, 64 do
        if GetPlayerPed(a) == ped then
            return a
        end
    end
    return -1
end

