RegisterNUICallback('escape', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
end)

RegisterNUICallback('showPhone', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    TriggerServerEvent("interaction:checkForPhone")
end)

RegisterNUICallback('loadInventory', function(data, cb)
    Citizen.Trace("inventory loading...")
    TriggerServerEvent("interaction:loadInventoryForInteraction")
end)

RegisterNUICallback('playEmote', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    --Citizen.Trace("setting voice level = " .. data.level)
    local COP,SIT,CHAIR,KNEEL,MEDIC,NOTEPAD,TRAFFIC,PHOTO,CLIPBOARD,LEAN,HANGOUT,POT,FISH,PHONE,YOGA,BINO,CHEER,STATUE,JOG,FLEX,SITUP,PUSHUP,WELD,MECHANIC = 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
    local selected = data.emoteNumber
    if selected == COP then
        TriggerEvent("playCopEmote")
    elseif selected == SIT then
        TriggerEvent("playSitEmote")
    elseif selected == CHAIR then
        TriggerEvent("playChairEmote")
    elseif selected == KNEEL then
        TriggerEvent("playKneelEmote")
    elseif selected == MEDIC then
        TriggerEvent("playMedicEmote")
    elseif selected == NOTEPAD then
        TriggerEvent("playNotepadEmote")
    elseif selected == TRAFFIC then
        TriggerEvent("playTrafficEmote")
    elseif selected == PHOTO then
        TriggerEvent("playPhotoEmote")
    elseif selected == CLIPBOARD then
        TriggerEvent("playClipboardEmote")
    elseif selected == LEAN then
        TriggerEvent("playLeanEmote")
    elseif selected == HANGOUT then
        TriggerEvent("playHangOutEmote")
    elseif selected == POT then
        TriggerEvent("playPotEmote")
    elseif selected == FISH then
        TriggerEvent("playFishEmote")
    elseif selected == PHONE then
        TriggerEvent("playPhoneEmote")
    elseif selected == YOGA then
        TriggerEvent("playYogaEmote")
    elseif selected == BINO then
        TriggerEvent("playBinocularsEmote")
    elseif selected == CHEER then
        TriggerEvent("playCheeringEmote")
    elseif selected == STATUE then
        TriggerEvent("playStatueEmote")
    elseif selected == JOG then
        TriggerEvent("playJogEmote")
    elseif selected == FLEX then
        TriggerEvent("playFlexEmote")
    elseif selected == SITUP then
        TriggerEvent("playSitUpEmote")
    elseif selected == PUSHUP then
        TriggerEvent("playPushUpEmote")
    elseif selected == WELD then
        TriggerEvent("playWeldingEmote")
    elseif selected == MECHANIC then
        TriggerEvent("playMechanicEmote")
    elseif selected == SMOKE then
        TriggerEvent("playSmokeEmote")
    elseif selected == DRINK then
        TriggerEvent("playDrinkEmote")
    elseif selected == CANCEL then
        TriggerEvent("playCancelEmote")
    elseif selected == "Cancel" then
        TriggerEvent("playCancelEmote")
    end
end)

RegisterNUICallback('setVoipLevel', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    --Citizen.Trace("setting voice level = " .. data.level)
    local YELL, NORMAL, WHISPER = 0,1,2
    local selected = data.level
    if selected == YELL then
        TriggerEvent("voip", "yell")
    elseif selected == NORMAL then
        TriggerEvent("voip","default")
    elseif selected == WHISPER then
        TriggerEvent("voip","whisper")
    end
end)

RegisterNetEvent("interaction:playerHadPhone")
AddEventHandler("interaction:playerHadPhone", function()
    TriggerEvent("phone:openPhone")
end)

RegisterNetEvent("interaction:inventoryLoaded")
AddEventHandler("interaction:inventoryLoaded", function(inventory, weapons, licenses)
    Citizen.Trace("inventory loaded...")
    SendNUIMessage({
        type = "inventoryLoaded",
        inventory = inventory,
        weapons = weapons,
        licenses = licenses
    })
end)

Citizen.CreateThread(function()
    while true do
        if menuEnabled then
            DisableControlAction(29, 241, menuEnabled) -- scroll up
            DisableControlAction(29, 242, menuEnabled) -- scroll down
            DisableControlAction(0, 1, menuEnabled) -- LookLeftRight
            DisableControlAction(0, 2, menuEnabled) -- LookUpDown
            DisableControlAction(0, 142, menuEnabled) -- MeleeAttackAlternate
            DisableControlAction(0, 106, menuEnabled) -- VehicleMouseControlOverride
            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)
