--# by: minipunch
--# for: USA REALISM RP
--# Chop shop script to get money from stealing certain types of vehicles, possibly with a bonus if done within a time limit

local KEY = 38 -- "E"

local JOB_TIME = 3600000 -- in ms (one hour)

local peds = {
  {x = 2346.036, y = 3045.159, z = 47.16, hash = 846439045, heading = 180.0},
  {x = -470.84, y = -1708.76, z = 17.91, hash = 846439045, heading = 270.0}
}

local drop_offs = {
  {x = 2349.481, y = 3040.80, z = 48.165}, -- next to tow truck spot in sandy shores
  {x = -465.21, y = -1718.34, z = 18.68}
}

local current_job = {
  active = false,
  vehicles = {},
  start_time = 0
}

local chop_time = 30000 -- in ms

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
  TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^3^*[CHOP SHOP] ^r^7Please bring me these models  (don\'t get caught):")
  local msg = ""
  for i = 1, #wanted_vehicles do
    --print("wanted: " .. wanted_vehicles[i].name)
    TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^0⠀• " .. ConvertRealCarToGtaCar(wanted_vehicles[i].name))
    msg = msg .. ConvertRealCarToGtaCar(wanted_vehicles[i].name) .. "\n"
  end
end)

-----------------------------------------------
-- Watches for entering the chopping circle  --
-----------------------------------------------
Citizen.CreateThread(function()
  local handle = 0
  local display_name = "Undefined"
  while true do
    Citizen.Wait(0)
    if current_job.active then
      local playerPed = PlayerPedId()
      local playerCoords = GetEntityCoords(playerPed)
      for i = 1, #drop_offs do
        DrawText3D(drop_offs[i].x, drop_offs[i].y, drop_offs[i].z, 10, '[E] - Drop-off Vehicle')
        if IsControlJustPressed(1,KEY) and Vdist(playerCoords, drop_offs[i].x, drop_offs[i].y, drop_offs[i].z) < 3.0 then
          local found = false
          local handle = GetVehiclePedIsIn(playerPed, true)
          local display_name = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(handle)))
          for x = 1, #current_job.vehicles do
            if display_name == string.lower(current_job.vehicles[x].name) then
              found = true
              if math.random() > 0.8 then
                local x, y, z = table.unpack(playerCoords)
                local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
                local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
                TriggerServerEvent('911:ChopShop', x, y, z, lastStreetNAME, IsPedMale(playerPed))
              end
              OpenAllDoors(handle)
              TaskLeaveVehicle(playerPed, handle, 256)
              SetVehicleDoorsLockedForAllPlayers(handle, true)
              SetVehicleDoorsLocked(handle, true)
              TriggerEvent('usa:notify', 'Wait here while the vehicle is being chopped up.')
              local chopped = true
              local beginTime = GetGameTimer()
              while GetGameTimer() - beginTime < chop_time do
                playerCoords = GetEntityCoords(playerPed)
                if Vdist(playerCoords, drop_offs[i].x, drop_offs[i].y, drop_offs[i].z) < 10.0 then
                  DrawTimer(beginTime, chop_time, 1.42, 1.475, 'CHOPPING')
                  Citizen.Wait(0)
                else
                  TriggerEvent('usa:notify', 'You went too far away while the vehicle was being chopped!')
                  chopped = false
                  break
                end
              end
              if chopped then
                RemoveFromWantedVehicles(display_name)
                NotifyOfUpdatedWantedVehicles()
    					  TriggerServerEvent("chopshop:reward", display_name, GetVehicleBodyDamage(handle))
                SetEntityAsMissionEntity(handle, true, true)
                DeleteCar(handle)
                break
              end
            end
          end
          if not found then
            TriggerEvent("usa:notify", "I didn't ask for this vehicle!")
          end
          found = false
        end
      end
    end
    ---------------------------------------
    -- watch for no more vehicles wanted --
    ---------------------------------------
    if #current_job.vehicles <= 0 then
      ResetJob()
    end
  end
end)

-------------------------------------------
-- Watches for asking the ped for a job  --
-------------------------------------------
Citizen.CreateThread(function()
  addBlips()
  while true do
    Citizen.Wait(0)
    if not current_job.active then
      local playerPed = PlayerPedId()
      local playerCoords = GetEntityCoords(playerPed)
      for i = 1, #peds do
        DrawText3D(peds[i].x, peds[i].y, peds[i].z + 1.0, 5, '[E] - Chop Shop')
        if IsControlJustPressed(1,KEY) and Vdist(playerCoords, peds[i].x, peds[i].y, peds[i].z) < 3.0 then
            TriggerServerEvent("chopshop:startJob")
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
        ResetJob()
        TriggerEvent("usa:notify", "You took too long to bring me the vehicles I wanted! Hit me up next time.")
      end
    end
    Wait(1000)
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
		local ped = CreatePed(4, hash, peds[i].x, peds[i].y, peds[i].z, peds[i].heading, false, true)
		SetEntityCanBeDamaged(ped, false)
		SetPedCanRagdollFromPlayerImpact(ped, false)
		TaskSetBlockingOfNonTemporaryEvents(ped, true)
		SetPedFleeAttributes(ped, 0, 0)
		SetPedCombatAttributes(ped, 17, 1)
		SetPedRandomComponentVariation(ped, true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRUG_DEALER_HARD", 0, true)
	end
end)

-----------------------
-- Utility Functions --
-----------------------
function ConvertRealCarToGtaCar(name)
  if string.lower(name) == "sabregt" then
    return "Declasse Sabre Turbo"
  elseif string.lower(name) == "sadler" then
    return "Vapid Sadler"
  elseif string.lower(name) == "fugitive" then
    return "Cheval Fugitive"
  elseif string.lower(name) == "buffalo" then
    return "Bravado Buffalo"
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
  elseif string.lower(name) == "peyote" then
	return "Vapid Peyote"
  elseif string.lower(name) == "bfinject" then
	return "BF Injection"
  else
    return name
  end
end

function GetVehicleBodyDamage(veh)
  local maxvehhp = 1000
  local damage = math.floor(maxvehhp - GetVehicleBodyHealth(veh))
  return damage
end

function ResetJob()
  TriggerServerEvent('chopshop:resetJob')
  current_job.active = false
  current_job.vehicles = {}
  current_job.start_time = 0
end

function NotifyOfUpdatedWantedVehicles()
  if #current_job.vehicles > 0 then
    local msg = "Vehicles still needed:\n"
    for k = 1, #current_job.vehicles do
      --print("wanted: " .. wanted_vehicles[i].name)
      msg = msg .. ConvertRealCarToGtaCar(current_job.vehicles[k].name) .. "\n"
    end
    TriggerEvent("usa:notify", msg)
  else
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
  for i = 1, 5 do
    SetVehicleDoorOpen(playerCar, i, true, true)
    Citizen.Wait(100)
  end
end

function addBlips()
  for i = 1, #drop_offs do
    local blip = AddBlipForCoord(drop_offs[i].x, drop_offs[i].y, drop_offs[i].z)
    SetBlipSprite(blip, 89)
    SetBlipColour(blip, 49)
    SetBlipScale(blip, 0.6)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Chop Shop")
    EndTextCommandSetBlipName(blip)
  end
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
    local factor = (string.len(text)) / 430
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
  end
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

RegisterNetEvent('character:setCharacter')
AddEventHandler('character:setCharacter', function()
    ResetJob()
end)