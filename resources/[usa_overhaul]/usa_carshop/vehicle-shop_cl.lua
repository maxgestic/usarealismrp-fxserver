--# by: minipunch
--# for: USA REALISM RP
--# simple vehicle shop script to preview and purchase a vehicle

local MENU_KEY = 38

local SHOPS = {
	--{name = "Paleto Bay", store_x = 120.9, store_y = 6624.605, store_z = 32.0, vehspawn_x = 131.04, vehspawn_y = 6625.39, vehspawn_z = 31.71, vehspawn_heading = 315.0},
	{name = "Los Santos", store_x = -33.40, store_y = -1102.03, store_z = 26.4523, vehspawn_x = -48.884, vehspawn_y = -1113.75, vehspawn_z = 26.4358, vehspawn_heading = 315.0},
	{name = "Sandy Shores", store_x = 1224.7, store_y = 2727.3, store_z = 37.0, vehspawn_x = 1228.5, vehspawn_y = 2718.0, vehspawn_z = 38.0, vehspawn_heading = 260.0}
}

local vehicleShopItems = nil

local menu_data = {
	closest = nil,
	preview = {
		start_coords = nil,
		handle = nil
	},
	vehicles_to_sell = nil
}

TriggerServerEvent("vehicle-shop:loadItems")

local sell_submenu = nil
local buy_submenu = nil

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Car Dealership", "Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
previewMenu = NativeUI.CreateMenu("Vehicle Preview", "~b~Welcome!", 0, 320)

mainMenu.OnItemSelect = function(menu, item, index)
	local selected = item.Text._Text
	if selected == "Get a Quote" then
		menu_data.vehicles_to_sell = nil
		sell_submenu:Clear()
		TriggerServerEvent("vehShop:loadVehiclesToSell")
		while not menu_data.vehicles_to_sell do
			Wait(50)
			--print("waiting for vehicles to sell")
		end
		if #menu_data.vehicles_to_sell > 0 then
			for i = 1, #menu_data.vehicles_to_sell do
				local veh = menu_data.vehicles_to_sell[i]
				local item = NativeUI.CreateItem(veh.make .. " " .. veh.model, "Sell this vehicle for $" .. comma_value(.50 * veh.price))
				item.Activated = function(parentmenu, selected)
					TriggerEvent("usa:notify", "~y~SOLD:~w~ " .. veh.make .. " " .. veh.model .. "\n~y~PRICE: ~g~$" .. comma_value(.50 * veh.price))
					TriggerServerEvent("vehShop:sellVehicle", veh)
					_menuPool:CloseAllMenus()
				end
				sell_submenu:AddItem(item)
			end
		else
			local item = NativeUI.CreateItem("No vehicles to sell!", "You don't own any vehicles!")
			sell_submenu:AddItem(item)
		end
	end
end

_menuPool:Add(mainMenu)
_menuPool:Add(previewMenu)

function CreateMenu(menu)
	Citizen.CreateThread(function()
		local me = GetPlayerPed(-1)
		while not vehicleShopItems do
			Wait(100)
		end
		----------
		-- buy --
		----------
		buy_submenu = _menuPool:AddSubMenu(menu, "Showroom & Purchases", "Shop for a vehicle!", true)

		for category, items in pairs(vehicleShopItems["vehicles"]) do
		  local category_submenu = _menuPool:AddSubMenu(buy_submenu, category, "See our selection of " .. category, true)
		  for i = 1, #items do
			  local item = NativeUI.CreateItem("($" .. comma_value(items[i].price) .. ") " .. items[i].make .. " " .. items[i].model, "Browse options for the " .. items[i].make .. " " .. items[i].model .. " (Storage Capacity: " .. items[i].storage_capacity .. ")")
			  item.Activated = function(parentmenu, selected)
				parentmenu:Visible(false)
				previewMenu:Visible(true)
				menu_data.preview.vehicle = items[i]
				menu_data.preview.prev_menu = parentmenu
				UpdatePreviewMenu()
			  end
			  category_submenu:AddItem(item)
		  end
		end
		----------
		-- sell --
		----------
		sell_submenu = _menuPool:AddSubMenu(menu, "Get a Quote", "Sell a vehicle!", true)
	end)
end

function UpdatePreviewMenu()
	local me = GetPlayerPed(-1)
	-- clear --
	previewMenu:Clear()
	---------------
	-- preview --
	---------------
	local item = NativeUI.CreateItem("Preview", "Preview the " .. menu_data.preview.vehicle.make .. " " .. menu_data.preview.vehicle.model)
	item.Activated = function(parentmenu, selected)
		if not menu_data.preview.handle then
			menu_data.preview.start_coords = GetEntityCoords(me)
			PreviewVehicle(menu_data.preview.vehicle)
		else
			EndPreview()
			PreviewVehicle(menu_data.preview.vehicle)
		end
	end
	previewMenu:AddItem(item)
	-----------------
	-- purchase  --
	-----------------
	local item = NativeUI.CreateItem("Purchase", "Purchase this vehicle for $" .. comma_value(menu_data.preview.vehicle.price))
	item.Activated = function(parentmenu, selected)
			local playerCoords = GetEntityCoords(me, false)
			EndPreview()
			TriggerServerEvent("mini:checkVehicleMoney", menu_data.preview.vehicle, property)
			previewMenu:Visible(false)
	end
	previewMenu:AddItem(item)
end

CreateMenu(mainMenu)
_menuPool:RefreshIndex()

RegisterNetEvent("vehicle-shop:loadItems")
AddEventHandler("vehicle-shop:loadItems", function(items)
	vehicleShopItems = items
	for category, vehs in pairs(vehicleShopItems["vehicles"]) do
		for i = 1, #vehs do
			if type(vehs[i].hash) ~= "number" then
				vehs[i].hash = GetHashKey(vehs[i].hash)
			end
		end
	end
end)

RegisterNetEvent("vehShop:spawnPlayersVehicle")
AddEventHandler("vehShop:spawnPlayersVehicle", function(hash, plate)
	local numberHash = tonumber(hash)
	-- thread code stuff below was taken from an example on the wiki
	-- Create a thread so that we don't 'wait' the entire game
	Citizen.CreateThread(function()
		-- Request the model so that it can be spawned
		RequestModel(numberHash)
		-- Check if it's loaded, if not then wait and re-request it.
		while not HasModelLoaded(numberHash) do
			Wait(100)
		end
		-- Model loaded, continue
		-- Spawn the vehicle at the gas station car dealership in paleto and assign the vehicle handle to 'vehicle'
		local vehicle = CreateVehicle(numberHash, menu_data.closest.vehspawn_x, menu_data.closest.vehspawn_y, menu_data.closest.vehspawn_z, menu_data.closest.vehspawn_heading, true, false)
		SetVehicleNumberPlateText(vehicle, plate)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
		--SetVehicleAsNoLongerNeeded(vehicle)
		SetEntityAsMissionEntity(vehicle, true, true)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
	end)

end)

RegisterNetEvent("vehShop:displayVehiclesToSell")
AddEventHandler("vehShop:displayVehiclesToSell", function(vehicles)
	if vehicles then
		if #vehicles > 0 then
			--print("#vehicles " .. #vehicles)
			menu_data.vehicles_to_sell = vehicles
		else
			menu_data.vehicles_to_sell = {}
		end
	end
end)

Citizen.CreateThread(function()
	----------------
	-- draw blips --
	----------------
	addBlips()
	while true do
		local playerPed = PlayerPedId()
		------------------
		-- draw markers --
		------------------
		for k = 1, #SHOPS do
			-----------------------------------------------------------
			-- watch for entering store and menu open keypress event --
			-----------------------------------------------------------
			DrawText3D(SHOPS[k].store_x, SHOPS[k].store_y, SHOPS[k].store_z, 10, '~g~E~s~ - Car Dealership')
			if getPlayerDistanceFromShop(playerPed, SHOPS[k].store_x, SHOPS[k].store_y, SHOPS[k].store_z) < 3 then
				if not mainMenu:Visible() then
					if IsControlJustPressed(1, MENU_KEY) then
						menu_data.closest = SHOPS[k]
						mainMenu:Visible(not mainMenu:Visible())
					end
				end
			end
		end
		----------------------
		-- process menu --
		----------------------
		_menuPool:MouseControlsEnabled(false)
		_menuPool:ControlDisablingEnabled(false)
		_menuPool:ProcessMenus()
		-- closing menus --
		if not menu_data.preview.handle and menu_data.closest and getPlayerDistanceFromShop(playerPed, menu_data.closest.store_x, menu_data.closest.store_y, menu_data.closest.store_z) > 3 then
			mainMenu:Visible(false)
		end
		-- ending preview --
		if menu_data.preview.handle and not _menuPool:IsAnyMenuOpen() then
			EndPreview()
		end
		--print("menu_data.closest: " .. type(menu_data.closest))
		Wait(0)
	end
end)

function getPlayerDistanceFromShop(ped, shopX,shopY,shopZ)
	local playerCoords = GetEntityCoords(ped, false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopX,shopY,shopZ,true)
end

function PreviewVehicle(item)
		local numberHash = tonumber(item.hash)
		-- thread code stuff below was taken from an example on the wiki
		-- Create a thread so that we don't 'wait' the entire game
		Citizen.CreateThread(function()
			-- Request the model so that it can be spawned
			RequestModel(numberHash)
			-- Check if it's loaded, if not then wait and re-request it.
			while not HasModelLoaded(numberHash) do
				Wait(100)
			end
			-- Model loaded, continue
			menu_data.preview.handle = CreateVehicle(numberHash, menu_data.closest.vehspawn_x, menu_data.closest.vehspawn_y, menu_data.closest.vehspawn_z, menu_data.closest.vehspawn_heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
			SetVehicleExplodesOnHighExplosionDamage(menu_data.preview.handle, false)
			SetVehicleOnGroundProperly(menu_data.preview.handle)
			SetVehRadioStation(menu_data.preview.handle, "OFF")
			SetPedIntoVehicle(GetPlayerPed(-1), menu_data.preview.handle, -1)
			SetVehicleEngineOn(menu_data.preview.handle, true, false, false)
			FreezeEntityPosition(menu_data.preview.handle, true)
			SetVehicleDoorsLocked(menu_data.preview.handle, 4)
		end)
end

function addBlips()
	for i = 1, #SHOPS do
		local blip = AddBlipForCoord(SHOPS[i].store_x, SHOPS[i].store_y, SHOPS[i].store_z)
		SetBlipSprite(blip, 225)
		SetBlipAsShortRange(blip, true)
		SetBlipScale(blip, 0.7)
		SetBlipDisplay(blip, 4)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Car Dealership")
		EndTextCommandSetBlipName(blip)
	end
end

function EndPreview()
	if menu_data.preview.handle then
	    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( menu_data.preview.handle ) )
		menu_data.preview.handle = nil
		SetEntityCoords(GetPlayerPed(-1), table.unpack(menu_data.preview.start_coords))
		menu_data.preview.prev_menu:Visible(true)
	end
end

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

function DrawText3D(x, y, z, distance, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < distance then
	    SetTextScale(0.35, 0.35)
	    SetTextFont(4)
	    SetTextProportional(1)
	    SetTextColour(255, 255, 255, 215)
	    SetTextEntry("STRING")
	    SetTextCentre(1)
	    AddTextComponentString(text)
	    DrawText(_x,_y)
	    local factor = (string.len(text)) / 500
	    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
	end
end