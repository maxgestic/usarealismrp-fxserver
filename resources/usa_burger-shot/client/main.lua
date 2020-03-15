-- CONFIG STUFF
local ITEMS = {}
TriggerServerEvent("burgerjob:loadItems")

local standardPress = "[E] - "
local startWork = standardPress .. "Start work"
local quitWork = standardPress .. "Quit work"

local timer
local minutesuntilFired = 8

local employer_ped = "csb_burgerdrug"
local employer_location = {-1190.24, -897.37, 14.0}

-- Strike system
local timeBeforeStrikes = 600 * 1000
local signedIn = nil

local JOB_START_TEXT_DIST = 3

local utils = {
    {x = -1198.91, y = -895.17, z = 14.0, model = "smoothie"},
    {x = -1199.66, y = -900.84, z = 14.0, model = "burgers"},
    {x = -1201.17, y = -898.72, z = 14.0, model = 'frying'}
}

local working = "no"
local createdMenus = {}
-- CONFIG END

-- MENUS
_menuPool = NativeUI.CreatePool()

foodMenu = NativeUI.CreateMenu("Burger Menu", "~b~Please select an item!", 0 --[[X COORD]], 320 --[[Y COORD]])
table.insert(createdMenus, { menu = foodMenu, category = "Burgers", model = "burgers"})
sodaMenu = NativeUI.CreateMenu("Soda Machine", "~b~Please select an item!", 0 --[[X COORD]], 320 --[[Y COORD]])
table.insert(createdMenus, { menu = sodaMenu, category = "Soda", model = "smoothie"})
waterMenu = NativeUI.CreateMenu("Frying Menu", "~b~Please select an item!", 0 --[[X COORD]], 320 --[[Y COORD]])
table.insert(createdMenus, { menu = waterMenu, category = "Fry", model = "frying"})

for i = 1, #createdMenus do
    _menuPool:Add(createdMenus[i].menu)
end

RegisterNetEvent("burgerjob:loadItems")
AddEventHandler("burgerjob:loadItems", function(items)
    ITEMS = items
    for i = 1, #createdMenus do
        CreateMenu(createdMenus[i].menu, createdMenus[i].category)
    end
    _menuPool:RefreshIndex()
end)
-- MENU END

RegisterNetEvent('burgerjob:checkStrikes')
AddEventHandler('burgerjob:checkStrikes', function(strikes)
    if strikes >= 3 then
        exports.globals:notify('You have 3 or more strikes to your name. You will now need to pay $3,000 to clear the strikes against you.')
        showPay()
    else
        TriggerServerEvent("burgerjob:startJob")
        working = 'yes'
        exports.globals:notify('You are now working for Burger Shot.')
        if not signedIn then
            signedIn = GetGameTimer()
        end
        ShowHelp()
    end
end)

RegisterCommand("paybsfine", function()
    TriggerServerEvent('burgerjob:payFine')
end)

-- handle clocking in / out
Citizen.CreateThread(function()
    while true do
        local x,y,z = table.unpack(employer_location)
        if nearMarker(x,y,z) then
            promptJob(employer_location)
        end
        Wait(0)
    end
end)

-- handles kitchen actions
Citizen.CreateThread(function()
    while true do
        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        _menuPool:ProcessMenus()
        for k = 1, #utils do
            local location = table.pack(utils[k].x, utils[k].y, utils[k].z)
            if working == 'yes' then
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, utils[k].x, utils[k].y, utils[k].z)
                if dist < 1 then
                    DrawText3D(utils[k].x, utils[k].y, utils[k].z, 1, "[E] - Open Menu")
                    if IsControlJustPressed(0, 38) then
                        if _menuPool:IsAnyMenuOpen() then
                            _menuPool:CloseAllMenus()
                        end
                        for j = 1, #createdMenus do
                            if utils[k].model == createdMenus[j].model then
                                createdMenus[j].menu:Visible(true)
                            end
                        end
                        break
                    end
                end
                if Vdist(plyCoords.x, plyCoords.y, plyCoords.z, utils[k].x, utils[k].y, utils[k].z) > 6 then
                    _menuPool:CloseAllMenus(utils[k].model)
                end
            end
        end
        Wait(0)
    end
end)

-- Set the map marker // spawn NPC to clock in
local employerNPCHandle = nil
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId(), false)
        local x,y,z = table.unpack(employer_location)
        if Vdist(playerCoords, x, y, z) < 40 then
            if not employerNPCHandle then
                RequestModel(GetHashKey(employer_ped))
                while not HasModelLoaded(employer_ped) do
                    RequestModel(employer_ped)
                    Wait(1)
                end
                employerNPCHandle = CreatePed(0, employer_ped, x, y, z, 0.1, false, false) -- need to add distance culling
                SetEntityCanBeDamaged(employer_ped,false)
                SetPedCanRagdollFromPlayerImpact(employer_ped,false)
                SetBlockingOfNonTemporaryEvents(employer_ped,true)
                SetPedFleeAttributes(employer_ped,0,0)
                SetPedCombatAttributes(employer_ped,17,1)
            end
        else 
            if employerNPCHandle then
                DeletePed(employerNPCHandle)
                employerNPCHandle = nil
            end
        end
        Wait(1)
    end
end)

-- If player travels away from the location then kick them from the job.
Citizen.CreateThread(function ()
    while true do
        if working == 'yes' then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed, true)
            if Vdist(playerCoords, -1194.31, -892.23, 14.0) > 40 then
                TriggerServerEvent("burgerjob:quitJob")
                exports.globals:notify("You have been removed from working at BurgerShot!")
                working = "no"
                if signedIn then
                    local strikeCounter = signedIn + (timeBeforeStrikes)
                    if GetGameTimer() < strikeCounter then
                        local seconds = math.ceil((strikeCounter - GetGameTimer()) / 1000)
                        TriggerServerEvent("burgerjob:addStrike")
                        exports.globals:notify('You haven\'t long started work! You have gained 1 strike against your name.')
                        Wait(8000)
                        exports.globals:notify('If you gain 3 strikes you will not be welcome back here as an employee.')
                    end
                end
            end
        end
        Wait(1)
    end
end)

-- Kick the player after X mins if they're just standing still
Citizen.CreateThread(function()
    timer = minutesuntilFired
    while true do
        if working == 'yes' then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed, true)
            if Vdist(playerCoords, prevPos) < 2 then
                if timer > 0 then
                    TriggerServerEvent("burgerjob:quitJob")
                    exports.globals:notify("You have been removed from working at BurgerShot!")
                    working = "no"
                    if signedIn then
                        local strikeCounter = signedIn + (timeBeforeStrikes)
                        if GetGameTimer() < strikeCounter then
                            local seconds = math.ceil((strikeCounter - GetGameTimer()) / 1000)
                            TriggerServerEvent("burgerjob:addStrike")
                            exports.globals:notify('You haven\'t long started work! You have gained 1 strike against your name.')
                            Wait(8000)
                            exports.globals:notify('If you gain 3 strikes you will not be welcome back here as an employee.')
                        end
                    end
                end
            else
                timer = minutesuntilFired
            end
            prevPos = playerCoords
            Wait(60000)
        end
        Wait(1)
    end
end)


-- Functions
function nearMarker(x, y, z)
    local mycoords = GetEntityCoords(GetPlayerPed(-1))
    return GetDistanceBetweenCoords(x, y, z, mycoords.x, mycoords.y, mycoords.z, true) < JOB_START_TEXT_DIST
end

function promptJob(location)
    local x,y,z = table.unpack(location)
    if working == 'no' then
        DrawText3D(x,y,z, 8, startWork)
        if IsControlJustPressed(0, 38) then
            TriggerServerEvent('burgerjob:checkStrikes')
        end
    else
        DrawText3D(x,y,z,  5, quitWork)
        if IsControlJustPressed(0, 38) then
            TriggerServerEvent("burgerjob:quitJob", location)
            exports.globals:notify('You are no longer working for Burger Shot.')
            working = "no"
            if signedIn then
                local strikeCounter = signedIn + (timeBeforeStrikes)
                if GetGameTimer() < strikeCounter then
                    TriggerServerEvent("burgerjob:addStrike")
                    exports.globals:notify('You haven\'t long started work! You have gained 1 strike against your name.')
                    Wait(8000)
                    exports.globals:notify('If you gain 3 strikes you will not be welcome back here as an employee.')
                end
            end
        end
    end
end

function CreateMenu(menu, category)
    for i = 1, #ITEMS[category] do
        local product = ITEMS[category][i]
        local item = NativeUI.CreateItem(product.name, "Ingredients Cost: $" .. exports["globals"]:comma_value(product.price))
        item.Activated = function(parentmenu, seleseted)
            local beginTime = GetGameTimer()
            local pid = PlayerPedId()
            RequestAnimDict("friends@")
            while (not HasAnimDictLoaded("friends@")) do Citizen.Wait(0) end
            while GetGameTimer() - beginTime < 30000 do
                if not IsEntityPlayingAnim(pid, "friends@", "pickupwait", 3) then
                    TaskPlayAnim(pid, "friends@", "pickupwait", 8.0, 1.0, -1, 11, 1.0, false, false, false)
                end
                DrawTimer(beginTime, 30000, 1.42, 1.475, 'Preparing')
                Citizen.Wait(1)
            end
            ClearPedTasks(pid)
            TriggerServerEvent('burgerjob:removecashforingredients', category, i)
        end
        menu:AddItem(item)
    end
end

function DrawText3D(x, y, z, distance, text)
    if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
        local onScreen,_x,_y=World3dToScreen2d(x,y,z)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 470
        DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
    end
end

function DrawTimer(beginTime, duration, x, y, text)
    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars')
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    if GetTimeDifference(GetGameTimer(), beginTime) < duration then
        w = (GetTimeDifference(GetGameTimer(), beginTime) * (0.085 / duration))
    end

    local correction = ((1.0 - math.floor(GetSafeZoneSize(), 2)) * 100) * 0.005
    x, y = x - correction, y - correction

    Set_2dLayer(0)
    DrawSprite('timerbars', 'all_black_bg', x, y, 0.15, 0.0325, 0.0, 255, 255, 255, 180)

    Set_2dLayer(1)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 100, 0, 0, 180)

    Set_2dLayer(2)
    DrawRect(x - 0.015 + (w / 2), y, w, 0.0125, 150, 0, 0, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    Set_2dLayer(3)
    DrawText(x - 0.06, y - 0.012)
end

function showPay()
    TriggerEvent("chatMessage", "", {}, "^3INFO: ^0To pay your fine use the following /paybsfine")
    Wait(3000)
end

function ShowHelp()
    TriggerEvent("chatMessage", "", {}, "^3INFO: ^0If you do not work here for a minimum of 10 minutes you will receive a strike against your name. 3 strikes and you will not be able to come back and work without paying a fine.")
    Wait(3000)
    TriggerEvent("chatMessage", "", {}, "^3INFO: ^0Head into the kitchen. Press ^3E ^0 on some of the utilities to make food and drink for customers.")
    Wait(3000)
end