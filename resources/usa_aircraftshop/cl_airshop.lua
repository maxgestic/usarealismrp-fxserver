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
	["Cayo Perico"] = {
		menu = {
			x = 4452.7124023438, y = -4477.6674804688, z = 4.2959222793579
		},
		returns = {
			x = 4502.2192382812, y = -4476.0576171875, z = 4.1998791694641
		},
		spawn = {
			x = 4477.71875, y = -4494.4794921875, z = 4.1950483322144,
			heading = 141.0
		},
		ped = {
			x = 4452.9755859375, y = -4476.7690429688, z = 4.3102388381958,
			heading = 160.0,
			model = 'U_M_Y_PARTY_01'
		}
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

RENTAL_PERCENTAGE = nil
CLAIM_PERCENTAGE = nil

RegisterNetEvent("aircraft:loadItems") -- items + rental % amount setting
AddEventHandler("aircraft:loadItems", function(items, rentalPercentage, claimPercentage)
	aircraftShopItems = items
	RENTAL_PERCENTAGE = rentalPercentage
	CLAIM_PERCENTAGE = claimPercentage
end)

TriggerServerEvent("aircraft:loadItems")

RegisterNetEvent('aircraft:openMenu')
AddEventHandler('aircraft:openMenu', function(aircraft)
	ownedAircraft = aircraft
	currentAircraftShopMenuPage = "home"
	displayAircraftShopMenu = true
end)

RegisterNetEvent('aircraft:spawn')
AddEventHandler('aircraft:spawn', function(hash, plate)
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
	SetEntityAsMissionEntity(aircraft, 1, 1)
    if plate then
        SetVehicleNumberPlateText(aircraft, plate)
    end
    local vehicle_key = {
        name = "Key -- " .. GetVehicleNumberPlateText(aircraft),
        quantity = 1,
        type = "key",
        owner = "GOVT",
        make = "GOVT",
        model = "GOVT",
        plate = GetVehicleNumberPlateText(aircraft)
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
			if shopDist < 70 then
				DrawText3D(data.menu.x, data.menu.y, data.menu.z, 8, '[E] - Aircraft Management')
			end

            if shopDist < 5 then
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
			if returnDist < 70 then
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
	local blip = AddBlipForCoord(locations[k].menu.x, locations[k].menu.y, locations[k].menu.z)
	SetBlipSprite(blip, MAP_BLIP_SPRITE)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Aircrafts')
	EndTextCommandSetBlipName(blip)
end