local vehicles_being_checked = {}

RegisterNetEvent("vehicle:finishedUsingInventory")
AddEventHandler("vehicle:finishedUsingInventory", function(plate)
  vehicles_being_checked[plate] = nil
end)

RegisterServerEvent("vehicle:getInventory")
AddEventHandler("vehicle:getInventory", function(target_plate_number)
  local userSource = tonumber(source)
  GetVehicleInventory(target_plate_number, function(inv)
      TriggerClientEvent("vehicle:loadedInventory", userSource, inv)
  end)
end) -- TO TEST

-- store an item in a vehicle
-- note: assumes that the quantity provided is <= item.quantiy
RegisterServerEvent("vehicle:storeItem")
AddEventHandler("vehicle:storeItem", function(vehicle_plate, item, quantity)
  local userSource = tonumber(source)
  GetVehicleInventory(vehicle_plate, function(inv)
      -- for storing weapons --
      if item.type ~= "weapon" then
        for j = 1, #inv do
          local vehicle_inventory_item = inv[j]
          if vehicle_inventory_item.name == item.name then
            inv[j].quantity = inv[j].quantity + quantity
            -- update vehicle storage --
            TriggerEvent('es:exposeDBFunctions', function(couchdb)
    			couchdb.updateDocument("vehicles", vehicle_plate, { inventory = inv }, function()
    				--print("DEBUG: finished updating DB in vehicle:storeItem")
    			end)
    		end)
            return
          end
        end
      end
      -- weapon type items --
      item.quantity = quantity -- set quantity to the one provided as user input, assumes quantity provided is <= to item.quantity
      table.insert(inv, item)
      -- not already in inventory, add it:
     -- print("adding item to vehicle: " .. item.name .. ", quantity: " .. quantity)
      -- update vehicle storage --
      TriggerEvent('es:exposeDBFunctions', function(couchdb)
          couchdb.updateDocument("vehicles", vehicle_plate, { inventory = inv }, function()
              --print("DEBUG: finished updating DB in vehicle:storeItem")
          end)
      end)
  end)
end) -- TEST

RegisterServerEvent("vehicle:seizeContraband")
AddEventHandler("vehicle:seizeContraband", function(target_vehicle_plate)
    local userSource = tonumber(source)
    GetVehicleInventory(target_vehicle_plate, function(inv)
        -- remove illegal items --
        for j = #inv, 1, -1 do
          if inv[j].legality then
            if inv[j].legality == "illegal" then
              TriggerClientEvent("usa:notify", userSource, "~y~Seized:~w~ " .. "(x" .. inv[j].quantity .. ") " .. inv[j].name)
              TriggerClientEvent("chatMessage", "", userSource, {}, "^3Seized:^0 " .. "(x" .. inv[j].quantity .. ") " .. inv[j].name)
              table.remove(inv, j)
            end
          end
        end
        -- update vehicle storage --
        TriggerEvent('es:exposeDBFunctions', function(couchdb)
            couchdb.updateDocument("vehicles", target_vehicle_plate, { inventory = inv }, function()
                --print("DEBUG: finished updating DB in vehicle:storeItem")
            end)
        end)
    end)
end) -- TEST

RegisterServerEvent("vehicle:removeItem")
AddEventHandler("vehicle:removeItem", function(whole_item, quantity, target_vehicle_plate)
    local userSource = tonumber(source)
    GetVehicleInventory(target_vehicle_plate, function(inv)
        for j = 1, #inv do
            local vehicle_inventory_item = inv[j]
            if (vehicle_inventory_item.name == whole_item.name and whole_item.type ~= "weapon") or (whole_item.type == "weapon" and vehicle_inventory_item.type == "weapon" and vehicle_inventory_item.uuid == whole_item.uuid and whole_item.name == vehicle_inventory_item.name) then
                if inv[j].quantity - quantity <= 0 then
                    table.remove(inv, j)
                else
                    inv[j].quantity = inv[j].quantity - quantity
                end
                -- update vehicle in DB --
                TriggerEvent('es:exposeDBFunctions', function(couchdb)
                    couchdb.updateDocument("vehicles", target_vehicle_plate, { inventory = inv }, function()
                        --print("DEBUG: finished updating DB in vehicle:removeItem")
                    end)
                end)
                return
            else
                print("*** Error: item not found!! ***")
            end
        end
    end)
end) -- TEST

-- when retrieving a weapon from a vehicle, first check if player has room for it
RegisterServerEvent("vehicle:checkPlayerWeaponAmount")
AddEventHandler("vehicle:checkPlayerWeaponAmount", function(item, vehicle_plate)
    local userSource = tonumber(source)
    if not vehicles_being_checked[vehicle_plate] then
        vehicles_being_checked[vehicle_plate] = true
        local user = exports["essentialmode"]:getPlayerFromId(userSource)
        local user_weapons = user.getActiveCharacterData("weapons")
        if #user_weapons < 3 then
            GetVehicleInventory(vehicle_plate, function(inv)
                for j = 1, #inv do
                    local vehicle_inventory_item = inv[j]
                    if vehicle_inventory_item.name == item.name then
                        TriggerClientEvent("vehicle:retrieveWeapon", userSource, item, vehicle_plate)
                        return
                    end
                end
                -- not in vehicle at all:
                TriggerClientEvent("usa:notify", userSource, "Item not in vehicle!")
            end)
        else
            TriggerClientEvent("usa:notify", userSource, "Can't carry more than 3 weapons!")
        end
    else
        print("****discontinuing weapon retreival****")
        TriggerClientEvent("usa:notify", userSource, "Please wait a moment.")
    end
end) -- TEST

RegisterServerEvent("vehicle:isItemStillInVehicle")
AddEventHandler("vehicle:isItemStillInVehicle", function(plate, item, quantity)
    local userSource = tonumber(source)
    if not vehicles_being_checked[plate] then
        vehicles_being_checked[plate] = true
        local user = exports["essentialmode"]:getPlayerFromId(userSource)
        if not item.weight then item.weight = 2 end
        local temp_item = { weight = item.weight, quantity = quantity}
        if user.getCanActiveCharacterHoldItem(temp_item) then
            GetVehicleInventory(plate, function(inv)
                for j = 1, #inv do
                    local vehicle_inventory_item = inv[j]
                    if vehicle_inventory_item.name == item.name then
                        if vehicle_inventory_item.quantity >= quantity then
                            -- item was still in vehicle to retrieve and had enough quantity --
                            TriggerClientEvent("vehicle:continueRetrievingItem", userSource, plate, item, quantity)
                            return
                        else
                            TriggerClientEvent("usa:notify", userSource, "Quantity input too high!")
                            return
                        end
                    end
                end
                -- not in vehicle at all:
                TriggerClientEvent("usa:notify", userSource, "Item not in vehicle!")
            end)
        else
            vehicles_being_checked[plate] = nil
            TriggerClientEvent("usa:notify", userSource, "Inventory is full.")
        end
    else
        print("****discontinuing inventory item retrieval****")
        TriggerClientEvent("usa:notify", userSource, "Please wait a moment.")
        -- experimental:
        vehicles_being_checked[plate] = nil
    end
end) -- TEST

RegisterServerEvent("vehicle:canVehicleHoldItem")
AddEventHandler("vehicle:canVehicleHoldItem", function(vehId, plate, item, quantity)
    print("checking to see if vehicle has enough room for item: " .. item.name .. ", quantity: " .. quantity)
    local userSource = tonumber(source)
    local current_weight = 0.0
    GetVehicleInventoryAndCapacity(plate, function(inv, capacity)
        for j = 1, #inv do
            local vehicle_inventory_item = inv[j]
            if not vehicle_inventory_item.weight then
                vehicle_inventory_item.weight = 2.0
            end
            current_weight = current_weight + (vehicle_inventory_item.weight * vehicle_inventory_item.quantity) -- add item weight to total
        end
        -- add check for old vehicles that didn't have storage capacity property when purchased:
        if not capacity then
            -- veh.storage_capacity did not exist! set to to 100.0 --
            capacity = 100.0
        end
        -- add check for items with no weight property:
        if not item.weight then item.weight = 1 end
        -- total weight calculated, call appropriate client function
        if current_weight + (item.weight * quantity) <= capacity then
            -- not full, able to store item
            TriggerClientEvent("vehicle:continueStoringItem", userSource, vehId, plate, item, quantity)
            TriggerClientEvent("usa:notify", userSource, "Item stored! (" .. current_weight + (item.weight * quantity) .. "/" .. capacity .. ")")
        else
            -- vehicle storage full
            TriggerClientEvent("usa:notify", userSource, "Vehicle storage full! (" .. current_weight .. "/" .. capacity .. ")")
        end
        return
    end)
end) -- TEST

function GetVehicleInventory(plate, cb)
	-- query for the information needed from each vehicle --
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehicleInventoryByPlate"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
      local inventory = {}
			--print("veh inventory: " .. responseText)
			local data = json.decode(responseText)
      if data.rows and data.rows[1].value then
			     inventory = data.rows[1].value[1] -- inventory
      end
			cb(inventory)
		end
	end, "POST", json.encode({
		keys = { plate }
		--keys = { "86CSH075" }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end

function GetVehicleInventoryAndCapacity(plate, cb)
	-- query for the information needed from each vehicle --
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehicleInventoryAndCapacityByPlate"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
      local inventory = {}
      local capacity = 0.0
			--print("veh inventory: " .. responseText)
			local data = json.decode(responseText)
      if data.rows[1] then
  			inventory = data.rows[1].value[1] -- inventory
        capacity = data.rows[1].value[2] -- capacity
      end
			cb(inventory, capacity)
		end
	end, "POST", json.encode({
		keys = { plate }
		--keys = { "86CSH075" }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end
