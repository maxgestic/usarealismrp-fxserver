essence = 0.142
local stade = 0
local lastModel = 0

local vehiclesUsed = {}

Citizen.CreateThread(function()
	while true do
		Wait(3000)
		CheckVeh()
	end
end)

Citizen.CreateThread(function()
	TriggerServerEvent("essence:addPlayer")
	while true do
		Wait(0)
		renderBoxes()
	end
end)

local isNearFuelStation
local stationNumber
local isNearFuelPStation
local stationPlaneNumber
local isNearFuelHStation
local stationHeliNumber
local isNearFuelBStation
local stationBoatNumber

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(6000)
		local me = GetPlayerPed(-1)
		isNearFuelStation, stationNumber = isNearStation(me)
		isNearFuelPStation, stationPlaneNumber = isNearPlaneStation(me)
		isNearFuelHStation, stationHeliNumber = isNearHeliStation(me)
		isNearFuelBStation, stationBoatNumber = isNearBoatStation(me)
	end
end)


Citizen.CreateThread(function()

	local menu = false
	local bool = false
	local int = 0
	local position = 1
	local array = {"TEST", "TEST2", "TEST3", "TEST4"}

	while true do
		Citizen.Wait(0)

		--[[
		local isNearFuelStation, stationNumber = isNearStation()
		local isNearFuelPStation, stationPlaneNumber = isNearPlaneStation()
		local isNearFuelHStation, stationHeliNumber = isNearHeliStation()
		local isNearFuelBStation, stationBoatNumber = isNearBoatStation()
		--]]

		local me = GetPlayerPed(-1)
		local is_in_veh = IsPedInAnyVehicle(me, -1)
		local is_in_heli = IsPedInAnyHeli(me)


		------------------------------- VEHICLE FUEL PART -------------------------------

		if(isNearFuelStation and is_in_veh and not is_in_heli and not isBlackListedModel()) then
			if isElectricModel() then
				Info(settings[lang].electricError)
			else
				Info(settings[lang].openMenu)

				if(IsControlJustPressed(1, 38)) then
					menu = not menu
					int = 0
					--[[Menu.hidden = not Menu.hidden

					Menu.Title = "Station essence"
					ClearMenu()
					Menu.addButton("Eteindre le moteur", "stopMotor")]]--
				end

				if(menu) then
					TriggerEvent("fuelGUI:Title", settings[lang].buyFuel)

					local maxEscense = 60-(essence/0.142)*60

					TriggerEvent("fuelGUI:Int", settings[lang].liters.." : ", int, 0, maxEscense, function(cb)
						int = cb
					end)

					TriggerEvent("fuelGUI:Option", settings[lang].confirm, function(cb)
						if(cb) then
							menu = not menu
							local playerCoords = GetEntityCoords(me, false)
							TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
								TriggerServerEvent("essence:buy", int, stationNumber,false, property)
							end)
						else

						end
					end)

					TriggerEvent("fuelGUI:Update")
				end
			end
		elseif (isNearElectricStation(me) and is_in_veh and not is_in_heli and not isBlackListedModel()) then
			if isElectricModel() then
				Info(settings[lang].openMenu)

				if(IsControlJustPressed(1, 38)) then
					menu = not menu
					int = 0
					--[[Menu.hidden = not Menu.hidden

					Menu.Title = "Station essence"
					ClearMenu()
					Menu.addButton("Eteindre le moteur", "stopMotor")]]--
				end

				if(menu) then
					TriggerEvent("fuelGUI:Title", settings[lang].buyFuel)

					local maxEssence = 60-(essence/0.142)*60

					TriggerEvent("fuelGUI:Int", settings[lang].percent.." : ", int, 0, maxEssence, function(cb)
						int = cb
					end)

					TriggerEvent("fuelGUI:Option", settings[lang].confirm, function(cb)
						if(cb) then
							menu = not menu
							local playerCoords = GetEntityCoords(me, false)
							TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
								TriggerServerEvent("essence:buy", int, electricityPrice,true, property)
							end)
						else

						end
					end)

					TriggerEvent("fuelGUI:Update")
				end
			else
				Info(settings[lang].fuelError)
			end
		elseif(isNearFuelBStation and is_in_veh and not IsPedInAnyHeli(me) and not isBlackListedModel()) then
			Info(settings[lang].openMenu)

			if(IsControlJustPressed(1, 38)) then
				menu = not menu
				int = 0
				--[[Menu.hidden = not Menu.hidden

				Menu.Title = "Station essence"
				ClearMenu()
				Menu.addButton("Eteindre le moteur", "stopMotor")]]--
			end

			if(menu) then
				TriggerEvent("fuelGUI:Title", settings[lang].buyFuel)

				local maxEssence = 60-(essence/0.142)*60
				TriggerEvent("fuelGUI:Int", settings[lang].percent.." : ", int, 0, maxEssence, function(cb)
					int = cb
				end)

				TriggerEvent("fuelGUI:Option", settings[lang].confirm, function(cb)
					if(cb) then
						menu = not menu
						local playerCoords = GetEntityCoords(me, false)
						TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
							TriggerServerEvent("essence:buy", int, stationBoatNumber,false, property)
						end)
					else

					end
				end)

				TriggerEvent("fuelGUI:Update")
			end
		elseif(isNearFuelPStation and is_in_veh and not isBlackListedModel()) then
			if isPlaneModel() then
				Info(settings[lang].openMenu)

				if(IsControlJustPressed(1, 38)) then
					menu = not menu
					int = 0
					--[[Menu.hidden = not Menu.hidden

					Menu.Title = "Station essence"
					ClearMenu()
					Menu.addButton("Eteindre le moteur", "stopMotor")]]--
				end

				if(menu) then
					TriggerEvent("fuelGUI:Title", settings[lang].buyFuel)

					local maxEssence = 60-(essence/0.142)*60

					TriggerEvent("fuelGUI:Int", settings[lang].percent.." : ", int, 0, maxEssence, function(cb)
						int = cb
					end)

					TriggerEvent("fuelGUI:Option", settings[lang].confirm, function(cb)
						if(cb) then
							menu = not menu
							local playerCoords = GetEntityCoords(me, false)
							TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
								TriggerServerEvent("essence:buy", int, stationPlaneNumber,false, property)
							end)
						else

						end
					end)

					TriggerEvent("fuelGUI:Update")
				end
			else
				Info(settings[lang].fuelError)
			end
		elseif(isNearFuelHStation and is_in_veh and not isBlackListedModel()) then
			if isHeliModel() then
				Info(settings[lang].openMenu)

				if(IsControlJustPressed(1, 38)) then
					menu = not menu
					int = 0
					--[[Menu.hidden = not Menu.hidden

					Menu.Title = "Station essence"
					ClearMenu()
					Menu.addButton("Eteindre le moteur", "stopMotor")]]--
				end

				if(menu) then
					TriggerEvent("fuelGUI:Title", settings[lang].buyFuel)

					local maxEssence = 60-(essence/0.142)*60

					TriggerEvent("fuelGUI:Int", settings[lang].percent.." : ", int, 0, maxEssence, function(cb)
						int = cb
					end)

					TriggerEvent("fuelGUI:Option", settings[lang].confirm, function(cb)
						if(cb) then
							menu = not menu
							local playerCoords = GetEntityCoords(me, false)
							TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
								TriggerServerEvent("essence:buy", int, stationHeliNumber,false, property)
							end)
						else

						end
					end)

					TriggerEvent("fuelGUI:Update")
				end
			else
				Info(settings[lang].fuelError)
			end
		end

	end
end)

local wasInAVeh = false
Citizen.CreateThread(function()

	while true do
		Wait(10000)
		local me = GetPlayerPed(-1)
		if(vehiclesUsed ~= nil and IsPedInAnyVehicle(me) and GetPedVehicleSeat(me) == -1 and not isBlackListedModel()) then
			wasInAVeh = true
			local index = getVehIndex()
			TriggerServerEvent("essence:setToAllPlayerEscense", essence, GetVehicleNumberPlateText(GetVehiclePedIsUsing(me)), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(me))))
			Wait(5000)
		else
			if(wasInAVeh) then
				TriggerServerEvent("essence:setToAllPlayerEscense", essence, GetVehicleNumberPlateText(GetVehiclePedIsUsing(me)), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(me))))
				wasInAVeh = false
				Wait(5000)
			end
		end
	end

end)


-- This appears to be what actually "consumes" the vehicle's fuel
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(5000)
		local me = GetPlayerPed(-1)
		if(IsPedInAnyVehicle(me, -1) and GetPedVehicleSeat(me) == -1 and not isBlackListedModel()) then
			local kmh = GetEntitySpeed(GetVehiclePedIsIn(me, false)) * 3.6
			local vitesse = math.ceil(kmh)

			if(vitesse > 0 and vitesse <20) then
				stade = 0.00010
			elseif(vitesse >= 20 and vitesse <50) then
				stade = 0.00011
			elseif(vitesse >= 50 and vitesse < 70) then
				stade = 0.00012
			elseif(vitesse >= 70 and vitesse <90) then
				stade = 0.00013
			elseif(vitesse >=90 and vitesse <130) then
				stade = 0.00014
			elseif(vitesse >= 130) then
				stade = 0.00025
			else
				stade = 0
			end

			local _essence = essence
			if(essence - stade > 0) then
				essence = essence - stade
			else
				essence = 0
				SetVehicleUndriveable(GetVehiclePedIsUsing(me), true)
			end
		end
	end

end)

-- 0.0001 pour 0 à 20, 0.142 = 100%
-- Donc 0.0001 km en moins toutes les 10 secondes

local lastPlate = 0
function CheckVeh()
	local me = GetPlayerPed(-1)
	if(IsPedInAnyVehicle(me, -1) and not isBlackListedModel()) then

		--if((lastPlate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and lastModel ~= GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) or (lastPlate ~= GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and lastModel == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) or (lastPlate ~= GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and lastModel ~= GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) then
		if(not wasInAVeh) then
			TriggerServerEvent("vehicule:getFuel", GetVehicleNumberPlateText(GetVehiclePedIsUsing(me)), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(me))))
			lastModel = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(me)))
			lastPlate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(me))
			Wait(10000)
		end
	end


	if(essence == 0 and GetVehiclePedIsUsing(me) ~= nil) then
		SetVehicleEngineOn(GetVehiclePedIsUsing(me), false, false, false)
	end
end

local UI = {
	x =  0.000,
	y = -0.001,
}

function renderBoxes()
	local me = GetPlayerPed(-1)
	if(IsPedInAnyVehicle(me, -1) and GetPedVehicleSeat(me) == -1 and not isBlackListedModel()) then
		DrawRect(0.086, 0.806, 0.142, 0.0149999999999998, 0, 0, 0, 130)
		DrawRect(0.015+(essence/2), 0.8062, essence, 0.0087, 225, 146, 45, 255)

		local percent = (essence/0.142)*100
		drawRct(UI.x + 0.11, UI.y + 0.864, 0.046, 0.03, 0, 0, 0, 150)
		drawTxt(UI.x + 0.61, UI.y + 1.3525, 1.0, 1.0, 0.64 , "~w~" .. math.floor(percent), 255, 255, 255, 255)
		drawTxt(UI.x + 0.6355, UI.y + 1.36, 1.0, 1.0, 0.4, "~w~ Fuel", 255, 255, 255, 255)
	end
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function isNearStation(ped)
	local plyCoords = GetEntityCoords(ped, 0)

	for _,items in pairs(station) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 2) then
			return true, items.s
		end
	end

	return false
end


function isNearPlaneStation(ped)
	local plyCoords = GetEntityCoords(ped, 0)

	for _,items in pairs(avion_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 10) then
			return true, items.s
		end
	end

	return false
end


function isNearHeliStation(ped)
	local plyCoords = GetEntityCoords(ped, 0)

	for _,items in pairs(heli_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 10) then
			return true, items.s
		end
	end

	return false
end


function isNearBoatStation(ped)
	local plyCoords = GetEntityCoords(ped, 0)

	for _,items in pairs(boat_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 10) then
			return true, items.s
		end
	end

	return false
end


function isNearElectricStation(ped)
	local plyCoords = GetEntityCoords(ped, 0)

	for _,items in pairs(electric_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 2) then
			return true
		end
	end

	return false
end

--100% = 100L = 100$
-- 1% = 1L = 1


function Info(text, loop)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, loop, 1, 0)
end



function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end


function isBlackListedModel()
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))))
	local isBL = false
	for _,k in pairs(blacklistedModels) do
		if(k==model) then
			isBL = true
			break;
		end
	end

	return isBL
end

function isElectricModel()
	--local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))))
	local hash = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1)))
	local isEL = false
	for _,k in pairs(electric_model) do
		if(GetHashKey(k)==hash) then
			isEL = true
			break;
		end
	end
	return isEL
end


function isHeliModel()
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))))
	local isHe = false
	for _,k in pairs(heli_model) do
		if(k==model) then
			isHe = true
			break;
		end
	end

	return isHe
end


function isPlaneModel()
	--local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))))
	local hash = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1)))
	local isPl = false
	for _,k in pairs(plane_model) do
		if(GetHashKey(k)==hash) then
			isPl = true
			break;
		end
	end

	return isPl
end


function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent("essence:setEssence")
AddEventHandler("essence:setEssence", function(ess,vplate,vmodel)
	if(ess ~= nil and vplate ~= nil and vmodel ~=nil) then
		local bool,index = searchByModelAndPlate(vplate,vmodel)

		if(bool and index ~=nil) then
			vehiclesUsed[index].es = ess
		else
			table.insert(vehiclesUsed, {plate = vplate, model = vmodel, es = ess})
		end
	end
end)




RegisterNetEvent("essence:hasBuying")
AddEventHandler("essence:hasBuying", function(amount)
	local amountToEssence = (amount/60)*0.142

	local done = false
	while done == false do
		Wait(0)
		local _essence = essence
		if(amountToEssence-0.0005 > 0) then
			amountToEssence = amountToEssence-0.0005
			essence = _essence + 0.0005
			_essence = essence
			if(_essence > 0.142) then
				essence = 0.142
				done = true
			end
			SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), true)
			SetVehicleEngineOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), false, false, false)
			Wait(100)
		else
			essence = essence + amountToEssence
			done = true
		end
	end

	--local index = getVehIndex()
	--vehiclesUsed[index].es = essence

	SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
	SetVehicleEngineOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), true, false, false)
end)


RegisterNetEvent("vehicule:sendFuel")
AddEventHandler("vehicule:sendFuel", function(bool, ess)

	if(bool == 1) then
		essence = ess
	else
		essence = (math.random(1,100)/100)*0.142
		--table.insert(vehiclesUsed, {plate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))), model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1)))), es = essence})
		vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))
	end

end)

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end


AddEventHandler("playerSpawned", function()
	TriggerServerEvent("essence:playerSpawned")
	TriggerServerEvent("essence:addPlayer")
end)


RegisterNetEvent("showNotif")
AddEventHandler("showNotif", function(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end)

RegisterNetEvent("advancedFuel:setEssence")
AddEventHandler("advancedFuel:setEssence", function(percent, plate, model)
	local toEssence = (percent/100)*0.142

	if(GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) == plate) then
		essence = toEssence
	end

	local bool, index = searchByModelAndPlate(plate, model)()

	if(bool) then
		vehiclesUsed[index].es = toEssence
	end
end)


RegisterNetEvent('essence:sendEssence')
AddEventHandler('essence:sendEssence', function(array)
	for i,k in pairs(array) do
		vehiclesUsed[i] = {plate=k.plate,model=k.model,es=k.es}
	end
end)

function IsVehInArray()
	for i,k in pairs(vehiclesUsed) do
		if(k.plate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and k.model == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) then
			return true
		end
	end

	return false
end

function searchByModelAndPlate(plate, model)
	for i,k in pairs(vehiclesUsed) do
		if(k.plate == plate and k.model == model) then
			return true, i
		end
	end

	return false, nil
end

function getVehIndex()
	local index = -1

	for i,k in pairs(vehiclesUsed) do
		if(k.plate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and k.model == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) then
			index = i
		end
	end

	return index
end

function getEssence()
	return essence
end

----------------
-- jerry cans --
----------------
local JERRY_CAN_LOCATIONS = {
	{x = 173.0, y = 6601.7, z = 31.8 }, -- paleto ron station
	{x = 1695.5, y = 6419.4, z = 32.6 }, -- paleto 24/7
	{x = 459.7, y = -990.9, z = 30.6}, -- mission row locker room
	{x = -359.7, y = 6109.2, z = 31.4}, -- paleto FD
	{x = -2554.6, y = 2327.1, z = 33.1}, -- route 1 / route 68 gas station
	{x = 1691.6, y = 4930.3, z = 42.1}, -- grapeseed gas tation
	{x = 2005.9, y = 3781.4, z = 32.2}, -- sandy shores gas station
	{x = 180.1, y = 6602.9, z = 31.8}, -- paleto ron station 2
	{x = 187.0, y = 6604.3, z = 31.8}, -- paleto ron station 3
	{x = 1204.6, y = 2663.4, z = 37.8}, -- route 68
	{x = 1039.3, y = 2668.0, z = 39.5}, -- route 68
	{x = 2681.6, y = 3267.5, z = 55.4}, -- senora fwy 1
	{x = 261.8, y = 2598.4, z = 44.7}, -- route 68
	{x = 45.7, y = 2781.7, z = 57.8}, -- route 68
	{x = 1182.9, y = -329.7, z = 69.2}, -- LS 1
	{x = 620.8, y = 269.2, z = 103.1} -- LS 2
}

local JERRY_CAN_HASH = -962731009

local JERRY_CAN_KEY = 38 -- "E"

Citizen.CreateThread(function()
	while true do
		local me = GetPlayerPed(-1)
		local mycoords = GetEntityCoords(me)
		-- picking up jerry can --
		for i = 1, #JERRY_CAN_LOCATIONS do
			if Vdist(mycoords.x, mycoords.y, mycoords.z, JERRY_CAN_LOCATIONS[i].x, JERRY_CAN_LOCATIONS[i].y, JERRY_CAN_LOCATIONS[i].z) < 4.0 then
				if IsControlJustPressed(1, JERRY_CAN_KEY) then
					if IsPickupWithinRadius(JERRY_CAN_HASH, JERRY_CAN_LOCATIONS[i].x, JERRY_CAN_LOCATIONS[i].y, JERRY_CAN_LOCATIONS[i].z, 4.0) and not IsPedInAnyVehicle(me, true) then
						-- give jerry can item in inventory for use --
						--print("giving jerry can to id: " .. GetPlayerServerId(PlayerId()))
						local jerry_can = {
							name = "Jerry Can",
							quantity = 1,
							legality = "legal",
							type = "weapon",
							hash = 883325847,
							weight = 10.0
						}
						TriggerServerEvent("usa:insertItem", jerry_can, jerry_can.quantity, GetPlayerServerId(PlayerId()))
					end
				end
			end
		end
		Wait(0)
	end
end)

function CreateJerryCanPickups()
	for i = 1, #JERRY_CAN_LOCATIONS do
		local can = JERRY_CAN_LOCATIONS[i]
		local pickup = CreatePickupRotate(JERRY_CAN_HASH, can.x, can.y, can.z - 0.5, 0, 0, 0, 512, 1, 1, 1, JERRY_CAN_HASH)
    SetPickupRegenerationTime(pickup, 180)
	end
end

Citizen.CreateThread(function()
	CreateJerryCanPickups()
end)
