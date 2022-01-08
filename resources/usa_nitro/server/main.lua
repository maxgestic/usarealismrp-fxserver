exports["globals"]:PerformDBCheck("usa_nitro", "vehicle-nitro-fuel", nil)

db = nil

TriggerEvent("es:exposeDBFunctions", function(exposedDB)
  db = exposedDB
end)

RegisterNetEvent('nitro:__sync')
AddEventHandler('nitro:__sync', function (boostEnabled, purgeEnabled, lastVehicle)
  -- Fix for source reference being lost during loop below.
  local source = source

  for _, player in ipairs(GetPlayers()) do
    if player ~= tostring(source) then
      TriggerClientEvent('nitro:__update', player, source, boostEnabled, purgeEnabled, lastVehicle)
    end
  end
end)


RegisterNetEvent("nitro:getFuel")
AddEventHandler("nitro:getFuel", function(vehPlate)
    print("trying to use nitro")
    local src = source
    vehPlate = exports.globals:trim(vehPlate)
    local query = {
        ["_id"] = vehPlate
    }
    local fields = {
        "_id",
        "upgrades",
    }
    db.getSpecificFieldFromDocumentByRows("vehicles", query, fields, function(doc)
        if doc then
            if doc.upgrades and isInArray(doc.upgrades, "nitrokit") and isInArray(doc.upgrades, "nitrobottle") then
                local fuelAmount = getNitroFuelAmount(vehPlate)
                print("fuel amount: " .. fuelAmount)
                TriggerClientEvent("nitro:setFuel", src, fuelAmount)
            else
                TriggerClientEvent("usa:notify", src, "Nitro kit & bottle not installed")
            end
        end
    end)
end)

RegisterNetEvent("nitro:saveFuel")
AddEventHandler("nitro:saveFuel", function(vehPlate, amount)
    vehPlate = exports.globals:trim(vehPlate)
    db.updateDocument("vehicle-nitro-fuel", vehPlate, {nitroFuelLevel = amount}, function(ok) end)
end)

function isInArray(arr, val)
    for i = 1, #arr do
        if arr[i]:find(val) then
            return true
        end
    end
    return false
end

function getNitroFuelAmount(vehPlate)
    local result = nil
    vehPlate = exports.globals:trim(vehPlate)
    db.getDocumentById("vehicle-nitro-fuel", vehPlate, function(doc)
        if doc then
            result = doc.nitroFuelLevel
        else
            result = 0
        end
    end)
    while result == nil do
        Wait(1)
    end
    return result
end