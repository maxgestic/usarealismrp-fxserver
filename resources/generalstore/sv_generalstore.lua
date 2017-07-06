function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterServerEvent("generalStore:buyItem")
AddEventHandler("generalStore:buyItem", function(item)
    local userSource = source
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
                docid = result._id
            TriggerEvent('es:getPlayerFromId', userSource, function(user)
                if result.money >= item.price then
                    user.removeMoney(item.price)
                    local newMoney = result.money - item.price
                    local inventory = result.inventory
                    if inventory then
                        for i = 1, #inventory do
                            if inventory[i].name == item.name then
                                inventory[i].quantity = inventory[i].quantity + 1
                                print("just sold item setting new money in DB to " .. newMoney)
                                user.setMoney(newMoney)
                                usersTable.updateDocument("essentialmode", docid ,{inventory = inventory, money = newMoney},function() end)
                                return
                            end
                        end
                        table.insert(inventory, item)
                        print("just sold item setting new money in DB to " .. newMoney)
                        user.setMoney(newMoney)
                        usersTable.updateDocument("essentialmode", docid ,{inventory = inventory, money = newMoney},function() end)
                    else
                        inventory = {}
                        table.insert(inventory, item)
                        print("just sold item setting new money in DB to " .. newMoney)
                        user.setMoney(newMoney)
                        usersTable.updateDocument("essentialmode", docid ,{inventory = inventory, money = newMoney},function() end)
                    end
                else
                    -- not enough money
                end
            end)
        end)
    end)
end)

RegisterServerEvent("generalStore:getItemsAndDisplay")
AddEventHandler("generalStore:getItemsAndDisplay", function()
    local userSource = source
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            docid = result._id
            local inventory = result.inventory
    		local items = {}
            if inventory then
        		for i = 1, #inventory do
        			if inventory[i].legality == "legal" and inventory[i].type ~= "weapon" then
        				table.insert(items, inventory[i])
        			end
        		end
    		    TriggerClientEvent("generalStore:displayItemsToSell", userSource, items)
            else
                print("inventory was nil during weapon list refresh")
            end
        end)
    end)
end)

RegisterServerEvent("generalStore:sellItem")
AddEventHandler("generalStore:sellItem", function(item)
    local userSource = source
    local idents = GetPlayerIdentifiers(userSource)
    local newMoney
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            docid = result._id
            local inventory = result.inventory
            local playerMoney = result.money
            if inventory then
                for i = 1, #inventory do
                    local item = inventory[i]
                    if item.name == item.name then
                        if item.quantity > 1 then
                            inventory[i].quantity = inventory[i].quantity - 1
                        else
                            table.remove(inventory,i)
                        end
                        newMoney = playerMoney + round(.50*item.price,0)
                        print("buying back item.. updating player DB money to " .. newMoney)
                        usersTable.updateDocument("essentialmode", docid ,{inventory = inventory, money = newMoney},function() end)
                        TriggerEvent("es:getPlayerFromId", userSource, function(user)
                            user.addMoney(round(.50*item.price,0))
                            user.set("money", newMoney)
                        end)
                    end
                end
            end
        end)
    end)
end)
