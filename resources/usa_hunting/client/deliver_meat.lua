-- Trader ped config
local MEAT_TRADER_NPC_MODEL = "s_m_y_chef_01" 
local meat_location = {959.75512695313, -2187.6110839844, 30.51185798645, 87.14}

-- spawn fur trader NPC
local meatTraderNPC = nil
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId(), false)
        local x,y,z,heading = table.unpack(meat_location)
        if Vdist(playerCoords, x, y, z) < 60 then
            if not meatTraderNPC then
                RequestModel(GetHashKey(MEAT_TRADER_NPC_MODEL))
                while not HasModelLoaded(MEAT_TRADER_NPC_MODEL) do
                    RequestModel(MEAT_TRADER_NPC_MODEL)
                    Wait(1)
                end
                meatTraderNPC = CreatePed(0, MEAT_TRADER_NPC_MODEL, x, y, z, heading, false, false) -- need to add distance culling
                SetEntityCanBeDamaged(meatTraderNPC,false)
                SetPedCanRagdollFromPlayerImpact(meatTraderNPC,false)
                SetBlockingOfNonTemporaryEvents(meatTraderNPC,true)
                SetPedFleeAttributes(meatTraderNPC,0,0)
                SetPedCombatAttributes(meatTraderNPC,17,1)
            end
        else
            if meatTraderNPC then
                DeletePed(meatTraderNPC)
                meatTraderNPC = nil
            end
        end
        Wait(1)
    end
end)

-- Prompt to sell meat to burger store
Citizen.CreateThread(function()
    while true do
        local mycoords = GetEntityCoords(PlayerPedId())
        local x,y,z = table.unpack(meat_location)
        if GetDistanceBetweenCoords(x, y, z, mycoords, true) < 7 then
            promptSale(x,y,z)
        end
        Wait(0)
    end
end)

-- Sell the fur
function promptSale(location)
    exports.globals:DrawText3D(meat_location[1], meat_location[2], meat_location[3], "[E] - Sell Meat")
    local beginTime = GetGameTimer()
    if IsControlJustPressed(0, 38) then
        local pid = PlayerPedId()
        RequestAnimDict("anim@narcotics@trash")
        while (not HasAnimDictLoaded("anim@narcotics@trash")) do Wait(0) end
        while GetGameTimer() - beginTime < 10000 do
            if not IsEntityPlayingAnim(pid, "anim@narcotics@trash", "drop_front", 3) then
                TaskPlayAnim(pid, "anim@narcotics@trash", "drop_front", 8.0, 1.0, -1, 11, 1.0, false, false, false)
            end
            exports.globals:DrawTimerBar(beginTime, 10000, 1.42, 1.475, 'Selling Meat')
            Wait(1)
        end
        ClearPedTasks(pid)
        TriggerServerEvent("hunting:sellMeat", location)
    end
end