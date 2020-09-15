local boats = {
    {name = "Nagasaki Dinghy", price =15000, rent = 2000, hash =  1033245328, stored = false},
    {name = "Nagasaki Dinghy 2", price =15000, rent = 2000, hash =  276773164, stored = false},
    {name = "Dinka Marquis", price = 30000, rent = 5000, hash =  -1043459709, stored = false},
    {name = "Speedophile Seashark", price = 5000, rent = 900, hash =  -1030275036, stored = false},
    {name = "Cuban Jetmax", price = 35000, rent =  7500, hash =  861409633, stored = false},
    {name = "Lampadati Toro", price = 60000, rent = 9000, hash =  1070967343, stored = false},
    {name = "Lampadati Toro 2", price = 60000, rent = 9000, hash =  908897389, stored = false},
    {name = "Tug", price = 200000, rent = 10000, hash = -2100640717, stored = false},
    {name = "Shitzu Squalo", price = 40000, rent = 7500, hash = 400514754, stored = false},
    {name = "Shitzu Tropic", price = 40000, rent = 7500, hash =  1448677353, stored = false},
    {name = "Shitzu Suntrap", price = 30000, rent = 5500, hash =  -282946103, stored = false},
    {name = "Submersible", price =750000, rent = 20000, hash = 771711535, stored = false},
    {name = "Submersible 2", price =750000, rent = 20000, hash = -1066334226, stored = false}
}

local playerBoats = {}
local closestShop = nil
local MENU_OPEN_KEY = 38

---------------------------
-- Set up main menu --
---------------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Boats", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

local rentals = {}

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
			z = 0.9,
			heading = 347.428
		},
		spawn = {
			x = -250.868,
			y = 6684.84,
			z = 0.2
		},
		ped = {
			x = -250.183,
			y = 6631.84,
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
	},
	["Los Santos (Small Lake)"] = {
		rent = {
			x = -193.3, y = 790.1, z = 198.1
		},
		return_rental = {
			x = -208.3, y = 804.9, z = 197.2,
			heading = 347.428
		},
		spawn = {
			x = -198.8, y = 783.6, z = 195.9
		},
		ped = {
			x = -193.3, y = 790.1, z = 198.1,
			heading = 312.352,
			model = "amy_beach_01"
		}
	}
}

-- S P A W N  J O B  P E D S
local createdJobPeds = {}
Citizen.CreateThread(function()
	while true do
		local playerCoords = GetEntityCoords(PlayerPedId(), false)
		for name, data in pairs(locations) do
			if Vdist(data.ped.x, data.ped.y, data.ped.z, playerCoords.x, playerCoords.y, playerCoords.z) < 50 then
				if not createdJobPeds[name] then
					local hash = -771835772
					RequestModel(hash)
					while not HasModelLoaded(hash) do
						Wait(100)
					end
					local ped = CreatePed(4, hash, data.ped.x, data.ped.y, data.ped.z, data.ped.heading, false, true)
					SetEntityCanBeDamaged(ped,false)
					SetPedCanRagdollFromPlayerImpact(ped,false)
					TaskSetBlockingOfNonTemporaryEvents(ped,true)
					SetPedFleeAttributes(ped,0,0)
					SetPedCombatAttributes(ped,17,1)
					SetPedRandomComponentVariation(ped, true)
					TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HANG_OUT_STREET", 0, true)
					createdJobPeds[name] = ped
				end
			else 
				if createdJobPeds[name] then
					DeletePed(createdJobPeds[name])
					createdJobPeds[name] = nil
				end
			end
		end
		Wait(1)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		-- for accessing shops
		for name, data in pairs(locations) do
			DrawText3D(data.rent.x, data.rent.y, data.rent.z, 8, '[E] - Boat Management')
			DrawText3D(data.return_rental.x, data.return_rental.y, data.return_rental.z, 30, '[E] - Return Boat')
			if IsControlJustPressed(0, MENU_OPEN_KEY) then
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), data.return_rental.x, data.return_rental.y, data.return_rental.z, true) < 5 then
					Citizen.Wait(500)
					local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
					local hash = GetEntityModel(vehicle)
					if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
						local wasRental = false
						for i = 1, #rentals do
							local item = rentals[i]
							if item.hash == hash then
								print("player had a boat rental! returning!")
								print("driving boat with hash: " .. hash)
								TriggerServerEvent("boatMenu:returnRental", item)
								Citizen.Trace("found matching model")
								TriggerEvent('usa:notify', 'You have been returned ~y~$'..comma_value(rentals[i].rent*0.25)..'.0~s~!')
								SetEntityAsMissionEntity( vehicle, true, true )
								deleteCar( vehicle )
								table.remove(rentals, i)
								wasRental = true
								break
							end
						end
						if not wasRental then
							local wasOwned = false
							for j = 1, #playerBoats do
								print("player had a withdrawn boat!")
								if playerBoats[j].hash == hash and not playerBoats[j].stored then
									TriggerEvent("usa:notify", "Your watercraft has been ~y~stored~s~.")
									print("matching hash found for withdrawn boat! returning to storage...")
									SetEntityAsMissionEntity( vehicle, true, true )
									deleteCar( vehicle )
									playerBoats[j].stored = true
									wasOwned = true
									break
								end
							end
							if not wasOwned then
								TriggerEvent("usa:notify", "This watercraft has been ~y~stored~s~.")
								print('plane not in player planes')
								SetEntityAsMissionEntity( vehicle, true, true )
								deleteCar( vehicle )
							end
						end
					else
						TriggerEvent('usa:notify', "You must be in the driver's seat.")
					end
				elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), data.rent.x, data.rent.y, data.rent.z, true) < 5 then
          Wait(500)
          if not IsControlPressed(0, MENU_OPEN_KEY) then -- E pressed
  					TriggerServerEvent('boatMenu:requestOpenMenu')
  					closestShop = name
          else -- E held
            TriggerServerEvent("boats:purchaseLicense")
          end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do

		-- Process Menu --
		_menuPool:MouseControlsEnabled(false)
		_menuPool:ControlDisablingEnabled(false)
		_menuPool:ProcessMenus()
		-----------------------

		if closestShop then
			local mycoords = GetEntityCoords(GetPlayerPed(-1))
		    if Vdist(locations[closestShop].rent.x, locations[closestShop].rent.y, locations[closestShop].rent.z, mycoords.x, mycoords.y, mycoords.z) > 5.0 then
		  		if _menuPool:IsAnyMenuOpen() then
		  			closestShop = nil
		  			_menuPool:CloseAllMenus()
		  		end
			end
		end
		Wait(0)
	end
end)

RegisterNetEvent("boatMenu:spawnSeacraft")
AddEventHandler("boatMenu:spawnSeacraft", function(boat)
    local playerCoords = GetEntityCoords(PlayerPedId())
	local numberHash = tonumber(boat.hash)
    Citizen.CreateThread(function()
        RequestModel(numberHash)
        while not HasModelLoaded(numberHash) do
            RequestModel(numberHash)
            Citizen.Wait(0)
        end
        for name, info in pairs(locations) do
        	if Vdist(info.rent.x, info.rent.y, info.rent.z, playerCoords) < 5 then
		        local vehicle = CreateVehicle(numberHash, info.spawn.x, info.spawn.y, info.spawn.z, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
				TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
				SetVehicleExplodesOnHighExplosionDamage(vehicle, true)
		        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		        SetEntityAsMissionEntity(vehicle, true, true)
		        local vehicle_key = {
    					name = "Key -- " .. GetVehicleNumberPlateText(vehicle),
    					quantity = 1,
    					type = "key",
    					owner = "GOVT",
    					make = "GOVT",
    					model = "GOVT",
    					plate = GetVehicleNumberPlateText(vehicle)
    				}
    				-- give key to owner
    				TriggerServerEvent("garage:giveKey", vehicle_key)
		        return
		    end
	    end
    end)
end)

RegisterNetEvent('boatMenu:loadedBoats')
AddEventHandler('boatMenu:loadedBoats', function(userBoats)
	playerBoats = userBoats
	if first_load then
		if playerBoats then
			for index = 1, #playerBoats do
				playerBoats[index].stored = true
			end
		end
		first_load = not first_load
	end
end)

RegisterNetEvent('boatMenu:rentBoat')
AddEventHandler('boatMenu:rentBoat', function(index)
	local playerCoords = GetEntityCoords(PlayerPedId())
	table.insert(rentals, boats[index])
	local numberHash = tonumber(boats[index].hash)
    Citizen.CreateThread(function()
        RequestModel(numberHash)
        while not HasModelLoaded(numberHash) do
            RequestModel(numberHash)
            Citizen.Wait(0)
        end
        for name, info in pairs(locations) do
        	if Vdist(info.rent.x, info.rent.y, info.rent.z, playerCoords) < 5 then
		        local vehicle = CreateVehicle(numberHash, info.spawn.x, info.spawn.y, info.spawn.z, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
				TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
				SetVehicleExplodesOnHighExplosionDamage(vehicle, true)
            local vehicle_key = {
    					name = "Key -- " .. GetVehicleNumberPlateText(vehicle),
    					quantity = 1,
    					type = "key",
    					owner = "GOVT",
    					make = "GOVT",
    					model = "GOVT",
    					plate = GetVehicleNumberPlateText(vehicle)
    				}
    				-- give key to owner
    				TriggerServerEvent("garage:giveKey", vehicle_key)
		        return
		    end
	     end
    end)
end)

RegisterNetEvent('boatMenu:openMenu')
AddEventHandler('boatMenu:openMenu', function(watercraft)
  playerBoats = watercraft
	ShowMainMenu()
end)

function deleteCar( entity )
	TriggerEvent('persistent-vehicles/forget-vehicle', entity)
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
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

function ShowMainMenu()
	mainMenu:Clear()
	CreateRentMenu(mainMenu, boats)
	CreateBuyMenu(mainMenu, boats)
	CreateSellMenu(mainMenu, playerBoats)
	CreateGarageMenu(mainMenu, playerBoats)
	local buyFishingPoleBtn = NativeUI.CreateItem("Buy fishing pole", "Press K to fish when on a boat.")
	buyFishingPoleBtn.Activated = function(parentmenu, selected)
		TriggerServerEvent("boatMenu:buyFishingPole")
	end
	mainMenu:AddItem(buyFishingPoleBtn)
	mainMenu:Visible(not mainMenu:Visible())
end

function CreateRentMenu(menu, vehicles)
	local rentMenu = _menuPool:AddSubMenu(menu, "Rent a Boat", '', true)
	for i = 1, #boats do
		local boat = boats[i]
		local item = NativeUI.CreateItem(boat.name, 'Rent price: $' ..comma_value(boat.rent))
		item.Activated = function(parentmenu, selected)
			TriggerServerEvent("boatMenu:requestRent", boat, i)
		end
		rentMenu.SubMenu:AddItem(item)
	end
end

function CreateBuyMenu(menu, vehicles)
	local buyMenu = _menuPool:AddSubMenu(menu, 'Buy a Boat', '', true)
	for i = 1, #boats do
		local boat = boats[i]
		local item = NativeUI.CreateItem(boat.name, 'Purchase price: $' ..comma_value(boat.price))
		item.Activated = function(parentmenu, selected)
			TriggerServerEvent('boatMenu:requestPurchase', boat)
			buyMenu.SubMenu:Visible(false)
		end
		buyMenu.SubMenu:AddItem(item)
	end
end

function CreateSellMenu(menu, vehicles)
	local sellMenu = _menuPool:AddSubMenu(menu, 'Sell a Boat', '', true)
	for i = 1, #playerBoats do
		local boat = playerBoats[i]
		local boatid = '('..boat.id..')'
		local item = NativeUI.CreateItem(boat.name.. ' ' ..boatid, 'Sell value: $' ..comma_value(0.5*boat.price))
		item.Activated = function(parentmenu, selected)
			if boat.stored then
				TriggerServerEvent('boatMenu:requestSell', boat)
				sellMenu.SubMenu:Visible(false)
			else
				TriggerEvent('usa:notify', 'This boat is ~y~not stored~s~, cannot be sold!')
			end
		end
		sellMenu.SubMenu:AddItem(item)
	end
	if #playerBoats <= 0 then
		local item = NativeUI.CreateItem("Nothing to sell!", "You don't own any watercraft to sell!")
		sellMenu.SubMenu:AddItem(item)
	end
end

function CreateGarageMenu(menu, vehicles)
	local retrieveMenu = _menuPool:AddSubMenu(menu, 'Retrieve a Boat', '', true)
	for i = 1, #playerBoats do
		local boat = playerBoats[i]
		local store_status = ''
		if boat.stored then
			store_status = '(~g~Stored~s~)'
		else
			store_status = '(~r~Not Stored~s~)'
		end
		local item = NativeUI.CreateItem('Retrieve ' .. boat.name .. ' ' .. store_status, 'Boat ID: '..boat.id)
		retrieveMenu.SubMenu:AddItem(item)
		item.Activated = function(parentmenu, selected)
			if boat.stored then
				TriggerEvent("boatMenu:spawnSeacraft", boat)
				TriggerEvent('usa:notify', 'Alright, boat is waiting in the water.')
				boat.stored = false
				retrieveMenu.SubMenu:Visible(false)
			else
				TriggerEvent('usa:notify', 'This watercraft is ~y~not stored~s~!')
			end
		end
	end
	if #playerBoats <= 0 then
		local item = NativeUI.CreateItem("Nothing to retrieve!", "You don't own any watercraft to retrieve!")
		retrieveMenu.SubMenu:AddItem(item)
	end
end

function DrawText3D(x, y, z, distance, text)
    if Vdist(GetEntityCoords(PlayerPedId()), x, y, z, true) < distance then
        local onScreen,_x,_y=World3dToScreen2d(x,y,z)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
    end
end

----------------------
---- Set up blips ----
----------------------
for k, v in pairs(locations) do
	local blip = AddBlipForCoord(locations[k].rent.x, locations[k].rent.y, locations[k].rent.z)
	SetBlipSprite(blip, 410)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Boat Shop')
	EndTextCommandSetBlipName(blip)
end