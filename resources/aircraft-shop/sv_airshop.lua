-- TO PREVENT MEMORY EDIT CHEATERS
local MAX_AIRCRAFT_RETURN_AMOUNT = .25 * 250000
local MIN_AIRCRAFT_PRICE = 15000

local prices = {
    ["Frogger"] = 35000,
    ["Supervolito"] = 45000,
    ["Swift"] = 55000,
    ["Swift 2"] = 65000,
    ["Volatus"] = 75000,
    ["Cuban 800"] = 20000,
    ["Dodo"] = 21000,
    ["Duster"] = 15000,
    ["Mammatus"] = 30000,
    ["Stunt"] = 45000,
    ["Velum"] = 55000,
    ["Vestra"] = 60000,
    ["Nimbus"] = 75000,
    ["Shamal"] = 75000,
    ["Luxor"] = 200000,
    ["Luxor 2"] = 250000
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
