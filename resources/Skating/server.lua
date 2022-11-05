local rollerItem = { name = "Roller Skates", price = 350, type = "misc", quantity = 1, legality = "legal", weight = 5, objectModel = "objectModel", blockedInPrison = true}
local iceItem = { name = "Ice Skates", price = 350, type = "misc", quantity = 1, legality = "legal", weight = 5, objectModel = "objectModel", blockedInPrison = true}

TriggerEvent('es:addCommand', 'removeskates', function(source, args, char)
    TriggerClientEvent("skating:leave", source)
end, { help = "Take off roller/ice skates" })

RegisterServerEvent("skates:addItem")
AddEventHandler("skates:addItem", function(type)
    local char = exports["usa-characters"]:GetCharacter(source)
    if type == "roller" then
        char.giveItem(rollerItem)
    elseif type == "ice" then
        char.giveItem(iceItem)
    end
end)