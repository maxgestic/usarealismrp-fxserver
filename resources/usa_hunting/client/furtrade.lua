-- Trader ped config
local trader = "a_f_y_business_01"
local trade_location = {714.13763427734, -977.67169189453, 24.122426986694, 242.0}

-- spawn fur trader NPC
local furTraderNPC = nil
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId(), false)
        local x,y,z,heading = table.unpack(trade_location)
        if Vdist(playerCoords, x, y, z) < 60 then
            if not furTraderNPC then
                RequestModel(GetHashKey(trader))
                while not HasModelLoaded(trader) do
                    RequestModel(trader)
                    Wait(1)
                end
                furTraderNPC = CreatePed(0, trader, x, y, z, heading, false, false) -- need to add distance culling
                SetEntityCanBeDamaged(furTraderNPC,false)
                SetPedCanRagdollFromPlayerImpact(furTraderNPC,false)
                SetBlockingOfNonTemporaryEvents(furTraderNPC,true)
                SetPedFleeAttributes(furTraderNPC,0,0)
                SetPedCombatAttributes(furTraderNPC,17,1)
            end
        else
            if furTraderNPC then
                DeletePed(furTraderNPC)
                furTraderNPC = nil
            end
        end
        Wait(1)
    end
end)

-- Prompt when by the ped for selling fur
Citizen.CreateThread(function()
    while true do
        local mycoords = GetEntityCoords(PlayerPedId())
        local x,y,z = table.unpack(trade_location)
        if Vdist(mycoords, x, y, z) < 8 then
            promptFurSale(x,y,z)
        end
        Wait(0)
    end
end)

-- Sell the fur
function promptFurSale()
    local beginTime = GetGameTimer()
    exports.globals:DrawText3D(trade_location[1], trade_location[2], trade_location[3], '[E] - Sell Fur(s)')
    if IsControlJustPressed(0, 38) then
        exports.globals:loadAnimDict("missheist_agency2aig_13")
        while GetGameTimer() - beginTime < 5000 do
            local pid = PlayerPedId()
            while GetGameTimer() - beginTime < 10000 do
                if not IsEntityPlayingAnim(pid, "missheist_agency2aig_13", "pickup_briefcase_upperbody", 3) then
                    TaskPlayAnim(pid, "missheist_agency2aig_13", "pickup_briefcase_upperbody", 8.0, 1.0, -1, 11, 1.0, false, false, false)
                end
                exports.globals:DrawTimerBar(beginTime, 10000, 1.42, 1.475, 'Selling Fur')
                Wait(1)
            end
            ClearPedTasks(pid)
            Wait(0)
        end
        TriggerServerEvent("hunting:sellFur")
    end
end