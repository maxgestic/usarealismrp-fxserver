local menuOpen = false
local selectedCharacter = {}
local selectedCharacterSlot = 0
local newCharacterTemplate = {} -- all atrributes for new characters are created here

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
    local slot = data.slot
    newCharacterTemplate = {
        firstName = data.firstName,
        middleName = data.middleName,
        lastName = data.lastName,
        dateOfBirth = data.dateOfBirth,
        active = data.active,
        appearance = {},
        jailtime = 0,
        money = 5000,
        bank = 0,
        inventory = {},
        weapons = {},
        vehicles = {},
        insurance = {},
        job = "civ",
        licenses = {},
        criminalHistory = {},
        policeRank = 0,
        emsRank = 0,
        securityRank = 0,
        ingameTime = 0
    }
    -- save the new character with the data from the GUI form into the first character slot
    TriggerServerEvent("character:save", newCharacterTemplate, slot)
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
    TriggerServerEvent("character:deleteCharacter", slot)
    cb('ok')
end)

function toggleMenu(status, menu, data)
    SetNuiFocus(status, status)
    menuOpen = status
    SendNUIMessage({
        type = "toggleMenu",
        menuStatus = status,
        menu = menu,
        data = data
    })
end
