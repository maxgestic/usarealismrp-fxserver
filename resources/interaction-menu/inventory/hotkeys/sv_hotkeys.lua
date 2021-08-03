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
        char.set("currentlySelectedIndex", key)
    else 
        TriggerClientEvent("usa:notify", source, "Nothing in slot " .. (key + 1))
    end
end)

-- sets or removes the currentlySelectedIndex field, -1 to remove
RegisterServerEvent("hotkeys:char:setCurrentlySelectedIndex")
AddEventHandler("hotkeys:char:setCurrentlySelectedIndex", function(index) -- 'equipped index' = server-sided character property for functions requiring the currently equipped player ped weapon
    local char = exports["usa-characters"]:GetCharacter(source)
    if index == -1 then
        char.set("currentlySelectedIndex", nil)
    else
        char.set("currentlySelectedIndex", index)
    end
end)