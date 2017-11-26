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
