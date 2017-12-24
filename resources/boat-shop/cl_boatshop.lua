local menu = false
local alreadyCalled = false
local rental = {}

local closest_coords = nil

local locations = {
	["Paleto"] = {
		rent = {
			x = -250.183,
			y = 6632.84,
			z = 1.79
		},
		return_rental = {
			x = -239.193,
			y = 6681.12,
			z = 1.3,
			heading = 347.428
		},
		spawn = {
			x = -250.868,
			y = 6684.84,
			z = 0.2
		},
		ped = {
			x = -250.183,
			y = 6632.84,
			z = 1.79,
			heading = 312.352,
			model = "amy_beach_01"
		}
	},
	["Sandy"] = {
		rent = {
			x = 2391.79,
			y = 4287.11,
			z = 31.9
		},
		return_rental = {
			x = 2334.57,
			y = 4243.26,
			z = 31.2,
			heading = 347.428
		},
		spawn = {
			x = 2356.78,
			y = 4284.52,
			z = 29.5
		},
		ped = {
			x = 2391.79,
			y = 4287.11,
			z = 31.9,
			heading = 312.352,
			model = "amy_beach_01"
		}
	}
}

-- S P A W N  J O B  P E D S
Citizen.CreateThread(function()
	for name, data in pairs(locations) do
		local hash = -771835772
		print("spawing boat ped, name = " .. name)
		--local hash = GetHashKey(data.ped.model)
		print("requesting hash...")
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end
		print("spawning ped, heading: " .. data.ped.heading)
		print("hash: " .. hash)
		local ped = CreatePed(4, hash, data.ped.x, data.ped.y, data.ped.z, data.ped.heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		TaskSetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetEntityInvincible(ped)
		SetPedRandomComponentVariation(ped, true)
	end
end)

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
						print("alreadyCalled = " .. tostring(alreadyCalled))
						if not alreadyCalled then
							alreadyCalled = true
							drawNotification("Here is your rental! You can return it for cash back just over there at the blue circle.")
							TriggerServerEvent("boatshop:rentVehicle", item, closest_coords)
							menu = false
							rental = item
							alreadyCalled = false
						end
					else
					end
				end)
			end

			-- close menu
			TriggerEvent("boatshopGUI:Option", "Close Menu", function(cb)
				if(cb) then
					menu = false
					alreadyCalled = false
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
		-- for accessing shops
		for name, data in pairs(locations) do
			DrawMarker(1, data.rent.x, data.rent.y, data.rent.z-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0) -- for rental
			DrawMarker(1, data.return_rental.x, data.return_rental.y, data.return_rental.z-0.5, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0) -- for return
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), data.rent.x, data.rent.y, data.rent.z, true) < 3 then
				DrawSpecialText("Press [ ~b~E~w~ ] to access Revsta's Boat Shop!")
				if IsControlPressed(0, 86) then
					Citizen.Wait(500)
					menu = true
					closest_coords = data.spawn
					print("opening menu! closest coords x = " .. closest_coords.x)
				end
			end
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), data.return_rental.x, data.return_rental.y, data.return_rental.z, true) < 5 then
				DrawSpecialText("Press [ ~b~E~w~ ] to return your seacraft rental!")
				if IsControlPressed(0, 86) then
					Citizen.Wait(500)
					if rental.price then
						local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
						local hash = GetEntityModel(vehicle)
						if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
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
						else
							drawNotification("You must be in the driver's seat.")
						end
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

RegisterNetEvent("boatshop:spawnSeacraft")
AddEventHandler("boatshop:spawnSeacraft", function(hash, coords)
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
        local vehicle = CreateVehicle(numberHash, coords.x, coords.y, coords.z, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
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
