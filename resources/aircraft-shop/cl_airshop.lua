local menu = false
local alreadyCalled = false

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

	while true do

		if(menu) then
			-- title of menu
			TriggerEvent("airshopGUI:Title", "Seaview Aircrafts")
				-- each vehicle the player owns
                for i = 1, #ITEMS do
    				TriggerEvent("airshopGUI:Option", "Retrieve ~y~"..ITEMS[i].name, function(cb)
                        local item = ITEMS[i]
    					if(cb) then
    						Citizen.Trace("Trying to retrieve aircraft...")
    						menu = false
    						if not alreadyCalled then
    							alreadyCalled = true
                                -- call this event with the vehicle.price
    							TriggerServerEvent("airshop:rentVehicle", item)
                                menu = false
    						end
    					else
    					end
    				end)
                end
			TriggerEvent("airshopGUI:Option", "Close Menu", function(cb)
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
			TriggerEvent("airshopGUI:Update")
		end
		Wait(0)
	end
end)


local locations = {
	{ ['x'] = -943.103, ['y'] = -2958.14, ['z'] = 13.9451}
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
	    for _, info in pairs(locations) do
			if GetDistanceBetweenCoords(info['x'], info['y'], info['z'],GetEntityCoords(GetPlayerPed(-1))) < 50 then
				DrawMarker(1, info['x'], info['y'], info['z']-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), info['x'], info['y'], info['z'], true) < 3 then
					DrawSpecialText("Press [ ~b~E~w~ ] to access the aircraft shop!")
					if IsControlPressed(0, 86) then
						Citizen.Wait(500)
						menu = true
					end
				else
                    menu = false
                end
			end
		end
	end
end)

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
        local spawnX, spawnY, spawnZ = -982.552, -2993.78, 13.9451
        -- Spawn the vehicle at the gas station car dealership in paleto and assign the vehicle handle to 'vehicle'
        local vehicle = CreateVehicle(numberHash, spawnX, spawnY, spawnZ, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
        SetVehicleExplodesOnHighExplosionDamage(vehicle, true)
    end)
end)
