local jailX, jailY, jailZ = 1714.893, 2542.678, 45.565
local releaseX, releaseY, releaseZ = 1847.086, 2585.990, 45.672
local lPed
local imprisoned = false

-- start of NUI menu

local menuEnabled = false

function EnableGui(enable)
    SetNuiFocus(enable)
    menuEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

RegisterNetEvent("jail:openMenu")
AddEventHandler("jail:openMenu", function()
    EnableGui(true)
end)

RegisterNUICallback('submit', function(data, cb)
    --PrintChatMessage("id = " .. data.id)
	--PrintChatMessage("sentence = " .. data.sentence)
--	PrintChatMessage("charges = " .. data.charges)
	EnableGui(false) -- close form
    TriggerServerEvent("jail:jailPlayerFromMenu", data)
    cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
    EnableGui(false)
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        if menuEnabled then
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
AddEventHandler("jail:jail", function(reason, sentence)

    lPed = GetPlayerPed(-1)
	FreezeEntityPosition(lPed, false) -- fix for the /cuff command freezing the player in place
	SetEntityCoords(GetPlayerPed(-1), jailX, jailY, jailZ, 1, 0, 0, 1) -- tp to jail
    imprisoned = true

end)

RegisterNetEvent("jail:release")
AddEventHandler("jail:release", function(playerModel)

	local model

	SetEntityCoords(GetPlayerPed(-1), releaseX, releaseY, releaseZ, 1, 0, 0, 1) -- release from jail
    imprisoned = false

	Citizen.CreateThread(function()

		if string.match(playerModel, "_") then
        	model = GetHashKey(playerModel)
		else
			model = tonumber(playerModel)
		end

        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            RequestModel(model)
            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)

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

RegisterNetEvent("jail:changeClothes")
AddEventHandler("jail:changeClothes", function()

    Citizen.CreateThread(function()
        local model = GetHashKey("S_M_Y_Prisoner_01")

        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            RequestModel(model)
            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)

    end)

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
