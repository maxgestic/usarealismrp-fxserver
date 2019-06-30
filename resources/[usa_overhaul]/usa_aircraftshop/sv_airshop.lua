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

local DEBUG = false
local rentals = {}

local LICENSE_PURCHASE_PRICE = 5000

AddEventHandler('es:playerLoaded', function(source, char)
  TriggerEvent("aircraft:loadAircraft", source)
end)

RegisterServerEvent("aircraft:loadAircraft")
AddEventHandler("aircraft:loadAircraft", function(source)
  local char = exports["usa-characters"]:GetCharacter(source)
  if char then
    local aircraft = char.get("aircraft") or {}
    TriggerClientEvent("aircraft:loadedAircraft", source, aircraft)
  end
end)

RegisterServerEvent("aircraft:requestPurchase")
AddEventHandler("aircraft:requestPurchase", function(aircraft)
  local price = prices.purchase[aircraft.name]
  local char = exports["usa-characters"]:GetCharacter(source)
  local player_aircraft = char.get("aircraft") or {}
  if DEBUG then print("#aircraft: " .. #aircraft) end
  if char.get("money") - price >= 0 then
    char.removeMoney(price)
    aircraft.id = math.random(9999999999)
    aircraft.stored = true
    TriggerClientEvent("usa:notify", source, "Purchased: ~y~" .. (aircraft.name or "Undefined") .. "\n~s~Price: ~y~$" .. comma_value(price)..'\n~s~ID: ~y~' .. aircraft.id)
    TriggerClientEvent("usa:notify", source, "Your aircraft can be found in your storage.")
    -- add to player's aircraft collection --
    if not player_aircraft then
      player_aircraft = {aircraft}
      char.set("aircraft", player_aircraft)
    else
      if #player_aircraft <= MAX_VEHICLES then
        table.insert(player_aircraft, aircraft)
        char.set("aircraft", player_aircraft)
      else
        TriggerClientEvent("usa:notify", source, "Sorry, you can't own more than " .. MAX_VEHICLES .. "!")
        return
      end
    end
    char.set("aircraft", player_aircraft)
    TriggerClientEvent("aircraft:loadedAircraft", source, player_aircraft)
    if DEBUG then
      print("owned aircraft: ")
      for i = 1, #player_aircraft do
        print("name: " .. aircraft[i].name)
        print('stored: '..tostring(aircraft[i].stored))
        print('id: '..aircraft[i].id)
      end
    end
  else
    TriggerClientEvent('usa:notify', source, 'You do not have enough money!')
  end
end)

RegisterServerEvent("aircraft:purchaseLicense")
AddEventHandler("aircraft:purchaseLicense", function()
  local timestamp = os.date("*t", os.time())
  local char = exports["usa-characters"]:GetCharacter(source)
  local NEW_PILOT_LICENSE = {
    name = 'Aircraft License',
    number = 'PL' .. tostring(math.random(1, 254367)),
    quantity = 1,
    ownerName = char.getFullName(),
    issued_by = "Seaview Aircrafts",
    ownerDob = char.get("dateOfBirth"),
    expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
    status = "valid",
    type = "license",
    notDroppable = true,
    weight = 2.0
  }
  if char.get("money") < LICENSE_PURCHASE_PRICE then
      TriggerClientEvent("usa:notify", source, "Not enough money!")
      return
  end
  if char.canHoldItem(NEW_PILOT_LICENSE) then
    char.giveItem(NEW_PILOT_LICENSE)
    char.removeMoney(LICENSE_PURCHASE_PRICE)
    TriggerClientEvent("usa:notify", source, "You have been issued a pilot's license!")
  else
    TriggerClientEvent("usa:notify", source, "Inventory full!")
  end
end)

RegisterServerEvent("aircraft:requestRent")
AddEventHandler("aircraft:requestRent", function(aircraft)
  if rentals[source] then TriggerClientEvent("usa:notify", source, "You are already renting an aircraft!") return end
  local char = exports["usa-characters"]:GetCharacter(source)
  local price = prices.rent[aircraft.name]
  if price >= MIN_AIRCRAFT_PRICE then
    if char.get("money") >= price then
      rentals[source] = aircraft
      char.removeMoney(price)
      TriggerClientEvent("aircraft:rentAircraft", source, aircraft)
    else
      TriggerClientEvent("usa:notify", source, "You cannot afford this purchase!")
    end
  end
end)

RegisterServerEvent("aircraft:requestSell")
AddEventHandler("aircraft:requestSell", function(aircraft)
  local return_amount = math.ceil(prices.purchase[aircraft.name] * .50)
  local char = exports["usa-characters"]:GetCharacter(source)
  local ownedAircraft = char.get("aircraft") or {}
  for i = 1, #ownedAircraft do
    if ownedAircraft[i].id == aircraft.id then
      table.remove(ownedAircraft, i)
      char.set("aircraft", ownedAircraft)
      char.giveMoney(return_amount)
      if DEBUG then print("sold aircraft!") end
      TriggerClientEvent("usa:notify", source, "Aircraft sold for ~y~$" .. comma_value(return_amount) .. "~s~!")
      TriggerClientEvent("aircraft:loadedAircraft", source, ownedAircraft)
      return
    end
  end
end)

RegisterServerEvent("aircraft:returnRental")
AddEventHandler("aircraft:returnRental", function(item)
  local char = exports["usa-characters"]:GetCharacter(source)
  if rentals[source].name == item.name then
    local price = prices.rent[item.name]
    local returnAmount = math.ceil(.25*price)
    if returnAmount <= MAX_AIRCRAFT_RETURN_AMOUNT then
      char.giveMoney(returnAmount)
    else
      DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
      TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for attempting to exploit aircraft:returnRental event, please intervene^0!')
    end
  end
end)

RegisterServerEvent('aircraft:requestOpenMenu')
AddEventHandler('aircraft:requestOpenMenu', function()
  local char = exports["usa-characters"]:GetCharacter(source)
  local license = char.getItem("Aircraft License")
  if license and license.status == "valid" then
    TriggerClientEvent('aircraft:openMenu', source)
  else
    TriggerClientEvent('usa:notify', source, 'No license! Hold E to purchase one for $' .. comma_value(LICENSE_PURCHASE_PRICE))
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
