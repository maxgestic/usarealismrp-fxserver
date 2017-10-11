local menu = false
local alreadyCalled = false
local rental = {}

local locations = {
	{ ['x'] = -782.598, ['y'] = -1482.14, ['z'] = 2.08597}
}

local returnLocations = {
    {x = -715.599, y = -1346.63, z = 1.565076}
}

local seacraftSpawnLocation = {
	x = -810.809,
	y = -1480.39,
	z = 1.399703
}

RegisterNetEvent("boatshopGUI:Title")
AddEventHandler("boatshopGUI:Title", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("boatshopGUI:Option")
AddEventHandler("boatshopGUI:Option", function(option, cb)
	cb(Menu.Option(option))
end)

RegisterNetEvent("boatshopGUI:Bool")
AddEventHandler("boatshopGUI:Bool", function(option, bool, cb)
	Menu.Bool(option, bool, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("boatshopGUI:Int")
AddEventHandler("boatshopGUI:Int", function(option, int, min, max, cb)
	Menu.Int(option, int, min, max, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("boatshopGUI:StringArray")
AddEventHandler("boatshopGUI:StringArray", function(option, array, position, cb)
	Menu.StringArray(option, array, position, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("boatshopGUI:Update")
AddEventHandler("boatshopGUI:Update", function()
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

	while true do
		if(menu) then

			-- title of menu
			TriggerEvent("boatshopGUI:Title", "Revsta's Boats")

        	-- each boat item
            for i = 1, #(ITEMS.boats) do
                local item = ITEMS.boats[i]
            	TriggerEvent("boatshopGUI:Option", "Rent ~y~"..item.name.."~w~ - ~g~$"..comma_value(item.price), function(cb)
            		if(cb) then
            			Citizen.Trace("Trying to retrieve boat: " .. item.name)
            			menu = false
            			if not alreadyCalled then
            				alreadyCalled = true
                            -- call this event with the vehicle.price
							drawNotification("Here is your rental! You can return it for cash back just around the corner at the green circle.")
            				TriggerServerEvent("boatshop:rentVehicle", item)
                            menu = false
                            rental = item
            			end
            		else
            		end
            	end)
            end

            -- close menu
			TriggerEvent("boatshopGUI:Option", "Close Menu", function(cb)
				if(cb) then
					menu = false
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
			TriggerEvent("boatshopGUI:Update")
		end
		Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        DrawMarker(1, returnLocations[1].x, returnLocations[1].y, returnLocations[1].z-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 76, 144, 114, 200, 0, 0, 0, 0) -- for returning the rental
	    for _, info in pairs(locations) do
			if GetDistanceBetweenCoords(info['x'], info['y'], info['z'],GetEntityCoords(GetPlayerPed(-1))) < 50 then
				DrawMarker(1, info['x'], info['y'], info['z']-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), info['x'], info['y'], info['z'], true) < 3 then
					DrawSpecialText("Press [ ~b~E~w~ ] to access Revsta's Boat Shop!")
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
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), returnLocations[1].x, returnLocations[1].y, returnLocations[1].z, true) < 5 then
            DrawSpecialText("Press [ ~b~E~w~ ] to return your seacraft rental!")
            if IsControlPressed(0, 86) then
                Citizen.Wait(500)
                --if rental.price then
                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    local hash = GetEntityModel(vehicle)

                    for i = 1, #ITEMS.boats do
                        local item = ITEMS.boats[i]
                        if item.hash == hash then
                            TriggerServerEvent("boatshop:returnedVehicle", item)
                            Citizen.Trace("found matching model")
                            SetEntityAsMissionEntity( vehicle, true, true )
                            deleteCar( vehicle )
							rental = {}
                            break
                        end
                    end
                --end
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

RegisterNetEvent("boatshop:spawnSeacraft")
AddEventHandler("boatshop:spawnSeacraft", function(hash)
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
        -- Spawn the vehicle at the gas station car dealership in paleto and assign the vehicle handle to 'vehicle'
        local vehicle = CreateVehicle(numberHash, seacraftSpawnLocation.x, seacraftSpawnLocation.y, seacraftSpawnLocation.z, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
        SetVehicleExplodesOnHighExplosionDamage(vehicle, true)
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
