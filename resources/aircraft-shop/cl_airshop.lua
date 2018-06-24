local menu = false
local alreadyCalled = false
local rental = {}
local selected_item = nil
local OWNED_AIRCRAFT = {}
local RETRIEVED_AIRCRAFT = {}
local selected_aircraft = nil

local STORE_LOCATIONS = {
	{x = 2145.1, y = 4811.2, z = 41.3, name = "Grapeseed"},
	{x = 1707.3, y = 3273.4, z = 41.2, name = "Sandy Shores"},
	{x = -982.7, y = -3021.9, z = 14.0, name = "Los Santos"}
}

RegisterNetEvent("airshopGUI:Title")
AddEventHandler("airshopGUI:Title", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("airshopGUI:Option")
AddEventHandler("airshopGUI:Option", function(option, cb)
	cb(Menu.Option(option))
end)

RegisterNetEvent("airshopGUI:Bool")
AddEventHandler("airshopGUI:Bool", function(option, bool, cb)
	Menu.Bool(option, bool, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("airshopGUI:Int")
AddEventHandler("airshopGUI:Int", function(option, int, min, max, cb)
	Menu.Int(option, int, min, max, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("airshopGUI:StringArray")
AddEventHandler("airshopGUI:StringArray", function(option, array, position, cb)
	Menu.StringArray(option, array, position, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("airshopGUI:Update")
AddEventHandler("airshopGUI:Update", function()
	Menu.updateSelection()
end)

-- custom events

RegisterNetEvent("aircraft:ownedAircraftLoaded")
AddEventHandler("aircraft:ownedAircraftLoaded", function(uaircraft)
	OWNED_AIRCRAFT = uaircraft
end)

-- end custom events

-- custom functions --
function alreadyRetrievedFromHangar(aircraft)
	for i = 1, #RETRIEVED_AIRCRAFT do
		--print("checking " .. aircraft.id .. " against " .. RETRIEVED_AIRCRAFT[i].id)
		if RETRIEVED_AIRCRAFT[i].id == aircraft.id then
			return true
		end
	end
	return false
end

function hasAircraftBeenRetrieved(aircraftHash)
	for i = 1, #RETRIEVED_AIRCRAFT do
		--print("checking " .. aircraft.id .. " against " .. RETRIEVED_AIRCRAFT[i].id)
		if RETRIEVED_AIRCRAFT[i].hash == aircraftHash then
			return true
		end
	end
	return false
end

function storeAircraftInHangar(aircraftHash)
	for i = 1, #RETRIEVED_AIRCRAFT do
		--print("checking " .. aircraft.id .. " against " .. RETRIEVED_AIRCRAFT[i].id)
		if RETRIEVED_AIRCRAFT[i].hash == aircraftHash then
			table.remove(RETRIEVED_AIRCRAFT, i)
			return
		end
	end
end
-- end custom functions --

Citizen.CreateThread(function()

	--local menu = false
	--local bool = false
	--local int = 0
	--local position = 1
	--local array = {"TEST", "TEST2", "TEST3", "TEST4"}

	local menuName = "home"

	while true do
		if(menu) then
			-- title of menu
			TriggerEvent("airshopGUI:Title", "Seaview Aircrafts")

			if menuName == "home" then

				-- heli menu --
				TriggerEvent("airshopGUI:Option", "Helicopters", function(cb)
					if(cb) then
						menuName = "heli"
					end
				end)

				-- plane menu --
				TriggerEvent("airshopGUI:Option", "Airplanes", function(cb)
					if(cb) then
						menuName = "plane"
					end
				end)

				-- player owned aircraft --
				TriggerEvent("airshopGUI:Option", "My Aircraft", function(cb)
					if(cb) then
						TriggerServerEvent("aircraft:getOwnedAircraft")
						menuName = "my-aircraft"
					end
				end)

			end

			if menuName ~= "home" then
				if menuName == "heli" then
					-- each helicopter item
					for i = 1, #(ITEMS.helicopters) do
						local item = ITEMS.helicopters[i]
						TriggerEvent("airshopGUI:Option", item.name, function(cb)
							if(cb) then
								menuName = "item-selected"
								selected_item = item
							end
						end)
					end
					-- back btn
					TriggerEvent("airshopGUI:Option", "~y~Back", function(cb)
						if(cb) then
							menuName = "home"
						end
					end)
				elseif menuName == "plane" then
					-- each plane item
					for i = 1, #(ITEMS.planes) do
						local item = ITEMS.planes[i]
						TriggerEvent("airshopGUI:Option", item.name, function(cb)
							if(cb) then
								menuName = "item-selected"
								selected_item = item
							end
						end)
					end
					-- back btn
					TriggerEvent("airshopGUI:Option", "~y~Back", function(cb)
						if(cb) then
							menuName = "home"
						end
					end)
				elseif menuName == "item-selected" then
					TriggerEvent("airshopGUI:Option", "(~g~$" .. comma_value(selected_item.price) .. "~w~) " .. "Rent", function(cb)
						if(cb) then
							local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
							TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
								TriggerServerEvent("airshop:rentAircraft", selected_item, property)
							end)
							rental = selected_item
							menu = false
							menuName = "home"
						end
					end)
					TriggerEvent("airshopGUI:Option", "(~g~$" .. comma_value(selected_item.buy_price) .. "~w~) " .. "Purchase", function(cb)
						if(cb) then
							local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
							TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
								TriggerServerEvent("airshop:purchaseAircraft", selected_item, property)
							end)
							menu = false
							menuName = "home"
						end
					end)
					TriggerEvent("airshopGUI:Option", "~y~Back", function(cb)
						if(cb) then
							menuName = "home"
						end
					end)
				elseif menuName == "my-aircraft" then
					if #OWNED_AIRCRAFT > 0 then
						for i = 1, #OWNED_AIRCRAFT do
							if not alreadyRetrievedFromHangar(OWNED_AIRCRAFT[i]) then
								TriggerEvent("airshopGUI:Option", OWNED_AIRCRAFT[i].name .. " (~g~Stored~w~)", function(cb)
										if cb then
											--TriggerEvent("airshop:spawnAircraft", OWNED_AIRCRAFT[i])
											menuName = "my-aircraft--selected"
											selected_aircraft = OWNED_AIRCRAFT[i]
										end
								end)
							end
						end
					else
						TriggerEvent("airshopGUI:Option", "You don't own any aircraft!", function(cb) if cb then end end)
					end
					TriggerEvent("airshopGUI:Option", "~y~Back", function(cb)
						if(cb) then
							menuName = "home"
						end
					end)
				elseif menuName == "my-aircraft--selected" then
					TriggerEvent("airshopGUI:Option", "~g~Retrieve", function(cb)
							if cb then
								TriggerEvent("airshop:spawnAircraft", selected_aircraft)
								menuName = "home"
								menu = false
								table.insert(RETRIEVED_AIRCRAFT, selected_aircraft)
							end
					end)
					TriggerEvent("airshopGUI:Option", "Sell", function(cb)
						if cb then
								TriggerServerEvent("airshop:sellAircraft", selected_aircraft)
								for i = 1, #OWNED_AIRCRAFT do
									if OWNED_AIRCRAFT[i].id == selected_aircraft.id then
										table.remove(OWNED_AIRCRAFT, i)
										break
									end
								end
								menuName = "my-aircraft"
						end
					end)
					TriggerEvent("airshopGUI:Option", "~y~Back", function(cb)
						if(cb) then
							menuName = "my-aircraft"
						end
					end)
				end
			end
			-- close menu
			TriggerEvent("airshopGUI:Option", "~y~Close Menu", function(cb)
				if(cb) then
					menu = false
					menuName = "home"
				end
			end)
			TriggerEvent("airshopGUI:Update")
		end
		Wait(0)
	end
end)


local locations = {
	{ ['x'] = -943.103, ['y'] = -2958.14, ['z'] = 13.9451 }, -- LS
	{ ['x'] = 2119.083, ['y'] = 4790.010, ['z'] = 41.139 }, -- Grape Seed
	{ ['x'] =  1727.8526, ['y'] = 3289.0103, ['z'] = 41.162 } -- sandy shores
}

local returnLocations = {
	{x = -993.573, y = -3015.14, z = 13.9451},
	{x = 2141.445, y = 4818.229, z = 41.359 },
	{x = 1700.487, y = 3271.906, z = 41.1502} -- sandy shores airfield
}

local spawnX, spawnY, spawnZ = -982.552, -2993.78, 13.9451

local spawnz = {
	{x = -982.552, y = -2993.78, z = 13.9451},
	{x = 1742.931, y = 3283.37, z = 41.089},
	{x = 2131.0134, y = 4810.08, z = 41.196}
}

Citizen.CreateThread(function()

	local me = nil

	while true do
		Citizen.Wait(5)
		me = GetPlayerPed(-1)
		---------------------------------------
		-- Watch for aircraft rental returns --
		---------------------------------------
		for _, info in pairs(returnLocations) do
			DrawMarker(1, info['x'], info['y'], info['z']-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 76, 144, 114, 200, 0, 0, 0, 0) -- for returning the rental
			if GetDistanceBetweenCoords(GetEntityCoords(me), info['x'], info['y'], info['z'], true) < 5 then
				DrawSpecialText("Press [ ~b~E~w~ ] to return your aircraft rental!")
				if IsControlPressed(0, 86) then
					Citizen.Wait(500)
					if rental.price then
						local vehicle = GetVehiclePedIsIn(me, false)
						local hash = GetEntityModel(vehicle)
						if GetPedInVehicleSeat(vehicle, -1) == me then
							for i = 1, #ITEMS.helicopters do
								local item = ITEMS.helicopters[i]
								if item.hash == hash then
									TriggerServerEvent("airshop:returnedVehicle", item)
									Citizen.Trace("found matching model")
									SetEntityAsMissionEntity( vehicle, true, true )
									deleteCar( vehicle )
									break
								end
							end
							for i = 1, #ITEMS.planes do
								local item = ITEMS.planes[i]
								if item.hash == hash then
									TriggerServerEvent("airshop:returnedVehicle", item)
									Citizen.Trace("found matching model")
									SetEntityAsMissionEntity( vehicle, true, true )
									deleteCar( vehicle )
									break
								end
							end
							rental = {}
						else
							drawNotification("You must be in the driver's seat.")
						end
					end
				end
			end
		end
		-------------------------------------------
		-- Watch for entering aircraft shop area --
		-------------------------------------------
		for _, info in pairs(locations) do
			if GetDistanceBetweenCoords(info['x'], info['y'], info['z'],GetEntityCoords(me)) < 50 then
				DrawMarker(1, info['x'], info['y'], info['z']-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(me), info['x'], info['y'], info['z'], true) < 3 then
					DrawSpecialText("Press [ ~b~E~w~ ] to access the Seaview Aircraft shop!")
					if IsControlPressed(0, 86) then
						Citizen.Wait(500)
						menu = true
					end
				else
					menu = false
					alreadyCalled = false
				end
			end
		end
		------------------------------------------
		-- Watch for purchased aircraft storage --
		------------------------------------------
		for i = 1, #STORE_LOCATIONS do
			DrawMarker(1, STORE_LOCATIONS[i].x, STORE_LOCATIONS[i].y, STORE_LOCATIONS[i].z - 1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 76, 114, 114, 200, 0, 0, 0, 0)
			if Vdist(GetEntityCoords(me), STORE_LOCATIONS[i].x, STORE_LOCATIONS[i].y, STORE_LOCATIONS[i].z) < 4.0 then
				DrawSpecialText("Press [ ~b~E~w~ ] to store your aircraft!")
				if IsControlPressed(0, 86) then
					local aircraft = GetVehiclePedIsIn(me, false)
					local hash = GetEntityModel(aircraft)
					if GetPedInVehicleSeat(aircraft, -1) == me and hasAircraftBeenRetrieved(hash) then
						SetEntityAsMissionEntity(aircraft, true, true)
						deleteCar(aircraft)
						storeAircraftInHangar(hash)
						TriggerEvent("usa:notify", "Aircraft stored!")
					end
				end
			end
		end
	end
end)

function deleteCar( entity )
	Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function DrawSpecialText(m_text)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

RegisterNetEvent("airshop:spawnAircraft")
AddEventHandler("airshop:spawnAircraft", function(aircraft, addToRetrievedAircraftList)
	Citizen.Trace("spawning players vehicle...")
	local numberHash = tonumber(aircraft.hash)
	-- thread code stuff below was taken from an example on the wiki
	-- Create a thread so that we don't 'wait' the entire game
	Citizen.CreateThread(function()
		-- Request the model so that it can be spawned
		RequestModel(numberHash)
		-- Check if it's loaded, if not then wait and re-request it.
		while not HasModelLoaded(numberHash) do
			Citizen.Wait(100)
		end
		-- Model loaded, continue
		local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
		for i = 1, #spawnz do
			if Vdist(playerCoords.x, playerCoords.y, playerCoords.z, spawnz[i].x, spawnz[i].y, spawnz[i].z) < 60 then
				spawnX, spawnY, spawnZ = spawnz[i].x, spawnz[i].y, spawnz[i].z
			end
		end
		-- Spawn the vehicle at the gas station car dealership in paleto and assign the vehicle handle to 'vehicle'
		local vehicle = CreateVehicle(numberHash, spawnX, spawnY, spawnZ, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
		-- add to retrieved aircraft list if purchased --
		if addToRetrievedAircraftList then
			print("Inserting " .. aircraft.name .. " into retrieved aircraft list, id: " .. aircraft.id)
			table.insert(RETRIEVED_AIRCRAFT, aircraft)
		end
	end)
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

function drawNotification(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end
