--# Residential / Business Properties
--# own, store stuff, be a bawse
--# by: minipunch
--# made for: USA REALISM RP

local PROPERTIES = {} -- loaded and updated by database

local BUSINESS_PAY_PERIOD_DAYS = 7
local HOUSE_PAY_PERIOD_DAYS = 30

RegisterServerEvent("properties:getPropertyIdentifier")
AddEventHandler("properties:getPropertyIdentifier", function()
    local steam_hex = GetPlayerIdentifiers(source)[1]
    print("setting property identifier with hex: " .. steam_hex)
    TriggerClientEvent("properties:setPropertyIdentifier", source, steam_hex)
end)

RegisterServerEvent("properties:getProperties")
AddEventHandler("properties:getProperties", function()
    TriggerClientEvent("properties:update", source, PROPERTIES, false)
end)

RegisterServerEvent("properties:getPropertyMoney")
AddEventHandler("properties:getPropertyMoney", function(name, cb)
    cb(PROPERTIES[name].storage.money)
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
            -- update properties --
            TriggerClientEvent("properties:update", -1, PROPERTIES, false)
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
    -- update properties --
	TriggerClientEvent("properties:update", -1, PROPERTIES, false)
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
	print("inside properties:store!")
	local user_source = source
	print("recevied item [" .. item.name .. "] to store with quantity [" .. item.quantity .. "]")
	local saved_quantity = item.quantity
		-- remove from player --
	print("sending into usa:remove item [" .. item.name .. "] item.quantity = " .. item.quantity .. ", quantity to remove = " .. quantity)
	TriggerEvent("usa:removeItem", item, quantity, user_source)
	-- update properties --
	TriggerClientEvent("properties:update", -1, PROPERTIES, true)
	-- refresh items in menu
	--TriggerEvent("properties:getUserItemsToStore", user_source)
	--TriggerClientEvent("properties:loadedStorage", user_source, PROPERTIES[name].storage.items)
	local copy = item
	copy.quantity = quantity
	local had_already = false
	print("storing item at property: " .. name)
	-- insert into property --
	for i = 1, #PROPERTIES[name].storage.items do
		if PROPERTIES[name].storage.items[i].name == item.name then
			print("had_already was true!")
			print("previous quantity: " .. PROPERTIES[name].storage.items[i].quantity)
			print("quantity to add: " .. quantity)
			had_already	= true
			PROPERTIES[name].storage.items[i].quantity = PROPERTIES[name].storage.items[i].quantity + quantity
			break
		end
	end
	if not had_already then
		print("had_already was false!")
		--print("quantity param: " .. quantity)
		--print("item.quantity from inventory was: " .. saved_quantity)
		--print("item.quantity to store is now after setting: " .. copy.quantity)
		table.insert(PROPERTIES[name].storage.items, copy)
		--print("added item! property now has:")
		for k = 1, #PROPERTIES[name].storage.items do
			print("name: " .. PROPERTIES[name].storage.items[k].name .. ", quantity: " .. PROPERTIES[name].storage.items[k].quantity)
		end
	end
end)

-- store vehicle at property --
RegisterServerEvent("properties:storeVehicle")
AddEventHandler("properties:storeVehicle", function(property_name, plate)
  local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local userVehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #userVehicles do
			local vehicle = userVehicles[i]
			if plate and vehicle then
				if string.match(plate,tostring(vehicle.plate)) or plate == vehicle.plate then -- player actually owns car that is being stored
					userVehicles[i].stored_location = property_name
					user.setActiveCharacterData("vehicles", userVehicles)
          table.insert(PROPERTIES[property_name].vehicles, userVehicles[i])
          TriggerClientEvent("properties:update", -1, PROPERTIES, true)
					TriggerClientEvent("properties:storeVehicle", userSource)
					return
				end
			end
		end
		TriggerClientEvent("garage:notify", userSource, "~r~You do not own that vehicle!")
	end)
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
      -- update properties table --
      TriggerClientEvent("properties:update", -1, PROPERTIES, true)
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
	print("inside properties:retrieve!")
	local user_source = source
	local player = exports["essentialmode"]:getPlayerFromId(user_source)
	if player then
		print("player existed!")
		item.quantity = quantity
		if player.getCanActiveCharacterHoldItem(item) then
			print("player can hold [" .. item.name .. "] with quantity: " .. item.quantity .. " - " .. quantity .. "!")
			-- remove from property --
			local prop_storage = PROPERTIES[name].storage.items
			for i = 1, #prop_storage do
				print("checking item in property storage: " .. prop_storage[i].name .. " against " .. item.name)
				if prop_storage[i].name == item.name then
					print("wants: " .. quantity .. ", has: " .. prop_storage[i].quantity)
					if prop_storage[i].quantity - quantity < 0 then
						print("tried to retrieve too much of item! wanted: " .. quantity .. ", had: " .. prop_storage[i].quantity)
						TriggerClientEvent("usa:notify", user_source, "You don't have that much of that item in storage!")
						return
					else
						if prop_storage[i].quantity - quantity == 0 then
							print("property item removed!")
							table.remove(PROPERTIES[name].storage.items, i)
						else
							print("previous quantity: " .. PROPERTIES[name].storage.items[i].quantity)
							print("quantity to decrement by: " .. quantity)
							PROPERTIES[name].storage.items[i].quantity = PROPERTIES[name].storage.items[i].quantity - quantity
						end
						break
					end
				end
			end
			-- insert into player inventory --
			TriggerEvent("usa:insertItem", item, quantity, user_source)
			-- update properties for all --
			print("updating properties!")
			--TriggerClientEvent("properties:update", -1, PROPERTIES, true)
			-- refresh menu property items --
			print("setting client's property storage items to:")
			for k = 1, #PROPERTIES[name].storage.items do
				print("item: " .. PROPERTIES[name].storage.items[k].name .. ", quantity: " .. PROPERTIES[name].storage.items[k].quantity)
			end
			TriggerClientEvent("properties:loadedStorage", user_source, PROPERTIES[name].storage.items)
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
			print("#(response.rows) = " .. #(response.rows))
			-- insert all properties from 'properties' db into lua table
			for i = 1, #(response.rows) do
				--table.insert(PROPERTIES, response.rows[i].doc)
                PROPERTIES[response.rows[i].doc.name] = response.rows[i].doc
                print("loaded property: " .. response.rows[i].doc.name)
			end
			print("finished loading properties...")
			--print("# of properties: " .. #PROPERTIES)
			print("checking for owners to evict...")
			Evict_Owners()
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end

loadProperties()

--------------------------------
-- ADD MONEY (from purchases) --
--------------------------------
RegisterServerEvent("properties:addMoney")
AddEventHandler("properties:addMoney", function(name, amount)
    PROPERTIES[name].storage.money = PROPERTIES[name].storage.money + amount
    TriggerClientEvent("properties:update", -1, PROPERTIES, true)
    print("$" .. amount .. " added!")
end)

------------------
-- REMOVE MONEY --
------------------
RegisterServerEvent("properties:withdraw")
AddEventHandler("properties:withdraw", function(name, amount, savedSource)
    if PROPERTIES[name].storage.money - amount >= 0 then
        -- remove from store --
        PROPERTIES[name].storage.money = PROPERTIES[name].storage.money - amount
        TriggerClientEvent("properties:update", -1, PROPERTIES, true)
		-- see if called from server file --
		if savedSource then source = savedSource end
        -- add to player --
        local player = exports["essentialmode"]:getPlayerFromId(tonumber(source))
		if player then
			local user_money = player.getActiveCharacterData("money")
			player.setActiveCharacterData("money", user_money + amount)
			TriggerClientEvent("usa:notify", source, "~y~Withdrawn: ~w~$" .. amount)
			print("$" .. amount .. " withdrawn!")
			-- update property info in DB --
			-- Get the document with that property name
			TriggerEvent('es:exposeDBFunctions', function(db)
				db.getDocumentByRow("properties", "name", name, function(doc, rText)
					if rText then
						--RconPrint("\nrText = " .. rText)
					end
					if doc then
						print("doc found!")
						doc._rev = nil
						db.updateDocument("properties", doc._id, PROPERTIES[name], function(status)
							if status == true then
								print("\nDocument successfully updated!")
							else
								--RconPrint("\nStatus Response: " .. status)
								if status == "201" then
									print("\nDocument successfully updated!")
								end
							end
						end)
					end
				end)
			end)
		else
			print("failed to retrieve player in properties:withdraw!")
		end
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

	if not property.type then property.type = "business" print("set property type to business") end
	--if property.type == "business" then ownership_length = BUSINESS_PAY_PERIOD_DAYS
	--elseif property.type == "house" then ownership_length = HOUSE_PAY_PERIOD_DAYS end

	local final_time = nil
	local today = os.date("*t", os.time())

    print("player #" .. source .. " wants to purchase " .. property.name)
    local player = exports["essentialmode"]:getPlayerFromId(user_source)
    local user_money = player.getActiveCharacterData("money")
    local char_name = player.getActiveCharacterData("fullName")

    if user_money >= property.fee.price then
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
        PROPERTIES[property.name].owner.identifier = GetPlayerIdentifiers(source)[1]
        -- update all clients property info --
        TriggerClientEvent("properties:update", -1, PROPERTIES, true)
        -- subtract money --
        player.setActiveCharacterData("money", user_money - property.fee.price)
        -- Get the document with that property name --
        TriggerEvent('es:exposeDBFunctions', function(db)
            db.getDocumentByRow("properties", "name", property.name, function(doc, rText)
                if rText then
                    --RconPrint("\nrText = " .. rText)
                end
                if doc then
                    PROPERTIES[property.name]._rev = nil
                    db.updateDocument("properties", doc._id, PROPERTIES[property.name], function(status)
                        print("called db.updateDocument checking status")
                        if status == true then
                            print("\nDocument updated.")
                        else
                            --RconPrint("\nStatus Response: " .. status)
                            if status == "201" then
                                print("\nDocument successfully updated!")
                            end
                        end
                    end)
                end
            end)
        end)
        -- send discord msg to #property-logs --
		local desc = "\n**Property:** " .. property.name .. "\n**Purchase Price:** $" .. comma_value(property.fee.price) ..  "\n**Purchased By:** " .. char_name .. "\n**Purchase Date:** ".. PROPERTIES[property.name].owner.purchase_date .. "\n**End Date:** " .. PROPERTIES[property.name].fee.end_date
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
						name = "BLAINE COUNTY PROPERTY MGMT"
					}
				}
			}
		}), { ["Content-Type"] = 'application/json' })
    else
        TriggerClientEvent("usa:notify", user_source, "You don't have enough money to purchase this property!")
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
		--[[
	if name and PROPERTIES[name].owner.name then
							--send discord message --
							local desc = "\n" .. PROPERTIES[name].owner.name .. " no longer owns the " .. name .. "!"
							local url = 'https://discordapp.com/api/webhooks/419573361170055169/6v2NLnxzF8lSHgT8pSDccB_XN1R6miVuZDrEYtvNfPny6kSqddSN_9iJ9PPkbAbM01pW'
							PerformHttpRequest(url, function(err, text, headers)
								if text then print(text) end
								end, "POST", json.encode({
									embeds = {
										{
											description = desc,
											color = 524288,
											author = {
												name = "BLAINE COUNTY PROPERTY MGMT"
											}
										}
								}
							}), { ["Content-Type"] = 'application/json' })
	end
	--]]
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
						if GetWholeDaysFromTime(info.fee.paid_time) > max_ownable_days then
							print("***Evicting owner of the " .. name .. " today!***")
							-- Get the document with that property name
							TriggerEvent('es:exposeDBFunctions', function(db)
								db.getDocumentByRow("properties", "name", name, function(doc, rText)
									if rText then
										--RconPrint("\nrText = " .. rText)
									end
									if doc then
										doc._rev = nil
										db.updateDocument("properties", doc._id, PROPERTIES[name], function(status)
											if status == true then
												print("\nDocument updated.")
											else
												--RconPrint("\nStatus Response: " .. status)
												if status == "201" then
													print("\nDocument successfully updated!")
												end
											end
											-- remove property owner information, make available for purchase --
											PROPERTIES[name].fee.end_date = 0
											PROPERTIES[name].fee.due_days = 0
											PROPERTIES[name].fee.paid_time = 0
											PROPERTIES[name].fee.paid = 0
											PROPERTIES[name].owner.name = nil
											PROPERTIES[name].owner.purchase_date = 0
											PROPERTIES[name].owner.identifier = "undefined"
											--PROPERTIES[name].storage.money = 0
											--PROPERTIES[name].storage.items = {}
										end)
									end
								end)
							end)
						end
				end
			end

end
-----------------------------------------

-----------------------------------------
-- Save property data every x minutes  --

	-- todo: save everytime something is changed instead of every x minutes? (to prevent performance degredation like falling through the map?)
-----------------------------------------
Citizen.CreateThread(function()

	local minutes = 32
	local interval = minutes * 60000

	function savePropertyData()
		print("calling savePropertyData()...")
		SetTimeout(interval, function()
            TriggerEvent('es:exposeDBFunctions', function(db)
                for name, info in pairs(PROPERTIES) do
                    print("trying to save property: " .. name)
                    -- Get the document with that property name
                    db.getDocumentByRow("properties", "name", name, function(doc, rText)
                        if rText then
                            --RconPrint("\nrText = " .. rText)
                        end
                        if doc then
                            print("doc found!")
                            info._rev = nil
                            db.updateDocument("properties", doc._id, info, function(status)
                                --print("info._rev: " .. info._rev)
                                print("inside of db.updateDocument!")
                                --print("doc._id = " .. doc._id)
                                print("status: " .. tostring(status))
                                if status == true then
                                    print("Property document successfully updated!")
                                else
                                    --RconPrint("\nStatus Response: " .. status)
                                    if tostring(status) == "202" then
                                        --RconPrint("\nDocument successfully updated!")
                                        print("Property document successfully updated!")
                                    end
                                end
                            end)
                        end
                    end)
                end
            end)
			savePropertyData()
		end)
	end

    savePropertyData()

end)
---------------------------------------

TriggerEvent('es:addCommand','loadproperties', function(source, args, user)
    if user.getGroup() == "owner" then
        print("inside /loadproperties command!")
        loadProperties()
        local steam_hex = GetPlayerIdentifiers(source)[1]
        TriggerClientEvent("properties:setPropertyIdentifier", source, steam_hex)
        TriggerClientEvent("properties:update", -1, PROPERTIES, false)
    end
end, {
	help = "Debug for properties"
})

-- todo: rcon command that loads properties from db (so we can make changes) and refresh everyone's clientside property info (without removing their property identifier)
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == "refreshproperties" then
		loadProperties(function(status)
			if status then
				TriggerClientEvent("properties:update", -1, PROPERTIES, false)
				print("all players property info refreshed!")
				TriggerEvent("es:getPlayers", function(players)
					for id, player in pairs(players) do
						if player then
							print("setting player #" .. id .. " property ident to: " .. GetPlayerIdentifiers(id)[1])
							TriggerClientEvent("properties:setPropertyIdentifier", id, GetPlayerIdentifiers(id)[1])
						end
					end
				end)
			end
		end)
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
	end
	CancelEvent()
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
