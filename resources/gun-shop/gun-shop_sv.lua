local MAX_PLAYER_WEAPON_SLOTS = 3

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterServerEvent("gunShop:buyPermit")
AddEventHandler("gunShop:buyPermit", function()
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        user.removeMoney(2000)
        local idents = GetPlayerIdentifiers(userSource)
        TriggerEvent('es:exposeDBFunctions', function(usersTable)
            usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
                docid = result._id
                local timestamp = os.date("*t", os.time())
                local permit = {
                    name = "Firearm Permit",
                    number = "G" .. tostring(math.random(1, 254367)),
                    quantity = 1,
                    ownerName = GetPlayerName(userSource),
                    expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
                    status = "valid"
                }
                local inventory = result.inventory
                if not inventory then
                    inventory = {}
                end
                table.insert(inventory, permit)
                print("saving inventory with gun permit inside of it")
                usersTable.updateDocument("essentialmode", docid ,{inventory = inventory},function() end)
            end)
        end)
    end)
end)

RegisterServerEvent("gunShop:checkPermit")
AddEventHandler("gunShop:checkPermit", function()
    local userSource = source
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            local inventory = result.inventory
            if inventory then
                for i = 1, #inventory do
                    print("inside gunShop:checkPermit with #inventory = " .. #inventory)
                    print("inventory[1].name = " .. inventory[1].name)
                    local item = inventory[i]
                    if item.name == "Firearm Permit" then
                        TriggerClientEvent("gunShop:showGunShopMenu", userSource)
                        return
                    end
                end
            end
            TriggerClientEvent("gunShop:showNoPermitMenu", userSource)
        end)
    end)
end)

RegisterServerEvent("gunShop:refreshWeaponList")
AddEventHandler("gunShop:refreshWeaponList", function()
    local userSource = source
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            local weapons = result.weapons
            if not weapons then weapons = {} end
            print("calling showSellMenu with #weapons = " .. #weapons)
            TriggerClientEvent("gunShop:showSellMenu", userSource, weapons, true)
        end)
    end)
end)

RegisterServerEvent("gunShop:sellWeapon")
AddEventHandler("gunShop:sellWeapon",function(weapon)
    local userSource = source
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            docid = result._id
            weapons = result.weapons
            if weapons then
                for i = 1, #weapons do
                    if weapons[i].name == weapon.name then
                        table.remove(weapons,i) -- remove from table
                        usersTable.updateDocument("essentialmode", docid ,{weapons = weapons},function() -- update DB
                            TriggerClientEvent("gunShop:showSellMenu", userSource, weapons) -- update client menu items
                            TriggerEvent('es:getPlayerFromId', userSource, function(user)
                                user.addMoney(round(.50*(weapon.price), 0))
                            end)
                        end)
                        break
                    end
                end
            end
        end)
    end)
end)

RegisterServerEvent("mini:checkGunMoney")
AddEventHandler("mini:checkGunMoney", function(weapon)
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        if weapon.price <= user.getMoney() then -- see if user has enough money
            TriggerClientEvent("mini:equipWeapon", userSource, userSource, weapon.hash, weapon.name) -- equip
            user.removeMoney(weapon.price) -- subtract price from user's money and store resulting amount
            local idents = GetPlayerIdentifiers(userSource)
            TriggerEvent('es:exposeDBFunctions', function(usersTable)
                usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
                    docid = result._id
                    local weapons = result.weapons
                    if not weapons then weapons = {} end
                    if #weapons < MAX_PLAYER_WEAPON_SLOTS then
                        table.insert(weapons, weapon)
                        usersTable.updateDocument("essentialmode", docid ,{weapons = weapons},function() end)
                    else
                        user.addMoney(weapon.price)-- refund money that was taken (see above)
                        --notify user of full weapon slots
                        TriggerClientEvent("chatMessage", userSource, "Gun Store", {41, 103, 203}, "^1All weapon slots full! (" .. MAX_PLAYER_WEAPON_SLOTS .. "/" .. MAX_PLAYER_WEAPON_SLOTS .. ")")
                    end
                end)
            end)
            TriggerClientEvent("chatMessage", userSource, "Gun Store", {41, 103, 203}, "^0You now own a ^3" .. weapon.name .. "^0!")
        else
            TriggerClientEvent("mini:insufficientFunds", userSource, weapon.price, "gun")
        end
    end)
end)
