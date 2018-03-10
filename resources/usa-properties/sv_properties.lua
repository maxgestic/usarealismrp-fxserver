local PROPERTIES = {} -- loaded and updated by database

local PROPERTY_PAY_PERIOD_DAYS = 7

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
    print("player #" .. source .. " wants to purchase " .. property.name)
    local player = exports["essentialmode"]:getPlayerFromId(user_source)
    local user_money = player.getActiveCharacterData("money")
    local char_name = player.getActiveCharacterData("fullName")
    if user_money >= property.fee.price then
        -- set new property info --
        PROPERTIES[property.name].fee.paid_time = os.time() -- save the time the property was purchased
        PROPERTIES[property.name].fee.paid = true
        PROPERTIES[property.name].fee.due_days = PROPERTY_PAY_PERIOD_DAYS
        local today = os.date("*t", os.time())
        local endtime = os.time({day = today.day + PROPERTY_PAY_PERIOD_DAYS, month = today.month, year = today.year})
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
		local desc = "\n**Business:** " .. property.name .. "\n**Purchase Price:** $" .. comma_value(property.fee.price) ..  "\n**Purchased By:** " .. char_name .. "\n**Purchase Date:** ".. PROPERTIES[property.name].owner.purchase_date .. "\n**End Date:** " .. PROPERTIES[property.name].fee.end_date
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

---------------------------------------
-- Evict owners whose leases expired --
---------------------------------------
for name, info in pairs(PROPERTIES) do 
    if info.paid_time then
        if GetWholeDaysFromTime(info.fee.paid_time) > PROPERTY_PAY_PERIOD_DAYS then
            print("***Evicting owner of the " .. name .. " today!***")
            Evict_Owner(name)
        end
    end
end

function Evict_Owner(name)
    PROPERTIES[name].fee.end_date = 0
    PROPERTIES[name].fee.due_days = 0
    PROPERTIES[name].fee.paid_time = 0
    PROPERTIES[name].fee.paid = 0

    PROPERTIES[name].owner.name = nil
    PROPERTIES[name].owner.purchase_date = 0
    PROPERTIES[name].owner.identifier = "undefined"
    PROPERTIES[name].storage.money = 0
    PROPERTIES[name].storage.items = {}
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
                    end)
                end
            end)
        end)

        -- send discord message
			local desc = "\n" .. char_name .. " no longer owns " .. property.name .. "!"
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
end
-----------------------------------------

-----------------------------------------
-- Save property data every x minutes  --
-----------------------------------------
Citizen.CreateThread(function()

	local minutes = 17
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
    if user.getGroup() ~= "user" then
        print("inside /loadproperties command!")
        loadProperties()
        local steam_hex = GetPlayerIdentifiers(source)[1]
        TriggerClientEvent("properties:setPropertyIdentifier", source, steam_hex)
        TriggerClientEvent("properties:update", -1, PROPERTIES, false)
    end
end, {
	help = "Debug for properties"
})

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