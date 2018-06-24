local jailX, jailY, jailZ = 1714.893, 2542.678, 45.565
local releaseX, releaseY, releaseZ = 1847.086, 2585.990, 45.672
local lPed
local imprisoned = false

-- start of NUI menu

local menuEnabled = false

function EnableGui(enable)
    SetNuiFocus(enable, enable)
    menuEnabled = enable
    SetPedCanSwitchWeapon(GetPlayerPed(-1), (not menuEnabled))

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

RegisterNetEvent("jail:notify")
AddEventHandler("jail:notify", function(msg)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end)

RegisterNetEvent("jail:openMenu")
AddEventHandler("jail:openMenu", function()
    EnableGui(true, true)
    SetPedCanSwitchWeapon(GetPlayerPed(-1), false)
    -- look at clipboard:
    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, 1)
end)

RegisterNUICallback('submit', function(data, cb)
	EnableGui(false, false) -- close form
    TriggerServerEvent("jail:jailPlayerFromMenu", data)
    cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
    EnableGui(false, false)
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        if menuEnabled then
            DisableControlAction(29, 241, menuEnabled) -- scroll up
            DisableControlAction(29, 242, menuEnabled) -- scroll down
            DisableControlAction(0, 1, menuEnabled) -- LookLeftRight
            DisableControlAction(0, 2, menuEnabled) -- LookUpDown
            DisableControlAction(0, 142, menuEnabled) -- MeleeAttackAlternate
            DisableControlAction(0, 106, menuEnabled) -- VehicleMouseControlOverride
            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)

-- end of NUI menu stuff

RegisterNetEvent("jail:jail")
AddEventHandler("jail:jail", function()

    lPed = GetPlayerPed(-1)
	FreezeEntityPosition(lPed, false) -- fix for the /cuff command freezing the player in place
	SetEntityCoords(GetPlayerPed(-1), jailX, jailY, jailZ, 1, 0, 0, 1) -- tp to jail
    imprisoned = true

end)

RegisterNetEvent("jail:release")
AddEventHandler("jail:release", function(character)
    Citizen.CreateThread(function()
	    local model
	    SetEntityCoords(GetPlayerPed(-1), releaseX, releaseY, releaseZ, 1, 0, 0, 1) -- release from jail
        imprisoned = false
        if not character.hash then
    		    model = GetHashKey("a_m_y_skater_01")
            RequestModel(model)
            while not HasModelLoaded(model) do -- Wait for model to load
                Citizen.Wait(100)
            end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
        else
            model = tonumber(character.hash)
            RequestModel(model)
            while not HasModelLoaded(model) do -- Wait for model to load
                Citizen.Wait(100)
            end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
            -- set customizations
            for key, value in pairs(character["components"]) do
                SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character["componentstexture"][key], 0)
            end
            for key, value in pairs(character["props"]) do
                SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character["propstexture"][key], true)
            end
        end
        TriggerEvent("usa:setPlayerComponents", character)
    end)
end)

RegisterNetEvent("jail:wrongPw")
AddEventHandler("jail:wrongPw", function()

	TriggerEvent("chatMessage", "SYSTEM", { 255,99,71 }, "^0WRONG JAIL PW")

end)

RegisterNetEvent("jail:removeWeapons")
AddEventHandler("jail:removeWeapons", function()

	RemoveAllPedWeapons(GetPlayerPed(-1), true) -- strip weapons

end)

--[[
MALE
Legs - 7
Legs Texture - 15
Feet - 42
Feet Texture - 2
Torso - 1
Torso Texture - 0
Accessories - 1
Accessories Texture - 0
Ties - 0
Vests - 0
Textures - 0
Arms/Hands - 0
Back - 0

FEMALE
Legs - 3
Legs Texture - 15
Back - 0
Feet - 1
Feet Texture - 0
Ties - 0
Torso - 9
Torso Texture - 1
Accessories - 2
Vests - 0
Textures - 0
Arms/Hands - 0(edited)
Prison clothes ^
]]

RegisterNetEvent("jail:changeClothes")
AddEventHandler("jail:changeClothes", function(gender)

  local me = PlayerPedId()

	-- only change clothes if male, since there is no female prisoner ped --
	if gender == "male" or gender == "undefined" then

    if not IsPedModel(me,"mp_m_freemode_01") then

  		Citizen.CreateThread(function()
  			local model = GetHashKey("S_M_Y_Prisoner_01")

  			RequestModel(model)
  			while not HasModelLoaded(model) do -- Wait for model to load
  				Citizen.Wait(100)
  			end

  			SetPlayerModel(PlayerId(), model)
  			SetModelAsNoLongerNeeded(model)
  			SetPedRandomComponentVariation(me, false)

  		end)

    else

      --SetPedComponentVariation(me, 4, 7, 15, 0)
      SetPedComponentVariation(me, 4, 7, 15, 2)
      SetPedComponentVariation(me, 6, 42, 2, 2)
      SetPedComponentVariation(me, 11, 1, 0, 2)
      SetPedComponentVariation(me, 8, 1, 0, 2)
      SetPedComponentVariation(me, 7, 0, 0, 2)
      SetPedComponentVariation(me, 9, 0, 0, 2)
      SetPedComponentVariation(me, 10, 0, 0, 2)
      SetPedComponentVariation(me, 3, 0, 0, 2)
      SetPedComponentVariation(me, 5, 0, 0, 2)

    end

	else

    if IsPedModel(me,"mp_f_freemode_01") then

      SetPedComponentVariation(me, 4, 3, 15, 2)
      SetPedComponentVariation(me, 5, 0, 0, 2)
      SetPedComponentVariation(me, 4, 3, 15, 2)
      SetPedComponentVariation(me, 6, 1, 0, 2)
      SetPedComponentVariation(me, 7, 0, 0, 2)
      SetPedComponentVariation(me, 11, 9, 1, 2)
      SetPedComponentVariation(me, 8, 2, 15, 2)
      SetPedComponentVariation(me, 3, 0, 0, 2)
      SetPedComponentVariation(me, 10, 0, 0, 2)
      SetPedComponentVariation(me, 9, 0, 0, 2)

    end

  end

end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if imprisoned and getPlayerDistanceFromCoords(jailX, jailY, jailZ) > 80 then
            SetEntityCoords(GetPlayerPed(-1), jailX, jailY, jailZ, 1, 0, 0, 1)
        end
    end
end)

function getPlayerDistanceFromCoords(x,y,z)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,x,y,z,false)
end
