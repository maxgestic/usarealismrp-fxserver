--# dependencies: garage, vehicle-shop
--# description: coordinates locking/unlocking by plate # and key system, made specficially for usa rp
--# by: minipunch

local vehicles = {}

local randomMsg = {	"You found the keys in the ignition!" }

-- check for key, and trigger proper lock/unlock event accordingly
RegisterServerEvent("lock:checkForKey")
AddEventHandler("lock:checkForKey", function(plate)
  local char = exports["usa-characters"]:GetCharacter(source)
  local key = char.getItemWithField("plate", plate)
  if key then
    if isLocked(plate) then
      setLocked(plate, false)
      TriggerClientEvent("lock:unlockVehicle", source)
    else
      setLocked(plate, true)
      TriggerClientEvent("lock:lockVehicle", source)
    end
  else
    TriggerClientEvent("lock:sendNotification", source, 1, "You don't have the keys to the vehicle!", 0.5)
  end
end)

RegisterServerEvent("lock:addPlate")
AddEventHandler("lock:addPlate", function(plate)
    vehicles[plate] = false
end)

RegisterServerEvent("lock:removePlate")
AddEventHandler("lock:removePlate", function(plate)
    vehicles[plate] = nil
end)

function isLocked(plate)
    if type(vehicles[plate]) == "nil" then
        return true
    else
        return vehicles[plate]
    end
end

function setLocked(plate, locked)
  if vehicles and plate then
    vehicles[plate] = locked
  end
end

RegisterServerEvent("lock:setLocked")
AddEventHandler("lock:setLocked", function(plate, locked)
  setLocked(plate, locked)
end)

TriggerEvent('es:addCommand', 'lockstatus', function(source, args, char)
    TriggerClientEvent("lock:printLockStatus", source)
end)
