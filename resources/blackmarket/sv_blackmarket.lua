local sv_storeItems = {
    ["weapons"] = {
		--{ name = "Lock Pick", type = "misc", hash = 615608432, price = 400, legality = "illegal", quantity = 1, weight = 5 },
        { name = "Molotov", type = "weapon", hash = 615608432, price = 650, legality = "illegal", quantity = 1, weight = 20 },
        { name = "Brass Knuckles", type = "weapon", hash = -656458692, price = 650, legality = "illegal", quantity = 1, weight = 5 },
        { name = "Dagger", type = "weapon", hash = -1834847097, price = 750, legality = "illegal", quantity = 1, weight = 10 },
        { name = "Switchblade", type = "weapon", hash = -538741184, price = 3000, legality = "illegal", quantity = 1, weight = 10 },
        { name = "AP Pistol", type = "weapon", hash = 0x22D8FE39, price = 14550, legality = "illegal", quantity = 1, weight = 15 },
        { name = "Sawn-off", type = "weapon", hash = 0x7846A318, price = 9000, legality = "illegal", quantity = 1, weight = 30 },
        { name = "Micro SMG", type = "weapon", hash = 324215364, price = 12000, legality = "illegal", quantity = 1, weight = 30 },
        { name = "SMG", type = "weapon", hash = 736523883, price = 16700, legality = "illegal", quantity = 1, weight = 45 },
        { name = "Machine Pistol", type = "weapon", hash = -619010992, price = 15500, legality = "illegal", quantity = 1, weight = 20 },
        { name = "Tommy Gun", type = "weapon", hash = 1627465347, price = 18750, legality = "illegal", quantity = 1, weight = 45 },
        { name = "AK47", type = "weapon", hash = -1074790547, price = 23500, legality = "illegal", quantity = 1, weight = 45 },
        { name = "Carbine", type = "weapon", hash = -2084633992, price = 24500, legality = "illegal", quantity = 1, weight = 45 },
        --{ name = "Compact Rifle", type = "weapon", hash = 1649403952, price = 19550, legality = "illegal", quantity = 1, weight = 55 },
        --{ name = "MK2 Assault Rifle", type = "weapon", hash = 961495388, price = 19550, legality = "illegal", quantity = 1, weight = 45 },
        { name = "Bullpup Rifle", type = "weapon", hash = 2132975508, price = 30000, legality = "illegal", quantity = 1, weight = 45 },
        --{ name = "Advanced Rifle", type = "weapon", hash = -1357824103, price = 20550, legality = "illegal", quantity = 1, weight = 45 },
        { name = "Assault SMG", type = "weapon", hash = -270015777, price = 40500, legality = "illegal", quantity = 1, weight = 45 }
        --{ name = "MK2 Carbine Rifle", type = "weapon", hash = 4208062921, price = 20550, legality = "illegal", quantity = 1, weight = 45 }
    }
}

local MAX_PLAYER_WEAPON_SLOTS = 3

RegisterServerEvent("blackMarket:requestPurchase")
AddEventHandler("blackMarket:requestPurchase", function(index)
  local userSource = source
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local weapon = sv_storeItems["weapons"][index]
  weapon.uuid = math.random(999999999)
  if user.getCanActiveCharacterHoldItem(weapon) then
    if weapon.type == "weapon" then
      local weapons = user.getActiveCharacterData("weapons")
      if not weapons then
        weapons = {}
      end
      if #weapons < MAX_PLAYER_WEAPON_SLOTS then
        local user_money = user.getActiveCharacterData("money")
        if weapon.price <= user_money then -- see if user has enough money
          TriggerEvent("usa:insertItem", weapon, 1, userSource)
          user.setActiveCharacterData("money", user_money - weapon.price)
          if weapon.type == "weapon" then
            TriggerClientEvent("blackMarket:equipWeapon", userSource, userSource, weapon.hash, weapon.name) -- equip
          end
          TriggerClientEvent("usa:notify", userSource, "You have purchased a ~r~" .. weapon.name .. ".")
        else
          TriggerClientEvent("usa:notify", userSource, "Not enough money!")
        end
      else
        TriggerClientEvent("usa:notify", userSource, "~r~All weapons slot are full! (" .. MAX_PLAYER_WEAPON_SLOTS .. "/" .. MAX_PLAYER_WEAPON_SLOTS .. ")")
      end
    else
      local user_money = user.getActiveCharacterData("money")
      if weapon.price <= user_money then -- see if user has enough money
        TriggerEvent("usa:insertItem", weapon, 1, userSource)
        user.setActiveCharacterData("money", user_money - weapon.price)
        TriggerClientEvent("usa:notify", userSource, "You have purchased a ~r~" .. weapon.name .. ".")
      end
    end
  else
    TriggerClientEvent("usa:notify", userSource, "Inventory is full!")
  end
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
