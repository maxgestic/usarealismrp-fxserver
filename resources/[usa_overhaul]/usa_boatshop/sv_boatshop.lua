local MAX_VEHICLES = 6

local boats = {
  ["Nagasaki Dinghy"] = {name = "Nagasaki Dinghy", buy = 15000, rent = 5000},
  ["Nagasaki Dinghy 2"] = {name = "Nagasaki Dinghy 2", buy = 15000, rent = 5000},
  ["Dinka Marquis"] = {name = "Dinka Marquis", buy = 30000, rent = 9000},
  ["Speedophile Seashark"] = {name = "Speedophile Seashark", buy = 5000, rent = 3500},
  ["Cuban Jetmax"] = {name = "Cuban Jetmax", buy = 35000, rent = 7500},
  ["Lampadati Toro"] = {name = "Lampadati Toro", buy = 60000, rent = 15000},
  ["Lampadati Toro 2"] = {name = "Lampadati Toro 2", buy = 60000, rent = 15000},
  ["Tug"] = {name = "Tug", buy = 200000, rent = 50000},
  ["Shitzu Squalo"] = {name = "Shitzu Squalo", buy = 40000, rent = 7500},
  ["Shitzu Tropic"] = {name = "Shitzu Tropic", buy = 40000, rent = 7500},
  ["Shitzu Suntrap"] = {name = "Shitzu Suntrap", buy = 30000, rent = 5500},
  ["Submersible"] = {name = "Submersible", buy = 750000, rent = 70000},
  ["Submersible 2"] = {name = "Submersible 2", buy = 750000, rent = 70000}
}

local rentals = {}

AddEventHandler('es:playerLoaded', function(source, user)
  TriggerEvent("boatMenu:loadBoats", source)
end)

RegisterServerEvent("boatMenu:requestPurchase")
AddEventHandler("boatMenu:requestPurchase", function(boat)
  local price = boats[boat.name].buy
  local char = exports["usa-characters"]:GetCharacter(source)
  local money = char.get("money")
  if money >= price then
      boat.id = math.random(9999999999)
      boat.stored = true
      local boats = char.get("watercraft")
      if not boats then
        boats = {boat}
        char.set("watercraft", boats)
        char.removeMoney(price)
      else
        if #boats <= MAX_VEHICLES then
          table.insert(boats, boat)
          char.set("watercraft", boats)
          char.removeMoney(price)
        else
          TriggerClientEvent("usa:notify", source, "Sorry, you can't own more than " .. MAX_VEHICLES .. "!")
          return
        end
      end
      TriggerClientEvent("usa:notify", source, "Purchased: ~y~" .. boat.name .. "\n~s~Price: ~y~$" .. comma_value(boat.price)..'\n~s~ID: ~y~' ..boat.id)
      TriggerClientEvent("usa:notify", source, "Your boat can be found in your storage.")
      TriggerClientEvent("boatMenu:loadedBoats", source, user_boats)
  else
    TriggerClientEvent("usa:notify", source, "You cannot afford this purchase!")
  end
end)

RegisterNetEvent("boatMenu:loadBoats")
AddEventHandler("boatMenu:loadBoats", function(source2)
  if source2 then source = source2 end
  local char = exports["usa-characters"]:GetCharacter(source)
  local boats = user.getActiveCharacterData("watercraft")
  if boats then
    if #boats > 0 then
      TriggerClientEvent("boatMenu:loadedBoats", source, boats)
    end
  end
end)

RegisterServerEvent('boatMenu:requestOpenMenu')
AddEventHandler('boatMenu:requestOpenMenu', function()
  local char = exports["usa-characters"]:GetCharacter(source)
  local license = char.getItem("Boat License")
  if license and license.status == "valid" then
    TriggerClientEvent('boatMenu:openMenu', userSource)
  else
    TriggerClientEvent('usa:notify', userSource, 'You do not have a valid Boat License!')
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
  local boats = char.get("watercraft")
  if #boats > 0 then
    for i = 1, #boats do
      if boats[i].id == item.id then
        local return_amount = 0.5 * boats[item.name].buy
        table.remove(boats, i)
        char.set("watercraft", boats)
        char.giveMoney(return_amount)
        TriggerClientEvent("boatMenu:loadedBoats", source, boats)
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
