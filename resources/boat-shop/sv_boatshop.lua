local MAX_VEHICLES = 6

local prices = {
  boats = {
    ["Nagasaki Dinghy"] = {buy = 15000, rent = 5000},
    ["Nagasaki Dinghy 2"] = {buy = 15000, rent = 5000},
    ["Dinka Marquis"] = {buy = 30000, rent = 9000},
    ["Speedophile Seashark"] = {buy = 5000, rent = 3500},
    ["Cuban Jetmax"] = {buy = 35000, rent = 7500},
    ["Lampadati Toro"] = {buy = 60000, rent = 15000},
    ["Lampadati Toro 2"] = {buy = 60000, rent = 15000},
    ["Tug"] = {buy = 200000, rent = 50000},
    ["Shitzu Squalo"] = {buy = 40000, rent = 7500},
    ["Shitzu Tropic"] = {buy = 40000, rent = 7500},
    ["Shitzu Suntrap"] = {buy = 30000, rent = 5500},
    ["Submersible"] = {buy = 750000, rent = 70000},
    ["Submersible 2"] = {buy = 750000, rent = 70000}
  }
}

AddEventHandler('es:playerLoaded', function(source, user)
  print("loading player boats!")
  TriggerEvent("boatShop:loadBoats", source)
end)

RegisterServerEvent("boatshop:purchaseBoat")
AddEventHandler("boatshop:purchaseBoat", function(boat, coords, property)
    print("boat.name = " .. boat.name)
    print("boat.price = " .. boat.price)
    print("boat.hash = " .. boat.hash)
    local price = prices.boats[boat.name].buy
    print("boat price = $" .. price)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        print("inside of get player from id")
        if user then
            print("user existed")
            local user_money = user.getActiveCharacterData("money")
            if user_money >= price then
                -- charge player:
                user.setActiveCharacterData("money", user_money - price)
                -- give money to store owner --
                if property then 
                  TriggerEvent("properties:addMoney", property.name, round(0.20 * price, 0))
                end
                -- store in player object:
                print("saving players' boats!")
                local user_boats = user.getActiveCharacterData("watercraft")
                if not user_boats then
                  print("player had no boats!")
                  user_boats = {boat}
                  user.setActiveCharacterData("watercraft", user_boats)
                else
                  print("user had boats! # = " .. #user_boats)
                  if #user_boats <= MAX_VEHICLES then
                    table.insert(user_boats, boat)
                    user.setActiveCharacterData("watercraft", user_boats)
                  else
                    TriggerClientEvent("usa:notify", userSource, "Sorry, you can't own more than " .. MAX_VEHICLES .. "!")
                    return
                  end
                end
                -- spawn seacraft:
                print("calling spawnAircraft")
                TriggerClientEvent("usa:notify", userSource, "Purchased: " .. boat.name .. "\nPrice: $" .. comma_value(boat.price))
                TriggerClientEvent("usa:notify", userSource, "Here is your boat! Thanks for your business! Feel free to store it here for a small fee.")
                TriggerClientEvent("boatshop:spawnSeacraft", userSource, boat, coords)
                TriggerClientEvent("boatShop:loadedBoats", userSource, user_boats)
            else
                print("player did not have enough money")
            end
        end
    end)
end)

RegisterServerEvent("boatshop:rentVehicle")
AddEventHandler("boatshop:rentVehicle", function(vehicle, coords, property)
    print("vehicle.name = " .. vehicle.name)
    print("vehicle.price = " .. vehicle.price)
    print("vehicle.hash = " .. vehicle.hash)
    local price = prices.boats[vehicle.name].rent
    print("rental boat price = $" .. price)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        print("inside of get player from id")
        if user then
            print("user existed")
            local user_money = user.getActiveCharacterData("money")
            if user_money >= price then
                user.setActiveCharacterData("money", user_money - price)
                -- give money to store owner --
                if property then 
                  TriggerEvent("properties:addMoney", property.name, round(0.20 * price, 0))
                end
                print("calling spawnAircraft")
                TriggerClientEvent("boatshop:spawnSeacraft", userSource, vehicle, coords)
                TriggerClientEvent("usa:notify", userSource, "Here is your rental! You can return it for cash back just over there at the blue circle.")
            else
                print("player did not have enough money")
            end
        end
    end)
end)

RegisterNetEvent("boatShop:loadBoats")
AddEventHandler("boatShop:loadBoats", function(source2)
  if source2 then source = source2 end
  local userSource = tonumber(source)
  TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local user_boats = user.getActiveCharacterData("watercraft")
    if user_boats then
      if #user_boats > 0 then
        TriggerClientEvent("boatShop:loadedBoats", userSource, user_boats)
      else
        TriggerClientEvent("boatShop:setPage", userSource, "home")
        TriggerClientEvent("usa:notify", userSource, "You don't own any watercraft!")
      end
    else
      TriggerClientEvent("boatShop:setPage", userSource, "home")
      TriggerClientEvent("usa:notify", userSource, "You don't own any watercraft!")
    end
  end)
end)

RegisterServerEvent("boatShop:sellBoat")
AddEventHandler("boatShop:sellBoat", function(item)
  local userSource = tonumber(source)
  TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local user_boats = user.getActiveCharacterData("watercraft")
    if user_boats then
      if #user_boats > 0 then
        for i = 1, #user_boats do
          if user_boats[i].hash == item.hash then
            print("found matching boat hash to sell from player!")
            local return_amount = 0.5 * prices.boats[item.name].buy
            print("selling for $" .. return_amount)
            local user_money = user.getActiveCharacterData("money")
            user.setActiveCharacterData("money", user_money + return_amount)
            table.remove(user_boats, i)
            user.setActiveCharacterData("watercraft", user_boats)
            TriggerClientEvent("boatShop:loadedBoats", userSource, user_boats)
            return
          end
        end
      end
    end
  end)
end)

RegisterServerEvent("boatshop:returnRental")
AddEventHandler("boatshop:returnRental", function(item)
  local userSource = tonumber(source)
  local return_amount = round(prices.boats[item.name].rent * 0.25, 0)
  TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local user_money = user.getActiveCharacterData("money")
    user.setActiveCharacterData("money", user_money + return_amount)
  end)
end)

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

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
