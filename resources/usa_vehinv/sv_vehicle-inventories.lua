RegisterServerEvent("vehicle:AddPersonToInventory")
AddEventHandler("vehicle:AddPersonToInventory", function(plate)
  VehInventoryManager:AddPersonToInventory(plate, source)
end)

RegisterServerEvent("vehicle:RemovePersonFromInventory")
AddEventHandler("vehicle:RemovePersonFromInventory", function(plate)
  VehInventoryManager:RemovePersonFromInventory(plate, source)
end)

RegisterServerEvent("vehicle:updateForOthers")
AddEventHandler("vehicle:updateForOthers", function(plate, inv, isLocked) -- todo: this could be exploited/abused by lua injection, remove inv parameter and fetch inventory by plate again?
    if VehInventoryManager.beingAccessed[plate] then
        for id, val in pairs(VehInventoryManager.beingAccessed[plate]) do
            if IsPlayerActive(id) then
                TriggerClientEvent("interaction:sendNUIMessage", id, { type = "vehicleInventoryLoaded", inventory = inv, locked = (isLocked or nil)})
            end
        end
    end
end)

RegisterServerEvent("vehicle:getInventory")
AddEventHandler("vehicle:getInventory", function(target_plate_number)
  local userSource = tonumber(source)
  GetVehicleInventory(target_plate_number, function(inv)
      TriggerClientEvent("vehicle:loadedInventory", userSource, inv)
  end)
end)

-- store an item in a vehicle
-- note: assumes that the quantity provided is <= item.quantiy
RegisterServerEvent("vehicle:storeItem")
AddEventHandler("vehicle:storeItem", function(src, vehicle_plate, item, quantity, slot, cb) -- TODO: get item instead of passing as param to avoid lua injecting items
    quantity = math.floor(quantity)
    local usource = tonumber(src)
    GetVehicleInventory(vehicle_plate, function(inv)
        if quantity <= 0 then
            cb(false, inv)
            return
        end
        item.quantity = quantity
        if VehInventoryManager.canHoldItem(inv, item) then
            VehInventoryManager.putItemInSlot(vehicle_plate, inv, item, slot, function(success, msg)
                if success == true then
                    if item.type == "weapon" then
                        TriggerClientEvent("interaction:equipWeapon", usource, item, false) -- remove weapon
                    end
                    if item.name:find("Radio") then
                        TriggerClientEvent("Radio.Set", usource, false, {})
                    end
                    TriggerClientEvent("usa:playAnimation", usource, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 3)
                end
                if msg then
                    TriggerClientEvent("usa:notify", usource, msg)
                end
                cb(success, inv)
            end)
        else
            TriggerClientEvent("usa:notify", usource, "Vehicle inventory full!")
            cb(false, inv)
        end
    end)
end)

RegisterServerEvent("vehicle:moveItemToPlayerInv")
AddEventHandler("vehicle:moveItemToPlayerInv", function(src, plate, fromSlot, toSlot, quantity, char, cb)
    quantity = math.floor(quantity)
    local usource = tonumber(src)
    GetVehicleInventory(plate, function(inv)
        local item = inv.items[tostring(fromSlot)]
        -- validate item move --
        if item and quantity > item.quantity or quantity <= 0 then
            exports["usa_vehinv"]:removeVehicleBusy(plate)
            return
        end
        if item and item.type and item.type == "license" then
            TriggerClientEvent("usa:notify", src, "Can't move licenses!")
            -- todo: send msg to NUI to give some UI feedback for failed move
            exports["usa_vehinv"]:removeVehicleBusy(plate)
            return
        end
        -- move item --
        if item then
            if char.canHoldItem(item, quantity) then
                char.putItemInSlot(item, toSlot, quantity, function(success)
                    if success == true then
                        if item.type == "weapon" then
                            TriggerClientEvent("interaction:equipWeapon", usource, item, true)
                        end
                        TriggerClientEvent("usa:playAnimation", usource, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 3)
                        VehInventoryManager.removeItemInSlot(plate, inv, fromSlot, quantity)
                        cb(inv)
                    else
                        exports["usa_vehinv"]:removeVehicleBusy(plate)
                    end
                end)
            else
                TriggerClientEvent("usa:notify", usource, "Inventory full!")
                exports["usa_vehinv"]:removeVehicleBusy(plate)
            end
        end
    end)
end)

RegisterServerEvent("vehicle:moveInventorySlots")
AddEventHandler("vehicle:moveInventorySlots", function(plate, fromSlot, toSlot, cb)
    GetVehicleInventory(plate, function(inv)
        VehInventoryManager.moveItemSlots(plate, inv, fromSlot, toSlot)
        cb(inv)
    end)
end)

RegisterServerEvent("vehicle:removeAllIllegalItems")
AddEventHandler("vehicle:removeAllIllegalItems", function(plate)
  local usource = tonumber(source)
  local charJob = exports["usa-characters"]:GetCharacterField(usource, "job")
  if charJob == "sheriff" or charJob == "corrections" then
    GetVehicleInventory(plate, function(inv)
        VehInventoryManager.removeAllIllegalItems(usource, plate, inv, true)
    end)
  else
    DropPlayer(usource, "Exploiting. If you feel this was wrongfully done, please contact staff.")
  end
end)

function GetVehicleInventory(plate, cb)
    -- query for the information needed from each vehicle --
    local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehicleInventoryByPlate"
    local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
    PerformHttpRequest(url, function(err, responseText, headers)
        if responseText then
            local inventory = nil
            local data = json.decode(responseText)
            if data and data.rows and data.rows[1] and data.rows[1].value then
                inventory = data.rows[1].value[1] -- inventory
            else
                local tempVehInv = VehInventoryManager:getTempVehInv(plate)
                if tempVehInv  then
                    inventory = tempVehInv
                elseif not inventory and not tempVehInv then
                    inventory = VehInventoryManager:newTempVehInv(plate)
                end
            end
            cb(inventory)
        end
    end, "POST", json.encode({
        keys = { plate }
        --keys = { "86CSH075" }
    }), { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end

function GetVehicleInventoryAndCapacity(plate, cb)
    -- query for the information needed from each vehicle --
    local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehicleInventoryAndCapacityByPlate"
    local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
    PerformHttpRequest(url, function(err, responseText, headers)
        if responseText then
            local inventory = nil
            local capacity = 0.0
            local data = json.decode(responseText)
            if data.rows[1] and data.rows[1].value[1] then
                inventory = data.rows[1].value[1] -- inventory
                capacity = data.rows[1].value[2] -- capacity
            else -- check for non player owned "temporary" vehicles
                local tempVehInv = VehInventoryManager:getTempVehInv(plate)
                if tempVehInv  then
                    inventory = tempVehInv
                elseif not inventory and not tempVehInv then
                    inventory = VehInventoryManager:newTempVehInv(plate)
                end
                capacity = inventory.MAX_CAPACITY
            end
            cb(inventory, capacity)
        end
    end, "POST", json.encode({
        keys = { plate }
        --keys = { "86CSH075" }
    }), { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end

function IsPlayerActive(id)
  return GetPlayerName(id)
end

function NewInventory(capacity)
    return VehInventoryManager:NewInventory(capacity)
end
