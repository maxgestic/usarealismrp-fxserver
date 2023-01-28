function onInteract(targetData,itemData)
    print(targetData.name,targetData.label) --> my_buffalo_target   Buffalo
    print(itemData.name,itemData.label)     --> lock_door           Lock Door
end

function onVehicleOptionSelect(a, buttonInfo, hitHandle)
    -- enable ui and go to correction page
    local vehPlate = GetVehicleNumberPlateText(hitHandle)
    if buttonInfo.label == "Open" then
        EnableGui(vehPlate, "vehicleActions.open")
    elseif buttonInfo.label == "Close" then
        EnableGui(vehPlate, "vehicleActions.close")
    elseif buttonInfo.label == "Inventory" then
        EnableGui(vehPlate, "inventory")
    elseif buttonInfo.label == "Hide Trunk" then
        TriggerEvent('trunkhide:hideInNearestTrunk')
    elseif buttonInfo.label == "Impound" then
        TriggerServerEvent("impound:impoundVehicle", hitHandle, GetVehicleNumberPlateText(hitHandle))
    elseif buttonInfo.label == "Tow" then
        TriggerEvent('towJob:towVehicle')
    elseif buttonInfo.label == "Repair" then
        TriggerEvent("mechanic:repairJobCheck")
    end
end

function onPersonOptionSelect(a, b, hitHandle) end

function addCivPlayerOptions()
    target.addPlayer("personOptions", "Person", "fas fa-male", 3.0, onPersonOptionSelect, {
        {
            name = 'give-money',
            label = 'Give Money',
            onSelect = function(a, b, entityHandle)
                -- had to save closest player ID for some reason --
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                -- Get desired amount to give from user --
                local amount = tonumber(exports.globals:GetUserInput())
                if amount then
                    -- Give cash to nearest player --
                    TriggerServerEvent("bank:givecash", playerServerId, amount)
                end
            end
        },
        {
            name = 'rob',
            label = 'Rob',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerEvent("crim:attemptToRobNearestPerson", playerServerId)
            end
        },
        {
            name = 'tie',
            label = 'Tie',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                local myped = PlayerPedId()
                local playerCoords = GetEntityCoords(myped)
                local playerHeading = GetEntityHeading(myped)
                local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(myped, 0.0, 0.65, -1.0))
                TriggerServerEvent("crim:foundPlayerToTie", playerServerId, true, x, y, z, playerHeading)
            end
        },
        {
            name = 'untie',
            label = 'Untie',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                local myped = PlayerPedId()
                local playerCoords = GetEntityCoords(myped)
                local playerHeading = GetEntityHeading(myped)
                local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(myped, 0.0, 0.65, -1.0))
                TriggerServerEvent("crim:foundPlayerToTie", playerServerId, false, x, y, z, playerHeading)
            end
        },
        {
            name = 'drag',
            label = 'Drag',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerEvent("drag:attemptToDragNearest", playerServerId)
            end
        },
        {
            name = 'blindfold',
            label = 'Blindfold',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerEvent("crim:attemptToBlindfoldNearestPerson", true, playerServerId)
            end
        },
        {
            name = 'remove-blindfold',
            label = 'Remove Blindfold',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerEvent("crim:attemptToBlindfoldNearestPerson", false, playerServerId)
            end
        },
        {
            name = 'place',
            label = 'Place',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerServerEvent("place:placePerson", playerServerId)
            end
        },
        {
            name = 'search',
            label = 'Search',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerEvent("search:attemptToSearchNearestPerson", playerServerId)
            end
        },
        {
            name = 'inspect',
            label = 'Inspect',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                local myServerId = GetPlayerServerId(PlayerId())
                TriggerServerEvent('injuries:getPlayerInjuries', playerServerId, myServerId)
            end
        },
    })
end

function addLEOPlayerOptions()
    target.addPlayer("personOptions", "Person", "fas fa-male", 3.0, onPersonOptionSelect, {
        {
            name = 'cuff',
            label = 'Cuff',
            onSelect = function(a, b, entityHandle)
                TriggerEvent("cuff:attemptToCuffNearest")
            end
        },
        {
            name = 'frisk',
            label = 'Frisk',
            onSelect = function(a, b, entityHandle)
                local src = GetPlayerServerId(PlayerId())
                TriggerEvent("police:friskNearest", src)
            end
        },
        {
            name = 'bandage',
            label = 'Bandage',
            onSelect = function(a, b, entityHandle)
                TriggerEvent("injuries:bandageNearestPed")
            end
        },
        {
            name = 'give-money',
            label = 'Give Money',
            onSelect = function(a, b, entityHandle)
                -- had to save closest player ID for some reason --
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                -- Get desired amount to give from user --
                local amount = tonumber(exports.globals:GetUserInput())
                if amount then
                    -- Give cash to nearest player --
                    TriggerServerEvent("bank:givecash", playerServerId, amount)
                end
            end
        },
        {
            name = 'untie',
            label = 'Untie',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                local myped = PlayerPedId()
                local playerCoords = GetEntityCoords(myped)
                local playerHeading = GetEntityHeading(myped)
                local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(myped, 0.0, 0.65, -1.0))
                TriggerServerEvent("crim:foundPlayerToTie", playerServerId, false, x, y, z, playerHeading)
            end
        },
        {
            name = 'drag',
            label = 'Drag',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerEvent("drag:attemptToDragNearest", playerServerId)
            end
        },
        {
            name = 'remove-blindfold',
            label = 'Remove Blindfold',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerEvent("crim:attemptToBlindfoldNearestPerson", false, playerServerId)
            end
        },
        {
            name = 'place',
            label = 'Place',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerServerEvent("place:placePerson", playerServerId)
            end
        },
        {
            name = 'search',
            label = 'Search',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerEvent("search:attemptToSearchNearestPerson", playerServerId)
            end
        },
        {
            name = 'inspect',
            label = 'Inspect',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                local myServerId = GetPlayerServerId(PlayerId())
                TriggerServerEvent('injuries:getPlayerInjuries', playerServerId, myServerId)
            end
        },
    })
end

function addEMSPlayerOptions()
    target.addPlayer("personOptions", "Person", "fas fa-male", 3.0, onPersonOptionSelect, {
        {
            name = 'bandage',
            label = 'Bandage',
            onSelect = function(a, b, entityHandle)
                TriggerEvent("injuries:bandageNearestPed")
            end
        },
        {
            name = 'give-money',
            label = 'Give Money',
            onSelect = function(a, b, entityHandle)
                -- had to save closest player ID for some reason --
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                -- Get desired amount to give from user --
                local amount = tonumber(exports.globals:GetUserInput())
                if amount then
                    -- Give cash to nearest player --
                    TriggerServerEvent("bank:givecash", playerServerId, amount)
                end
            end
        },
        {
            name = 'untie',
            label = 'Untie',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                local myped = PlayerPedId()
                local playerCoords = GetEntityCoords(myped)
                local playerHeading = GetEntityHeading(myped)
                local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(myped, 0.0, 0.65, -1.0))
                TriggerServerEvent("crim:foundPlayerToTie", playerServerId, false, x, y, z, playerHeading)
            end
        },
        {
            name = 'drag',
            label = 'Drag',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerEvent("drag:attemptToDragNearest", playerServerId)
            end
        },
        {
            name = 'remove-blindfold',
            label = 'Remove Blindfold',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerEvent("crim:attemptToBlindfoldNearestPerson", false, playerServerId)
            end
        },
        {
            name = 'place',
            label = 'Place',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerServerEvent("place:placePerson", playerServerId)
            end
        },
        {
            name = 'search',
            label = 'Search',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                TriggerEvent("search:attemptToSearchNearestPerson", playerServerId)
            end
        },
        {
            name = 'inspect',
            label = 'Inspect',
            onSelect = function(a, b, entityHandle)
                local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHandle))
                local myServerId = GetPlayerServerId(PlayerId())
                TriggerServerEvent('injuries:getPlayerInjuries', playerServerId, myServerId)
            end
        },
    })
end

function addCivVehicleOptions()
    target.addVehicle("vehicleOptions", "Vehicle", 'fas fa-car', 1.0, onVehicleOptionSelect, {
        {
            name = "open",
            label = "Open"
        },
        {
            name = "close",
            label = "Close"
        },
        {
            name = "inventory",
            label = "Inventory"
        },
        {
            name = "hideTrunk",
            label = "Hide Trunk"
        }
    })
end

function addLEOVehicleOptions()
    target.addVehicle("vehicleOptions", "Vehicle", 'fas fa-car', 1.0, onVehicleOptionSelect, {
        {
            name = "impound",
            label = "Impound"
        },
        {
            name = "open",
            label = "Open"
        },
        {
            name = "close",
            label = "Close"
        },
        {
            name = "inventory",
            label = "Inventory"
        },
        {
            name = "hideTrunk",
            label = "Hide Trunk"
        }
    })
end

function addMechanicVehicleOptions()
    target.addVehicle("vehicleOptions", "Vehicle", 'fas fa-car', 1.0, onVehicleOptionSelect, {
        {
            name = "tow",
            label = "Tow"
        },
        {
            name = "repair",
            label = "Repair"
        },
        {
            name = "open",
            label = "Open"
        },
        {
            name = "close",
            label = "Close"
        },
        {
            name = "inventory",
            label = "Inventory"
        },
        {
            name = "hideTrunk",
            label = "Hide Trunk"
        }
    })
end

addCivPlayerOptions()
addCivVehicleOptions()

RegisterNetEvent("thirdEye:updateActionsForNewJob")
AddEventHandler("thirdEye:updateActionsForNewJob", function(job)
    target.removeTarget("personOptions")
    target.removeTarget("vehicleOptions")
    if job == "sheriff" or job == "corrections" then
        addLEOPlayerOptions()
        addLEOVehicleOptions()
    elseif job == "ems" then
        addEMSPlayerOptions()
        addCivVehicleOptions()
    elseif job == "mechanic" then
        addCivPlayerOptions()
        addMechanicVehicleOptions()
    else
        addCivPlayerOptions()
        addCivVehicleOptions()
    end
end)