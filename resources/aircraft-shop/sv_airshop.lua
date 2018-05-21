-- TO PREVENT MEMORY EDIT CHEATERS
local MAX_AIRCRAFT_RETURN_AMOUNT = .25 * 250000
local MIN_AIRCRAFT_PRICE = 15000

local prices = {
    ["Frogger"] = 15000,
    ["Supervolito"] = 25000,
    ["Swift"] = 35000,
    ["Swift 2"] = 40000,
    ["Volatus"] = 50000,
    ["Cuban 800"] = 10000,
    ["Dodo"] = 10000,
    ["Duster"] = 6000,
    ["Mammatus"] = 15000,
    ["Stunt"] = 25000,
    ["Velum"] = 35000,
    ["Vestra"] = 40000,
    ["Nimbus"] = 55000,
    ["Shamal"] = 55000,
    ["Luxor"] = 70000,
    ["Luxor 2"] = 100000
}

RegisterServerEvent("airshop:rentVehicle")
AddEventHandler("airshop:rentVehicle", function(vehicle, property)
  print("vehicle.name = " .. vehicle.name)
  print("vehicle.price = " .. vehicle.price)
  print("vehicle.hash = " .. vehicle.hash)
  local price = prices[vehicle.name]
  local userSource = tonumber(source)
  if price >= MIN_AIRCRAFT_PRICE then
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
      print("inside of get player from id")
      if user then
        local user_money = user.getActiveCharacterData("money")
        print("user existed")
        if user_money >= price then
          local new_money = user_money - price
          -- give money to store owner --
          if property then 
            TriggerEvent("properties:addMoney", property.name, round(0.20 * price, 0))
          end
          user.setActiveCharacterData("money", new_money)
          print("calling spawnAircraft")
          TriggerClientEvent("airshop:spawnAircraft", userSource, vehicle.hash)
        else
          print("player did not have enough money")
        end
      end
    end)
  end
end)

RegisterServerEvent("airshop:returnedVehicle")
AddEventHandler("airshop:returnedVehicle", function(item)
    local userSource = tonumber(source)
    local price = prices[item.name]
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local user_money = user.getActiveCharacterData("money")
        local returnAmount = .25*price
        local rounded = round(returnAmount, 0)
        if rounded <= MAX_AIRCRAFT_RETURN_AMOUNT then
          local new_money = user_money + rounded
          user.setActiveCharacterData("money", new_money)
        else
          print("*** PLAYER .. " .. GetPlayerName(userSource) .. " WAS TRYING TO MEMORY CHEAT AIRCRAFT RETURN TO EXPLOIT MONEY! ***")
        end
    end)
end)

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end
