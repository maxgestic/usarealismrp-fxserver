local menuOpen = false
local selectedCharacter = {}
local selectedCharacterSlot = 0

local open_menu_spawn_coords = {
    x = -1236.653,
    y = 4392.405,
    z = 19.532,
    angle = 285.343
}

local spawn_coords_closed_menu = {
    x = 177.596,
    y = 6636.183,
    z = 31.638,
    angle = 168.2
}

local swap_locations = {
{name="Clothes Store", x = 1.27486, y = 6511.89, z = 30.8778}, -- paleto bay
{name="Clothes Store", x = 1692.24, y = 4819.79, z = 41.0631}, -- grape seed
{name="Clothes Store", x = 1199.09, y = 2707.86, z = 37.0226}, -- sandy shores 1
{name="Clothes Store", x = 614.565, y = 2763.17, z = 41.0881}, -- sandy shores 2
{name="Clothes Store", x = -1097.71, y = 2711.18, z = 18.5079}, -- route 68
{name="Clothes Store", x = -3170.52, y = 1043.97, z = 20.0632}, -- chumash, great ocean hwy
{name="Clothes Store", x = -1449.93, y = -236.979, z = 49.0106}, -- vinewood 1
{name="Clothes Store", x = -710.239, y = -152.319, z = 37.0151}, -- vinewood 2
{name="Clothes Store", x = -1192.84, y = -767.861, z = 17.0187}, -- vinewood 3
{name="Clothes Store", x = -163.61, y = -303.987, z = 39.0333}, -- vinewood 4
{name="Clothes Store", x = 125.403, y = -223.887, z = 54.0578}, -- vinewood 5
{name="Clothes Store", x = 423.474, y = -809.565, z = 29.0911}, -- vinewood 6
{name="Clothes Store", x = -818.509, y = -1074.14, z = 11.0281}, -- vinewood 7
{name="Clothes Store", x = 77.7774, y = -1389.87, z = 29.0761} -- vinewood 8
}

RegisterNetEvent("character:swap--check-distance")
AddEventHandler("character:swap--check-distance", function()
  for i = 1, #swap_locations do
    local location = swap_locations[i]
    if GetDistanceBetweenCoords(location.x, location.y, location.z,GetEntityCoords(GetPlayerPed(-1))) < 7 then
      print("Player is at a swap location!")
      TriggerServerEvent("character:getCharactersAndOpenMenu", "home")
    end
  end
end)

RegisterNetEvent("character:open")
AddEventHandler("character:open", function(menu, data)
    menuOpen = true
    toggleMenu(menuOpen, menu, data)
end)

RegisterNetEvent("character:close")
AddEventHandler("character:close", function()
    menuOpen = false
    toggleMenu(menuOpen)
end)

-- loading in character from JS selection
RegisterNetEvent("character:setCharacter")
AddEventHandler("character:setCharacter", function(character)
    RemoveAllPedWeapons(GetPlayerPed(-1), true) -- remove weapons for the case where a different character is selected after choosing one with weapons initially
    print("setting character!")
    local weapons
    if character then
        print("character existed")
        weapons = character.weapons
        if character.appearance then
            print("character.appearance existed")
            if character.appearance.hash then
                print("character.appearance.hash existed")
                local name, model
                model = tonumber(character.appearance.hash)
                Citizen.Trace("giving loading with customizations with hash = " .. model)
                Citizen.CreateThread(function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do -- Wait for model to load
                        RequestModel(model)
                        Citizen.Wait(0)
                    end
                    SetPlayerModel(PlayerId(), model)
                    SetModelAsNoLongerNeeded(model)
                    -- ADD CUSTOMIZATIONS FROM CLOTHING STORE
                    for key, value in pairs(character.appearance["components"]) do
                        SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character.appearance["componentstexture"][key], 0)
                    end
                    for key, value in pairs(character.appearance["props"]) do
                        SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character.appearance["propstexture"][key], true)
                    end
                    print("GIVING WEAPONS TO PED! # = " .. #weapons)
                    -- G I V E  W E A P O N S
                    for i =1, #weapons do
                        GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
                    end
                end)
            else
                Citizen.Trace("Could not find saved character skin!")
                print("GIVING WEAPONS TO PED! # = " .. #weapons)
                -- G I V E  W E A P O N S
                for i =1, #weapons do
                    GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
                end
            end
        end
    else
        Citizen.Trace("Could not find character!")
    end
end)

RegisterNUICallback('escape', function(data, cb)
    toggleMenu(false)
    cb('ok')
end)

RegisterNUICallback('new-character-submit', function(data, cb)
    print("saving character " .. data.firstName .. " into slot #" .. data.slot)
    TriggerServerEvent("character:new", data)
    cb('ok')
end)

RegisterNUICallback('select-character', function(data, cb)
    toggleMenu(false)
    Citizen.Trace("selecting char: " .. data.character.firstName)
    selectedCharacter = data.character -- set selected character on lua side from selected js char card
    selectedCharacterSlot = tonumber(data.slot) + 1
    TriggerEvent("chat:setCharName", selectedCharacter) -- for chat messages
    TriggerServerEvent("altchat:setCharName", selectedCharacter) -- for altchat messages
    -- loadout the player with the selected character appearance
    TriggerServerEvent("character:loadCharacter", selectedCharacterSlot)
    -- set active character slot
    TriggerServerEvent("character:setActive", selectedCharacterSlot)
    -- check jail status
    --print("checking player jailed status")
    --TriggerServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
    cb('ok')
end)

RegisterNUICallback('delete-character', function(data, cb)
    local slot = (data.slot) + 1 -- +1 because of js --> lua
    Citizen.Trace("deleting char at slot #" .. slot)
    TriggerServerEvent("character:delete", slot)
    cb('ok')
end)

RegisterNetEvent("character:send-nui-message")
AddEventHandler("character:send-nui-message", function(messageTable)
  SendNUIMessage(messageTable)
end)

function toggleMenu(status, menu, data)
    -- set player position
    local ped = GetPlayerPed(-1)
    if status then
        SetEntityCoords(ped, open_menu_spawn_coords.x, open_menu_spawn_coords.y, open_menu_spawn_coords.z, open_menu_spawn_coords.angle, 0, 0, 1)
        RemoveAllPedWeapons(ped, true)
    else
        SetEntityCoords(ped, spawn_coords_closed_menu.x, spawn_coords_closed_menu.y, spawn_coords_closed_menu.z, 0.0, 0, 0, 1)
    end
    FreezeEntityPosition(ped, status)
    DisplayHud(not status)
    DisplayRadar(not status)
    SetEnableHandcuffs(ped, status)
    -- open / close menu
    SetNuiFocus(status, status)
    menuOpen = status
    SendNUIMessage({
        type = "toggleMenu",
        menuStatus = status,
        menu = menu,
        data = data
    })
end
