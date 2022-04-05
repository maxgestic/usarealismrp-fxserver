
RegisterNetEvent("speaker:toggleMenu")
AddEventHandler("speaker:toggleMenu", function(id)
    SendNUIMessage({
        type = "toggle",
        speakerId = id
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("play", function(data)
    TriggerServerEvent("speaker:play", data)
end)

RegisterNUICallback("stop", function(data)
    TriggerServerEvent("speaker:stop", data)
end)

RegisterNUICallback("pickUp", function(data)
    TriggerServerEvent("speaker:pickUp", data)
end)

RegisterNUICallback("close", function(data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback("updateVolume", function(data)
    TriggerServerEvent("speaker:updateVolume", data)
end)