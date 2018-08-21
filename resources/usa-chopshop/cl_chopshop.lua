--# by: minipunch
--# for: USA REALISM RP
--# Chop shop script to get money from stealing certain types of vehicles, possibly with a bonus if done within a time limit

local KEY = 38 -- "E"

local JOB_TIME = 3600000 -- in ms (one hour)

local BLIPS_ENABLED = true

local peds= {
  --{x = 99.841, y = 3752.429, z = 39.668, hash = 846439045}, -- sandy shores (stab city)
  {x = 2346.036, y = 3045.159, z = 48.16, hash = 846439045}
}

local drop_offs = {
  --{x = 103.855, y = 3746.65, z = 39.75}, -- sandy shores (stab city)
  {x = 2349.481, y = 3040.80, z = 48.165} -- next to tow truck spot in sandy shores
}

local current_job = {
  active = false,
  vehicles = {},
  start_time = 0
}

local chop_time = 18000 -- in ms

local me = GetPlayerPed(-1)
local playerCoords = GetEntityCoords(me, false)

--------------------
-- Event Handlers --
--------------------
RegisterNetEvent("chopshop:startJob")
AddEventHandler("chopshop:startJob", function(wanted_vehicles)
  if not current_job.active then
    current_job.active = true
    current_job.vehicles = wanted_vehicles
    current_job.start_time = GetGameTimer()
  end
  TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^3Please bring me these models:")
  TriggerEvent("usa:notify", "Please bring me these models:")
  local msg = ""
  for i = 1, #wanted_vehicles do
    --print("wanted: " .. wanted_vehicles[i].name)
    TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^0" .. ConvertRealCarToGtaCar(wanted_vehicles[i].name))
    msg = msg .. ConvertRealCarToGtaCar(wanted_vehicles[i].name) .. "\n"
  end
  TriggerEvent("usa:notify", msg)
end)

-----------------------------------------------
-- Watches for entering the chopping circle  --
-----------------------------------------------
Citizen.CreateThread(function()
  local handle = 0
  local display_name = "Undefined"
  while true do
	me = GetPlayerPed(-1)

    if current_job.active then
      for i = 1, #drop_offs do
        DrawMarker(27, drop_offs[i].x, drop_offs[i].y, drop_offs[i].z - 1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 5.0, 255 --[[r]], 92 --[[g]], 92 --[[b]], 90, 0, 0, 2, 0, 0, 0, 0)
        playerCoords = GetEntityCoords(me, false)
        if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,drop_offs[i].x,drop_offs[i].y,drop_offs[i].z,false) < 3 then
          drawTxt("Press [~y~E~w~] to start chopping the vehicle",7,1,0.5,0.8,0.6,255,255,255,255)
          if IsControlJustPressed(1,KEY) then
            local found = false
            handle = GetVehiclePedIsIn(me, true)
            display_name = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(handle)))
            print("display_name: " .. display_name)
            for x = 1, #current_job.vehicles do
              if current_job.vehicles[x] then
                if display_name == string.lower(current_job.vehicles[x].name) then
                  print("matching vehicle found to chop!")
                  found = true
                  OpenAllDoors(handle)
                  TaskLeaveVehicle(me, handle, 256)
                  Wait(chop_time) -- delay giving reward
                  RemoveFromWantedVehicles(display_name)
                  NotifyOfUpdatedWantedVehicles()
				  local playerCoords = GetEntityCoords(me, false)
				  TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
					TriggerServerEvent("chopshop:reward", display_name, GetVehicleBodyDamage(handle), property)
				  end)
                  SetEntityAsMissionEntity( handle, true, true )
                  DeleteCar(handle)
                end
              end
            end
            if not found then
              TriggerEvent("usa:notify", "I didn't ask for this type of vehicle!")
            end
            found = false
          end
        elseif GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,drop_offs[i].x,drop_offs[i].y,drop_offs[i].z,false) > 3 then
          -- out of range

        end
      end
      ---------------------------------------
      -- watch for no more vehicles wanted --
      ---------------------------------------
      if #current_job.vehicles <= 0 then
        ResetJob()
      end
    end
	Wait(0)
  end
end)

-------------------------------------------
-- Watches for asking the ped for a job  --
-------------------------------------------
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if not current_job.active then
      for i = 1, #peds do
        DrawMarker(27, peds[i].x, peds[i].y, peds[i].z - 1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 5.0, 255 --[[r]], 92 --[[g]], 92 --[[b]], 90, 0, 0, 2, 0, 0, 0, 0)
        local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
        if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,peds[i].x,peds[i].y,peds[i].z,false) < 3 then
          drawTxt("Press ~y~[E]~w~ to talk with Miguel",0,1,0.5,0.8,0.6,255,255,255,255)
          if IsControlJustPressed(1,KEY) then
            TriggerServerEvent("chopshop:startJob")
          end
        elseif GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,peds[i].x,peds[i].y,peds[i].z,false) > 3 then
          -- out of range

        end
      end
    end
  end
end)

-------------------------------------
-- Watch for job timer expiration  --
-------------------------------------
Citizen.CreateThread(function()
  while true do
    if current_job.active then
      if GetGameTimer() >= current_job.start_time + JOB_TIME then
        print("timer expired! ending chop shop job!")
        ResetJob()
        TriggerEvent("usa:notify", "You took too long to bring me the vehicles I wanted! Hit me up next time.")
      end
    end
    Wait(0)
  end
end)

---------------
-- Add Blips --
---------------
Citizen.CreateThread(function()
  if BLIPS_ENABLED then
    addBlips()
  end
end)

-------------------------------
-- S P A W N  J O B  P E D S --
-------------------------------
Citizen.CreateThread(function()
	for i = 1, #peds do
		local hash = peds[i].hash
		--local hash = GetHashKey(data.ped.model)
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end
		local ped = CreatePed(4, hash, peds[i].x, peds[i].y, peds[i].z, -90.0 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		TaskSetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetPedRandomComponentVariation(ped, true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRUG_DEALER_HARD", 0, true);
	end
end)

-----------------------
-- Utility Functions --
-----------------------
function ConvertRealCarToGtaCar(name)
  if string.lower(name) == "sabregt" then
    return "Ford Mustang Boss 302"
  elseif string.lower(name) == "sadler" then
    return "Ford F350 Super Duty"
  elseif string.lower(name) == "fugitive" then
    return "Masseratti Quattroporte"
  elseif string.lower(name) == "buffalo" then
    return "Chrystler 300C"
  elseif string.lower(name) == "ruiner" then
	return "Imponte Ruiner"
  elseif string.lower(name) == "bobcatxl" then
	return "Vapid Bobcat XL"
  elseif string.lower(name) == "dubsta" then
	return "Benefactor Dubsta"
  elseif string.lower(name) == "tornado3" then
	return "Declasse Tornado"
  elseif string.lower(name) == "oracle2" then
	return "Ubermacht Oracle XS"
  elseif string.lower(name) == "rebel02" then
	return "Karin Rebel"
  elseif string.lower(name) == "sanchez02" then
	return "Miabatsu Sanchez"
  elseif string.lower(name) == "sandking" then
	return "Vapid Sandking XL"
  elseif string.lower(name) == "emperor" then
	return "Albany Emperor"
  elseif string.lower(name) == "seminole" then
	return "Canis Seminole"
  elseif string.lower(name) == "blista2" then
	return "Dinka Blista Compact"
  elseif string.lower(name) == "flatbed" then
	return "MTL Flatbed (tow)"
  elseif string.lower(name) == "scrap" then
	return "Utility Scrap Truck"
  elseif string.lower(name) == "peyote" then
	return "Vapid Peyote"
  elseif string.lower(name) == "bfinject" then
	return "BF Injection"
  elseif string.lower(name) == "penumbra" then
	return "Nissan 370z"
  else
    return name
  end
end

function GetVehicleBodyDamage(veh)
  local maxvehhp = 1000
  local damage = 0
  damage = (maxvehhp - GetVehicleBodyHealth(veh))/100
  --LSCMenu:addPurchase("Repair vehicle",round(250+150*damage,0), "Full body repair and engine service.")
  return (math.floor(250+75*damage) or 0)
end

function ResetJob()
  current_job.active = false
  current_job.vehicles = {}
  current_job.start_time = 0
end

function NotifyOfUpdatedWantedVehicles()
  if #current_job.vehicles > 0 then
    TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^3Thanks! I still want these models:")
    TriggerEvent("usa:notify", "Thanks! I still want these models:")
    local msg = ""
    for k = 1, #current_job.vehicles do
      --print("wanted: " .. wanted_vehicles[i].name)
      TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^0" .. ConvertRealCarToGtaCar(current_job.vehicles[k].name))
      msg = msg .. ConvertRealCarToGtaCar(current_job.vehicles[k].name) .. "\n"
    end
    TriggerEvent("usa:notify", msg)
  else
    TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^3Thanks! Let me know if you can help some more!")
    TriggerEvent("usa:notify", "Thanks! Let me know if you can help some more!")
  end
end

function RemoveFromWantedVehicles(name)
  if current_job.vehicles then
    for i = 1, #current_job.vehicles do
      if string.lower(current_job.vehicles[i].name) == string.lower(name) then
        table.remove(current_job.vehicles, i)
        return
      end
    end
  end
end

function DeleteCar(entity)
  Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function OpenAllDoors(playerCar)
  SetVehicleDoorOpen(playerCar, 5, true, true)
  SetVehicleDoorOpen(playerCar, 4, true, true)
  SetVehicleDoorOpen(playerCar, 0, true, true)
  SetVehicleDoorOpen(playerCar, 1, true, true)
  SetVehicleDoorOpen(playerCar, 2, true, true)
  SetVehicleDoorOpen(playerCar, 3, true, true)
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function addBlips()
  for i = 1, #drop_offs do
    local blip = AddBlipForCoord(drop_offs[i].x, drop_offs[i].y, drop_offs[i].z)
    SetBlipSprite(blip, 89)
    SetBlipColour(blip, 49)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Chop Shop")
    EndTextCommandSetBlipName(blip)
  end
end

RegisterNetEvent("makepedskillable")
AddEventHandler("makepedskillable", function()
    Citizen.CreateThread(function()
        for ped in exports.globals:EnumeratePeds() do
            SetEntityCanBeDamaged(ped, true)
            Wait(5)
        end
        print("Made all peds killable!")
    end)
end)
