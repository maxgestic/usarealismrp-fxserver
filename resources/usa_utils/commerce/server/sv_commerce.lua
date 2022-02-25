local db = nil

TriggerEvent('es:exposeDBFunctions', function(couchdb)
    db = couchdb
end)

TriggerEvent("es:addCommand", "store", function(source, args, char, location)
    if CanPlayerStartCommerceSession(source) then 
        TriggerClientEvent("commerce:openStore", source)
    else 
        TriggerClientEvent("usa:notify", source, "Please sign into your FiveM account!", "^3USARRP STORE: ^0Please sign into your FiveM account! You can do this right after FiveM starts (see the top) or by clicking 'Settings' at the top.")
    end
end, {
	help = "Open the in-game market place!"
})

TriggerEvent("es:addCommand", "commerce", function(source, args, char, location)
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

AddEventHandler('rconCommand', function(cmd, args)
    if cmd == 'giveSupporterReward' then
        local type = args[1]
        local transactionID = args[2]
        print("storing " .. type .. " reward for claim! transaction ID: " .. transactionID)
        db.createDocumentWithId("tebex-transaction-ids", { type = type }, transactionID, function(ok) end)
    end
end)

TriggerEvent("es:addCommand", "claimreward", function(src, args, char, location)
    local transactionID = args[2]
    if transactionID and not transactionID:find(" ") then
        db.getDocumentById("tebex-transaction-ids", transactionID, function(doc)
            if doc then
                if not doc.claimInfo then
                    TriggerClientEvent("usa:notify", src, "Claiming " .. doc.type .. " reward!")
                    if TEBEX_PACKAGE_FUNCTIONS[doc.type](src) then
                        TriggerClientEvent("usa:notify", src, "Success!")
                        doc.claimInfo = {
                            claimedBy = {
                                identifier = GetPlayerIdentifiers(src)[1],
                                name = char.getFullName(),
                            },
                            timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time()),
                        }
                        db.updateDocument("tebex-transaction-ids", transactionID, doc, function(ok) end)
                        print("Tebex package successfully claimed (" .. transactionID .. ") by " .. char.getFullName() .. "!")
                    else
                        TriggerClientEvent("usa:notify", src, "Something went wrong!")
                    end
                else 
                    TriggerClientEvent("usa:notify", src, "Transaction ID already claimed!")
                end
            else
                TriggerClientEvent("usa:notify", src, "Transaction ID not found!")
            end
        end)
    else
        TriggerClientEvent("usa:notify", src, "Must provide a valid tebex transaction ID!")
    end
end, {
    help = "Claim a tebex reward",
    params = {
        { name = "transaction ID", help = "The transaction ID of your purchase" },
    }
})

exports["globals"]:PerformDBCheck("usa_utils", "tebex-transaction-ids", nil)