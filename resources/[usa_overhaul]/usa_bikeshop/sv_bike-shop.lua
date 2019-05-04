local SV_ITEMS = { -- must be kept in sync with one in cl_bike-shop.lua --
  {name = "BMX", price = 250, hash = 1131912276},
  {name = "Cruiser", price = 300, hash = 448402357},
  {name = "Fixster", price = 350, hash = -836512833},
  {name = "Scorcher", price = 500, hash = -186537451},
  {name = "TriBike", price = 550, hash = 1127861609}
}

RegisterServerEvent("bikeShop:requestPurchase")
AddEventHandler("bikeShop:requestPurchase", function(index, location)
  local userSource = source
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local bike = SV_ITEMS[index]
  local user_money = user.getActiveCharacterData("money")
  local vehicles = user.getActiveCharacterData("vehicles")
  if bike.price <= user_money then -- see if user has enough money
    user.setActiveCharacterData("money", user_money - bike.price)
    local owner_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
    local plate = generate_random_number_plate()
    local vehicle = {
      owner = owner_name,
      make = bike.name,
      model = 'Bicycle',
      hash = bike.hash,
      plate = plate,
      stored = false,
      price = bike.price,
      inventory = {},
      storage_capacity = 5.0
    }
    -- give player vehicle --
    table.insert(vehicles, vehicle.plate)
    user.setActiveCharacterData("vehicles", vehicles)
    print("vehicle purchased (" .. vehicle.model .. ")!")
    -- add to database --
    AddVehicleToDB(vehicle)
    TriggerEvent("lock:addPlate", vehicle.plate)
    TriggerClientEvent("usa:notify", userSource, "You have purchased a ~y~" .. bike.name .. "~s~, you may store it in a garage.")
    TriggerClientEvent("bikeShop:spawnBike", userSource, bike, location, plate)
    TriggerClientEvent("bikeShop:toggleMenu", userSource, false)
  else
    TriggerClientEvent("usa:notify", userSource, "Not enough money!")
  end
end)


function generate_random_number_plate()
  local charset = {
    numbers = {},
    letters = {}
  }
  -- QWERTYUIOPASDFGHJKLZXCVBNM1234567890
  for i = 48,  57 do table.insert(charset.numbers, string.char(i)) end -- add numbers 1 - 9
  for i = 65,  90 do table.insert(charset.letters, string.char(i)) end -- add capital letters
  local number_plate = ""
  number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
  number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
  number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
  number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
  number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
  number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
  number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
  number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
  print("created random plate: ")
  return number_plate
end

-- Insert new vehicle into DB --
function AddVehicleToDB(vehicle)
  TriggerEvent('es:exposeDBFunctions', function(couchdb)
    couchdb.createDocumentWithId("vehicles", vehicle, vehicle.plate, function(success)
      if success then
        print("* Vehicle created in DB!! *")
      else
        print("* Error: vehicle was not created in DB!! *")
      end
    end)
  end)
end