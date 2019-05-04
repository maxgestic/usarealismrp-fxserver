-- TO PREVENT MEMORY EDIT CHEATERS
local MAX_AIRCRAFT_RETURN_AMOUNT = .25 * 100000
local MIN_AIRCRAFT_PRICE = 6000
local MAX_VEHICLES = 6

local prices = {
  rent = {
    ["Frogger"] = 20000,
    ["Havok"] = 15000,
    ["Supervolito"] = 105000,
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
    ["Shamal"] = 100000,
    ["Luxor"] = 200000,
    ["Luxor 2"] = 300000,
    ["Microlight"] = 15000,
    ["Alpha Z1"] = 35000,
    ["Seabreeze"] = 30000
  },
  purchase = {
    ["Frogger"] = 175000,
    ["Havok"] = 95000,
    ["Supervolito"] = 400000,
    ["Swift"] = 275000,
    ["Swift 2"] = 600000,
    ["Volatus"] = 660000,
    ["Cuban 800"] = 100000,
    ["Dodo"] = 95000,
    ["Duster"] = 80000,
    ["Mammatus"] = 140000,
    ["Stunt"] = 900000,
    ["Velum"] = 325000,
    ["Vestra"] = 750000,
    ["Nimbus"] = 900000,
    ["Shamal"] = 450000,
    ["Luxor"] = 3000000,
    ["Luxor 2"] = 3500000,
    ["Microlight"] = 55000,
    ["Alpha Z1"] = 110000,
    ["Seabreeze"] = 90000
  }
}

local DEBUG = true

AddEventHandler('es:playerLoaded', function(source, user)
  print("loading player aircraft!")
  TriggerEvent("aircraft:loadAircraft", source)
end)

RegisterServerEvent("aircraft:loadAircraft")
AddEventHandler("aircraft:loadAircraft", function(source)
  local usource = source
  local user = exports["essentialmode"]:getPlayerFromId(usource)
  local user_aircraft = user.getActiveCharacterData("aircraft") or {}
  TriggerClientEvent("aircraft:loadedAircraft", usource, user_aircraft)
end)

RegisterServerEvent("aircraft:requestPurchase")
AddEventHandler("aircraft:requestPurchase", function(aircraft)
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
    aircraft.stored = true
    -- spawn aircraft --
    TriggerClientEvent("usa:notify", usource, "Purchased: ~y~" .. aircraft.name .. "\n~s~Price: ~y~$" .. comma_value(price)..'\n~s~ID: ~y~' .. aircraft.id)
    TriggerClientEvent("usa:notify", usource, "Your aircraft can be found in your storage.")
    print("Creating aircraft ID # for purchased aircraft: " .. aircraft.id)
    print('Aircraft stored: '..tostring(aircraft.stored))
    -- add to player's aircraft collection --
    if not user_aircraft then
      print("player had no aircrafts!")
      user_aircraft = {aircraft}
      user.setActiveCharacterData("aircraft", user_aircraft)
    else
      print("user had aircrafts! # = " .. #user_aircraft)
      if #user_aircraft <= MAX_VEHICLES then
        table.insert(user_aircraft, aircraft)
        user.setActiveCharacterData("aircraft", user_aircraft)
      else
        TriggerClientEvent("usa:notify", usource, "Sorry, you can't own more than " .. MAX_VEHICLES .. "!")
        return
      end
    end
    user.setActiveCharacterData("aircraft", user_aircraft)
    TriggerClientEvent("aircraft:loadedAircraft", usource, user_aircraft)
    --TriggerClientEvent("aircraft:spawnAircraft", usource, aircraft)
    if DEBUG then
      print("owned aircraft: ")
      for i = 1, #user_aircraft do
        print("name: " .. user_aircraft[i].name)
        print('stored: '..tostring(user_aircraft[i].stored))
        print('id: '..user_aircraft[i].id)
      end
    end
  else
    TriggerClientEvent('usa:notify', usource, 'You do not have enough money!')
  end
end)

RegisterServerEvent("aircraft:requestRent")
AddEventHandler("aircraft:requestRent", function(aircraft)
  local price = prices.rent[aircraft.name]
  local usource = tonumber(source)
  if price >= MIN_AIRCRAFT_PRICE then
    --TriggerEvent("es:getPlayerFromId", usource, function(user)
    local user = exports["essentialmode"]:getPlayerFromId(usource)
    if user then
      local user_money = user.getActiveCharacterData("money")
      if user_money >= price then
        local new_money = user_money - price
        user.setActiveCharacterData("money", new_money)
        TriggerClientEvent("aircraft:rentAircraft", usource, aircraft)
      else
        print("player did not have enough money to rent aircraft")
      end
    end
    --end)
  end
end)

RegisterServerEvent("aircraft:requestSell")
AddEventHandler("aircraft:requestSell", function(aircraft)
  local usource = tonumber(source)
  local return_amount = math.ceil(prices.purchase[aircraft.name] * .50)
  local user = exports["essentialmode"]:getPlayerFromId(usource)
  local user_money = user.getActiveCharacterData("money")
  local user_aircraft = user.getActiveCharacterData("aircraft") or {}
  for i = 1, #user_aircraft do
    if user_aircraft[i].id == aircraft.id then
      table.remove(user_aircraft, i)
      user.setActiveCharacterData("aircraft", user_aircraft)
      local new_money = user_money + return_amount
      user.setActiveCharacterData("money", new_money)
      if DEBUG then print("sold aircraft!") end
      TriggerClientEvent("usa:notify", usource, "Aircraft sold for ~y~$" .. comma_value(return_amount) .. "~s~!")
      TriggerClientEvent("aircraft:loadedAircraft", usource, user_aircraft)
      return
    end
  end
end)

RegisterServerEvent("aircraft:returnRental")
AddEventHandler("aircraft:returnRental", function(item)
  local usource = tonumber(source)
  print(item.name)
  local price = prices.rent[item.name]
  local user = exports["essentialmode"]:getPlayerFromId(usource)
  local user_money = user.getActiveCharacterData("money")
  local returnAmount = .25*price
  local rounded = math.ceil(returnAmount)
  if rounded <= MAX_AIRCRAFT_RETURN_AMOUNT then
    local new_money = user_money + rounded
    user.setActiveCharacterData("money", new_money)
  else
    print("*** PLAYER .. " .. GetPlayerName(usource) .. " WAS TRYING TO MEMORY CHEAT AIRCRAFT RETURN TO EXPLOIT MONEY! ***")
  end
end)

RegisterServerEvent('aircraft:requestOpenMenu')
AddEventHandler('aircraft:requestOpenMenu', function()
  local usource = source
  local user = exports["essentialmode"]:getPlayerFromId(usource)
  local licenses = user.getActiveCharacterData("licenses")
    for i = 1, #licenses do
      if licenses[i].name == 'Aircraft License' then
        if licenses[i].status == 'valid' then
          TriggerClientEvent('aircraft:openMenu', usource)
          return
        else
          TriggerClientEvent('usa:notify', usource, 'Your aircraft license is ~y~suspended~s~ by a Judge.')
          return
        end
      end
    end
    TriggerClientEvent('usa:notify', usource, 'You do not have an aircraft license!')
    return
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
