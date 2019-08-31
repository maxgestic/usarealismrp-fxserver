local isMenuOpen = false

RegisterNetEvent("races:toggleMenu")
AddEventHandler("races:toggleMenu", function(doOpen, races)
    print("toggling menu!")
    isMenuOpen = doOpen
    SendNUIMessage({
        type = "toggle",
        doOpen = isMenuOpen,
        races = races
    })
    SetNuiFocus(isMenuOpen, isMenuOpen)
end)

RegisterNUICallback("closeMenu", function(data, cb)
    TriggerEvent("races:toggleMenu", false)
end)

RegisterNUICallback("joinRace", function(data, cb)
    TriggerServerEvent("races:joinRace", data.host)
end)