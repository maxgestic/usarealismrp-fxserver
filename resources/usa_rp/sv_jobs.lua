--
--  MADE BY MINIPUNCH
-- A player will get close to a designated blip on the map within this script, press "E", and begin gathering.
-- This same concept within the script will handle all aspects of a job from getting supplies, processing, to selling, etc.
--

local methSuppliesPedBusy = false

function removeOrDecrementItem(itemNameBeingGiven)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local inventory = user.getInventory()
            if itemNameBeingGiven == "Meth" then
                for i = 1, #inventory do
                    if inventory[i].name == "Suspicious Chemicals" then
                        if inventory[i].quantity > 1 then
                            inventory[i].quantity = inventory[i].quantity - 1
                            user.setInventory(inventory)
                            print("decremented Suspicious Chemicals! at: " .. inventory[i].quantity)
                            return
                        else
                            print("removing Suspicious Chemicals from inventory! at: " .. inventory[i].quantity)
                            table.remove(inventory, i)
                            user.setInventory(inventory)
                            return
                        end
                    end
                end
            end
        end
    end)
end

RegisterServerEvent("usa_rp:sellItem")
AddEventHandler("usa_rp:sellItem", function(job)
    if job.name == "Meth" then
        local userSource = tonumber(source)
        TriggerEvent("es:getPlayerFromId", userSource, function(user)
            if user then
                local inventory = user.getInventory()
                for i = 1, #inventory do
                    local item = inventory[i]
                    if item.name == "Meth" then
                        local reward = 500
                        user.addMoney(reward)
                        if item.quantity > 1 then
                            inventory[i].quantity = inventory[i].quantity - 1
                            user.setInventory(inventory)
                            print("meth quantity decremented!")
                            TriggerClientEvent("usa_rp:notify", userSource, "Thanks, homie! Here is ~g~$500~w~!")
                            return
                        end
                        table.remove(inventory,i)
                        user.setInventory(inventory)
                        print("removed meth from inventrory!")
                        TriggerClientEvent("usa_rp:notify", userSource, "Thanks, homie! Here is ~g~$500~w~!")
                        return
                    end
                end
            end
        end)
    end
end)

RegisterServerEvent("usa_rp:giveItem")
AddEventHandler("usa_rp:giveItem", function(itemToGive)
    local dropoffCoords = {x = 0.0, y = 0.0}
    print("inside of usa_rp:giveItem!")
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local inventory = user.getInventory()
            removeOrDecrementItem(itemToGive.name)
            for i = 1, #inventory do
                local item = inventory[i]
                if item.name == itemToGive.name then -- player already has one of this item in inventory, so increment
                    inventory[i].quantity = inventory[i].quantity + 1 -- increment item in inventory
                    print("meth quantity added! at: " .. inventory[i].quantity)
                    user.setInventory(inventory) -- save the inventory
                    -- todo: choose one of a few different drop off location coordinates here?
                    if itemToGive.name == "Meth" then
                        dropoffCoords = {x = 1257.82, y = -1611.92}
                        TriggerEvent("go_postal:setActiveJob", userSource, dropoffCoords, "meth_dropoff")
                    end
                    TriggerClientEvent("usa_rp:setWaypoint", userSource, dropoffCoords)
                    TriggerClientEvent("usa_rp:notify", userSource, "Here is your product and directions to your destination!")
                    return
                end
            end
            -- user does not have that item yet, so give it to them
            table.insert(inventory, itemToGive)
            user.setInventory(inventory)
            print("gave meth to user!")
            -- set waypoint
            -- todo: choose one of a few different drop off location coordinates here?
            if itemToGive.name == "Meth" then
                dropoffCoords = {x = 1257.82, y = -1611.92}
                TriggerEvent("go_postal:setActiveJob", userSource, dropoffCoords, "meth_dropoff")
            end
            TriggerClientEvent("usa_rp:setWaypoint", userSource, dropoffCoords)
            TriggerClientEvent("usa_rp:notify", userSource, "Here is your product and directions to your destination!")
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
                if item.name == supply then -- player already has one of this item in inventory
                    if item.quantity > 1 then
                        inventory[i].quantity = item.quantity - 1
                        user.setInventory(inventory)
                        TriggerClientEvent("usa_rp:doesUserHaveJobSupply", userSource, true)
                        print("player had job supply!!")
                        return
                    else
                        table.remove(inventory, i)
                        user.setInventory(inventory)
                        TriggerClientEvent("usa_rp:doesUserHaveJobSupply", userSource, true)
                        print("player had job supply!!")
                        return
                    end
                end
            end
            -- does not have job supply at this point
            TriggerClientEvent("usa_rp:doesUserHaveJobSupply", userSource, false)
            print("player had job supply!!")
        end
    end)
end)

RegisterServerEvent("usa_rp:startTimer")
AddEventHandler("usa_rp:startTimer", function(timerType)
    local userSource = tonumber(source)
    if timerType == "meth_supplies_ped" and not methSuppliesPedBusy then
        methSuppliesPedBusy = true
        local seconds = 30
        local time = seconds * 1000
        SetTimeout(time, function()
            TriggerClientEvent("usa_rp:notify", userSource, "Here are the chemicals needed for cooking!")
            methSuppliesPedBusy = false
            -- return ped to start position
            TriggerClientEvent("usa_rp:returnPedToStartPosition", userSource, timerType)
            -- give loot
            TriggerEvent("es:getPlayerFromId", userSource, function(user)
                if user then
                    local inventory = user.getInventory()
                    for i = 1, #inventory do
                        local item = inventory[i]
                        if item.name == "Suspicious Chemicals" then
                            inventory[i].quantity = inventory[i].quantity + 1
                            user.setInventory(inventory)
                            print("Suspicious Chemicals quantity increased at: " .. inventory[i].quantity)
                            return
                        end
                    end
                    local suspiciousChemicals = {
                        name = "Suspicious Chemicals",
                        legality = "illegal",
                        quantity = 1,
                        type = "chemical"
                    }
                    table.insert(inventory, suspiciousChemicals)
                    user.setInventory(inventory)
                    print("added suspicious chemicals!")
                end
            end)
        end)
    end
end)
