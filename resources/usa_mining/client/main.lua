local createdMenus = {}

local MINING = {
    {x = 1797.88, y = -2831.8, z = 3.57, radius = 30},
    {x = -592.55, y = 2076.86, z = 131.37, radius = 40}
}

_menuPool = NativeUI.CreatePool()
miningMenu = NativeUI.CreateMenu('Sell Mined Goods', "~~b~Please select an item you would like to sell!", 0, 320)
table.insert(createdMenus, {menu = miningMenu})

for i = 1, #createdMenus do
    _menuPool:Add(createdMenus[i].menu)
end

RegisterNetEvent('mining:deleteDoor')
AddEventHandler('mining:deleteDoor', function()
    SetEntityAsMissionEntity(4591362)
    DeleteObject(4591362)
end)

TriggerEvent('miningDeleteDoor')

Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId()
        for i = 1, #MINING do
            if nearMarker(MINING[i].x, MINING[i].y, MINING[i].z, MINING[i].radius) then
                exports.globals:DrawText3D(MINING[i].x, MINING[i].y, MINING[i].z, '[E] - Start Mining')
                if IsControlJustPressed(0, 86) and not IsPedInAnyVehicle(player) then
                    TriggerServerEvent('mining:doesUserHaveCorrectItems')
                end
            end
        end
        Wait(0)
    end
end)

RegisterNetEvent('mining:startMining')
AddEventHandler('mining:startMining', function()
    local ped = PlayerPedId()
    local begintime = GetGameTimer()
    exports.globals:loadAnimDict("anim@move_m@trash")
    while GetGameTimer() - begintime < 15000 do
        exports.globals:DrawTimerBar(begintime, 15000, 1.42, 1.475, 'Mining')
        if not IsEntityPlayingAnim(ped, "anim@move_m@trash", "pickup", 3) then
            TaskPlayAnim(ped, "anim@move_m@trash", "pickup", 8.0, 1.0, 15000, 1.0, false, false, false)
        end
        Wait(1)
    end
    ClearPedTasksImmediately(ped)
    TriggerServerEvent('mining:giveUserMiningGoods')
end)


local purchaser = 'a_f_y_business_01'
local purchase_location = {x = -629.08, y = -265.75, z = 38.79}
local purchase_location = {x = -629.08, y = -265.75, z = 38.79}
local BASE_SELL_TIME = 5000

local NPCHandle = nil
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId(), false)
        if Vdist(playerCoords, purchase_location.x, purchase_location.y, purchase_location.z) < 40 then
            if not NPCHandle then
                RequestModel(GetHashKey(purchaser))
                while not HasModelLoaded(purchaser) do
                    RequestModel(purchaser)
                    Wait(1)
                end
                NPCHandle = CreatePed(0, purchaser, purchase_location.x, purchase_location.y, purchase_location.z, 0.1, false, false)
                SetEntityCanBeDamaged(NPCHandle, false)
                SetPedCanRagdollFromPlayerImpact(NPCHandle, false)
                SetBlockingOfNonTemporaryEvents(NPCHandle, true)
                SetPedFleeAttributes(NPCHandle,0,0)
                SetPedCombatAttributes(NPCHandle,17,1)
            end
        else
            if NPCHandle then
                DeletePed(NPCHandle)
                NPCHandle = nil
            end
        end
        Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if nearMarker(purchase_location.x, purchase_location.y, purchase_location.z, 3) then
            exports.globals:DrawText3D(purchase_location.x, purchase_location.y, purchase_location.z, '[E] - Sell Mined Goods')
            if IsControlJustPressed(0, 86) then
                local thisSellTime = BASE_SELL_TIME + math.random(1000, 5000)
                local beginTime = GetGameTimer()
                while GetGameTimer() - beginTime < thisSellTime do
                    exports.globals:DrawTimerBar(beginTime, thisSellTime, 1.42, 1.475, 'Selling Mined Goods')
                    DisableControlAction(0, 244, true) -- 244 = M key (interaction menu / inventory)
                    DisableControlAction(0, 38, true) -- prevent spam clicking
                    Wait(1)
                end
                TriggerServerEvent('mining:sellMinedItems')
            end
        end
        Wait(1)
    end
end)


function nearMarker(x, y, z, radius)
    local coords = GetEntityCoords(PlayerPedId())
    return Vdist(x, y, z, coords.x, coords.y, coords.z) < radius
end