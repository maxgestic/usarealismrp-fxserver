local menu = {page = "home", open = false}

local rental = {}

local closest_coords = nil

local first_load = true

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
	},
	["Los Santos"] = {
		rent = {
			x = -782.1,
			y = -1441.0,
			z = 1.6
		},
		return_rental = {
			x = -771.3,
			y = -1413.3,
			z = 1.5,
			heading = 347.428
		},
		spawn = {
			x = -793.2,
			y = -1434.7,
			z = 1.6
		},
		ped = {
			x = -782.1,
			y = -1441.0,
			z = 1.6,
			heading = 312.352,
			model = "amy_beach_01"
		}
	}
}

-- S P A W N  J O B  P E D S
Citizen.CreateThread(function()
	for name, data in pairs(locations) do
		local hash = -771835772
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			Citizen.Wait(100)
		end
		local ped = CreatePed(4, hash, data.ped.x, data.ped.y, data.ped.z, data.ped.heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		TaskSetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetPedRandomComponentVariation(ped, true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HANG_OUT_STREET", 0, true)
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
RegisterNetEvent("boatShop:loadedBoats")
AddEventHandler("boatShop:loadedBoats", function(boats)
	menu.watercraft = boats
	if first_load then
		print("was first load for boats!")
		if menu.watercraft then
			for index = 1, #menu.watercraft do
				menu.watercraft[index].stored = true
			end
		end
		first_load = not first_load
	end
end)
-- end custom events

Citizen.CreateThread(function()
	while true do
		if menu.open then
			-- title of menu
			TriggerEvent("boatshopGUI:Title", "Revsta's Boats")
			if menu.page == "home" then
				TriggerEvent("boatshopGUI:Option", "Rent", function(cb)
					if(cb) then
						menu.page = "rent"
					end
				end)
				TriggerEvent("boatshopGUI:Option", "Purchase", function(cb)
					if(cb) then
						menu.page = "buy"
					end
				end)
				TriggerEvent("boatshopGUI:Option", "Sell", function(cb)
					if(cb) then
						if menu.watercraft then
							print("menu.watercraft existed")
							if #menu.watercraft > 0 then
								print("#menu.watercraft > 0!")
								menu.page = "sell"
							else
								TriggerEvent("usa:notify", "You don't own any watercraft!")
							end
						else
							TriggerEvent("usa:notify", "You don't own any watercraft!")
						end
					end
				end)
				TriggerEvent("boatshopGUI:Option", "My Boats", function(cb)
					if(cb) then
						if menu.watercraft then
							if #menu.watercraft > 0 then
								menu.page = "boats"
							else
								TriggerEvent("usa:notify", "You have no watercraft stored here!")
							end
						else
							TriggerEvent("usa:notify", "You have no watercraft stored here!")
						end
					end
				end)
				TriggerEvent("boatshopGUI:Option", "~y~Close", function(cb)
					if(cb) then
						menu.open = false
						menu.page = "home"
					end
				end)
			elseif menu.page == "rent" then
				-- each boat item
				for i = 1, #(ITEMS.boats) do
					local item = ITEMS.boats[i]
					TriggerEvent("boatshopGUI:Option", "Rent ~y~"..item.name.."~w~ - ~g~$"..comma_value(item.rent), function(cb)
						if(cb) then
							Citizen.Trace("Trying to retrieve boat: " .. item.name)
							local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
							TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
								TriggerServerEvent("boatshop:rentVehicle", item, closest_coords, property)
							end)
							menu.open = false
							menu.page = "home"
							rental = item
						end
					end)
				end
				-- close menu
				TriggerEvent("boatshopGUI:Option", "~y~Back", function(cb)
					if(cb) then
						menu.page = "home"
					end
				end)
				-- close menu
				TriggerEvent("boatshopGUI:Option", "~y~Close Menu", function(cb)
					if(cb) then
						menu.open = false
					end
				end)
			elseif menu.page == "buy" then
				-- each boat item
				for i = 1, #(ITEMS.boats) do
					local item = ITEMS.boats[i]
					TriggerEvent("boatshopGUI:Option", "Buy ~y~"..item.name.."~w~ - ~g~$"..comma_value(item.price), function(cb)
						if(cb) then
							Citizen.Trace("Trying to purchase boat: " .. item.name)
							local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
							TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
								TriggerServerEvent("boatshop:purchaseBoat", item, closest_coords, property)
							end)
							menu.open = false
							menu.page = "home"
						end
					end)
				end
				-- go back
				TriggerEvent("boatshopGUI:Option", "~y~Back", function(cb)
					if(cb) then
						menu.page = "home"
					end
				end)
				-- close menu
				TriggerEvent("boatshopGUI:Option", "~y~Close Menu", function(cb)
					if(cb) then
						menu.open = false
					end
				end)
			elseif menu.page == "sell" then
				-- show boats to sell
				if menu.watercraft then
					for i = 1, #menu.watercraft do
						local item = menu.watercraft[i]
						TriggerEvent("boatshopGUI:Option", "Sell ~y~"..item.name.."~w~ - ~g~$"..comma_value(0.5 * item.price), function(cb)
							if(cb) then
								Citizen.Trace("Trying to sell boat: " .. item.name)
								TriggerServerEvent("boatShop:sellBoat", item)
								menu.page = "home"
							end
						end)
					end
					-- go back
					TriggerEvent("boatshopGUI:Option", "~y~Back", function(cb)
						if(cb) then
							menu.page = "home"
						end
					end)
					-- close menu
					TriggerEvent("boatshopGUI:Option", "~y~Close Menu", function(cb)
						if(cb) then
							menu.open = false
						end
					end)
				end
			elseif menu.page == "boats" then
				-- show boats to retrieve
				if menu.watercraft then
					if #menu.watercraft > 0 then
						for i = 1, #menu.watercraft do
							local item = menu.watercraft[i]
							local store_status = ""
							if item.stored then
								--print("watercraft at " .. i .. " was stored!")
								store_status = "~g~Stored~w~"
							else
								--print("watercraft at " .. i .. " was not stored!")
								store_status = "~y~Not Stored~w~"
							end
							TriggerEvent("boatshopGUI:Option", "Retrieve ~y~"..item.name .. " ~w~(" .. store_status .. ")", function(cb)
								if(cb) then
									Citizen.Trace("Trying to retrieve boat: " .. item.name)
									if item.stored then
										TriggerEvent("boatshop:spawnSeacraft", item, closest_coords, true)
										print("setting watercraft at " .. i .. " stored status to false!")
										menu.watercraft[i].stored = false
										menu.open = false
										menu.page = "home"
									else
										TriggerEvent("usa:notify", "You did not store this vehicle! Can't retrieve.")
									end
								end
							end)
						end
						-- go back
						TriggerEvent("boatshopGUI:Option", "~y~Back", function(cb)
							if(cb) then
								menu.page = "home"
							end
						end)
						-- close menu
						TriggerEvent("boatshopGUI:Option", "~y~Close Menu", function(cb)
							if(cb) then
								menu.open = false
							end
						end)
					else
						TriggerEvent("usa:notify", "You don't have any watercraft!")
					end
				end
			end

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
					menu.open = true
					closest_coords = data.spawn
					print("opening menu! closest coords x = " .. closest_coords.x)
				end
			end
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), data.return_rental.x, data.return_rental.y, data.return_rental.z, true) < 5 then
				DrawSpecialText("Press [ ~b~E~w~ ] to return/store your seacraft!")
				if IsControlPressed(0, 86) then
					Citizen.Wait(500)
					local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
					local hash = GetEntityModel(vehicle)
					print("driving boat with hash: " .. hash)
					if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
						if rental.rent then
							print("player had a boat rental! returning!")
							for i = 1, #ITEMS.boats do
								local item = ITEMS.boats[i]
								if item.hash == hash then
									print("driving boat with hash: " .. hash)
									TriggerServerEvent("boatshop:returnRental", item)
									Citizen.Trace("found matching model")
									SetEntityAsMissionEntity( vehicle, true, true )
									deleteCar( vehicle )
									rental = {}
									break
								end
							end
						else -- not a rented boat
							if menu.watercraft then
								print("player had a withdrawn boat!")
								for j = 1, #menu.watercraft do
									if menu.watercraft[j].hash == hash then
										TriggerEvent("usa:notify", "~g~Have a good day! We'll keep this thing safe!")
										print("matching hash found for withdrawn boat! returning to storage...")
										SetEntityAsMissionEntity( vehicle, true, true )
										deleteCar( vehicle )
										menu.watercraft[j].stored = true
									end
								end
							end
						end
					else
						drawNotification("You must be in the driver's seat.")
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

RegisterNetEvent("boatShop:setPage")
AddEventHandler("boatShop:setPage", function(page_name)
	menu.page = page_name
end)

RegisterNetEvent("boatshop:spawnSeacraft")
AddEventHandler("boatshop:spawnSeacraft", function(boat, coords)
    Citizen.Trace("spawning players vehicle...")
    local numberHash = tonumber(boat.hash)
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
