local MAX_PLAYER_WEAPON_SLOTS = 3

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterServerEvent("gunShop:buyPermit")
AddEventHandler("gunShop:buyPermit", function()
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        --user.removeMoney(2000)
        local cost = 2000
        local user_cash = user.getActiveCharacterData("money")
        user.setActiveCharacterData("money", user_cash - cost)
        local licenses = user.getActiveCharacterData("licenses")
        local timestamp = os.date("*t", os.time())
        local permit = {
            name = "Firearm Permit",
            number = "G" .. tostring(math.random(1, 254367)),
            quantity = 1,
            ownerName = GetPlayerName(userSource),
            expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
            status = "valid",
            type = "license"
        }
        table.insert(licenses, permit)
        print("saving inventory with gun permit inside of it")
        user.setActiveCharacterData("licenses", licenses)
        -- give money to property owner --
        if property then 
            TriggerEvent("properties:addMoney", property.name, round(0.18 * cost, 0))
        end
		--TriggerEvent("sway:updateDB", userSource)
    end)
end)

RegisterServerEvent("gunShop:checkPermit")
AddEventHandler("gunShop:checkPermit", function()
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local licenses = user.getActiveCharacterData("licenses")
        for i = 1, #licenses do
            local item = licenses[i]
            if item.name == "Firearm Permit" then
				if item.status == "suspended" then 
					TriggerClientEvent("usa:notify", userSource, "Your firearm permit is suspended!")
					return
				else 
					TriggerClientEvent("gunShop:showGunShopMenu", userSource)
					return
				end
            end
        end
        TriggerClientEvent("gunShop:showNoPermitMenu", userSource)
    end)
end)

RegisterServerEvent("gunShop:refreshWeaponList")
AddEventHandler("gunShop:refreshWeaponList", function()
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
            local weapons = user.getActiveCharacterData("weapons")
            print("calling showSellMenu with #weapons = " .. #weapons)
            TriggerClientEvent("gunShop:showSellMenu", userSource, weapons, true)
    end)
end)

RegisterServerEvent("gunShop:sellWeapon")
AddEventHandler("gunShop:sellWeapon",function(weapon)
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        weapons = user.getActiveCharacterData("weapons")
        for i = 1, #weapons do
            if weapons[i].name == weapon.name then
                table.remove(weapons,i) -- remove from table
                TriggerClientEvent("gunShop:showSellMenu", userSource, weapons) -- update client menu items
                --user.addMoney(round(.50*(weapon.price), 0))
                local money_amount_to_add = round(.50*(weapon.price), 0)
                local user_money =  user.getActiveCharacterData("money")
                user.setActiveCharacterData("money", user_money + money_amount_to_add)
                user.setActiveCharacterData("weapons", weapons)
				TriggerEvent("sway:updateDB", userSource)
                break
            end
        end
    end)
end)

RegisterServerEvent("mini:checkGunMoney")
AddEventHandler("mini:checkGunMoney", function(weapon, property)
  local userSource = source
  TriggerEvent('es:getPlayerFromId', userSource, function(user)
    local weapons = user.getActiveCharacterData("weapons")
    if #weapons < MAX_PLAYER_WEAPON_SLOTS then
      if user.getCanActiveCharacterHoldItem(weapon) then
        local user_money = user.getActiveCharacterData("money")
        if weapon.price <= user_money then -- see if user has enough money
          --user.removeMoney(weapon.price) -- subtract price from user's money and store resulting amounts
          user.setActiveCharacterData("money", user_money - weapon.price)
          table.insert(weapons, weapon)
          user.setActiveCharacterData("weapons", weapons)
          TriggerClientEvent("mini:equipWeapon", userSource, userSource, weapon.hash, weapon.name) -- equip
          TriggerClientEvent("chatMessage", userSource, "Gun Store", {41, 103, 203}, "^0You now own a ^3" .. weapon.name .. "^0!")
          if property then
            -- give money to store owner --
            TriggerEvent("properties:addMoney", property.name, round(0.20 * weapon.price, 0))
          end
          --TriggerEvent("sway:updateDB", userSource)
        else
          TriggerClientEvent("mini:insufficientFunds", userSource, weapon.price, "gun")
        end
      else
        TriggerClientEvent("usa:notify", userSource, "Inventory is full.")
      end
    else
      --notify user of full weapon slots
      TriggerClientEvent("chatMessage", userSource, "Gun Store", {41, 103, 203}, "^1All weapon slots full! (" .. MAX_PLAYER_WEAPON_SLOTS .. "/" .. MAX_PLAYER_WEAPON_SLOTS .. ")")
    end
  end)
end)
