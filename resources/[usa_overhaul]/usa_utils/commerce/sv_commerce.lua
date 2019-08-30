TriggerEvent("es:addCommand", "store", function(source, char, args, location)
    if CanPlayerStartCommerceSession(source) then 
        TriggerClientEvent("commerce:openStore", source)
    else 
        TriggerClientEvent("usa:notify", source, "Please sign into your FiveM account!", "^3USARRP STORE: ^0Please sign into your FiveM account! You can do this right after FiveM starts (see the top) or by clicking 'Settings' at the top.")
    end
end, {
	help = "Open the in-game market place!"
})

TriggerEvent("es:addCommand", "commerce", function(source, char, args, location)
    if CanPlayerStartCommerceSession(source) then 
        TriggerClientEvent("commerce:openStore", source)
    else 
        TriggerClientEvent("usa:notify", source, "Please sign into your FiveM account!", "^3USARRP STORE: ^0Please sign into your FiveM account! You can do this right after FiveM starts (see the top) or by clicking 'Settings' at the top.")
    end
end, {
	help = "Open the in-game market place!"
})

RegisterServerEvent("commerce:purchase")
AddEventHandler("commerce:purchase", function(id)
    local usource = source
    Citizen.CreateThread(function()
        LoadPlayerCommerceData(usource) -- makes HTTP GET request via cpp component for all available owned SKUs for player
        while not IsPlayerCommerceInfoLoaded(usource) do
            Wait(100)
        end
        if not DoesPlayerOwnSku(usource, id) then
            print("COMMERCE: starting commerce session for id " .. id .. ", type is " .. type(id))
            RequestPlayerCommerceSession(usource, id)
            TriggerClientEvent("usa:notify", usource, "A new web browser tab should open after selecting \"Yes\", check your web browser!", "^3USARRP STORE: ^0A new web browser tab should open after selecting \"Yes\", check your web browser!")
        else 
            print("COMMERCE: user already had SKU " .. id .. "!")
            TriggerClientEvent("usa:notify", usource, "You already own that item!", "^3USARRP STORE: ^0You already own that item!")
        end
    end)
end)