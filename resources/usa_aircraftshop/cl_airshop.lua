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
	},
	["Johnson"] = {
		menu = {
			x = -55.28,
			y = 782.23,
			z = 222.48
		},
		returns = {
			x = -28.34,
			y = 773.89,
			z = 223.42
		},
		spawn = {
			x = -29.8,
			y = 769.32,
			z = 223.42,
			heading = 42.68
		},
		ped = {},
		private = true
	},
	["Elemental"] = {
		menu = {
			x = -1013.7918701172, y = 176.72352600098, z = 61.654273986816
		},
		returns = {
			x = -1025.7778320313, y = 179.72576904297, z = 63.475910186768
		},
		spawn = {
			x = -1024.7823486328, y = 176.40382385254, z = 63.475910186768,
			heading = 42.68
		},
		ped = {},
		private = true
	}
	--["GloryCorp"] = {
	--	menu = {
	--		x = -1607.23,
	--		y = 840.97,
	--		z = 186.0
	--	},
	--	returns = {
	--		x = -1598.37,
	--		y = 833.64,
	--		z = 187.74
	--	},
	--	spawn = {
	--		x = -1596.33,
	--		y = 829.51,
	--		z = 187.74,
	--		heading = 291.91
	--	},
	--	ped = {},
	--	private = true
	--}
}

local KEYS = {
    E = 38
}

local ITEMS = {}

local RENTAL_PERCENTAGE = nil
local CLAIM_PERCENTAGE = nil

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Aircrafts", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

RegisterNetEvent("aircraft:loadItems") -- items + rental % amount setting
AddEventHandler("aircraft:loadItems", function(items, rentalPercentage, claimPercentage)
	ITEMS = items
	RENTAL_PERCENTAGE = rentalPercentage
	CLAIM_PERCENTAGE = claimPercentage
end)

TriggerServerEvent("aircraft:loadItems")

RegisterNetEvent('aircraft:openMenu')
AddEventHandler('aircraft:openMenu', function(aircraft)
	ShowMainMenu(aircraft)
end)

RegisterNetEvent('aircraft:openPrivateMenu')
AddEventHandler('aircraft:openPrivateMenu', function(aircraft)
	ShowPrivateMenu(aircraft)
end)

RegisterNetEvent('aircraft:spawn')
AddEventHandler('aircraft:spawn', function(hash, id)
    if type(hash) ~= "number" then
        hash = GetHashKey(hash)
    end
    if not HasModelLoaded(hash) then
        RequestModel(hash)
    end
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(0)
    end
    local location = GetClosestLocation()
	local aircraft = CreateVehicle(hash, location.spawn.x, location.spawn.y, location.spawn.z, (location.spawn.heading or 0.0), true, false)
	TriggerEvent('persistent-vehicles/register-vehicle', aircraft)
	SetEntityAsMissionEntity(aircraft, 1, 1)
    if id then
        SetVehicleNumberPlateText(aircraft, tostring(id):sub(1, 8))
    end
    local plate = GetVehicleNumberPlateText(aircraft)
    local vehicle_key = {
        name = "Key -- " .. plate,
        quantity = 1,
        type = "key",
        owner = "GOVT",
        make = "GOVT",
        model = "GOVT",
        plate = plate
    }
    TriggerServerEvent("garage:giveKey", vehicle_key)
end)

-- stationary job peds --
local createdJobPeds = {}
Citizen.CreateThread(function()
	while true do
		local playerCoords = GetEntityCoords(PlayerPedId(), false)
		for name, data in pairs(locations) do
			if Vdist(data.ped.x, data.ped.y, data.ped.z, playerCoords.x, playerCoords.y, playerCoords.z) < 50 then
				if not createdJobPeds[name] then
					local hash = GetHashKey(data.ped.model)
					RequestModel(hash)
					while not HasModelLoaded(hash) do
						Citizen.Wait(100)
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

-- for accessing shops --
Citizen.CreateThread(function()
    while true do
        for name, data in pairs(locations) do
            local shopDist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), data.menu.x, data.menu.y, data.menu.z, true)
			if data.private and shopDist < 70 then
				DrawText3D(data.menu.x, data.menu.y, data.menu.z, 2, '[E] - Private Hanger')
				if IsControlPressed(0, KEYS.E) and shopDist < 5 then
					TriggerServerEvent('aircraft:requestOpenPrivateMenu')
				end
			elseif shopDist < 70 then
				DrawText3D(data.menu.x, data.menu.y, data.menu.z, 8, '[E] - Aircraft Management')
			end

            if shopDist < 5 and not data.private then
                if IsControlJustPressed(0, KEYS.E) then
                    Wait(500)
                    if IsControlPressed(0, KEYS.E) then -- holding E
                        local business = exports["usa-businesses"]:GetClosestStore(15)
                        TriggerServerEvent("aircraft:purchaseLicense", business)
                    else
                        TriggerServerEvent('aircraft:requestOpenMenu')
                    end
                end
            end
        end
        Wait(1)
	end
end)

-- for returning aircraft --
Citizen.CreateThread(function()
    while true do
        for name, data in pairs(locations) do
            local returnDist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), data.returns.x, data.returns.y, data.returns.z, true)
			if data.private and returnDist < 70 then
				DrawText3D(data.returns.x, data.returns.y, data.returns.z, 10, '[E] - Return aircraft')
			elseif returnDist < 70 then
                DrawText3D(data.returns.x, data.returns.y, data.returns.z, 30, '[E] - Return personal / rented aircraft')
                DrawMarker(1, data.returns.x, data.returns.y, data.returns.z-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 76, 144, 114, 200, 0, 0, 0, 0)
            end
            if returnDist < 4 then
                if IsControlJustPressed(0, KEYS.E) then
                    local me = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(me, false)
                    local hash = GetEntityModel(vehicle)
                    local inDriverSeat = GetPedInVehicleSeat(vehicle, -1) == me
                    if inDriverSeat then
                        local plate = GetVehicleNumberPlateText(vehicle)
                        TriggerServerEvent("aircraft:requestReturn", plate)
						if DoesEntityExist(vehicle) and IsPlaneOrHeli(vehicle) then
							TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
							DeleteVehicle(vehicle)
                        end
                    else
                        exports.globals:notify("You must be in the driver's seat.")
                    end
                end
            end
        end
        Wait(1)
    end
end)

-- NativeUI menu processesing --
Citizen.CreateThread(function()
	while true do

		_menuPool:MouseControlsEnabled(false)
		_menuPool:ControlDisablingEnabled(false)
        _menuPool:ProcessMenus()
        
        local me = PlayerPedId()
        local mycoords = GetEntityCoords(me)

        local isNearAny = false
        for name, data in pairs(locations) do
            local shopDist = GetDistanceBetweenCoords(mycoords, data.menu.x, data.menu.y, data.menu.z, true)
            if shopDist < 5 then
                isNearAny = true
                break
            end
        end

        if not isNearAny then
            if _menuPool:IsAnyMenuOpen() then
                _menuPool:CloseAllMenus()
            end
        end


		Wait(0)
	end
end)

function ShowPrivateMenu(aircraft)
	mainMenu:Clear()
	CreateGarageMenu(mainMenu, aircraft)
	mainMenu:Visible(not mainMenu:Visible())
end

function ShowMainMenu(aircraft)
	mainMenu:Clear()
	CreateHelicopterMenu(mainMenu, ITEMS.helicopters)
	CreatePlaneMenu(mainMenu, ITEMS.planes)
	CreateSellMenu(mainMenu, aircraft)
    CreateGarageMenu(mainMenu, aircraft)
    CreateClaimMenu(mainMenu, aircraft)
	mainMenu:Visible(not mainMenu:Visible())
end

function CreateHelicopterMenu(menu, vehicles)
	local helicopters = _menuPool:AddSubMenu(menu, "Helicopters", 'See our selection of helicopters', true)
	for name, info in pairs(vehicles) do
		local aircraft = info
		local heliMenu = _menuPool:AddSubMenu(helicopters.SubMenu, aircraft.name, 'View prices of the '..aircraft.name, true)
		local rent = NativeUI.CreateItem('Rent '..aircraft.name, 'Rent price: $' .. exports.globals:comma_value(RENTAL_PERCENTAGE*aircraft.price))
		local buy = NativeUI.CreateItem('Buy '..aircraft.name, 'Buy price: $'.. exports.globals:comma_value(aircraft.price))
		rent.Activated = function(parentmenu, selected)
            local business = exports["usa-businesses"]:GetClosestStore(15)
			TriggerServerEvent('aircraft:requestRent', "helicopters", aircraft.name, business)
			heliMenu.SubMenu:Visible(false)
		end
		buy.Activated = function(parentmenu, selected)
            local business = exports["usa-businesses"]:GetClosestStore(15)
            TriggerServerEvent('aircraft:requestPurchase', "helicopters", aircraft.name, business)
			heliMenu.SubMenu:Visible(false)
		end
		heliMenu.SubMenu:AddItem(rent)
		heliMenu.SubMenu:AddItem(buy)
		helicopters.SubMenu:AddItem(heliMenu.SubMenu)
	end
end

function CreatePlaneMenu(menu, vehicles)
	local planes = _menuPool:AddSubMenu(menu, "Airplanes", 'See our selection of airplanes', true)
	for name, info in pairs(vehicles) do
		local aircraft = info
		local planeMenu = _menuPool:AddSubMenu(planes.SubMenu, aircraft.name, 'View prices of the '..aircraft.name, true)
		local rent = NativeUI.CreateItem('Rent '..aircraft.name, 'Rent price: $' .. exports.globals:comma_value(0.30*aircraft.price))
		local buy = NativeUI.CreateItem('Buy '..aircraft.name, 'Buy price: $'.. exports.globals:comma_value(aircraft.price))
		rent.Activated = function(parentmenu, selected)
			local business = exports["usa-businesses"]:GetClosestStore(15)
			TriggerServerEvent('aircraft:requestRent', "planes", aircraft.name, business)
			planeMenu.SubMenu:Visible(false)
		end
		buy.Activated = function(parentmenu, selected)
            local business = exports["usa-businesses"]:GetClosestStore(15)
			TriggerServerEvent('aircraft:requestPurchase', "planes", aircraft.name, business)
			planeMenu.SubMenu:Visible(false)
		end
		planeMenu.SubMenu:AddItem(rent)
		planeMenu.SubMenu:AddItem(buy)
		planes.SubMenu:AddItem(planeMenu.SubMenu)
	end
end

function CreateSellMenu(menu, playerAircraft)
	local sellMenu = _menuPool:AddSubMenu(menu, 'Sell an Aircraft', '', true)
	for i = 1, #playerAircraft do
		local aircraft = playerAircraft[i]
		local aircraftid = '('..aircraft.id..')'
		local item = NativeUI.CreateItem(aircraft.name.. ' ' ..aircraftid, 'Sell value: $' .. exports.globals:comma_value(0.5*aircraft.price))
		item.Activated = function(parentmenu, selected)
			TriggerServerEvent('aircraft:requestSell', aircraft.id)
			sellMenu.SubMenu:Visible(false)
		end
		sellMenu.SubMenu:AddItem(item)
	end
	if #playerAircraft <= 0 then
		local item = NativeUI.CreateItem("Nothing to sell!", "You don't own any aircraft to sell!")
		sellMenu.SubMenu:AddItem(item)
	end
end

function CreateGarageMenu(menu, playerAircraft)
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
            TriggerServerEvent("aircraft:requestRetrieval", aircraft.id)
            retrieveMenu.SubMenu:Visible(false)
		end
	end
	if #playerAircraft <= 0 then
		local item = NativeUI.CreateItem("Nothing to retrieve!", "You don't own any aircraft to retrieve!")
		retrieveMenu.SubMenu:AddItem(item)
	end
end

function CreateClaimMenu(menu, playerAircraft)
    local claimMenu = _menuPool:AddSubMenu(menu, 'Make a claim', 'Lose an aircraft? No problem!', true)
    local hadAircraftToClaim = false
	for i = 1, #playerAircraft do
        local aircraft = playerAircraft[i]
        if not aircraft.stored then
            hadAircraftToClaim = true
            local claimPrice = math.floor(CLAIM_PERCENTAGE*aircraft.price)
            local item = NativeUI.CreateItem(aircraft.name, "Claim for: $" .. exports.globals:comma_value(claimPrice))
            item.Activated = function(pmenu, selected)
                TriggerServerEvent("aircraft:claim", aircraft.id)
                claimMenu.SubMenu:Visible(false)
            end
		    claimMenu.SubMenu:AddItem(item)
        end
    end
    if not hadAircraftToClaim then
        local item = NativeUI.CreateItem("Nothing to claim!", "")
        claimMenu.SubMenu:AddItem(item)
    end
end

function GetClosestLocation()
    local closest = nil
    for name, data in pairs(locations) do
        local shopDist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), data.menu.x, data.menu.y, data.menu.z, true)
        if shopDist < 5 then
            closest = data
        end
    end
    return closest
end

function IsPlaneOrHeli(vehicle)
    local class = GetVehicleClass(vehicle)
    return class == 15 or class == 16
end

function DrawText3D(x, y, z, distance, text)
    if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
      local onScreen,_x,_y=World3dToScreen2d(x,y,z)
      SetTextScale(0.35, 0.35)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 215)
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
      local factor = (string.len(text)) / 470
      DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
    end
end

----------------------
---- Set up blips ----
----------------------
local MAP_BLIP_SPRITE = 251
for k, v in pairs(locations) do
	if not v.private then
		local blip = AddBlipForCoord(locations[k].menu.x, locations[k].menu.y, locations[k].menu.z)
		SetBlipSprite(blip, MAP_BLIP_SPRITE)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Aircrafts')
		EndTextCommandSetBlipName(blip)
	end
end