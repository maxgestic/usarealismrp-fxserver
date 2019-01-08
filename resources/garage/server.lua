--# Public vehicle parking garages to store player vehicles
--# For: USA Realism RP
--# By: minipunch

local WITHDRAW_FEE = 50
local IMPOUND_FEE = 2000

RegisterServerEvent("garage:giveKey")
AddEventHandler("garage:giveKey", function(key)
	local already_has_key = false
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local inv = user.getActiveCharacterData("inventory")
		for i = 1, #inv do
			local item = inv[i]
			if item then
				if string.find(item.name, "Key") then
					if string.find(key.plate, item.plate) then
						already_has_key = true
					end
				end
			end
		end
		if not already_has_key then
			table.insert(inv, key)
			user.setActiveCharacterData("inventory", inv)
		end
		-- add to server side list of plates being tracked for locking resource:
		TriggerEvent("lock:addPlate", key.plate)
		return
end)

RegisterServerEvent("garage:storeKey")
AddEventHandler("garage:storeKey", function(plate)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local inv = user.getActiveCharacterData("inventory")
		if inv then
			for i = 1, #inv do
				local item = inv[i]
				if item then
					if string.find(item.name, "Key") then
						if plate then
							if string.find(plate, item.plate) then
								table.remove(inv, i)
								user.setActiveCharacterData("inventory", inv)
								-- remove key from lock resource toggle list:
								TriggerEvent("lock:removePlate", item.plate)
								return
							end
						end
					end
				end
			end
		end
end)

RegisterServerEvent("garage:storeVehicle")
AddEventHandler("garage:storeVehicle", function(handle, numberPlateText, required_jobs)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local isAuthorized = false
	local usource = source

	if required_jobs then
		local userJob = user.getActiveCharacterData("job")
		for i = 1, #required_jobs do
			if userJob == required_jobs[i] then
				isAuthorized = true
				break
			end
		end
	else
		isAuthorized = true
	end

	if isAuthorized then
		local userVehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #userVehicles do
			local vehicle = userVehicles[i]
			if numberPlateText and vehicle then
				if string.match(numberPlateText,tostring(vehicle)) or numberPlateText == vehicle then -- player actually owns car that is being stored
					TriggerEvent('es:exposeDBFunctions', function(couchdb)
						couchdb.updateDocument("vehicles", numberPlateText, { stored = true }, function()
							TriggerClientEvent("garage:storeVehicle", usource)
						end)
					end)
					return
				end
			end
		end
		TriggerClientEvent("usa:notify", usource, "~r~You do not own that vehicle!")
		return
	else
		TriggerClientEvent("usa:notify", usource, "Garage prohibited!")
	end
end)

-- ask to retrieve vehicle from garage --
RegisterServerEvent("garage:vehicleSelected")
AddEventHandler("garage:vehicleSelected", function(vehicle, property)
	local userSource = tonumber(source)
	local withdraw_fee = 0
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local userVehicles = user.getActiveCharacterData("vehicles")
	local user_money = user.getActiveCharacterData("money")
	if vehicle.impounded == true then
		if user_money >= withdraw_fee then
			TriggerClientEvent("usa:notify", userSource, "~g~BC IMPOUND: ~w~Here's your car!")
			-- get customizations --
			GetVehicleCustomizations(vehicle.plate, function(customizations)
				-- spawn vehicle --
				vehicle.customizations = customizations
				TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
				-- set stored status to false --
				TriggerEvent('es:exposeDBFunctions', function(couchdb)
					couchdb.updateDocument("vehicles", vehicle.plate, { impounded = false, stored = false }, function()
						-- take storage fee --
						user.setActiveCharacterData("money", user_money - IMPOUND_FEE)
						-- give money to garage property owner --
						if property then
							TriggerEvent("properties:addMoney", property.name, math.ceil(0.70 * IMPOUND_FEE))
						end
					end)
				end)
			end)
		else
			TriggerClientEvent("usa:notify", userSource, "~r~BC IMPOUND: ~w~Your car is impounded and can be retrieved for $2,000!")
		end
		return
	elseif vehicle.stored == true then
		TriggerClientEvent("usa:notify", userSource, "Here's your car! Storage Fee: $" .. WITHDRAW_FEE)
		-- get customizations --
		GetVehicleCustomizations(vehicle.plate, function(customizations)
			-- spawn vehicle --
			vehicle.customizations = customizations
			TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
			-- set stored status to false --
			TriggerEvent('es:exposeDBFunctions', function(couchdb)
			    couchdb.updateDocument("vehicles", vehicle.plate, { stored = false }, function()
					-- take storage fee --
					user.setActiveCharacterData("money", user_money - WITHDRAW_FEE)
					-- give money to garage property owner --
					if property then
						TriggerEvent("properties:addMoney", property.name, math.ceil(0.70 * WITHDRAW_FEE))
					end
				end)
			end)
		end)
	else
		TriggerClientEvent("usa:notify", userSource, "~r~Sorry! That vehicle is not stored at any of our garages.")
	end
end)

RegisterServerEvent("garage:openMenu")
AddEventHandler("garage:openMenu", function(required_jobs)
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if required_jobs then
		local userJob = user.getActiveCharacterData("job")
		for i = 1, #required_jobs do
			if required_jobs[i] == userJob then
				GetVehiclesForMenu(user.getActiveCharacterData("vehicles"), function(vehs)
					TriggerClientEvent("garage:openMenuWithVehiclesLoaded", usource, vehs)
				end)
				return
			end
			TriggerClientEvent("usa:notify", usource, "Garage prohibited!")
		end
	else
		GetVehiclesForMenu(user.getActiveCharacterData("vehicles"), function(vehs)
			TriggerClientEvent("garage:openMenuWithVehiclesLoaded", usource, vehs)
		end)
	end
end)

function GetVehiclesForMenu(plates, cb) -- test
	-- query for the information needed from each vehicle --
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehiclesForGarageMenu"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local responseVehArray = {}
			--print(responseText)
			local data = json.decode(responseText)
			if data.rows then
				for i = 1, #data.rows do
					local veh = {
						plate = data.rows[i].value[1], -- plate
						make = data.rows[i].value[2], -- make
						model = data.rows[i].value[3], -- model
						impounded = data.rows[i].value[4], -- impounded
						stored = data.rows[i].value[5], -- stored
						hash = data.rows[i].value[6], -- hash
						owner = data.rows[i].value[7] -- owner
					}
					table.insert(responseVehArray, veh)
				end
				-- send vehicles to client for displaying --
				--print("# of vehicles loaded for menu: " .. #responseVehArray)
			end
			cb(responseVehArray)
		end
	end, "POST", json.encode({
		keys = plates
		--keys = { "86CSH075" }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end

function GetVehicleCustomizations(plate, cb)
	-- query for the information needed from each vehicle --
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehicleCustomizationsByPlate"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local customizations = {}
			--print(responseText)
			local data = json.decode(responseText)
			if data.rows and data.rows[1].value then
				customizations = data.rows[1].value[1] -- customizations
			end
			cb(customizations)
		end
	end, "POST", json.encode({
		keys = { plate }
		--keys = { "86CSH075" }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end
