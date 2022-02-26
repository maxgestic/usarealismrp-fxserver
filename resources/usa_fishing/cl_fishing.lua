local _menuPool = NativeUI.CreatePool()
local mainMenu = NativeUI.CreateMenu("Fish Store", "~b~Sell your fish", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

local fishing = false
local seaFishing = false

local fishStoreLocations = {
  {x = -666.796, y = 5805.82, z = 17.57},
  {x = -3044.07, y = 102.78, z = 12.34},
  {x = 4519.8374023438, y = -4515.0639648438, z = 4.4947814941406} -- cayo perico
}

local fishingZoneSpots = {
  {x = -1614.893, y = 5260.193, z = 3.974, heading = 113.0},
  {x = -1612.144, y = 5262.591, z = 3.974, heading = 22.0},
  {x = -1612.006, y = 5254.585, z = 3.974, heading = 113.0},
  {x = -1605.885, y = 5259.260, z = 2.089, heading = 300.0},
  {x = -1607.893, y = 5264.255, z = 3.974, heading = 24.0},
  {x = -3410.52, y = 952.02, z = 8.34, heading = 175.0},
  {x = -3409.07, y = 953.92, z = 8.34, heading = 273.0},
  {x = -3408.96, y = 959.20, z = 8.34, heading = 269.0},
  {x = -3409.19, y = 973.33, z = 8.34, heading = 271.0},
  {x = -3408.98, y = 978.53, z = 8.34, heading = 271.0},
  {x = -3410.87, y = 982.69, z = 8.34, heading = 0.0}
}

local fishingZoneBlips = {
  {x = -1614.893, y = 5260.193, z = 3.974},
  {x = -3407.63, y = 967.52, z = 8.29}
}

local fish = {
	{name = 'Trout'},
	{name = 'Flounder'},
	{name = 'Halibut'}
}

local seaFish = {
	{name = 'Yellowfin Tuna'},
	{name = 'Swordfish'}
}

local peds = {
	{x = -666.794, y = 5805.77, z = 16.5, heading = 280.352, hash = 261586155},
	{x = -3044.07, y = 102.78, z = 11.34, heading = 282.0, hash = 261586155}
}

local KEYS = {
	K = 311,
	E = 38
}

RegisterNetEvent("fishing:startDockFishing")
AddEventHandler("fishing:startDockFishing", function(spotHeading)
	if not fishing then
		local playerPed = PlayerPedId()
		exports.globals:notify('Wait for a fish to bite!')
		SetEntityHeading(playerPed, spotHeading)
		FreezeEntityPosition(playerPed, true)
		fishing = true
		local wait = math.random(15000, 45000)
		local robObject = AttachEntityToPed('prop_fishing_rod_01', 60309, 0, 0, 0, 0, 0, 0)
		exports.globals:loadAnimDict('amb@world_human_stand_fishing@base')
		TaskPlayAnim(playerPed,'amb@world_human_stand_fishing@base', 'base', 8.0, -8, -1, 49, 0, 0, 0, 0)
		Wait(wait)
		ClearPedTasks(playerPed)
		TriggerEvent('usa:showHelp', true, 'Tap ~INPUT_PICKUP~ to reel the fish in!')
		exports.globals:notify('Tap ~y~E~w~ to reel the fish in!')
		local resistance = 0
		local maxResistance = math.random(4000, 10000)
		exports.globals:loadAnimDict('amb@world_human_stand_fishing@idle_a')
		TaskPlayAnim(playerPed,'amb@world_human_stand_fishing@idle_a', 'idle_c', 8.0, -8, -1, 49, 0, 0, 0, 0) -- 10sec
		Citizen.CreateThread(function()
			while fishing do
				Wait(0)
				DrawTimer(GetGameTimer() - resistance, maxResistance, 1.42, 1.475, 'REELING')
				if IsControlJustPressed(0, KEYS.E) then
					resistance = resistance + math.random(30, 100)
					if resistance > maxResistance and fishing then
						ClearPedTasks(playerPed)
						DeleteEntity(robObject)
						fishing = false
						while securityToken == nil do
							Wait(1)
						end
						TriggerServerEvent('fish:giveFish', securityToken)
						FreezeEntityPosition(playerPed, false)
					end
				end
			end
		end)
		Citizen.CreateThread(function()
			Wait(20000)
			if fishing and resistance < maxResistance / 2 then
				ClearPedTasks(playerPed)
				DeleteEntity(robObject)
				TriggerEvent('usa:notify', 'You failed to catch the fish!')
				fishing = false
				FreezeEntityPosition(playerPed, false)
			end
		end)
	else 
		exports.globals:notify("You are already fishing!")
	end
end)

RegisterNetEvent("fishing:startSeaFishing")
AddEventHandler("fishing:startSeaFishing", function()
	if not seaFishing then
		local playerPed = PlayerPedId()
		exports.globals:notify('Wait for a fish to bite!')
		seaFishing = true
		local wait = math.random(25000, 120000)
		local robObject = AttachEntityToPed('prop_fishing_rod_01', 60309, 0, 0, 0, 0, 0, 0)
		exports.globals:loadAnimDict('amb@world_human_stand_fishing@base')
		TaskPlayAnim(playerPed,'amb@world_human_stand_fishing@base', 'base', 8.0, -8, -1, 49, 0, 0, 0, 0)
		Wait(wait)
		ClearPedTasks(playerPed)
		TriggerEvent('usa:showHelp', true, 'Tap ~INPUT_PICKUP~ to reel the fish in!')
		exports.globals:notify('Tap ~y~E~w~ to reel the fish in!')
		local resistance = 0
		local maxResistance = math.random(10000, 15000)
		exports.globals:loadAnimDict('amb@world_human_stand_fishing@idle_a')
		TaskPlayAnim(playerPed,'amb@world_human_stand_fishing@idle_a', 'idle_c', 8.0, -8, -1, 49, 0, 0, 0, 0) -- 10sec
		Citizen.CreateThread(function()
			while seaFishing do
				Wait(0)
				DrawTimer(GetGameTimer() - resistance, maxResistance, 1.42, 1.475, 'REELING')
				if IsControlJustPressed(0, 38) then
					resistance = resistance + math.random(85, 150)
					if resistance > maxResistance and seaFishing then
						seaFishing = false
						ClearPedTasks(playerPed)
						DeleteEntity(robObject)
						while securityToken == nil do
							Wait(1)
						end
						TriggerServerEvent('fish:giveSeaFish', securityToken)
					end
				end
			end
		end)
		Citizen.CreateThread(function()
			Wait(20000)
			if seaFishing and resistance < maxResistance / 2 then
				ClearPedTasks(playerPed)
				DeleteEntity(robObject)
				TriggerEvent('usa:notify', 'You failed to catch the fish!')
				seaFishing = false
			end
		end)
	else 
		exports.globals:notify("You are already fishing!")
	end
end)

-- Sea Fishing
Citizen.CreateThread(function()
	while true do
		if IsControlJustPressed(0, KEYS.K) then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local boat = GetClosestBoatInRange(playerCoords, 10)
			if DoesEntityExist(boat) then
				SetEntityAsMissionEntity(boat, true, true)
				if IsEntityInWater(boat) or GetVehicleClass(boat) == 14 then
					if not IsPedSwimming(playerPed) and not IsPedInAnyVehicle(playerPed, true) then
						TriggerServerEvent("fishing:checkForPole")
					end
				end
			end
		end
		Wait(1)
	end
end)

local nearbyFishingZoneSpots = {}
local nearbyFishStoreLocations = {}

-- record nearest stores every so often (as an optimization for drawing 3d text)
Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local mycoords = GetEntityCoords(playerPed)
		for i = 1, #fishingZoneSpots do
			local dist = Vdist(mycoords, fishingZoneSpots[i].x, fishingZoneSpots[i].y, fishingZoneSpots[i].z)
			if dist <= 15 then
				nearbyFishingZoneSpots[i] = true
			else
				nearbyFishingZoneSpots[i] = nil
			end
		end
		for i = 1, #fishStoreLocations do
			local dist = Vdist(mycoords, fishStoreLocations[i].x, fishStoreLocations[i].y, fishStoreLocations[i].z)
			if dist <= 10 then
				nearbyFishStoreLocations[i] = true
			else
				nearbyFishStoreLocations[i] = nil
			end
		end
		Wait(1000)
	end
end)

-- process menus + start fishing + draw 3d text for nearest stores and fishing zones
Citizen.CreateThread(function()
	PlaceMapBlips()
	while true do
		Citizen.Wait(1)
		if _menuPool:IsAnyMenuOpen() then
			_menuPool:MouseControlsEnabled(false)
			_menuPool:ControlDisablingEnabled(false)
			_menuPool:ProcessMenus()
		end
		local playerPed = PlayerPedId()
		for i, isNearby in pairs(nearbyFishingZoneSpots) do
			local spot = fishingZoneSpots[i]
			DrawText3D(spot.x, spot.y, spot.z, '[K] - Fish')
		end
		for i, isNearby in pairs(nearbyFishStoreLocations) do
			local spot = fishStoreLocations[i]
			DrawText3D(spot.x, spot.y, spot.z, '[E] - Sell Fish')
		end
		if IsControlJustPressed(0, KEYS.K) then
			for i = 1, #fishingZoneSpots do
				local spot = fishingZoneSpots[i]
				local playerCoords = GetEntityCoords(playerPed)
				if Vdist(playerCoords, spot.x, spot.y, spot.z) < 1.0 then
					if not IsPedInAnyVehicle(playerPed) and not IsPedSwimming(playerPed) then
						TriggerServerEvent("fishing:checkForPole", spot.heading)
					end
				end
			end
		elseif IsControlJustPressed(0, KEYS.E) then
			for i = 1, #fishStoreLocations do
				local spot = fishStoreLocations[i]
				local playerCoords = GetEntityCoords(playerPed)
				if Vdist(playerCoords, spot.x, spot.y, spot.z) < 2.0 then
					mainMenu:Visible(not mainMenu:Visible())
					Citizen.CreateThread(function()
						while mainMenu:Visible() do
							Citizen.Wait(100)
							playerCoords = GetEntityCoords(playerPed)
							if Vdist(playerCoords, spot.x, spot.y, spot.z) > 3.0 then
								mainMenu:Visible(false)
							end
						end
					end)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if fishing then
			DisableControlAction(0, 30, true)
			DisableControlAction(0, 31, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 140, true)
		end
	end
end)

Citizen.CreateThread(function()
	for i = 1, #peds do
		RequestModel(peds[i].hash)
		while not HasModelLoaded(peds[i].hash) do
			Citizen.Wait(100)
		end
		local ped = CreatePed(4, peds[i].hash, peds[i].x, peds[i].y, peds[i].z, peds[i].heading, false, true)
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		SetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetPedRandomComponentVariation(ped, true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_MOBILE", 0, true);
	end
end)

function comma_value(amount)
	if not amount then return end
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

function CreateMenu()
	for i = 1, #fish do
		local fishItem = NativeUI.CreateItem(fish[i].name, "Sale price varies on weight")
		fishItem.Activated = function(parentmenu, selected)
			TriggerServerEvent('fish:sellFish', i)
		end
		mainMenu:AddItem(fishItem)
	end

	for i = 1, #seaFish do
		local seafishItem = NativeUI.CreateItem(seaFish[i].name, "Sale price varies on weight")
		seafishItem.Activated = function(parentmenu, selected)
			TriggerServerEvent('fish:sellSeaFish', i)
		end
		mainMenu:AddItem(seafishItem)
	end
end

CreateMenu(mainMenu)
_menuPool:RefreshIndex()

function GetClosestBoatInRange(coords, range)
	for veh in exports.globals:EnumerateVehicles() do 
		if GetVehicleClass(veh) == 14 then
			local dist = Vdist(coords, GetEntityCoords(veh))
			if dist <= range then 
				return veh
			end
		end
	end
	return nil
end

function AttachEntityToPed(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
	local BoneID = GetPedBoneIndex(PlayerPedId(), bone_ID)
	local obj = CreateObject(GetHashKey(prop),  1729.73,  6403.90,  34.56,  false,  false,  false)
	SetEntityAsMissionEntity(obj, true, true)
	vX,vY,vZ = table.unpack(GetEntityCoords(PlayerPedId()))
	xRot, yRot, zRot = table.unpack(GetEntityRotation(PlayerPedId(),2))
	AttachEntityToEntity(obj,  PlayerPedId(),  BoneID, x,y,z, RotX,RotY,RotZ,  false, false, false, false, 2, true)
	return obj
end

function DrawText3D(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
end

function DrawTimer(beginTime, duration, x, y, text)
    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars')
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    if GetTimeDifference(GetGameTimer(), beginTime) < duration then
        w = (GetTimeDifference(GetGameTimer(), beginTime) * (0.085 / duration))
    end

    local correction = ((1.0 - math.floor(GetSafeZoneSize(), 2)) * 100) * 0.005
    x, y = x - correction, y - correction

    Set_2dLayer(0)
    DrawSprite('timerbars', 'all_black_bg', x, y, 0.15, 0.0325, 0.0, 255, 255, 255, 180)

    Set_2dLayer(1)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 100, 0, 0, 180)

    Set_2dLayer(2)
    DrawRect(x - 0.015 + (w / 2), y, w, 0.0125, 150, 0, 0, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    Set_2dLayer(3)
    DrawText(x - 0.06, y - 0.012)
end

function PlaceMapBlips()
	for i = 1, #fishingZoneBlips do
		local blip = fishingZoneBlips[i]
		local handle = AddBlipForCoord(blip.x, blip.y, blip.z)
		SetBlipSprite(handle, 68)
		SetBlipDisplay(handle, 4)
		SetBlipScale(handle, 0.7)
		SetBlipColour(handle, 4)
		SetBlipAsShortRange(handle, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Fishing Zone')
		EndTextCommandSetBlipName(handle)
	end

	for i = 1, #fishStoreLocations do
		local blip = fishStoreLocations[i]
		local handle = AddBlipForCoord(blip.x, blip.y, blip.z)
		SetBlipSprite(handle, 88)
		SetBlipDisplay(handle, 4)
		SetBlipScale(handle, 0.7)
		SetBlipColour(handle, 4)
		SetBlipAsShortRange(handle, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Fish Store')
		EndTextCommandSetBlipName(handle)
	end
end
