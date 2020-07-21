-- Helper function for getting player money
function getMoney(source)
    local char = exports["usa-characters"]:GetCharacter(source)
    return char.get("money")
end

-- Helper function for removing player money
function removeMoney(source, amount)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.removeMoney(amount)
end

-- Helper function for adding player money
function addMoney(source, amount)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.giveMoney(amount)
end

-- Helper function for getting player name
function getName(source)
    local char = exports["usa-characters"]:GetCharacter(source)
    return char.getName()
end

-- Helper function for notifying players
function notifyPlayer(source, msg)
    TriggerClientEvent('chatMessage', source, "[StreetRaces]", {255, 0, 0}, msg)
    TriggerClientEvent("usa:notify", source, msg)
end

-- Helper function for loading saved player data
function loadPlayerData(src, cb)
    TriggerEvent("es:exposeDBFunctions", function(db)
        local user = exports["essentialmode"]:getPlayerFromId(src)
        db.getDocumentById("races-private", user.getIdentifier(), function(doc)
            cb((doc or {}))
        end)
    end)
end

-- Helper function for saving player data
function savePlayerData(src, data)
    TriggerEvent("es:exposeDBFunctions", function(db)
        local user = exports["essentialmode"]:getPlayerFromId(src)
        db.getDocumentById("races-private", user.getIdentifier(), function(doc)
            if doc then
                doc._rev = nil
                db.updateDocument("races-private", doc._id, data, function(doc, err, rText)
                    print("race doc updatedd! err: " .. err)
                end)
            else 
                db.createDocumentWithId("races-private", data, user.getIdentifier(), function(ok)
                    if ok then
                        print("race doc created")
                    else 
                        print("error creating race document")
                    end
                end)
            end
        end)
    end)
end

--[[
    {
        ["Race 1 Name"] = checkpoints,
        ["Race 2 Name"] = checkpoints,
        ...
    }
]]

exports["globals"]:PerformDBCheck("StreetRaces", "races-private", nil)