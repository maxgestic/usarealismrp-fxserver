local MAX_PLAYER_WEAPON_SLOTS = 3

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterServerEvent("blackMarket:getWeaponsAndDisplaySellMenu")
AddEventHandler("blackMarket:getWeaponsAndDisplaySellMenu", function()
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local weapons = user.getActiveCharacterData("weapons")
        TriggerClientEvent("blackMarket:displaySellMenu", userSource, weapons)
    end)
end)

RegisterServerEvent("blackMarket:sellWeapon")
AddEventHandler("blackMarket:sellWeapon",function(weapon)
	local userSource = source
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local weapons = user.getActiveCharacterData("weapons")
        local user_money = user.getActiveCharacterData("money")
        if weapons then
            for i = 1, #weapons do
                if weapons[i].name == weapon.name then
                    table.remove(weapons, i)
                    user.setActiveCharacterData("weapons", weapons)
                    user.setActiveCharacterData("money", user_money + round(.50*weapon.price, 0))
					--TriggerEvent("sway:updateDB", userSource)
                    break
                end
            end
        else
            print("player had no weapons to sell")
        end
    end)
end)

RegisterServerEvent("blackMarket:checkGunMoney")
AddEventHandler("blackMarket:checkGunMoney", function(weapon)
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local weapons = user.getActiveCharacterData("weapons")
        if not weapons then
            weapons = {}
        end
        if #weapons < MAX_PLAYER_WEAPON_SLOTS then
            local user_money = user.getActiveCharacterData("money")
            if weapon.price <= user_money then -- see if user has enough money
                print("player had enough money! (" .. user_money .. ")")
                table.insert(weapons, weapon)
                user.setActiveCharacterData("weapons", weapons)
                print("setting money after buying to : $" .. user_money - weapon.price)
                user.setActiveCharacterData("money", user_money - weapon.price)
                print("equipping weapon with type source : source = " .. type(source) .. " : " .. source)
                print("weapon.name = " .. weapon.name)
                TriggerClientEvent("blackMarket:equipWeapon", userSource, userSource, weapon.hash, weapon.name) -- equip
                TriggerClientEvent("blackMarket:notify", userSource, "You have purchased a ~r~" .. weapon.name .. ".")
				--TriggerEvent("sway:updateDB", userSource)
            else
                print("player did not have enough money to purchase weapon")
                TriggerClientEvent("mini:insufficientFunds", userSource, weapon.price, "gun")
            end
        else
            TriggerClientEvent("blackMarket:notify", userSource, "~r~All weapons slot are full! (" .. MAX_PLAYER_WEAPON_SLOTS .. "/" .. MAX_PLAYER_WEAPON_SLOTS .. ")")
        end
    end)
end)


    --[[ A simple exemple that get the document ID from a player, and add data to it.
    -- getDocumentByRow is used to get docuemnt ID
    --updateDocument is used to send data to it.
    idents = GetPlayerIdentifiers(source)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
    usersTable.getDocumentByRow("dbnamehere", "identifier" , idents[1], function(result)
    docid = result._id
    usersTable.updateDocument("dbnamehere", docid ,{weapons = "WEAPON_StunGun"},function()
end)
end)
end)
]]
