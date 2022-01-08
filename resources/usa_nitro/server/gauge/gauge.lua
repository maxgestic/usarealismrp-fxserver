
RegisterServerEvent("nitro-gauge:fetchGuageData")
AddEventHandler("nitro-gauge:fetchGuageData", function(vehPlate)
    local src = source
    vehPlate = exports.globals:trim(vehPlate)
    if doesHaveGuageInstalled(vehPlate) then
        local nitroFuelLevelInfo = getNitroFuelLevelInfo(vehPlate)
        if nitroFuelLevelInfo then
            if not nitroFuelLevelInfo.max then
                print("NITRO FUEL DB DOC WITH NO MAX CAPACITY VALUE DETECTED, ABORTING")
                return
            end
            TriggerClientEvent("nitro-gauge:setGaugeData", src, nitroFuelLevelInfo.current, nitroFuelLevelInfo.max)
        end
    end
end)

function doesHaveGuageInstalled(vehPlate)
    local hasGuage = doesVehicleHaveUpgrades(vehPlate, {"nitroguage"})
    return hasGuage
end

function getNitroFuelLevelInfo(vehPlate)
    local result = nil
    db.getDocumentById("vehicle-nitro-fuel", vehPlate, function(doc)
        if doc then
            result = {
                max = doc.maxCapacity,
                current = doc.nitroFuelLevel
            }
        else
            result = false
        end
    end)
    while result == nil do
        Wait(1)
    end
    return result
end

function doesVehicleHaveUpgrades(plate, upgradesToLookFor)
    local result = nil
    plate = exports.globals:trim(plate)
    db.getDocumentById("vehicles", plate, function(doc)
        if doc and doc.upgrades then
            for i = #upgradesToLookFor, 1, -1 do
                for j = 1, #doc.upgrades do
                    if doc.upgrades[j] == upgradesToLookFor[i] then
                        table.remove(upgradesToLookFor, i)
                        break
                    end
                end
            end
            result = #upgradesToLookFor == 0
        else
            result = false
        end
    end)
    while result == nil do
        Wait(1)
    end
    return result
end