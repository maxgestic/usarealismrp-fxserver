local isBusy = "no"
local engagedWith

RegisterServerEvent("drugs:giveCannabis")
AddEventHandler("drugs:giveCannabis", function()
    local userSource = source
    print("inside of giveCannabis function...")
    local cannabisPackage = {
        name = "20g of concentrated cannabis",
        quantity = 1,
        type = "drug",
        legality = "illegal"
    }
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            docid = result._id
            local inventory = {}
            if result.inventory then
                inventory = result.inventory
                for i = 1, #inventory do
                    local item = inventory[i]
                    if item.name == "20g of concentrated cannabis" then
                        inventory[i].quantity = inventory[i].quantity + 1
                        usersTable.updateDocument("essentialmode", docid ,{inventory = inventory},function() end)
                        break
                        return
                    end
                end
                table.insert(inventory, cannabisPackage)
                usersTable.updateDocument("essentialmode", docid ,{inventory = inventory},function() end)
            else
                table.insert(inventory, cannabisPackage)
                usersTable.updateDocument("essentialmode", docid ,{inventory = inventory},function() end)
            end
        end)
    end)
    print("PLAYER GIVEN CONCENTRATED CANNABIS")
 end)

RegisterServerEvent("drugs:inRange")
AddEventHandler("drugs:inRange", function()
    local actualSource = source -- fixes issue where below messages would display globally (-1) instead of just to og source
	-- wait 60 seconds to 'get' drugs
	SetTimeout(90000, function()
        TriggerClientEvent("drugs:isPlayerStillWithinRange", actualSource)
        isBusy = "no" -- not busy anymore
        TriggerClientEvent("drugs:growerWalkBack", actualSource)
	end)
end)

RegisterServerEvent("drugs:outOfRange")
AddEventHandler("drugs:outOfRange", function()
    isBusy = "no"
end)

RegisterServerEvent("drugs:giveMoney")
AddEventHandler("drugs:giveMoney", function(amount)
    print("inside give money")
	local identifier = getPlayerIdentifierEasyMode(source)
	local playerMoney = getPlayerMoneyFromDb(identifier)
	-- Gives the loaded user corresponding to the given player id(second argument).
	TriggerEvent('es:getPlayerFromId', source, function(user)
        user.addMoney(amount)
	    TriggerClientEvent("drugs:thanksMessage", source)
    end)

end)

RegisterServerEvent("drugs:notInRange")
AddEventHandler("drugs:notInRange", function()
    print("just set isBusy = no")
    isBusy = "no" -- not busy anymore
end)

RegisterServerEvent("drugs:sellDrugs")
AddEventHandler("drugs:sellDrugs", function()
    local userSource = source
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            docid = result._id
            local newMoney = result.money + 8000
            if result.inventory then
                local inventory = result.inventory
                for i = 1, #inventory do
                    local item = inventory[i]
                    if item.name == "20g of concentrated cannabis" then
                        if item.quantity > 1 then
                            print("decrementing cannabis in inventory")
                            inventory[i].quantity = inventory[i].quantity - 1
                            usersTable.updateDocument("essentialmode", docid ,{inventory = inventory, money = newMoney},function()
                                TriggerEvent('es:getPlayerFromId', userSource, function(user)
                                    user.addMoney(8000)
                                    user.set("money", newMoney)
                                end)
                            end)
                            return
                        else
                            print("removing cannabis from inventory")
                            table.remove(inventory, i)
                            usersTable.updateDocument("essentialmode", docid ,{inventory = inventory, money = newMoney},function()
                                TriggerEvent('es:getPlayerFromId', userSource, function(user)
                                    user.addMoney(8000)
                                    user.set("money", newMoney)
                                end)
                            end)
                            return
                        end
                        break
                    end
                end
                -- no cannabis to sell
                print("user has no cannabis to sell")
            end
        end)
    end)
end)


AddEventHandler('es:playerLoaded', function(source)

	TriggerClientEvent("mini:spawnCannabisGrower", source)
	TriggerClientEvent("mini:spawnCannabisDealer", source)

end)

RegisterServerEvent("drugs:checkBusy")
AddEventHandler("drugs:checkBusy", function()

    if isBusy == "yes" then
        TriggerClientEvent("drugs:notifyFailureNpcBusy", source) -- someone is already getting drugs. wait till not busy
    else
            TriggerClientEvent("drugs:checkDistance", source)
            isBusy = "yes"
            print("just set isBusy = 'yes'  : isBusy = " .. isBusy)
            engagedWith = source
    end

end)

-- fix issue where player leaves during run, making the grower always 'busy'
AddEventHandler('playerDropped', function()
    if engagedWith == source then
        print("drugs: player #" .. source .. " dropped, setting isBusy = no")
        isBusy = "no"
    end
end)
