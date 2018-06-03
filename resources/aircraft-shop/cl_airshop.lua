local menu = false
local alreadyCalled = false
local rental = {}

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
--[[
RegisterNetEvent("garage:openMenuWithVehiclesLoaded")
AddEventHandler("garage:openMenuWithVehiclesLoaded", function(userVehicles)
	ownedVehicles = userVehicles
	alreadyCalled = false
	menu = true
end)
--]]
-- end custom events

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

                -- heli menu
    			TriggerEvent("airshopGUI:Option", "Heli Menu", function(cb)
    				if(cb) then
    					menuName = "heli"
    				end
    			end)

                -- plane menu
    			TriggerEvent("airshopGUI:Option", "Plane Menu", function(cb)
    				if(cb) then
    					menuName = "plane"
    				end
    			end)

            end

            if menuName ~= "home" then
                if menuName == "heli" then
        			-- each helicopter item
                    for i = 1, #(ITEMS.helicopters) do
                        local item = ITEMS.helicopters[i]
            			TriggerEvent("airshopGUI:Option", "Rent ~y~"..item.name.."~w~ - ~g~$"..comma_value(item.price), function(cb)
            				if(cb) then
            					Citizen.Trace("Trying to retrieve aircraft: " .. item.name)
            					menu = false
            					if not alreadyCalled then
            						alreadyCalled = true
                                    local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
									TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
            							TriggerServerEvent("airshop:rentVehicle", item, property)
									end)
                                    menu = false
                                    rental = item
            					end
            				else
            				end
            			end)
                    end
                    -- back btn
        			TriggerEvent("airshopGUI:Option", "Back", function(cb)
        				if(cb) then
                            menuName = "home"
        				end
        			end)
                elseif menuName == "plane" then
                    -- each plane item
                    for i = 1, #(ITEMS.planes) do
                        local item = ITEMS.planes[i]
                        TriggerEvent("airshopGUI:Option", "Rent ~y~"..item.name.."~w~ - ~g~$"..comma_value(item.price), function(cb)
                            if(cb) then
                                Citizen.Trace("Trying to retrieve aircraft: " .. item.name)
                                menu = false
                                if not alreadyCalled then
                                    alreadyCalled = true
                                    -- call this event with the vehicle.price
									drawNotification("Here is your rental! You can return it for cash back at the green circle over there.")
                                    TriggerServerEvent("airshop:rentVehicle", item)
                                    menu = false
                                    rental = item
                                end
                            else
                            end
                        end)
                    end
                    -- back btn
        			TriggerEvent("airshopGUI:Option", "Back", function(cb)
        				if(cb) then
                            menuName = "home"
        				end
        			end)
                end
            end

            -- close menu
			TriggerEvent("airshopGUI:Option", "Close Menu", function(cb)
				if(cb) then
					menu = false
                    menuName = "home"
				end
			end)

			--[[
			TriggerEvent("GUI:Bool", "bool", bool, function(cb)
				bool = cb
			end)

			TriggerEvent("GUI:Int", "int", int, 0, 55, function(cb)
				int = cb
			end)

			TriggerEvent("GUI:StringArray", "string:", array, position, function(cb)
				position = cb
			end)
			--]]
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
	while true do
		Citizen.Wait(0)
		for _, info in pairs(returnLocations) do
			DrawMarker(1, info['x'], info['y'], info['z']-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 76, 144, 114, 200, 0, 0, 0, 0) -- for returning the rental
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), info['x'], info['y'], info['z'], true) < 5 then
	            DrawSpecialText("Press [ ~b~E~w~ ] to return your aircraft rental!")
	            if IsControlPressed(0, 86) then
	                Citizen.Wait(500)
	                if rental.price then
	                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	                    local hash = GetEntityModel(vehicle)
						if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
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
	    for _, info in pairs(locations) do
			if GetDistanceBetweenCoords(info['x'], info['y'], info['z'],GetEntityCoords(GetPlayerPed(-1))) < 50 then
				DrawMarker(1, info['x'], info['y'], info['z']-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), info['x'], info['y'], info['z'], true) < 3 then
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
AddEventHandler("airshop:spawnAircraft", function(hash)
    Citizen.Trace("spawning players vehicle...")
    local numberHash = tonumber(hash)
    -- thread code stuff below was taken from an example on the wiki
    -- Create a thread so that we don't 'wait' the entire game
    Citizen.CreateThread(function()
        -- Request the model so that it can be spawned
        RequestModel(numberHash)
        -- Check if it's loaded, if not then wait and re-request it.
        while not HasModelLoaded(numberHash) do
            RequestModel(numberHash)
            Citizen.Wait(0)
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
