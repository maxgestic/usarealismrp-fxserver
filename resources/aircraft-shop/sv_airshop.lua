-- TO PREVENT MEMORY EDIT CHEATERS
local MAX_AIRCRAFT_RETURN_AMOUNT = .25 * 100000
local MIN_AIRCRAFT_PRICE = 6000

local prices = {
  rent = {
    ["Frogger"] = 15000,
    ["Havok"] = 15000,
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
    ["Luxor 2"] = 100000,
    ["Microlight"] = 15000,
    ["Alpha Z1"] = 35000,
    ["Seabreeze"] = 30000
  },
  purchase = {
    ["Frogger"] = 135000,
    ["Havok"] = 95000,
    ["Supervolito"] = 200000,
    ["Swift"] = 2750000,
    ["Swift 2"] = 300000,
    ["Volatus"] = 360000,
    ["Cuban 800"] = 100000,
    ["Dodo"] = 95000,
    ["Duster"] = 80000,
    ["Mammatus"] = 140000,
    ["Stunt"] = 200000,
    ["Velum"] = 225000,
    ["Vestra"] = 240000,
    ["Nimbus"] = 260000,
    ["Shamal"] = 350000,
    ["Luxor"] = 450000,
    ["Luxor 2"] = 500000,
    ["Microlight"] = 55000,
    ["Alpha Z1"] = 110000,
    ["Seabreeze"] = 90000
  }
}

local DEBUG = true

RegisterServerEvent("aircraft:getOwnedAircraft")
AddEventHandler("aircraft:getOwnedAircraft", function()
  local usource = source
  local user = exports["essentialmode"]:getPlayerFromId(usource)
  local user_aircraft = user.getActiveCharacterData("aircraft") or {}
  TriggerClientEvent("aircraft:ownedAircraftLoaded", usource, user_aircraft)
end)

RegisterServerEvent("airshop:purchaseAircraft")
AddEventHandler("airshop:purchaseAircraft", function(aircraft, property)
  local price = prices.purchase[aircraft.name]
  local usource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(usource)
  local user_aircraft = user.getActiveCharacterData("aircraft") or {}
  if DEBUG then print("#aircraft: " .. #user_aircraft) end
  local umoney = user.getActiveCharacterData("money")
  if umoney - price >= 0 then
    user.setActiveCharacterData("money", umoney - price)
    -- create unique id --
    aircraft.id = math.random(9999999999)
    -- spawn aircraft --
    TriggerClientEvent("airshop:spawnAircraft", usource, aircraft, true)
    print("Creating aircraft ID # for purchased aircraft: " .. aircraft.id)
    -- add to player's aircraft collection --
    table.insert(user_aircraft, aircraft)
    user.setActiveCharacterData("aircraft", user_aircraft)
    -- give money to property owner --
    if property then
      TriggerEvent("properties:addMoney", property.name, math.ceil(0.40 * price))
    end
    if DEBUG then
      print("owned aircraft: ")
      for i = 1, #user_aircraft do
        print("name: " .. user_aircraft[i].name)
      end
    end
  else
    TriggerClientEvent("chatMessage", usource, "", {}, "^0Not enough money to purchase! Need: $" .. price .. "!")
  end
end)

RegisterServerEvent("airshop:rentAircraft")
AddEventHandler("airshop:rentAircraft", function(aircraft, property)
  local price = prices.rent[aircraft.name]
  local userSource = tonumber(source)
  if price >= MIN_AIRCRAFT_PRICE then
    --TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local user = exports["essentialmode"]:getPlayerFromId(userSource)
    if user then
      local user_money = user.getActiveCharacterData("money")
      if user_money >= price then
        local new_money = user_money - price
        -- give money to store owner --
        if property then
          TriggerEvent("properties:addMoney", property.name, math.ceil(0.30 * price))
        end
        user.setActiveCharacterData("money", new_money)
        TriggerClientEvent("airshop:spawnAircraft", userSource, aircraft, false)
      else
        print("player did not have enough money to rent aircraft")
      end
    end
    --end)
  end
end)

RegisterServerEvent("airshop:sellAircraft")
AddEventHandler("airshop:sellAircraft", function(aircraft)
  local userSource = tonumber(source)
  local return_amount = math.ceil(prices.purchase[aircraft.name] * .50)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_money = user.getActiveCharacterData("money")
  local new_money = user_money + return_amount
  user.setActiveCharacterData("money", new_money)
  local user_aircraft = user.getActiveCharacterData("aircraft") or {}
  for i = 1, #user_aircraft do
    if user_aircraft[i].id == aircraft.id then
      table.remove(user_aircraft, i)
      user.setActiveCharacterData("aircraft", user_aircraft)
      if DEBUG then print("sold aircraft!") end
      TriggerClientEvent("usa:notify", userSource, "Aircraft sold for ~g~$" .. comma_value(return_amount) .. "~w~!")
      return
    end
  end
end)

RegisterServerEvent("airshop:returnedVehicle")
AddEventHandler("airshop:returnedVehicle", function(item)
  local userSource = tonumber(source)
  local price = prices.rent[item.name]
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_money = user.getActiveCharacterData("money")
  local returnAmount = .25*price
  local rounded = math.ceil(returnAmount)
  if rounded <= MAX_AIRCRAFT_RETURN_AMOUNT then
    local new_money = user_money + rounded
    user.setActiveCharacterData("money", new_money)
  else
    print("*** PLAYER .. " .. GetPlayerName(userSource) .. " WAS TRYING TO MEMORY CHEAT AIRCRAFT RETURN TO EXPLOIT MONEY! ***")
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
