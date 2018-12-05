--# Residential / Business Properties
--# own, store stuff, be a bawse
--# by: minipunch
--# made for: USA REALISM RP

local PROPERTIES = {} -- loaded and updated by database
local PROPERTIES_FOR_CLIENT = nil

local BUSINESS_PAY_PERIOD_DAYS = 7
local HOUSE_PAY_PERIOD_DAYS = 30
local MAX_NUM_OF_PROPERTIES_SINGLE_PERSON = 7

RegisterServerEvent("properties:getPropertyIdentifier")
AddEventHandler("properties:getPropertyIdentifier", function()
    local steam_hex = GetPlayerIdentifiers(source)[1]
    print("setting property identifier with hex: " .. steam_hex)
    TriggerClientEvent("properties:setPropertyIdentifier", source, steam_hex)
end)

RegisterServerEvent("properties:getProperties")
AddEventHandler("properties:getProperties", function()
    if PROPERTIES_FOR_CLIENT then
        TriggerClientEvent("properties:updateAll", source, PROPERTIES_FOR_CLIENT, false)
        print(" ** Properties loaded for client! ** ")
    else
        print("** Error loading properties, PROPERTIES_FOR_CLIENT was nil! **")
    end
end)

RegisterServerEvent("properties:getPropertyMoney")
AddEventHandler("properties:getPropertyMoney", function(name, cb)
    cb(PROPERTIES[name].storage.money)
end)

-- TODO: see if hittch frame warnings stop after a little
RegisterServerEvent("properties:checkSpawnPoint")
AddEventHandler("properties:checkSpawnPoint", function(usource)
	local player = exports["essentialmode"]:getPlayerFromId(usource)
	local spawn = player.getActiveCharacterData("spawn")
	if type(spawn) ~= "nil" then
		print("spawn existed! checking if spawn is still valid after evictions!")
    -- faster look up --
    if spawn.name then
      if PROPERTIES[spawn.name] then
        if PROPERTIES[spawn.name].owner.identifier == GetPlayerIdentifiers(usource)[1] then
          print("Still owns property, leaving spawn!")
        else
          print("does not own property anymore, resetting spawn!")
          player.setActiveCharacterData("spawn", nil)
        end
      end
    else
      -- for backwards compatability (with spawns that have no .name property set yet) --
  		for name, info in pairs(PROPERTIES) do
  			if info.x == spawn.x and info.y == spawn.y and info.z == spawn.z then
  				print("property still valid after eviction!")
  				if info.owner.identifier == GetPlayerIdentifiers(usource)[1] then
  					print("Still owns property, leaving spawn!")
            spawn.name = name
            player.setActiveCharacterData("spawn", spawn)
  				else
  					print("does not own property anymore, resetting spawn!")
  					player.setActiveCharacterData("spawn", nil)
  				end
  				return
  			end
  		end
      -- not valid at this point, remove
      print("removing set spawn!")
      player.setActiveCharacterData("spawn", nil)
    end
	end
end)

----------------------
-- WARDROBE --
----------------------
RegisterServerEvent("properties:deleteOutfitByName")
AddEventHandler("properties:deleteOutfitByName", function(property_name, outfit_name)
    ----------------------------------------
    -- remove outfit from property --
    ----------------------------------------
    local wardrobe = PROPERTIES[property_name].wardrobe
    if  not wardrobe then
        wardrobe = {}
    end
    -- search for matching outfit to delete --
    for i = 1, #wardrobe do
        if wardrobe[i].name == outfit_name then
            --print("matching outfit found to delete!")
            -- remove --
            table.remove(PROPERTIES[property_name].wardrobe, i)
            -- update menu --
            TriggerClientEvent("properties:loadWardrobe", source, PROPERTIES[property_name].wardrobe)
            -- save property --
            SavePropertyData(property_name)
            return
        end
    end
end)

RegisterServerEvent("properties:saveOutfit")
AddEventHandler("properties:saveOutfit", function(property_name, outfit)
    -- add outfit to property --
    if  not PROPERTIES[property_name].wardrobe then
        PROPERTIES[property_name].wardrobe = {}
    end
    table.insert(PROPERTIES[property_name].wardrobe, outfit)
    -- update menu --
    TriggerClientEvent("properties:loadWardrobe", source, PROPERTIES[property_name].wardrobe)
  -- save property --
  SavePropertyData(property_name)
end)

RegisterServerEvent("properties:getWardrobe")
AddEventHandler("properties:getWardrobe", function(property_name)
    TriggerClientEvent("properties:loadWardrobe", source, PROPERTIES[property_name].wardrobe)
end)

----------------------------
-- ITEM STORAGE --
----------------------------
-- load stored items --
RegisterServerEvent("properties:loadStorage")
AddEventHandler("properties:loadStorage", function(name)
	TriggerClientEvent("properties:loadedStorage", source, PROPERTIES[name].storage.items)
end)

-- get items to store --
RegisterServerEvent("properties:getUserItemsToStore")
AddEventHandler("properties:getUserItemsToStore", function(user_source)
	local userSource = source
	if user_source then userSource = user_source end
    local player = exports["essentialmode"]:getPlayerFromId(userSource)
	if player then
		local items = {}
		local inventory = player.getActiveCharacterData("inventory")
		local weapons = player.getActiveCharacterData("weapons")
		for i = 1, #inventory do table.insert(items, inventory[i]) end
		for i = 1, #weapons do table.insert(items, weapons[i]) end
		print("sending #" .. #items .. " items to client for storage menu")
		TriggerClientEvent("properties:setItemsToStore", userSource, items)
	end
end)

-- store cash in property --
RegisterServerEvent("properties:storeMoney")
AddEventHandler("properties:storeMoney", function(name, amount)
	local user_source = source
	local player = exports["essentialmode"]:getPlayerFromId(user_source)
	local user_money = player.getActiveCharacterData("money")
	if user_money - amount >= 0 then
		-- remove from player --
		player.setActiveCharacterData("money", user_money - amount)
		-- add to property --
		TriggerEvent("properties:addMoney", name, amount)
	else
		TriggerClientEvent("usa:notify", user_source, "You don't have that much money on you!")
	end
end)

-- try to store item --
RegisterServerEvent("properties:store")
AddEventHandler("properties:store", function(name, item, quantity)
	--print("inside properties:store!")
	local user_source = source
	--print("recevied item [" .. item.name .. "] to store at property with quantity [" .. item.quantity .. "]")
	local saved_quantity = item.quantity
		-- remove from player --
	--print("sending into usa:remove item [" .. item.name .. "] item.quantity = " .. item.quantity .. ", quantity to remove = " .. quantity)
	TriggerEvent("usa:removeItem", item, quantity, user_source)
	local copy = item
	copy.quantity = quantity
	local had_already = false
	--print("storing item at property: " .. name)
	-- insert into property --
	for i = 1, #PROPERTIES[name].storage.items do
		if PROPERTIES[name].storage.items[i].name == item.name then
			--print("had_already was true!")
			--print("previous quantity: " .. PROPERTIES[name].storage.items[i].quantity)
			--print("quantity to add: " .. quantity)
      if PROPERTIES[name].storage.items[i].type ~= "weapon" then
  			had_already	= true
  			PROPERTIES[name].storage.items[i].quantity = PROPERTIES[name].storage.items[i].quantity + quantity
      end
      break
		end
	end
	if not had_already then
		--print("had_already was false!")
		--print("quantity param: " .. quantity)
		--print("item.quantity from inventory was: " .. saved_quantity)
		--print("item.quantity to store is now after setting: " .. copy.quantity)
		table.insert(PROPERTIES[name].storage.items, copy)
    print("inserted item into house storage: " .. copy.name .. ", type: " .. copy.type .. ", customizations: " .. type(copy.components))
		--print("added item! property now has:")
		--for k = 1, #PROPERTIES[name].storage.items do
			--print("name: " .. PROPERTIES[name].storage.items[k].name .. ", quantity: " .. PROPERTIES[name].storage.items[k].quantity)
		--end
	end
  -- save property --
  SavePropertyData(name)
end)

-- load stored money --
RegisterServerEvent("properties:loadMoneyForMenu")
AddEventHandler("properties:loadMoneyForMenu", function(name)
	TriggerClientEvent("properties:loadMoneyForMenu", source, PROPERTIES[name].storage.money)
end)

-- load stored vehicles --
RegisterServerEvent("properties:loadVehiclesForMenu")
AddEventHandler("properties:loadVehiclesForMenu", function(name)
	TriggerClientEvent("properties:loadVehiclesForMenu", source, PROPERTIES[name].vehicles)
end)

-- store vehicle at property --
RegisterServerEvent("properties:storeVehicle")
AddEventHandler("properties:storeVehicle", function(property_name, plate)
  local userSource = tonumber(source)
	--TriggerEvent('es:getPlayerFromId', userSource, function(user)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local userVehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #userVehicles do
			local vehicle = userVehicles[i]
			if plate and vehicle then
				if string.match(plate,tostring(vehicle.plate)) or plate == vehicle.plate then -- player actually owns car that is being stored
					userVehicles[i].stored_location = property_name
					user.setActiveCharacterData("vehicles", userVehicles)
          table.insert(PROPERTIES[property_name].vehicles, userVehicles[i])
					TriggerClientEvent("properties:storeVehicle", userSource)
          -- save property --
          SavePropertyData(property_name)
					return
				end
			end
		end
		TriggerClientEvent("garage:notify", userSource, "~r~You do not own that vehicle!")
	--end)
end)

-- retrieve vehicle from property --
RegisterServerEvent("properties:retrieveVehicle")
AddEventHandler("properties:retrieveVehicle", function(property_name, vehicle)
  print("retrieving vehicle with name: " .. vehicle.make .. " " .. vehicle.model)
  print("from: " .. property_name)
  local userSource = source
  local vehs = PROPERTIES[property_name].vehicles
  -- does property have the vehicle? --
  for i = 1, #vehs do
    -- match by plate --
    if vehs[i].plate == vehicle.plate then
      table.remove(PROPERTIES[property_name].vehicles, i)
      -- retrieve vehicle from property --
      TriggerClientEvent("properties:retrieveVehicle", source, vehicle)
      -- save property --
      SavePropertyData(property_name)
      -- update player vehicle stored location variable --
      local player = exports["essentialmode"]:getPlayerFromId(userSource)
      local player_vehicles = player.getActiveCharacterData("vehicles")
      for j = 1, #player_vehicles do
        if player_vehicles[j].plate == vehicle.plate then
          player_vehicles[j].stored_location = nil
          player.setActiveCharacterData("vehicles", player_vehicles)
          return
        end
      end
      return
    end
  end
end)

-- try to retrieve item (assumed to already be in the property) --
RegisterServerEvent("properties:retrieve")
AddEventHandler("properties:retrieve", function(name, item, quantity)
  --[[
	print("inside properties:retrieve!")
  print("property name: " .. name)
  print("item name: " .. item.name)
  print("retrieve quantity: " .. quantity)
  --]]
	local user_source = source
	local player = exports["essentialmode"]:getPlayerFromId(user_source)
	if player then
		item.quantity = quantity
		if player.getCanActiveCharacterHoldItem(item) then
			--print("player can hold [" .. item.name .. "] with quantity: " .. item.quantity .. " - " .. quantity .. "!")
			-- remove from property --
      --print("looking for item in storage to retrieve!")
			local prop_storage = PROPERTIES[name].storage.items
			for i = 1, #prop_storage do
				--print("checking item in property storage: " .. prop_storage[i].name .. " against " .. item.name)
        --print("item.uuid: " .. type(item.uuid))
        --print("prop_storage[i].uuid: " .. type(prop_storage[i].uuid))
				if (prop_storage[i].name == item.name and item.type ~= "weapon") or (item.type == "weapon" and prop_storage[i].type == "weapon" and item.uuid == prop_storage[i].uuid and prop_storage[i].name == item.name) then
          print("found matching item! on line 263! name: " .. prop_storage[i].name)
					--print("wants: " .. quantity .. ", has: " .. prop_storage[i].quantity)
          print("prop_storage[i].quantity - quantity: " .. prop_storage[i].quantity - quantity)
					if prop_storage[i].quantity - quantity < 0 then
						--print("tried to retrieve too much of item! wanted: " .. quantity .. ", had: " .. prop_storage[i].quantity)
						TriggerClientEvent("usa:notify", user_source, "You don't have that much of that item in storage!")
						return
					else
						if prop_storage[i].quantity - quantity == 0 then
							print("property item removed!")
							table.remove(PROPERTIES[name].storage.items, i)
						else
							--print("previous quantity: " .. PROPERTIES[name].storage.items[i].quantity)
							--print("quantity to decrement by: " .. quantity)
              print("decrementing item quantity!")
							PROPERTIES[name].storage.items[i].quantity = PROPERTIES[name].storage.items[i].quantity - quantity
						end
            print("breaking!")
						break
					end
				else
          --print("did not found weapon on first check, looking for weapons without uuids...")
          if (item.type == "weapon" and PROPERTIES[name].storage.items[i].type == "weapon") and (not item.uuid and not PROPERTIES[name].storage.items[i].uuid) and (item.name == PROPERTIES[name].storage.items[i].name) then
          --if item.type == "weapon" and not item.uuid then
          --print("removing: " .. PROPERTIES[name].storage.items[i].name .. ", quantity: " .. PROPERTIES[name].storage.items[i].quantity)
            table.remove(PROPERTIES[name].storage.items, i)
            --print("removed weapon with no UUID!")
            break
          end
        end
			end
			-- insert into player inventory --
			TriggerEvent("usa:insertItem", item, quantity, user_source)
      --print("inserted item into player inventory from property: " .. item.name .. ", type: " .. item.type .. ", customizations: " .. type(item.components))
			-- update properties for all --
			--print("updating properties!")
			-- refresh menu property items --
			--print("setting client's property storage items to:")
			--for k = 1, #PROPERTIES[name].storage.items do
				--print("item: " .. PROPERTIES[name].storage.items[k].name .. ", quantity: " .. PROPERTIES[name].storage.items[k].quantity)
			--end
			TriggerClientEvent("properties:loadedStorage", user_source, PROPERTIES[name].storage.items)
      -- save property --
      SavePropertyData(name)
		else
			TriggerClientEvent("usa:notify", user_source, "Inventory full.")
		end
	end
end)

-----------------------------
-- LOAD PROPERTIES FROM DB --
-----------------------------
function loadProperties()
	print("fetching all properties...")
	PerformHttpRequest("http://127.0.0.1:5984/properties/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		print("finished getting properties...")
		print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			PROPERTIES = {} -- reset table
            PROPERTIES_FOR_CLIENT = {} -- set as table from nil
			print("#(response.rows) = " .. #(response.rows))
			-- insert all properties from 'properties' db into lua table
			for i = 1, #(response.rows) do
				--table.insert(PROPERTIES, response.rows[i].doc)
				if response.rows[i] then
					--if response.rows[i].doc.doc then response.rows[i].doc = response.rows[i].doc.doc end
					if response.rows[i].doc.name then
						PROPERTIES[response.rows[i].doc.name] = response.rows[i].doc
                        PROPERTIES_FOR_CLIENT[response.rows[i].doc.name] = { -- only give client needed information for each property for performance reasons
                            name = response.rows[i].doc.name,
                            storage = {
                                money = response.rows[i].doc.storage.money
                            },
                            fee = response.rows[i].doc.fee,
                            x = response.rows[i].doc.x,
                            y = response.rows[i].doc.y,
                            z = response.rows[i].doc.z,
                            garage_coords = response.rows[i].doc.garage_coords,
                            owner = response.rows[i].doc.owner,
                            type = response.rows[i].doc.type,
                            coowners = response.rows[i].doc.coowners
                        }
						print("loaded property: " .. response.rows[i].doc.name)
                    else
						print("Error loading property document at index #" .. i)
					end
				else
					print("Error loading property at index #" .. i)
				end
			end
			print("finished loading properties...")
			--print("# of properties: " .. #PROPERTIES)
			print("checking for owners to evict...")
			Evict_Owners()
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end

-- PERFORM FIRST TIME DB CHECK --
exports["globals"]:PerformDBCheck("usa-properties", "properties", loadProperties)

--------------------------------
-- ADD MONEY (from purchases) --
--------------------------------
RegisterServerEvent("properties:addMoney")
AddEventHandler("properties:addMoney", function(name, amount)
    PROPERTIES[name].storage.money = PROPERTIES[name].storage.money + amount
    print("$" .. amount .. " added!")
    -- save property --
    SavePropertyData(name)
end)

------------------
-- REMOVE MONEY --
------------------
RegisterServerEvent("properties:withdraw")
AddEventHandler("properties:withdraw", function(name, amount, savedSource, give_money_to_player)
  if PROPERTIES[name].storage.money - amount >= 0 then
    -- remove from store --
    PROPERTIES[name].storage.money = PROPERTIES[name].storage.money - amount
    -- see if called from server file --
    if savedSource then source = savedSource end
    -- only take money if asked to --
    if give_money_to_player then
      -- add to player --
      local player = exports["essentialmode"]:getPlayerFromId(tonumber(source))
      if player then
        local user_money = player.getActiveCharacterData("money")
        player.setActiveCharacterData("money", user_money + amount)
        TriggerClientEvent("usa:notify", source, "~y~Withdrawn: ~w~$" .. amount)
        print("$" .. amount .. " withdrawn!")
      else
        print("failed to retrieve player in properties:withdraw!")
      end
    end
    -- save property --
    SavePropertyData(name)
  else
    TriggerClientEvent("usa:notify", source, "Don't have that much to withdraw!")
  end
end)

-----------------------
-- PURCHASE PROPERTY --
-----------------------
RegisterServerEvent("properties:purchaseProperty")
AddEventHandler("properties:purchaseProperty", function(property)
	local user_source = source
	local ident = GetPlayerIdentifiers(user_source)[1]

	if GetNumberOfOwnedProperties(ident) < MAX_NUM_OF_PROPERTIES_SINGLE_PERSON then

		if not property.type then property.type = "business" print("set property type to business") end
		--if property.type == "business" then ownership_length = BUSINESS_PAY_PERIOD_DAYS
		--elseif property.type == "house" then ownership_length = HOUSE_PAY_PERIOD_DAYS end

		local final_time = nil
		local today = os.date("*t", os.time())

		print("player #" .. user_source .. " wants to purchase " .. property.name)
		local player = exports["essentialmode"]:getPlayerFromId(user_source)
		local user_money = player.getActiveCharacterData("money")
		local char_name = player.getActiveCharacterData("fullName")

		--if user_money >= property.fee.price then
    if user_money >= PROPERTIES[property.name].fee.price then
			-- set new property info --
			PROPERTIES[property.name].fee.paid_time = os.time() -- save the time the property was purchased
			PROPERTIES[property.name].fee.paid = true
			if property.type == "business" then
				PROPERTIES[property.name].fee.due_days = BUSINESS_PAY_PERIOD_DAYS
				final_time = {day = today.day + BUSINESS_PAY_PERIOD_DAYS, month = today.month, year = today.year}
			elseif property.type == "house" then
				PROPERTIES[property.name].fee.due_days = HOUSE_PAY_PERIOD_DAYS
				final_time = {day = today.day, month = today.month + 1, year = today.year}
			end
			local endtime = os.time(final_time)
			PROPERTIES[property.name].fee.due_time = endtime
			PROPERTIES[property.name].fee.end_date = os.date("%x", endtime)
			PROPERTIES[property.name].owner.name = char_name
			PROPERTIES[property.name].owner.purchase_date = os.date("%x", os.time())
			PROPERTIES[property.name].owner.identifier = ident
			-- update all clients property info --
            local PROPERTY_FOR_CLIENT = { -- only give client needed information for each property for performance reasons
                name = property.name,
                storage = {
                    money = PROPERTIES[property.name].storage.money
                },
                fee = PROPERTIES[property.name].fee,
                x = PROPERTIES[property.name].x,
                y = PROPERTIES[property.name].y,
                z = PROPERTIES[property.name].z,
                garage_coords = PROPERTIES[property.name].garage_coords,
                owner = PROPERTIES[property.name].owner,
                type = PROPERTIES[property.name].type
            }
			TriggerClientEvent("properties:update", -1, PROPERTY_FOR_CLIENT, true)
			-- subtract money --
			player.setActiveCharacterData("money", user_money - PROPERTIES[property.name].fee.price)
      -- save property --
      SavePropertyData(property.name)
			-- send discord msg to #property-logs --
			local desc = "\n**Property:** " .. property.name .. "\n**Purchase Price:** $" .. comma_value(PROPERTIES[property.name].fee.price) ..  "\n**Purchased By:** " .. char_name .. "\n**Purchase Date:** ".. PROPERTIES[property.name].owner.purchase_date .. "\n**End Date:** " .. PROPERTIES[property.name].fee.end_date
			local url = 'https://discordapp.com/api/webhooks/419573361170055169/6v2NLnxzF8lSHgT8pSDccB_XN1R6miVuZDrEYtvNfPny6kSqddSN_9iJ9PPkbAbM01pW'
			PerformHttpRequest(url, function(err, text, headers)
				if text then
					print(text)
				end
			end, "POST", json.encode({
				embeds = {
					{
						description = desc,
						color = 524288,
						author = {
							name = "SAN ANDREAS PROPERTY MGMT"
						}
					}
				}
			}), { ["Content-Type"] = 'application/json' })
		else
			TriggerClientEvent("usa:notify", user_source, "You don't have enough money to purchase this property!")
		end
	else
		TriggerClientEvent("usa:notify", user_source, "You have reached your max number of properties!")
	end
end)

----------------------------
-- GET PROPERTY CO-OWNERS --
----------------------------
RegisterServerEvent("properties:getCoOwners")
AddEventHandler("properties:getCoOwners", function(property_name)
  -- check if property has any co owners already --
  if not PROPERTIES[property_name].coowners then
    PROPERTIES[property_name].coowners = {}
  end
  -- return to client --
  TriggerClientEvent("properties:getCoOwners", source, PROPERTIES[property_name].coowners)
end)

---------------------------
-- ADD PROPERTY CO-OWNER --
---------------------------
RegisterServerEvent("properties:addCoOwner")
AddEventHandler("properties:addCoOwner", function(property_name, id)
  if GetPlayerName(id) then
    -- check if property has any co owners already --
    if not PROPERTIES[property_name].coowners then
      PROPERTIES[property_name].coowners = {}
    end
    -- create person --
    local person = exports["essentialmode"]:getPlayerFromId(id)
    local coowner = {
      name = person.getActiveCharacterData("fullName"),
      identifier = GetPlayerIdentifiers(id)[1]
    }
    -- add person to list of co owners --
    table.insert(PROPERTIES[property_name].coowners, coowner)
    -- save --
    SavePropertyData(property_name)
    -- update all clients --
    TriggerClientEvent("properties:update", -1, PROPERTIES[property_name])
    -- notify --
    TriggerClientEvent("usa:notify", source, coowner.name .. " has been successfully added!")
  else
    TriggerClientEvent("usa:notify", source, "Person does not exist!")
  end
end)

------------------------------
-- REMOVE PROPERTY CO-OWNER --
------------------------------
RegisterServerEvent("properties:removeCoOwner")
AddEventHandler("properties:removeCoOwner", function(property_name, index)
  -- check if property has any co owners already --
  if not PROPERTIES[property_name].coowners then
    PROPERTIES[property_name] = {}
  end
  -- remove at index --
  if PROPERTIES[property_name].coowners[index] then
    table.remove(PROPERTIES[property_name].coowners, index)
    -- save --
    SavePropertyData(property_name)
    -- update all clients --
    TriggerClientEvent("properties:update", -1, PROPERTIES[property_name])
    -- notify --
    TriggerClientEvent("usa:notify", source, "Co-owner removed!")
  end
end)

function GetWholeDaysFromTime(reference_time)
	local timestamp = os.date("*t", os.time())
	local daysfrom = os.difftime(os.time(), reference_time) / (24 * 60 * 60) -- seconds in a day
	local wholedays = math.floor(daysfrom)
	print("property owned whole days: " .. wholedays) -- today it prints "1"
	return wholedays
end

function Evict_Owners()
    ---------------------------------------
    -- Evict owners whose leases expired --
    ---------------------------------------
    for name, info in pairs(PROPERTIES) do
        -- below if statement only temporarily here to adjust any old DB documents that didn't get the type attribute --
        if not info.type then
            PROPERTIES[name].type = "business"
        end
        -- see if eviction time has arrived
        if info.fee.paid_time then
            local max_ownable_days = 0
            if info.type == "business" then
                max_ownable_days = BUSINESS_PAY_PERIOD_DAYS
            elseif info.type == "house" then
                max_ownable_days = HOUSE_PAY_PERIOD_DAYS
            end
            if GetWholeDaysFromTime(info.fee.paid_time) >= max_ownable_days then
                if info.type == "house" then
                    if info.storage.money >= info.fee.price then
                        print("** Money from property (" .. name .. ") storage was used to pay for a month of rent. **")
                        PROPERTIES[name].storage.money = PROPERTIES[name].storage.money - info.fee.price
                        PROPERTIES[name].fee.paid_time = os.time()
                  			PROPERTIES[name].fee.paid = true
                        local final_time = nil
                    		local today = os.date("*t", os.time())
                        PROPERTIES[name].fee.due_days = HOUSE_PAY_PERIOD_DAYS
                				final_time = {day = today.day, month = today.month + 1, year = today.year}
                        local endtime = os.time(final_time)
                  			PROPERTIES[name].fee.due_time = endtime
                        PROPERTIES[name].fee.end_date = os.date("%x", endtime)
                        SavePropertyData(name)
                    else
                        print("***Not enough money, evicting owner of the " .. name .. " today, owner identifier: " .. PROPERTIES[name].owner.identifier .. "***")
                        -- remove property owner information, make available for purchase --
                        PROPERTIES[name].fee.end_date = 0
                        PROPERTIES[name].fee.due_days = 0
                        PROPERTIES[name].fee.paid_time = 0
                        PROPERTIES[name].fee.paid = 0
                        PROPERTIES[name].owner.name = nil
                        PROPERTIES[name].owner.purchase_date = 0
                        PROPERTIES[name].owner.identifier = "undefined"
                        PROPERTIES[name].coowners = {}
                        --PROPERTIES[name].storage.money = 0
                        --PROPERTIES[name].storage.items = {}
                        -- save property --
                        SavePropertyData(name)
                    end
                else
                    print("***Evicting owner of the " .. name .. " business today, owner identifier: " .. PROPERTIES[name].owner.identifier .. "***")
                    -- remove property owner information, make available for purchase --
                    PROPERTIES[name].fee.end_date = 0
                    PROPERTIES[name].fee.due_days = 0
                    PROPERTIES[name].fee.paid_time = 0
                    PROPERTIES[name].fee.paid = 0
                    PROPERTIES[name].owner.name = nil
                    PROPERTIES[name].owner.purchase_date = 0
                    PROPERTIES[name].owner.identifier = "undefined"
                    PROPERTIES[name].coowners = {}
                    --PROPERTIES[name].storage.money = 0
                    --PROPERTIES[name].storage.items = {}
                    -- save property --
                    SavePropertyData(name)
                end
        end
    end
end

end
-----------------------------------------

------------------------
-- Save Property Data --
------------------------
-- TODO: pass into save property data the specific field to update, instead of writing entire document every save
function SavePropertyData(property_name)
  TriggerEvent('es:exposeDBFunctions', function(couchdb)
    PROPERTIES[property_name]._rev = nil
    couchdb.updateDocument("properties", PROPERTIES[property_name]._id, PROPERTIES[property_name], function(status)
      print("called db.updateDocument checking status")
      if status == true then
        print("\nDocument updated.")
      else
        print("\nStatus Response: " .. status)
        if tostring(status) == "201" then
          print("\nDocument successfully updated!")
        end
      end
    end)
  end)
end

--[[
TriggerEvent('es:addCommand','loadproperties', function(source, args, user)
    if user.getGroup() == "owner" then
        print("inside /loadproperties command!")
        loadProperties()
        local steam_hex = GetPlayerIdentifiers(source)[1]
        TriggerClientEvent("properties:setPropertyIdentifier", source, steam_hex)
        --TriggerClientEvent("properties:updateAll", -1, PROPERTIES, false)
    end
end, {
	help = "Debug for properties"
})
--]]

--TriggerEvent('es:addCommand','addproperty', function(source, args, user)
TriggerEvent('es:addGroupCommand', 'addproperty', 'admin', function(source, args, user)
	local usource = source
  local group = user.getGroup()
    if group == "owner" or group == "superadmin" or group == "admin" then
        print("inside /addproperty command!")
        -- usage: /addproperty [door X] [door Y] [door Z] [garage X] [garage Y] [garage Z] [price] [name]
        local price = tonumber(args[8])
        local coords = {
          door = {
            x = tonumber(args[2]),
            y = tonumber(args[3]),
            z = tonumber(args[4])
          },
          garage = {
            x = tonumber(args[5]),
            y = tonumber(args[6]),
            z = tonumber(args[7])
          }
        }
        table.remove(args, 1)
        table.remove(args, 1)
        table.remove(args, 1)
        table.remove(args, 1)
        table.remove(args, 1)
        table.remove(args, 1)
        table.remove(args, 1)
        table.remove(args, 1)
        local name = table.concat(args, " ")
        local new_property = {
          owner = {
            name = null,
            purchase_date = 0,
            identifier = "undefined"
          },
          type = "house",
          name = name,
          fee = {
            price =  price,
            paid_time = 0,
            due_time = 0,
            paid =  false,
            end_date = 0,
            due_days = 0
            },
          y = coords.door.y,
          x = coords.door.x,
          z = coords.door.z,
          storage =  {
            money = 0,
            items = {}
          },
           garage_coords = {
            x = coords.garage.x,
            y = coords.garage.y,
            z = coords.garage.z,
            heading = 214.7
           },
          vehicles = {},
          wardrobe = {},
          coowners = {}
        }
        if name and price and coords.door.x and coords.garage.x then
          -- add to db --
          TriggerEvent('es:exposeDBFunctions', function(GetDoc)
            -- insert into db
            GetDoc.createDocument("properties", new_property, function()
              -- notify:
				print("**Property [" .. name .. "] added successfully! Make sure the circles are there next restart.**")
				TriggerClientEvent("usa:notify", usource, "Property [" .. name .. "] added successfully! Make sure the circles are there next restart.")
              -- refresh properties:
              --loadProperties()
              -- can do refreshproperties for it to show up
            end)
          end)
        else
          TriggerClientEvent("usa:notify", usource, "Invalid command format! Usage: /addproperty [door X] [door Y] [door Z] [garage X] [garage Y] [garage Z] [price] [name]")
        end
    end
end, {
	help = "Add a new residential property",
    params = {
        { name = "Circle X", help = "Main circle X coordinate" },
        { name = "Circle Y", help = "Main circle Y coordinate" },
        { name = "Circle Z", help = "Main circle Z coordinate" },
        { name = "Garage X", help = "Garage circle X coordinate" },
        { name = "Garage Y", help = "Garage circle Y coordinate" },
        { name = "Garage Z", help = "Garage circle Z coordinate" },
        { name = "Price", help = "Price of house (ex: 40000). NO COMMAS OR DOLLAR SIGN!" },
        { name = "Name", help = "The name of the property" }
    }
})

-- To add business properties --
TriggerEvent('es:addGroupCommand', 'addbusinessproperty', 'admin', function(source, args, user)
	local usource = source
  local group = user.getGroup()
    if group == "owner" or group == "superadmin" or group == "admin" then
        print("inside /addbusinessproperty command!")
        -- usage: /addbusinessproperty [door X] [door Y] [door Z] [price] [name]
        local price = tonumber(args[5])
        local coords = {
          door = {
            x = tonumber(args[2]),
            y = tonumber(args[3]),
            z = tonumber(args[4])
          }
        }
        table.remove(args, 1)
        table.remove(args, 1)
        table.remove(args, 1)
        table.remove(args, 1)
        table.remove(args, 1)
        local name = table.concat(args, " ")
        local new_property = {
          owner = {
            name = null,
            purchase_date = 0,
            identifier = "undefined"
          },
          type = "business",
          name = name,
          fee = {
            price =  price,
            paid_time = 0,
            due_time = 0,
            paid =  false,
            end_date = 0,
            due_days = 0
            },
          y = coords.door.y,
          x = coords.door.x,
          z = coords.door.z,
          storage =  {
            money = 0,
            items = {}
          },
          wardrobe = {},
          coowners = {}
        }
        if name and price and coords.door.x then
          -- add to db --
          TriggerEvent('es:exposeDBFunctions', function(GetDoc)
            -- insert into db
            GetDoc.createDocument("properties", new_property, function()
              -- notify:
				print("**Property [" .. name .. "] added successfully! Make sure the circle is there next restart.**")
				TriggerClientEvent("usa:notify", usource, "Property [" .. name .. "] added successfully! Make sure the circle is there next restart.")
              -- refresh properties:
              --loadProperties()
              -- can do refreshproperties for it to show up
            end)
          end)
        else
          TriggerClientEvent("usa:notify", usource, "Invalid command format! Usage: /addproperty [door X] [door Y] [door Z] [price] [name]")
        end
    end
end, {
	help = "Add a new business property",
    params = {
        { name = "Circle X", help = "Main circle X coordinate" },
        { name = "Circle Y", help = "Main circle Y coordinate" },
        { name = "Circle Z", help = "Main circle Z coordinate" },
        { name = "Price", help = "Price of business (ex: 40000). NO COMMAS OR DOLLAR SIGN!" },
        { name = "Name", help = "The name of the property" }
    }
})

-- todo: rcon command that loads properties from db (so we can make changes) and refresh everyone's clientside property info (without removing their property identifier)
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == "refreshproperties" then
		--loadProperties(function(status)
			--if status then
				TriggerEvent("es:getPlayers", function(players)
					for id, player in pairs(players) do
						if id and player then
							if GetPlayerIdentifiers(id)[1] then
								print("setting player #" .. id .. " property ident to: " .. GetPlayerIdentifiers(id)[1])
								TriggerClientEvent("properties:setPropertyIdentifier", id, GetPlayerIdentifiers(id)[1])
                                TriggerClientEvent("properties:getProperties", id)
							end
						end
					end
				end)
			--end
		--end)

	elseif commandName == "properties" then
		for name, info in pairs(PROPERTIES) do
			if info.owner.name then
				RconPrint("Name: " .. info.name)
				RconPrint("\nOwner: " .. info.owner.name)
				RconPrint("\nIdent: " .. info.owner.identifier)
				RconPrint("\nCurrent Money: $" .. info.storage.money)
				RconPrint("\nItems: ")
				for k = 1, #info.storage.items do
					RconPrint("\n(" .. info.storage.items[k].quantity .. "x) " .. info.storage.items[k].name)
				end
				RconPrint("\nEnd Date: " .. info.fee.end_date .. "\n\n")
			end
		end
	elseif commandName == "addproperty" then
		-- usage: addproperty [door X] [door Y] [door Z] [garage X] [garage Y] [garage Z] [price] [name]
		local price = tonumber(args[7])
		local coords = {
			door = {
				x = tonumber(args[1]),
				y = tonumber(args[2]),
				z = tonumber(args[3])
			},
			garage = {
				x = tonumber(args[4]),
				y = tonumber(args[5]),
				z = tonumber(args[6])
			}
		}
		table.remove(args, 1)
		table.remove(args, 1)
		table.remove(args, 1)
		table.remove(args, 1)
		table.remove(args, 1)
		table.remove(args, 1)
		table.remove(args, 1)
		local name = table.concat(args, " ")
		local new_property = {
			owner = {
				name = null,
				purchase_date = 0,
				identifier = "undefined"
			},
			type = "house",
			name = name,
			fee = {
				price =  price,
				paid_time = 0,
				due_time = 0,
				paid =  false,
				end_date = 0,
				due_days = 0
			  },
			y = coords.door.y,
			x = coords.door.x,
			z = coords.door.z,
			storage =  {
				money = 0,
				items = {}
			},
		   garage_coords = {
				x = coords.garage.x,
				y = coords.garage.y,
				z = coords.garage.z,
				heading = 214.7
			 },
			vehicles = {}
		}
		if name and price and coords.door.x and coords.garage.x then
			-- add to db --
			TriggerEvent('es:exposeDBFunctions', function(GetDoc)
				-- insert into db
				GetDoc.createDocument("properties", new_property, function()
					-- notify:
					RconPrint("\nProperty [" .. name .. "] added successfully! Make sure the circles are there next restart.")
					-- refresh properties:
					--loadProperties()
					-- can do refreshproperties for it to show up
				end)
			end)
		else
			RconPrint("\nInvalid command format! Usage: addproperty [door X] [door Y] [door Z] [garage X] [garage Y] [garage Z] [price] [name]")
		end
	end
	CancelEvent()
end)

function GetNumberOfOwnedProperties(identifier)
	local count = 0
	for name, info in pairs(PROPERTIES) do
		if info.owner.identifier == identifier then
			count = count + 1
		end
	end
	print("player with identifier [" .. identifier .. "] owns " .. count .. " properties")
	return count
end

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
