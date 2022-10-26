local MAX_VEHICLES = 6

local boats = {
  ["Nagasaki Dinghy"] = {name = "Nagasaki Dinghy", buy = 15000, rent = 2000},
  ["Nagasaki Dinghy 2"] = {name = "Nagasaki Dinghy 2", buy = 15000, rent =2000},
  ["Dinka Marquis"] = {name = "Dinka Marquis", buy = 30000, rent = 5000},
  ["Speedophile Seashark"] = {name = "Speedophile Seashark", buy = 5000, rent = 900},
  ["Cuban Jetmax"] = {name = "Cuban Jetmax", buy = 35000, rent = 7500},
  ["Lampadati Toro"] = {name = "Lampadati Toro", buy = 60000, rent = 9000},
  ["Lampadati Toro 2"] = {name = "Lampadati Toro 2", buy = 60000, rent = 9000},
  ["Tug"] = {name = "Tug", buy = 200000, rent = 10000},
  ["Shitzu Squalo"] = {name = "Shitzu Squalo", buy = 40000, rent = 7500},
  ["Shitzu Tropic"] = {name = "Shitzu Tropic", buy = 40000, rent = 7500},
  ["Shitzu Suntrap"] = {name = "Shitzu Suntrap", buy = 30000, rent = 5500},
  ["Submersible"] = {name = "Submersible", buy = 750000, rent = 20000},
  ["Submersible 2"] = {name = "Submersible 2", buy = 750000, rent = 20000},
  ["Sea Ray L650 Fly"] = {name = "Sea Ray L650 Fly", buy = 3000000, rent = 50000},
  ["Amels 200"] = {name = "Amels 200", buy = 15000000, rent = 500000},
  ["Kraken Avisa"] = {name = "Kraken Avisa", buy = 1000000, rent = 50000},
  ["42ft Yellow Fin"] = {name = "42ft Yellow Fin", buy = 75000, rent = 11000}
}

local rentals = {}

local LICENSE_PURCHASE_PRICE = 1000

local fishingPole = {
  name = "Fishing Pole",
  type = "misc",
  quantity = 1,
  legality = "legal",
  weight = 15.0,
  price = 100
}

AddEventHandler('es:playerLoaded', function(source, user)
  TriggerEvent("boatMenu:loadBoats", source)
end)

RegisterServerEvent("boatMenu:buyFishingPole")
AddEventHandler("boatMenu:buyFishingPole", function()
  local char = exports["usa-characters"]:GetCharacter(source)
  if char.canHoldItem(fishingPole) then 
    if char.get("money") >= fishingPole.price then
      char.removeMoney(100)
      char.giveItem(fishingPole)
      TriggerClientEvent("usa:notify", source, "You've purchased a fishing pole!")
    else 
      TriggerClientEvent("usa:notify", source, "Not enough money! Need $100")
    end
  else 
    TriggerClientEvent("usa:notify", source, "Inventory full!")
  end
end)

RegisterServerEvent("boatMenu:requestPurchase")
AddEventHandler("boatMenu:requestPurchase", function(boat)
  local price = boats[boat.name].buy
  local char = exports["usa-characters"]:GetCharacter(source)
  local money = char.get("money")
  if money >= price then
      boat.id = math.random(9999999999)
      boat.stored = true
      local charBoats = char.get("watercraft")
      if not charBoats then
        charBoats = {boat}
        char.set("watercraft", charBoats)
        char.removeMoney(price)
      else
        if #charBoats <= MAX_VEHICLES then
          table.insert(charBoats, boat)
          char.set("watercraft", charBoats  )
          char.removeMoney(price)
        else
          TriggerClientEvent("usa:notify", source, "Sorry, you can't own more than " .. MAX_VEHICLES .. "!")
          return
        end
      end
      TriggerClientEvent("usa:notify", source, "Purchased: ~y~" .. boat.name .. "\n~s~Price: ~y~$" .. comma_value(boat.price)..'\n~s~ID: ~y~' ..boat.id)
      TriggerClientEvent("usa:notify", source, "Your boat can be found in your storage.")
      TriggerClientEvent("boatMenu:loadedBoats", source, charBoats)
  else
    TriggerClientEvent("usa:notify", source, "You cannot afford this purchase!")
  end
end)

RegisterServerEvent("boatMenu:loadBoats")
AddEventHandler("boatMenu:loadBoats", function(source2)
  if source2 then source = source2 end
  local char = exports["usa-characters"]:GetCharacter(source)
  if char then
    local charBoats = char.get("watercraft")
    print("#charBoats: " .. #charBoats)
    if charBoats then
      if #charBoats > 0 then
        TriggerClientEvent("boatMenu:loadedBoats", source, charBoats)
      end
    end
  end
end)

RegisterServerEvent('boatMenu:requestOpenMenu')
AddEventHandler('boatMenu:requestOpenMenu', function()
  local char = exports["usa-characters"]:GetCharacter(source)
  local license = char.getItem("Boat License")
  local watercraft = char.get("watercraft")
  if license and license.status == "valid" then
    TriggerClientEvent('boatMenu:openMenu', source, watercraft)
  else
    TriggerClientEvent('usa:notify', source, 'No license! Hold E to purchase one for $' .. comma_value(LICENSE_PURCHASE_PRICE))
  end
end)

RegisterServerEvent("boats:purchaseLicense")
AddEventHandler("boats:purchaseLicense", function()
  local timestamp = os.date("*t", os.time())
  local char = exports["usa-characters"]:GetCharacter(source)
  local NEW_BOAT_LICENSE = {
    name = 'Boat License',
    number = 'BL' .. tostring(math.random(1, 254367)),
    quantity = 1,
    ownerName = char.getFullName(),
    issued_by = "Boat Shop",
    ownerDob = char.get("dateOfBirth"),
    status = "valid",
    type = "license",
    notDroppable = true,
    expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
    weight = 0
  }
  if char.get("money") < LICENSE_PURCHASE_PRICE then
      TriggerClientEvent("usa:notify", source, "Not enough money!")
      return
  end
  if char.hasItem("Boat License") then
    TriggerClientEvent("usa:notify", source, 'You already have a boating license!')
  else
    if char.canHoldItem(NEW_BOAT_LICENSE) then
      char.giveItem(NEW_BOAT_LICENSE)
      char.removeMoney(LICENSE_PURCHASE_PRICE)
      TriggerClientEvent("usa:notify", source, "You have been issued a boating license!")
    else
      TriggerClientEvent("usa:notify", source, "Inventory full!")
    end
  end
end)

RegisterServerEvent("boatMenu:requestRent")
AddEventHandler("boatMenu:requestRent", function(vehicle, index)
  if rentals[source] then TriggerClientEvent("usa:notify", source, "You already have a rental watercraft!") return end
  local price = boats[vehicle.name].rent
  local char = exports["usa-characters"]:GetCharacter(source)
  local money = char.get("money")
  if money >= price then
    char.removeMoney(price)
    rentals[source] = boats[vehicle.name]
    TriggerClientEvent("boatMenu:rentBoat", source, index)
    TriggerClientEvent("usa:notify", source, "Here is your rental! You can return it just where you got it from for your money.")
  else
    TriggerClientEvent('usa:notify', source, 'You do not have enough money!')
  end
end)

RegisterServerEvent("boatMenu:requestSell")
AddEventHandler("boatMenu:requestSell", function(item)
  local char = exports["usa-characters"]:GetCharacter(source)
  local charBoats = char.get("watercraft")
  if #charBoats > 0 then
    for i = 1, #charBoats do
      if charBoats[i].id == item.id then
        local return_amount = 0.5 * boats[item.name].buy
        table.remove(charBoats, i)
        char.set("watercraft", charBoats)
        char.giveMoney(return_amount)
        TriggerClientEvent("boatMenu:loadedBoats", source, charBoats)
        TriggerClientEvent("usa:notify", source, "Boat sold for ~y~$" .. comma_value(return_amount) .. "~s~!")
        return
      end
    end
  end
end)

RegisterServerEvent("boatMenu:returnRental")
AddEventHandler("boatMenu:returnRental", function(item)
  if rentals[source].name == item.name then
    local return_amount = math.ceil(boats[item.name].rent * 0.25)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.giveMoney(return_amount)
    rentals = {}
  end
end)

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end
