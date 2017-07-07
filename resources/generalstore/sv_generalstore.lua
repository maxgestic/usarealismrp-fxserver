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
                if user.getMoney() >= item.price then
                    user.removeMoney(item.price)
                    local inventory = result.inventory
                    if inventory then
                        for i = 1, #inventory do
                            if inventory[i].name == item.name then
                                inventory[i].quantity = inventory[i].quantity + 1
                                usersTable.updateDocument("essentialmode", docid ,{inventory = inventory},function() end)
                                return
                            end
                        end
                        table.insert(inventory, item)
                        usersTable.updateDocument("essentialmode", docid ,{inventory = inventory},function() end)
                    else
                        inventory = {}
                        table.insert(inventory, item)
                        usersTable.updateDocument("essentialmode", docid ,{inventory = inventory},function() end)
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
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            docid = result._id
            local inventory = result.inventory
            if inventory then
                for i = 1, #inventory do
                    if  inventory[i].name == item.name then
                        if inventory[i].quantity > 1 then
                            inventory[i].quantity = inventory[i].quantity - 1
                        else
                            table.remove(inventory,i)
                        end
                        usersTable.updateDocument("essentialmode", docid ,{inventory = inventory},function()
                            TriggerEvent("es:getPlayerFromId", userSource, function(user)
                                user.addMoney(round(.50*item.price,0))
                            end)
                        end)
                    end
                end
            end
        end)
    end)
end)
