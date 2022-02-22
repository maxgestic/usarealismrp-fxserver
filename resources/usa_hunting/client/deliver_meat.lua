-- Trader ped config
local MEAT_TRADER_NPC_MODEL = "s_m_y_chef_01" 
local meat_sell_locations = {
    {x = 959.75512695313, y = -2187.6110839844, z = 30.51185798645, h = 87.14},
    {x = -1202.5804443359, y = -895.58770751953, z = 13.995266914368, h = 291.0},
    {x = -69.21866607666, y = 6270.1279296875, z = 31.323371887207, h = 68.0}
}

-- spawn fur trader NPC
local meatTraderNPC = nil
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId(), false)
        for i = 1, #meat_sell_locations do
            if Vdist(playerCoords, meat_sell_locations[i].x, meat_sell_locations[i].y, meat_sell_locations[i].z) < 60 then
                if not meat_sell_locations[i].meatTraderNPC then
                    RequestModel(GetHashKey(MEAT_TRADER_NPC_MODEL))
                    while not HasModelLoaded(MEAT_TRADER_NPC_MODEL) do
                        RequestModel(MEAT_TRADER_NPC_MODEL)
                        Wait(1)
                    end
                    meat_sell_locations[i].meatTraderNPC = CreatePed(0, MEAT_TRADER_NPC_MODEL, meat_sell_locations[i].x, meat_sell_locations[i].y, meat_sell_locations[i].z, meat_sell_locations[i].h, false, false) -- need to add distance culling
                    SetEntityCanBeDamaged(meat_sell_locations[i].meatTraderNPC,false)
                    SetPedCanRagdollFromPlayerImpact(meat_sell_locations[i].meatTraderNPC,false)
                    SetBlockingOfNonTemporaryEvents(meat_sell_locations[i].meatTraderNPC,true)
                    SetPedFleeAttributes(meat_sell_locations[i].meatTraderNPC,0,0)
                    SetPedCombatAttributes(meat_sell_locations[i].meatTraderNPC,17,1)
                    Wait(1000)
                    FreezeEntityPosition(meat_sell_locations[i].meatTraderNPC, true)
                end
            else
                if meat_sell_locations[i].meatTraderNPC then
                    DeletePed(meat_sell_locations[i].meatTraderNPC)
                    meat_sell_locations[i].meatTraderNPC = nil
                end
            end
        end
        Wait(1)
    end
end)

-- Prompt to sell meat to burger store
Citizen.CreateThread(function()
    while true do
        local mycoords = GetEntityCoords(PlayerPedId())
        for i = 1, #meat_sell_locations do
            if GetDistanceBetweenCoords(meat_sell_locations[i].x, meat_sell_locations[i].y, meat_sell_locations[i].z, mycoords, true) < 1.5 then
                exports.globals:DrawText3D(meat_sell_locations[i].x, meat_sell_locations[i].y, meat_sell_locations[i].z, "[E] - Sell Meat")
                promptSale()
            end
        end
        Wait(2)
    end
end)

-- Sell the fur
function promptSale()
    local beginTime = GetGameTimer()
    if IsControlJustPressed(0, 38) then
        local hasMeat = TriggerServerCallback {
            eventName = "hunting:doesHaveMeat",
            args = {}
        }
        if not hasMeat then
            exports.globals:notify("No meat to sell!")
            return
        end
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
        TriggerServerEvent("hunting:sellMeat")
    end
end