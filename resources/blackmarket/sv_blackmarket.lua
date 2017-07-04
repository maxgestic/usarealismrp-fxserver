local MAX_PLAYER_WEAPON_SLOTS = 3

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterServerEvent("blackMarket:refreshWeaponList")
AddEventHandler("blackMarket:refreshWeaponList", function()

    TriggerEvent('es:getPlayerFromId', source, function(user)
		local weapons
        weapons = user.get("weapons")
        if not weapons then
            weapons = {}
        end
		TriggerClientEvent("blackMarket:refreshWeapons", source, weapons)
    end)

end)

RegisterServerEvent("blackMarket:sellWeapon")
AddEventHandler("blackMarket:sellWeapon",function(weapon)
	local weapons
	TriggerEvent('es:getPlayerFromId', source, function(user)
		user.addMoney(round(.50*(weapon.price), 0))
        weapons = user.get("weapons")
        if weapons then
            for i = 1, #weapons do
                if weapons[i].name == weapon.name then
                    table.remove(weapons, i)
                    local idents = GetPlayerIdentifiers(source)
                    TriggerEvent('es:exposeDBFunctions', function(usersTable)
                        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
                            docid = result._id
                            usersTable.updateDocument("essentialmode", docid ,{weapons = weapons},function()
                            end)
                        end)
                    end)
                    break
                end
            end
            TriggerClientEvent("blackMarket:refreshWeapons", source, weapons)
        end
	end)
	if Menu then
		Menu.hidden = true
	end
end)

RegisterServerEvent("blackMarket:checkGunMoney")
AddEventHandler("blackMarket:checkGunMoney", function(weapon)
    local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local weapons = user.get("weapons")
        if not weapons then
            weapons = {}
        end
        if #weapons < MAX_PLAYER_WEAPON_SLOTS then
            print("player with source = " .. userSource .. " doesn't have max weapons")
            if weapon.price <= user.get("money") then -- see if user has enough money
                print("player had enough money!")
                TriggerClientEvent("blackMarket:equipWeapon", userSource, userSource, weapon.hash, weapon.name) -- equip
                user.removeMoney(weapon.price) -- subtract price from user's money and store resulting amount
                table.insert(weapons, weapon)
                user.setWeapons(weapons) -- idk about this one
                user.set("weapons", weapons) -- idk about this one
                TriggerClientEvent("chatMessage", userSource, "Gun Store", {41, 103, 203}, "^0You now own a ^3" .. weapon.name .. "^0!")
                -- A simple exemple that get the document ID from a player, and add data to it.
                -- getDocumentByRow is used to get docuemnt ID
                --updateDocument is used to send data to it.
                local idents = GetPlayerIdentifiers(source)
                TriggerEvent('es:exposeDBFunctions', function(usersTable)
                    usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
                        docid = result._id
                        usersTable.updateDocument("essentialmode", docid ,{weapons = weapons},function()
                        end)
                    end)
                end)
            else
                print("player did not have enough money to purchase weapon")
                TriggerClientEvent("mini:insufficientFunds", userSource, weapon.price, "gun")
            end
        else
            -- TODO: notify user of weapon slots full
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
