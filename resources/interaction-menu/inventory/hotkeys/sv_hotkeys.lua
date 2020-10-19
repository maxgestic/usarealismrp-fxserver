RegisterServerEvent("interaction:hotkeyPressed")
AddEventHandler("interaction:hotkeyPressed", function(key)
    key = tonumber(key) - 1
    local char = exports["usa-characters"]:GetCharacter(source)
    local item = char.getItemByIndex(key)
    if item then
        if item.type == "weapon" then
            -- equip
            TriggerClientEvent("interaction:toggleWeapon", source, item)
        else 
            -- perform item's 'use' action
            TriggerClientEvent("interaction:useItem", source, key, item)
        end
    else 
        TriggerClientEvent("usa:notify", source, "Nothing in slot " .. (key + 1))
    end
end)