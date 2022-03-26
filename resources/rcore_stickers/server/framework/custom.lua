CreateThread(function()
    if Config.EnableCustomEvents then
        ShowNotification = function(source, text)
            TriggerClientEvent('rcore_stickers:showNotification', source, text)
        end

        GetPlayerId = function(source)
            local promise = promise:new()

            TriggerEvent('rcore_stickers:getPlayerId', source, function(id)
                promise:resolve(id)
            end)

            return Citizen.Await(promise)
        end

        GetPlayerJob = function(source)
            local promise = promise:new()

            TriggerEvent('rcore_stickers:getPlayerJob', source, function(job)
                promise:resolve(job)
            end)

            return Citizen.Await(promise)
        end

        PayAmount = function(source, amount)
            local promise = promise:new()

            TriggerEvent('rcore_stickers:payAmount', source, amount, function(paid)
                promise:resolve(paid)
            end)

            return Citizen.Await(promise)
        end

        -- Edit this function to your needs if you want this script to be accessible only for certain players
        IsPlayerAllowed = function(source)
            return true
        end
    end
end)

AddEventHandler('rcore_stickers:getPlayerId', function(src, cb)
    local char = exports["usa-characters"]:GetCharacter(src)
    cb(char.getFullName())
end)

AddEventHandler('rcore_stickers:getPlayerJob', function(src, cb)
    local char = exports["usa-characters"]:GetCharacter(src)
    cb(char.get("job"))
end)

AddEventHandler('rcore_stickers:payAmount', function(src, amount, cb)
    local char = exports["usa-characters"]:GetCharacter(src)
    if char.get("money") >= amount then
        char.removeMoney(amount)
        cb(true)
    else
        cb(false)
    end
end)

AddEventHandler('rcore_stickers:getVehicleInfo', function(plate, hash, cb)
    TriggerEvent('es:exposeDBFunctions', function(db)
        db.getDocumentById("vehicles", plate, function(doc)
            if doc then
                cb({
                    hash = hash,
                    plate = plate,
                    owner = doc.owner
                })
            end
        end)
    end)
end)

RegisterServerEvent("rcore_stickers:showNotification")
AddEventHandler('rcore_stickers:showNotification', function(text)
    TriggerClientEvent("usa:notify", source, text)
end)

TriggerEvent('es:addCommand', 'stickers', function(source, args, char)
    TriggerClientEvent("rcore_stickers:open", source)
end, {
    help = "Add stickers to your vehicle"
})


exports["globals"]:PerformDBCheck("rcore_stickers", "car-stickers", nil)