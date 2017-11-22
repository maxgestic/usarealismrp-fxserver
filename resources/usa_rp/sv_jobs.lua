--
--  MADE BY MINIPUNCH
-- A player will get close to a designated blip on the map within this script, press "E", and begin gathering.
-- This same concept within the script will handle all aspects of a job from getting supplies, processing, to selling, etc.
--

function removeOrDecrementItem(itemNameBeingGiven)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local inventory = user.getActiveCharacterData("inventory")
            if itemNameBeingGiven == "Meth" then
                for i = 1, #inventory do
                    if inventory[i].name == "Suspicious Chemicals" then
                        if inventory[i].quantity > 1 then
                            inventory[i].quantity = inventory[i].quantity - 1
                            user.setActiveCharacterData("inventory", inventory)
                            print("decremented Suspicious Chemicals! at: " .. inventory[i].quantity)
                            return
                        else
                            print("removing Suspicious Chemicals from inventory! at: " .. inventory[i].quantity)
                            table.remove(inventory, i)
                            user.setActiveCharacterData("inventory", inventory)
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
                local inventory = user.getActiveCharacterData("inventory")
                for i = 1, #inventory do
                    local item = inventory[i]
                    if item.name == "Meth" then
                        local reward = 400
                        local user_money = user.getActiveCharacterData("money")
                        user.setActiveCharacterData("money", user_money + reward)
                        if item.quantity > 1 then
                            inventory[i].quantity = inventory[i].quantity - 1
                            user.setActiveCharacterData("inventory", inventory)
                            print("meth quantity decremented!")
                            TriggerClientEvent("usa_rp:notify", userSource, "Thanks, homie! Here is ~g~$"..reward.."~w~!")
                            TriggerEvent("go_postal:removeActiveJob", userSource) -- make sure this works
                            return
                        end
                        table.remove(inventory,i)
                        user.setActiveCharacterData("inventory", inventory)
                        print("removed meth from inventrory!")
                        TriggerClientEvent("usa_rp:notify", userSource, "Thanks, homie! Here is ~g~$"..reward.."~w~!")
                        TriggerEvent("go_postal:removeActiveJob", userSource) -- make sure this works
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
            local inventory = user.getActiveCharacterData("inventory")
            removeOrDecrementItem(itemToGive.name)
            for i = 1, #inventory do
                local item = inventory[i]
                if item.name == itemToGive.name then -- player already has one of this item in inventory, so increment
                    inventory[i].quantity = inventory[i].quantity + 3 -- increment item in inventory
                    print("meth quantity added! at: " .. inventory[i].quantity)
                    user.setInventory(inventory) -- save the inventory
                    -- todo: choose one of a few different drop off location coordinates here?
                    if itemToGive.name == "Meth" then
                        dropoffCoords = {x = -402.63, y = 6316.12}
                        TriggerEvent("go_postal:setActiveJob", userSource, dropoffCoords, "meth_dropoff")
                    end
                    TriggerClientEvent("usa_rp:setWaypoint", userSource, dropoffCoords)
                    TriggerClientEvent("usa_rp:notify", userSource, "You have successfully proccessed the materials into a meth product!")
                    return
                end
            end
            -- user does not have that item yet, so give it to them
            table.insert(inventory, itemToGive)
            user.setActiveCharacterData("inventory", inventory)
            print("gave meth to user!")
            -- set waypoint
            -- todo: choose one of a few different drop off location coordinates here?
            if itemToGive.name == "Meth" then
                dropoffCoords = {x = -402.63, y = 6316.12}
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
            local inventory = user.getActiveCharacterData("inventory")
            for i = 1, #inventory do
                local item = inventory[i]
                if item.name == supply then -- player already has one of this item in inventory
                    if item.quantity > 1 then
                        inventory[i].quantity = item.quantity - 1
                        user.setActiveCharacterData("inventory", inventory)
                        TriggerClientEvent("usa_rp:doesUserHaveJobSupply", userSource, true)
                        print("player had job supply!!")
                        return
                    else
                        table.remove(inventory, i)
                        user.setActiveCharacterData("inventory", inventory)
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

RegisterServerEvent("usa_rp:giveChemicals")
AddEventHandler("usa_rp:giveChemicals", function()
    local chemicals = {
        name = "Suspicious Chemicals",
        legality = "illegal",
        quantity = 1,
        type = "chemical"
    }
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local inventory = user.getActiveCharacterData("inventory")
            for i = 1, #inventory do
                local item = inventory[i]
                if item.name == "Suspicious Chemicals" then -- player already has one of this item in inventory
                    if item.quantity > 1 then
                        inventory[i].quantity = item.quantity + 1
                        user.setActiveCharacterData("inventory", inventory)
                        print("player went out of range, giving back Suspicious Chemicals")
                        return
                    else
                        table.insert(inventory, chemicals)
                        user.setActiveCharacterData("inventory", inventory)
                        print("player went out of range, giving back Suspicious Chemicals")
                        return
                    end
                end
            end
            -- not in inventory at this point, so give chemicals here
            table.insert(inventory, chemicals)
            user.setActiveCharacterData("inventory", inventory)
            print("player went out of range, giving back Suspicious Chemicals")
        end
    end)
end)

RegisterServerEvent("usa_rp:startTimer")
AddEventHandler("usa_rp:startTimer", function(timerType)
    local userSource = tonumber(source)
    TriggerClientEvent("usa_rp:notify", userSource, "Sup! You can chill out here while I get your stuff.")
    if timerType == "meth_supplies_ped" then
        local seconds = 80
        local time = seconds * 1000
        SetTimeout(time, function()
            TriggerClientEvent("usa_rp:notify", userSource, "Here are the chemicals needed for cooking!")
            -- return ped to start position
            TriggerClientEvent("usa_rp:returnPedToStartPosition", userSource, timerType)
            -- give loot
            TriggerEvent("es:getPlayerFromId", userSource, function(user)
                if user then
                    local inventory = user.getActiveCharacterData("inventory")
                    for i = 1, #inventory do
                        local item = inventory[i]
                        if item.name == "Suspicious Chemicals" then
                            inventory[i].quantity = inventory[i].quantity + 1
                            user.setActiveCharacterData("inventory", inventory)
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
                    user.setActiveCharacterData("inventory", inventory)
                    print("added suspicious chemicals!")
                end
            end)
        end)
    end
end)

RegisterServerEvent("methJob:checkUserMoney")
AddEventHandler("methJob:checkUserMoney", function(amount)
    local MAX_CHEMICALS = 10
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local userMoney = user.getActiveCharacterData("money")
        local inventory = user.getActiveCharacterData("inventory")
        -- check for max item quantity
        if hasItem("Suspicious Chemicals", inventory, MAX_CHEMICALS) then
            TriggerClientEvent("usa_rp:notify", userSource, "You can't carry more than " .. MAX_CHEMICALS .. " Suspicious Chemicals!")
            return
        end
        -- money check
        if userMoney >= amount then
            -- continue with transaction
            TriggerClientEvent("methJob:getSupplies", userSource)
            user.setActiveCharacterData("money", userMoney - amount)
        elseif userMoney < amount then
            -- not enough funds to continue
            TriggerClientEvent("usa_rp:notify", userSource, "Come back when you have ~y~$500~w~ to get the supplies!")
        end
    end)
end)

function hasItem(itemName, inventory, quantity)
    for i = 1, #inventory do
        local item = inventory[i]
        if item.name == itemName then
            if quantity then
                if type(tonumber(quantity)) ~= nil then
                    if item.quantity == quantity then
                        print("inventory item found with the searched quantity!")
                        return true
                    else
                        print("did not find item with that quantity")
                        return false
                    end
                end
            end
            print("FOUND: " .. itemName .. " in player's inventory")
            return true
        end
    end
    print("did not find item")
    return false
end
