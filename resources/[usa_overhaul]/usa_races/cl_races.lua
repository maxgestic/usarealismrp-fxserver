local isMenuOpen = false

RegisterNetEvent("races:openMenu")
AddEventHandler("races:openMenu", function()
    isMenuOpen = true
    SendNUIMessage({
        type = "ui",
        open = isMenuOpen
    })
    SetNuiFocus(isMenuOpen, isMenuOpen)
end)