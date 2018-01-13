--# dependencies: garage, vehicle-shop
--# description: coordinates locking/unlocking by plate # and key system, made specficially for usa rp
--# by: minipunch

local vehicles = {}

local randomMsg = {	"You found the keys in the ignition!"
    --[["You have found the keys on the sun-shield",
     				"You found the keys in the glove box.",
    				"You found the keys on the passenger seat.",
    				"You found the keys on the floor.",
    				"The keys were already on the contact, you took them."--]]}

-- check for key, and trigger proper lock/unlock event accordingly
RegisterServerEvent("lock:checkForKey")
AddEventHandler("lock:checkForKey", function(plate)
  local userSource = tonumber(source)
  TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local inv = user.getActiveCharacterData("inventory")
    for i = 1, #inv do
      local item = inv[i]
      if item then
        if string.find(item.name, "Key") then
          if string.find(plate, item.plate) then
            print("found plate match!")
            if isLocked(plate) then
              setLocked(plate, false)
              TriggerClientEvent("lock:unlockVehicle", userSource)
            else
              setLocked(plate, true)
              TriggerClientEvent("lock:lockVehicle", userSource)
            end
            return
          end
        end
      end
    end
    -- no key owned for vehicle trying to lock/unlock
    print("Player did not have the key to unlock vehicle with plate #" .. plate)
    TriggerClientEvent("lock:lookForKeys", userSource, plate)
  end)
end)

RegisterServerEvent("lock:foundKeys")
AddEventHandler("lock:foundKeys", function(found, plate)
    local userSource = tonumber(source)
    if found then
        local vehicle_key = {
            name = "Key -- " .. plate,
            quantity = 1,
            type = "key",
            owner = "Stolen?",
            make = "???",
            model = "???",
            plate = plate
        }
        TriggerEvent("es:getPlayerFromId", source, function(user)
            local inv = user.getActiveCharacterData("inventory")
            table.insert(inv, vehicle_key)
            user.setActiveCharacterData("inventory", inv)
            local length = #(randomMsg)
    		local randomNbr = math.random(1, tonumber(length))
    		TriggerClientEvent("lock:sendNotification", userSource, 1, randomMsg[randomNbr], 0.5)
        end)
    else
        TriggerClientEvent("lock:sendNotification", userSource, 1, "You don't have the keys to the vehicle!", 0.5)
    end
end)

RegisterServerEvent("lock:addPlate")
AddEventHandler("lock:addPlate", function(plate)
    vehicles[plate] = false
    print("added plate #" .. plate .. " to lock toggle list!")
end)

RegisterServerEvent("lock:removePlate")
AddEventHandler("lock:removePlate", function(plate)
    vehicles[plate] = nil
    print("removed plate #" .. plate .. " from lock toggle list!")
end)

function isLocked(plate)
    print("vehicles[plate] = " .. tostring(vehicles[tostring(plate)]))
    return vehicles[plate]
end

function setLocked(plate, locked)
  if vehicles[plate] then
    vehicles[plate] = locked
    print("plate #" .. plate .. " lock status set to: " .. tostring(locked))
  end
end

RegisterServerEvent("lock:setLocked")
AddEventHandler("lock:setLocked", function(plate, locked)
  setLocked(plate, locked)
end)

TriggerEvent('es:addCommand', 'locklist', function(source, args, user)
    for k, v in pairs(vehicles) do
        print("key = " .. k .. ", type = " .. type(k))
        print("val = " .. tostring(v))
    end
end)

TriggerEvent('es:addCommand', 'lockstatus', function(source, args, user)
    TriggerClientEvent("lock:printLockStatus", source)
end)
