local hunt_shack_location = {x = -1493.3, y = 4972.0, z = 63.93}

local SHOW_HINT_TEXT_DIST = 15
local MAX_HINT_TEXT_DIST = 5

local BUTCHER_ANIMATION_TIME_SECONDS = 30
local HUNTING_COOK_MEAT_TIME_SECONDS = 10

local KEYS = {
    E = 38
}

-- handle hunting hint text
Citizen.CreateThread(function()
    while true do
        local myped = PlayerPedId()
        local mycoords = GetEntityCoords(myped)
        local dist = GetDistanceBetweenCoords(hunt_shack_location.x, hunt_shack_location.y, hunt_shack_location.z, mycoords.x, mycoords.y, mycoords.z, true)
        if dist < SHOW_HINT_TEXT_DIST then
            exports.globals:DrawText3D(hunt_shack_location.x, hunt_shack_location.y, hunt_shack_location.z, "[E] - Hint")
        end
        if dist < MAX_HINT_TEXT_DIST then
            if IsControlPressed(0, KEYS.E) then
                Wait(200)
                TriggerEvent("chatMessage", "", {}, "^3HINT: ^0You are permitted to hunt only in rural areas and at least 1,000 feet away from any paved or unpaved roads. You can deliver any meat you gather to Hector at \"Raven's Slaughter House\" located just East of gun store #11 in South Los Santos.")
                Wait(3000)
                TriggerEvent("chatMessage", "", {}, "^3HINT: ^0You can deliver any hides you gather to Megan at the Darnell Bros Factory located just North of LS Customs #2.")
                Wait(3000)
            end
        end
        Wait(1)
    end
end)

-- skinning / butchering dead animals
Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, KEYS.E) then
            local myped = PlayerPedId()
            local playerCoords = GetEntityCoords(myped)
            local isInVeh = IsPedInAnyVehicle(myped, true)
            for otherPed in exports.globals:EnumeratePeds() do
                if not isBlacklistedModel(GetEntityModel(otherPed)) then
                    local pedCoords = GetEntityCoords(otherPed)
                    local distBetweenPedAndAnimal = Vdist(pedCoords, playerCoords)
                    if DoesEntityExist(otherPed) and IsPedDeadOrDying(otherPed) then
                        if distBetweenPedAndAnimal <= 1.5 and otherPed ~= myped and not IsPedHuman(otherPed) and not isInVeh then
                            SetEntityAsMissionEntity(otherPed)
                            local beginTime = GetGameTimer()
                            exports.globals:loadAnimDict("amb@medic@standing@kneel@idle_a")
                            while GetGameTimer() - beginTime < BUTCHER_ANIMATION_TIME_SECONDS * 1000 do
                                if not IsEntityPlayingAnim(myped, "amb@medic@standing@kneel@idle_a", "idle_a", 3) then
                                    TaskPlayAnim(myped, "amb@medic@standing@kneel@idle_a", "idle_a", 8.0, 1.0, -1, 11, 1.0, false, false, false)
                                end
                                exports.globals:DrawTimerBar(beginTime, BUTCHER_ANIMATION_TIME_SECONDS * 1000, 1.42, 1.475, 'Skinning & Butchering')
                                Wait(1)
                            end
                            ClearPedTasks(myped)
                            if DoesEntityExist(otherPed) then
                                while securityToken == nil do
                                    Wait(1)
                                end
                                TriggerServerEvent('hunting:skinforfurandmeat', securityToken)
                                DeleteEntity(otherPed)
                            end
                        end
                    end
                end
            end
        end
        Wait(1)
    end
end)


RegisterNetEvent('hunting:cookMeat')
AddEventHandler('hunting:cookMeat', function()
    local myped = PlayerPedId()
    local playerCoords = GetEntityCoords(myped)
    local campfire = getClosestCampfireInRange(playerCoords, 5)
    if DoesEntityExist(campfire) then
        local beginTime = GetGameTimer()
        exports.globals:loadAnimDict("amb@medic@standing@kneel@idle_a")
        while GetGameTimer() - beginTime < HUNTING_COOK_MEAT_TIME_SECONDS * 1000 do
            if not IsEntityPlayingAnim(myped, "amb@medic@standing@kneel@idle_a", "idle_a", 3) then
                TaskPlayAnim(myped, "amb@medic@standing@kneel@idle_a", "idle_a", 8.0, 1.0, -1, 11, 1.0, false, false, false)
            end
            exports.globals:DrawTimerBar(beginTime, HUNTING_COOK_MEAT_TIME_SECONDS * 1000, 1.42, 1.475, 'Cooking Meat')
            Wait(1)
        end
        while securityToken == nil do
            Wait(1)
        end
        TriggerServerEvent('hunting:giveCookedMeat', securityToken)
        ClearPedTasks(myped)
    end
end)



function isBlacklistedModel(model)
    local BLACK_LISTED_MODELS = {}
    BLACK_LISTED_MODELS[-1788665315] = true -- rottweiler
    BLACK_LISTED_MODELS[882848737] = true -- retriever
    BLACK_LISTED_MODELS[1832265812] = true -- pug
    BLACK_LISTED_MODELS[1125994524] = true -- poodle
    BLACK_LISTED_MODELS[1126154828] = true -- shepherd
    BLACK_LISTED_MODELS[-1384627013] = true -- westy
    BLACK_LISTED_MODELS[1318032802] = true -- husky
    BLACK_LISTED_MODELS[1462895032] = true -- cat
    BLACK_LISTED_MODELS[1173762] = false -- campfire
    BLACK_LISTED_MODELS[GetHashKey("a_c_rat")] = true -- rat
    BLACK_LISTED_MODELS[GetHashKey("a_c_hen")] = true -- chicken

    return BLACK_LISTED_MODELS[model]
end

function getClosestCampfireInRange(coords, range)
    print('alalal')
    for object in exports.globals:EnumerateObjects() do
        local pedCoords = GetEntityCoords(object)
        local distBetweenPedAndCampfire = Vdist(pedCoords, coords)
        local campfire = -1065766299
        if DoesEntityExist(object) then
            if distBetweenPedAndCampfire <= 5 and GetEntityModel(object) == campfire then
                return object
            end
        end
    end
end