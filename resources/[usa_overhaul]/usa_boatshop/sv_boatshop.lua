local MAX_VEHICLES = 6

local boats = {
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

AddEventHandler('es:playerLoaded', function(source, user)
  print("loading player boats!")
  TriggerEvent("boatMenu:loadBoats", source)
end)

RegisterServerEvent("boatMenu:requestPurchase")
AddEventHandler("boatMenu:requestPurchase", function(boat)
    print("boat.name = " .. boat.name)
    print("boat.price = " .. boat.price)
    print("boat.hash = " .. boat.hash)
    local price = boats[boat.name].buy
    print("boat price = $" .. price)
    local userSource = tonumber(source)
    local user = exports["essentialmode"]:getPlayerFromId(userSource)
        print("inside of get player from id")
        if user then
            print("user existed")
            local user_money = user.getActiveCharacterData("money")
            if user_money >= price then
                -- charge player:
                user.setActiveCharacterData("money", user_money - price)
                boat.id = math.random(9999999999)
                boat.stored = true
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
                TriggerClientEvent("usa:notify", userSource, "Purchased: ~y~" .. boat.name .. "\n~s~Price: ~y~$" .. comma_value(boat.price)..'\n~s~ID: ~y~' ..boat.id)
                TriggerClientEvent("usa:notify", userSource, "Your boat can be found in your storage.")
                --TriggerClientEvent("boatMenu:spawnSeacraft", userSource, boat)
                TriggerClientEvent("boatMenu:loadedBoats", userSource, user_boats)
            else
                print("player did not have enough money")
            end
        end
end)

RegisterNetEvent("boatMenu:loadBoats")
AddEventHandler("boatMenu:loadBoats", function(source2)
  if source2 then source = source2 end
  local userSource = tonumber(source)
  --TriggerEvent("es:getPlayerFromId", userSource, function(user)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
    local user_boats = user.getActiveCharacterData("watercraft")
    if user_boats then
      if #user_boats > 0 then
        TriggerClientEvent("boatMenu:loadedBoats", userSource, user_boats)
      end
    end
  --end)
end)

RegisterServerEvent('boatMenu:requestOpenMenu')
AddEventHandler('boatMenu:requestOpenMenu', function()
  local userSource = source
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local licenses = user.getActiveCharacterData("licenses")
    for i = 1, #licenses do
      if licenses[i].name == 'Boat License' then
        if licenses[i].status == 'valid' then
          TriggerClientEvent('boatMenu:openMenu', userSource)
          return
        else
          TriggerClientEvent('usa:notify', userSource, 'Your boat license is ~y~suspended~s~ by a Judge.')
          return
        end
      end
    end
    TriggerClientEvent('usa:notify', userSource, 'You do not have a valid boat license!')
    return
end)

RegisterServerEvent("boatMenu:requestRent")
AddEventHandler("boatMenu:requestRent", function(vehicle, index)
    print("vehicle.name = " .. vehicle.name)
    print("vehicle.price = " .. vehicle.price)
    print("vehicle.hash = " .. vehicle.hash)
    local price = boats[vehicle.name].rent
    print("rental boat price = $" .. price)
    local userSource = tonumber(source)
    --TriggerEvent("es:getPlayerFromId", userSource, function(user)
      local user = exports["essentialmode"]:getPlayerFromId(userSource)
        print("inside of get player from id")
        if user then
            print("user existed")
            local user_money = user.getActiveCharacterData("money")
            if user_money >= price then
                user.setActiveCharacterData("money", user_money - price)
                -- give money to store owner --
                print("calling spawnSeacraft")
                TriggerClientEvent("boatMenu:rentBoat", userSource, index)
                TriggerClientEvent("usa:notify", userSource, "Here is your rental! You can return it just where you got it from.")
            else
                print("player did not have enough money")
                TriggerClientEvent('usa:notify', userSource, 'You do not have enough money!')
            end
        end
    --end)
end)

RegisterServerEvent("boatMenu:requestSell")
AddEventHandler("boatMenu:requestSell", function(item)
  local userSource = tonumber(source)
  --TriggerEvent("es:getPlayerFromId", userSource, function(user)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
    local user_boats = user.getActiveCharacterData("watercraft")
    if user_boats then
      if #user_boats > 0 then
        for i = 1, #user_boats do
          if user_boats[i].id == item.id then
            print("found matching boat ID to sell from player!")
            local return_amount = 0.5 * boats[item.name].buy
            print("selling for $" .. return_amount)
            local user_money = user.getActiveCharacterData("money")
            user.setActiveCharacterData("money", user_money + return_amount)
            table.remove(user_boats, i)
            user.setActiveCharacterData("watercraft", user_boats)
            TriggerClientEvent("boatMenu:loadedBoats", userSource, user_boats)
            TriggerClientEvent("usa:notify", userSource, "Boat sold for ~y~$" .. comma_value(return_amount) .. "~s~!")
            return
          end
        end
      end
    end
  --end)
end)

RegisterServerEvent("boatMenu:returnRental")
AddEventHandler("boatMenu:returnRental", function(item)
  local userSource = tonumber(source)
  local return_amount = math.ceil(boats[item.name].rent * 0.25)
  --TriggerEvent("es:getPlayerFromId", userSource, function(user)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
    local user_money = user.getActiveCharacterData("money")
    user.setActiveCharacterData("money", user_money + return_amount)
  --end)
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
