--
--  MADE BY MINIPUNCH
-- A player will get close to a designated blip on the map within this script, press "E", and begin gathering.
-- This same concept within the script will handle all aspects of a job from getting supplies, processing, to selling, etc.
--

RegisterServerEvent("usa_rp:giveItem")
AddEventHandler("usa_rp:giveItem", function(itemToGive)
    print("inside of usa_rp:giveItem!")
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local inventory = user.getInventory()
            for i = 1, #inventory do
                local item = inventory[i]
                if item.name == itemToGive.name then -- player already has one of this item in inventory, so increment
                    inventory[i].quantity = inventory[i].quantity + 1 -- increment item in inventory
                    print("meth quantity added! at: " .. inventory[i].quantity)
                    user.setInventory(inventory) -- save the inventory
                    return
                end
            end
            -- user does not have that item yet, so give it to them
            table.insert(inventory, itemToGive)
            user.setInventory(inventory)
            print("gave meth to user!")
        end
    end)
end)

RegisterServerEvent("usa_rp:checkUserJobSupplies")
AddEventHandler("usa_rp:checkUserJobSupplies", function(supply)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local inventory = user.getInventory()
            for i = 1, #inventory do
                local item = inventory[i]
                if item.name == supply then -- player already has one of this item in inventory, so increment
                    TriggerClientEvent("usa_rp:doesUserHaveJobSupply", userSource, true)
                    print("player had job supply!!")
                    return
                end
            end
            -- does not have job supply at this point
            TriggerClientEvent("usa_rp:doesUserHaveJobSupply", userSource, false)
            print("player had job supply!!")
        end
    end)
end)
