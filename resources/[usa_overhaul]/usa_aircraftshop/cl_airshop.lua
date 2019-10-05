ITEMS = {
    helicopters = {
        {name = "Havok", price = 6000, buy_price = 95000, hash = GetHashKey("havok")},
        {name = "Frogger", price = 8000, buy_price = 175000, hash = 744705981},
        {name = "Supervolito", price = 9000, buy_price = 400000, hash = 710198397},
        {name = "Swift", price = 10000, buy_price = 275000, hash = -339587598},
        {name = "Swift 2", price = 10500, buy_price = 600000, hash =  1075432268},
        {name = "Volatus", price = 11000, buy_price = 660000, hash =  -1845487887}
    },
    planes = {
        {name = "Cuban 800", price = 6000, buy_price = 100000, hash = -644710429},
        {name = "Dodo", price = 6000, buy_price = 95000, hash =  -901163259},
        {name = "Duster", price = 5000, buy_price = 80000, hash =  970356638},
        {name = "Mammatus", price = 6000, buy_price = 140000, hash =  -1746576111},
        {name = "Stunt", price = 10000, buy_price = 900000, hash =  -2122757008},
        {name = "Microlight", price = 2000, buy_price = 55000, hash = GetHashKey("microlight")},
        {name = "Alpha Z1", price = 10000, buy_price = 110000, hash = GetHashKey("alphaz1")},
        {name = "Seabreeze", price = 9000, buy_price = 90000, hash = GetHashKey("seabreeze")},
        {name = "Velum", price = 7000, buy_price = 325000, hash =  -1673356438},
        {name = "Vestra", price = 15000, buy_price = 750000, hash =  1341619767},
        {name = "Nimbus", price = 30000, buy_price = 900000, hash =  -1295027632},
        {name = "Shamal", price = 30000, buy_price = 450000, hash =  -1214505995},
        {name = "Luxor", price = 30000, buy_price = 3000000, hash =  621481054},
        {name = "Luxor 2", price = 30000, buy_price = 3500000, hash =  -1214293858}
        --{name = "747 Jet", price = 8000000, hash =  1058115860}
    }
}

-- NOTE: price = rental price, buy_price = purchase price

local playerAircraft = {}
local closestShop = nil
local created_menus = {}
local MENU_OPEN_KEY = 38
local MAP_BLIP_SPRITE = 251

---------------------------
-- Set up main menu --
---------------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Aircrafts", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

local rentals = {}

local first_load = true

local locations = {
	["LSIA"] = {
		menu = {
			x = -934.707,
			y = -2970.07,
			z = 13.94
		},
		returns = {
			x = -969.7,
      y = -3035.3,
      z = 13.9
		},
		spawn = {
			x = -961.35,
			y = -3005.83,
			z = 13.94,
			heading = 60.0
		},
		ped = {
			x = -934.21,
			y = -2969.63,
			z = 12.94,
			heading = 150.352,
			model = "IG_BARRY"
		}
	},
	['Grapeseed Airfield'] = {
		menu = {
			x = 2136.97,
			y = 4798.02,
			z = 41.14
		},
		returns = {
			x = 2139.26,
			y = 4816.28,
			z = 41.20
		},
		spawn = {
			x = 2119.57,
			y = 4803.21,
			z = 41.19,
			heading = 110.0
		},
		ped = {
			x = 2137.40,
			y = 4797.59,
			z = 40.11,
			heading = 40.0,
			model = 'U_M_Y_PARTY_01'
		}
	},
	['Sandy Shores Airfield'] = {
		menu = {
			x = 1725.93,
			y = 3290.35,
			z = 41.14
		},
		returns = {
			x = 1737.44,
			y = 3288.68,
			z = 41.14
		},
		spawn = {
			x = 1729.62,
			y = 3259.38,
			z = 41.22,
			heading = 100.0
		},
		ped = {
			x = 1725.04,
			y = 3290.86,
			z = 40.14,
			heading = 230.0,
			model = 'A_M_M_MALIBU_01'
		}
	}
}

-- S P A W N  J O B  P E D S
Citizen.CreateThread(function()
	for name, data in pairs(locations) do
		local hash = GetHashKey(data.ped.model)
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


Citizen.CreateThread(function()
	while true do
		-- for accessing shops
		for name, data in pairs(locations) do
      local dist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), data.returns.x, data.returns.y, data.returns.z, true)
			DrawText3D(data.menu.x, data.menu.y, data.menu.z, 8, '[E] - Aircraft Management')
			DrawText3D(data.returns.x, data.returns.y, data.returns.z, 30, '[E] - Return personal / rented aircraft')
      if dist < 70 then
        DrawMarker(1, data.returns.x, data.returns.y, data.returns.z-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 76, 144, 114, 200, 0, 0, 0, 0)
      end
			if IsControlJustPressed(0, MENU_OPEN_KEY) then
				if dist < 5 then
					Citizen.Wait(500)
					local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
					local hash = GetEntityModel(vehicle)
					if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
						local wasRental = false
						for i = 1, #rentals do
							local item = rentals[i]
							if rentals[i].hash == hash then
								print("player has a plane rental! returning!")
								print("driving plane with hash: " .. hash)
								TriggerServerEvent("aircraft:returnRental", item)
								Citizen.Trace("found matching model")
								TriggerEvent('usa:notify', 'You have been returned ~y~$'..comma_value(rentals[i].price*0.25)..'~s~!')
								SetEntityAsMissionEntity( vehicle, true, true )
								deleteCar( vehicle )
								table.remove(rentals, i)
								wasRental = true
								break
							end
						end
						if not wasRental then
							local wasOwned = false
							for j = 1, #playerAircraft do
								print("player had a withdrawn plane!")
								if playerAircraft[j].hash == hash and not playerAircraft[j].stored then
									TriggerEvent("usa:notify", "Your aircraft has been ~y~stored~s~.")
									print("matching hash found for withdrawn plane! returning to storage...")
									SetEntityAsMissionEntity( vehicle, true, true )
									deleteCar( vehicle )
									playerAircraft[j].stored = true
									wasOwned = true
									break
								end
							end
							if not wasOwned then
								TriggerEvent("usa:notify", "This aircraft has been ~y~stored~s~.")
								print('plane not in player planes')
								SetEntityAsMissionEntity( vehicle, true, true )
								deleteCar( vehicle )
							end
						end
					else
						TriggerEvent('usa:notify', "You must be in the driver's seat.")
					end
				elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), data.menu.x, data.menu.y, data.menu.z, true) < 5 then
          Wait(500)
          if not IsControlPressed(0, MENU_OPEN_KEY) then -- E not pressed
  					TriggerServerEvent('aircraft:requestOpenMenu')
  					closestShop = name
          else -- E held
             local business = exports["usa-businesses"]:GetClosestStore(15)
            TriggerServerEvent("aircraft:purchaseLicense", business)
          end
				end
			end
		end
    Wait(1)
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
		    if Vdist(locations[closestShop].menu.x, locations[closestShop].menu.y, locations[closestShop].menu.z, mycoords.x, mycoords.y, mycoords.z) > 5.0 then
		  		if _menuPool:IsAnyMenuOpen() then
					  closestShop = nil
					  _menuPool:CloseAllMenus()
		  		end
			end
		end
		Wait(0)
	end
end)


RegisterNetEvent("aircraft:spawnAircraft")
AddEventHandler("aircraft:spawnAircraft", function(aircraft)
    local playerCoords = GetEntityCoords(PlayerPedId())
	local numberHash = tonumber(aircraft.hash)
    Citizen.CreateThread(function()
        RequestModel(numberHash)
        while not HasModelLoaded(numberHash) do
            RequestModel(numberHash)
            Citizen.Wait(0)
        end
        for name, info in pairs(locations) do
        	if Vdist(info.menu.x, info.menu.y, info.menu.z, playerCoords) < 5 then
		        local vehicle = CreateVehicle(numberHash, info.spawn.x, info.spawn.y, info.spawn.z, info.spawn.heading --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
		        SetVehicleExplodesOnHighExplosionDamage(vehicle, true)
		        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		        SetEntityAsMissionEntity(vehicle)
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

RegisterNetEvent('aircraft:loadedAircraft')
AddEventHandler('aircraft:loadedAircraft', function(userPlanes)
	print('loading planes dawgg')
	playerAircraft = userPlanes
	if first_load then
		print("was first load for planes!")
		if playerAircraft then
			for index = 1, #playerAircraft do
				playerAircraft[index].stored = true
			end
		end
		first_load = not first_load
	end
end)

RegisterNetEvent('aircraft:rentAircraft')
AddEventHandler('aircraft:rentAircraft', function(aircraft)
	local playerCoords = GetEntityCoords(PlayerPedId())
	print(aircraft.name)
	table.insert(rentals, aircraft)
	print(#rentals)
	local numberHash = tonumber(aircraft.hash)
    Citizen.CreateThread(function()
        RequestModel(numberHash)
        while not HasModelLoaded(numberHash) do
            RequestModel(numberHash)
            Citizen.Wait(0)
        end
        for name, info in pairs(locations) do
        	if Vdist(info.menu.x, info.menu.y, info.menu.z, playerCoords) < 5 then
		        local vehicle = CreateVehicle(numberHash, info.spawn.x, info.spawn.y, info.spawn.z, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
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

RegisterNetEvent('aircraft:openMenu')
AddEventHandler('aircraft:openMenu', function()
	ShowMainMenu()
end)

TriggerServerEvent("aircraft:loadAircraft", GetPlayerServerId(PlayerId()))

function deleteCar( entity )
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
	CreateHelicopterMenu(mainMenu, ITEMS.helicopters)
	CreatePlaneMenu(mainMenu, ITEMS.planes)
	CreateSellMenu(mainMenu, playerAircraft)
	CreateGarageMenu(mainMenu, playerAircraft)
	mainMenu:Visible(not mainMenu:Visible())
end

function CreatePlaneMenu(menu, vehicles)
	local planes = _menuPool:AddSubMenu(menu, "Airplanes", 'See our selection of airplanes', true)
	for i = 1, #vehicles do
		local aircraft = vehicles[i]
		local planeMenu = _menuPool:AddSubMenu(planes.SubMenu, aircraft.name, 'View prices of the '..aircraft.name, true)
		local rent = NativeUI.CreateItem('Rent '..aircraft.name, 'Rent price: $' ..comma_value(aircraft.price))
		local buy = NativeUI.CreateItem('Buy '..aircraft.name, 'Buy price: $'..comma_value(aircraft.buy_price))
		rent.Activated = function(parentmenu, selected)
			local business = exports["usa-businesses"]:GetClosestStore(15)
			TriggerServerEvent('aircraft:requestRent', aircraft, business)
			planeMenu.SubMenu:Visible(false)
		end
		buy.Activated = function(parentmenu, selected)
            local business = exports["usa-businesses"]:GetClosestStore(15)
			TriggerServerEvent('aircraft:requestPurchase', aircraft, business)
			planeMenu.SubMenu:Visible(false)
		end
		planeMenu.SubMenu:AddItem(rent)
		planeMenu.SubMenu:AddItem(buy)
		planes.SubMenu:AddItem(planeMenu.SubMenu)
	end
end

function CreateHelicopterMenu(menu, vehicles)
	local helicopters = _menuPool:AddSubMenu(menu, "Helicopters", 'See our selection of helicopters', true)
	for i = 1, #vehicles do
		local aircraft = vehicles[i]
		local heliMenu = _menuPool:AddSubMenu(helicopters.SubMenu, aircraft.name, 'View prices of the '..aircraft.name, true)
		local rent = NativeUI.CreateItem('Rent '..aircraft.name, 'Rent price: $' ..comma_value(aircraft.price))
		local buy = NativeUI.CreateItem('Buy '..aircraft.name, 'Buy price: $'..comma_value(aircraft.buy_price))
		rent.Activated = function(parentmenu, selected)
            local business = exports["usa-businesses"]:GetClosestStore(15)
			TriggerServerEvent('aircraft:requestRent', aircraft, business)
			heliMenu.SubMenu:Visible(false)
		end
		buy.Activated = function(parentmenu, selected)
            local business = exports["usa-businesses"]:GetClosestStore(15)
			TriggerServerEvent('aircraft:requestPurchase', aircraft, business)
			heliMenu.SubMenu:Visible(false)
		end
		heliMenu.SubMenu:AddItem(rent)
		heliMenu.SubMenu:AddItem(buy)
		helicopters.SubMenu:AddItem(heliMenu.SubMenu)
	end
end

function CreateSellMenu(menu, vehicles)
	local sellMenu = _menuPool:AddSubMenu(menu, 'Sell an Aircraft', '', true)
	for i = 1, #playerAircraft do
		local aircraft = playerAircraft[i]
		local aircraftid = '('..aircraft.id..')'
		local item = NativeUI.CreateItem(aircraft.name.. ' ' ..aircraftid, 'Sell value: $' ..comma_value(0.5*aircraft.buy_price))
		item.Activated = function(parentmenu, selected)
			if aircraft.stored then
				TriggerServerEvent('aircraft:requestSell', aircraft)
				sellMenu.SubMenu:Visible(false)
			else
				TriggerEvent('usa:notify', 'This aircraft is ~y~not stored~s~, cannot be sold!')
			end
		end
		sellMenu.SubMenu:AddItem(item)
	end
	if #playerAircraft <= 0 then
		local item = NativeUI.CreateItem("Nothing to sell!", "You don't own any aircraft to sell!")
		sellMenu.SubMenu:AddItem(item)
	end
end

function CreateGarageMenu(menu, vehicles)
	local retrieveMenu = _menuPool:AddSubMenu(menu, 'Retrieve an Aircraft', '', true)
	for i = 1, #playerAircraft do
		local aircraft = playerAircraft[i]
		local store_status = ''
		if aircraft.stored then
			store_status = '(~g~Stored~s~)'
		else
			store_status = '(~r~Not Stored~s~)'
		end
		local item = NativeUI.CreateItem('Retrieve ' .. aircraft.name .. ' ' .. store_status, 'Aircraft ID: '..aircraft.id)
		retrieveMenu.SubMenu:AddItem(item)
		item.Activated = function(parentmenu, selected)
			if aircraft.stored then
				TriggerEvent("aircraft:spawnAircraft", aircraft)
				print("setting aircraft at " .. i .. " stored status to false!")
				TriggerEvent('usa:notify', 'Alright, aircraft has been deployed.')
				aircraft.stored = false
				retrieveMenu.SubMenu:Visible(false)
			else
				TriggerEvent('usa:notify', 'This aircraft is not stored!')
			end
		end
	end
	if #playerAircraft <= 0 then
		local item = NativeUI.CreateItem("Nothing to retrieve!", "You don't own any aircraft to retrieve!")
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

local BLIPS = {}
function CreateMapBlips()
  if #BLIPS == 0 then
  	for k, v in pairs(locations) do
      local blip = AddBlipForCoord(locations[k].menu.x, locations[k].menu.y, locations[k].menu.z)
      SetBlipSprite(blip, MAP_BLIP_SPRITE)
      SetBlipDisplay(blip, 4)
      SetBlipScale(blip, 0.8)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString('Aircraft Shop')
      EndTextCommandSetBlipName(blip)
      table.insert(BLIPS, blip)
	end
  end
end

TriggerServerEvent('blips:getBlips')

RegisterNetEvent('blips:returnBlips')
AddEventHandler('blips:returnBlips', function(blipsTable)
  if blipsTable['planeshop'] then
    CreateMapBlips()
  else
    for _, k in pairs(BLIPS) do
      print(k)
      RemoveBlip(k)
    end
    BLIPS = {}
  end
end)

-----------------
-----------------
-----------------
