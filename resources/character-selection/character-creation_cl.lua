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

RegisterNetEvent("character:setAppearance")
AddEventHandler("character:setAppearance", function(character)
    local weapons = character.weapons
    if not weapons then weapons = {} end
    if character then
        if character.appearance then
            if character.appearance.hash then
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
                    -- GIVE WEAPONS
                    for i =1, #weapons do
                        if type(weapons[i]) == "string" then
                            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weapons[i]), 1000, false, false)
                        else -- table type most likely
                            GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
                        end
                    end
                end)
            else -- no custom character to load, just give weapons
                if weapons then
                    for i =1, #weapons do
                        if type(weapons[i]) == "string" then
                            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weapons[i]), 1000, false, false)
                        else -- table type most likely
                            GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
                        end
                    end
                end
            end
        end
    else
        Citizen.Trace("Could not find a character!")
        if weapons then
            for i =1, #weapons do
                if type(weapons[i]) == "string" then
                    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weapons[i]), 1000, false, false)
                else -- table type most likely
                    GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
                end
            end
        end
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
        bank = 0
        -- TODO: continue setting rest of new character fields ....
        
    }
    -- save the new character with the data from the GUI form into the first character slot
    TriggerServerEvent("character:save", characterData, slot)
    cb('ok')
end)

RegisterNUICallback('select-character', function(data, cb)
    toggleMenu(false)
    Citizen.Trace("selecting char: " .. data.character.firstName)
    selectedCharacter = data.character -- set selected character on lua side from selected js char card
    selectedCharacterSlot = tonumber(data.slot) + 1
    TriggerEvent("chat:setCharName", selectedCharacter) -- for chat messages
    TriggerServerEvent("altchat:setCharName", selectedCharacter) -- for altchat messages
    --TriggerServerEvent("character:save", selectedCharacter, selectedCharacterSlot) -- update active status to true
    -- loadout the player with the selected character appearance
    TriggerServerEvent("character:loadAppearance", selectedCharacterSlot)
    -- set active character slot
    TriggerServerEvent("character:setActive", selectedCharacterSlot)
    -- check jail status
    --print("checking player jailed status")
    --TriggerServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
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
