local sv_storeWeapons = {
  ["Melee"] = {
    { name = "Flashlight", type = "weapon", hash = -1951375401, price = 40, legality = "legal", quantity = 1, weight = 5 },
    { name = "Hammer", type = "weapon", hash = 0x4E875F73, price = 20, legality = "legal", quantity = 1, weight = 5 },
    { name = "Knife", type = "weapon", hash = 0x99B507EA, price = 88, legality = "legal", quantity = 1, weight = 3 },
    { name = "Bat", type = "weapon", hash = 0x958A4A8F, price = 85, legality = "legal", quantity = 1, weight = 10 },
    { name = "Crowbar", type = "weapon", hash = -2067956739, price = 65, legality = "legal", quantity = 1, weight = 10 },
    { name = "Hatchet", type = "weapon", hash = -102973651, price = 150, legality = "legal", quantity = 1, weight = 8 },
    { name = "Wrench", type = "weapon", hash = 419712736, price = 250, legality = "legal", quantity = 1, weight = 10 },
    { name = "Machete", type = "weapon", hash = -581044007, price = 150, legality = "legal", quantity = 1, weight = 7 }

  },
  ["Handguns"] = {
    { name = "Pistol", type = "weapon", hash = 0x1B06D571, price = 300, legality = "legal", quantity = 1, weight = 6 },
    { name = "Heavy Pistol", type = "weapon", hash = -771403250, price = 800, legality = "legal", quantity = 1, weight = 9 },
    { name = ".50 Caliber", type = "weapon", hash = -1716589765, price = 1500, legality = "legal", quantity = 1, weight = 8 },
    { name = "SNS Pistol", type = "weapon", hash = -1076751822, price = 500, legality = "legal", quantity = 1, weight = 3 },
    { name = "Combat Pistol", type = "weapon", hash = 1593441988, price = 1200, legality = "legal", quantity = 1, weight = 6 },
    { name = "Revolver", type = "weapon", hash = -1045183535, price = 900, legality = "legal", quantity = 1, weight = 8 },
    { name = "MK2", type = "weapon", hash = 3219281620, price = 1000, legality = "legal", quantity = 1, weight = 6 },
    { name = "Vintage Pistol", type = "weapon", hash = 137902532, price = 3000, legality = "legal", quantity = 1, weight = 9 },
    { name = "Marksman Pistol", type = "weapon", hash = -598887786, price = 4350, legality = "legal", quantity = 1, weight = 15 }

  },
  ["Shotguns"] = {
    { name = "Pump Shotgun", type = "weapon", hash = 0x1D073A89, price = 2000, legality = "legal", quantity = 1, weight = 20 },
    { name = "Bullpup", type = "weapon", hash = 0x9D61E50F, price = 8750, legality = "legal", quantity = 1, weight = 25 },
    { name = "Musket", type = "weapon", hash = -1466123874, price = 8500, legality = "legal", quantity = 1, weight = 30 },
    { name = "Firework Gun", type = "weapon", hash = 2138347493, price = 60000, legality = "legal", quantity = 1, weight = 50}
  },
  ["Extras"] = {
    { name = "Parachute", type = "weapon", hash = "GADGET_PARACHUTE", price = 350, legality = "legal", quantity = 1, weight = 20 }
  }
}

RegisterServerEvent("gunShop:requestPurchase")
AddEventHandler("gunShop:requestPurchase", function(category, index, property)
  local usource = source
  print("Person wants to buy: " .. sv_storeWeapons[category][index].name)
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local permit_status = checkPermit(user)
  if permit_status == "valid" then
    local user_money = user.getActiveCharacterData("money")
    if user_money - sv_storeWeapons[category][index].price >= 0 then
	  local user_weapons = user.getActiveCharacterData("weapons")
	  if #user_weapons >= 3 then
		TriggerClientEvent("usa:notify", source, "Can't carry more than 3 weapons!")
		return
	  end
      TriggerEvent("usa:insertItem", sv_storeWeapons[category][index], 1, usource, function(success)
        if success then
          user.setActiveCharacterData("money", user_money - sv_storeWeapons[category][index].price)
          TriggerClientEvent("mini:equipWeapon", usource, usource, sv_storeWeapons[category][index].hash, sv_storeWeapons[category][index].name) -- equip
          -- give money to property owner --
          if property then
            TriggerEvent("properties:addMoney", property.name, math.ceil(0.40 * sv_storeWeapons[category][index].price))
          end
        end
      end)
    else
      TriggerClientEvent("usa:notify", source, "Not enough money!")
    end
  elseif permit_status == "suspended" then
    TriggerClientEvent("usa:notify", usource, "Your permit is suspended!")
  elseif permit_status == "none" then
    TriggerClientEvent("usa:notify", usource, "No firearm permit!")
  end
end)

RegisterServerEvent("gunShop:buyPermit")
AddEventHandler("gunShop:buyPermit", function(property)
  local userSource = source
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  if checkPermit(user) ~= "none" then
    TriggerClientEvent("usa:notify", userSource, "You already have a firearm permit!")
    return
  end
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
  user.setActiveCharacterData("licenses", licenses)
  TriggerClientEvent("usa:notify", userSource, "You already have a firearm permit!")
  -- give money to property owner --
  if property then
    TriggerEvent("properties:addMoney", property.name, math.ceil(0.40 * cost))
  end
end)

function checkPermit(player)
  local licenses = player.getActiveCharacterData("licenses")
  for i = 1, #licenses do
    local item = licenses[i]
    if item.name == "Firearm Permit" then
      if item.status == "suspended" then
        --TriggerClientEvent("usa:notify", src, "Your firearm permit is suspended!")
        return "suspended"
      else
        --TriggerClientEvent("gunShop:showGunShopMenu", userSource)
        return "valid"
      end
    end
  end
  return "none"
  --TriggerClientEvent("gunShop:showNoPermitMenu", userSource)
end
