TriggerEvent("es:addCommand", "commerce", function(source, char, args, location)
    if CanPlayerStartCommerceSession(source) then 
        TriggerClientEvent("commerce:openStore", source)
    else 
        TriggerClientEvent("usa:notify", source, "Please sign into your FiveM account!", "^0Please sign into your FiveM account! You can do this right after FiveM starts (see the top) or by clicking 'Settings' at the top.")
    end
end)

RegisterServerEvent("commerce:purchase")
AddEventHandler("commerce:purchase", function(id)
    local usource = source
    Citizen.CreateThread(function()
        print("loading commerce data...")
        while not IsPlayerCommerceInfoLoaded(usource) do 
            LoadPlayerCommerceData(usource)
        end
        print("commerce data loaded!")
        if not DoesPlayerOwnSku(usource, id) then
            print("starting commerce session for id " .. id .. ", type is " .. type(id))
            print("usourec: " .. usource .. ", type is " .. type(usource))
            RequestPlayerCommerceSession(usource, id)
        else 
            print("user already had SKU " .. id .. "!")
            TriggerClientEvent("usa:notify", usource, "You already own that item!", "^0You already own that item!")
        end
    end)
end)

--[[

All of these are primarily server-side.

Use 'CanPlayerStartCommerceSession' to check if the user is able to start a commerce session/have SKUs loaded. This currently amounts to ‘being signed in to a FiveM account on a modern client’.

Similarly to loading models on clients, use 'LoadPlayerCommerceData' and 'IsPlayerCommerceInfoLoaded' in a loop to load available SKUs.

Use 'DoesPlayerOwnSku' to check if a player owns a specified SKU registered on your key account. There’s no way to manually grant these as of now, so you might want to couple this with an ACL check or similar.

Eventually, when a player clearly indicates in UI (commands, NUI or menus) they want to purchase a product, trigger a server event, and run 'RequestPlayerCommerceSession' on the server. They’ll be prompted using game UI to initiate a payment. Currently, there’s no way to confirm whether or not this succeeded, and it might be focus changes will terminate the user’s game client. Generally, purchases are only available on reconnection at this time.

]]