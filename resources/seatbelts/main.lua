local isUiOpen = false
local beltOn       = false
local wasInCar     = false

IsCar = function(veh)
  local vc = GetVehicleClass(veh)
  return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end

Fwv = function (entity)
  local hr = GetEntityHeading(entity) + 90.0
  if hr < 0.0 then hr = 360.0 + hr end
  hr = hr * 0.0174533
  return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

local function blackout()
	-- Only blackout once to prevent an extended blackout if both speed and damage thresholds were met
		-- This thread will black out the user's screen for the specified time
		Citizen.CreateThread(function()
			DoScreenFadeOut(100)
			while not IsScreenFadedOut() do
				Citizen.Wait(0)
			end
			Citizen.Wait(4 * 1000)
			DoScreenFadeIn(250)
		end)
end

-- Button press listener --
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local ped = GetPlayerPed(-1)
    if IsControlJustReleased(0, 311) and GetLastInputMethod(0) and IsPedInAnyVehicle(ped, false) then
      if IsCar(GetVehiclePedIsIn(ped)) then
        beltOn = not beltOn
        if beltOn then
          --TriggerEvent("pNotify:SendNotification", {text = "Seatbelt On", type = "success", timeout = 1400, layout = "centerLeft"}
          TriggerServerEvent("InteractSound_SV:PlayOnSource", "seatbelt-in", 0.1)
          SendNUIMessage({
            displayWindow = 'false'
          })
          isUiOpen = true
        else
          --TriggerEvent("pNotify:SendNotification", {text = "Seatbelt Off", type = "error", timeout = 1400, layout = "centerLeft"})
          TriggerServerEvent("InteractSound_SV:PlayOnSource", "seatbelt-out", 0.1)
          SendNUIMessage({
            displayWindow = 'true'
          })
          isUiOpen = true
        end
      end
    end
  end
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    local ped = GetPlayerPed(-1)
    local car = GetVehiclePedIsIn(ped)

    if car ~= 0 and (wasInCar or IsCar(car)) then
      wasInCar = true
      if isUiOpen == false and not IsPlayerDead(PlayerId()) then
        SendNUIMessage({
          displayWindow = 'true'
        })
        isUiOpen = true
      end

      if beltOn then DisableControlAction(0, 75) end -- disable veh exit

      -- eject event listener --
      if not beltOn then
        local speed = GetEntityVelocity(car)
        local check1 = GetEntitySpeedVector(car, true).y
        Wait(2)
        local check2 = GetEntitySpeedVector(car, true).y
        if check1 - check2 > 10.0 then
          local co = GetEntityCoords(ped)
          local fw = Fwv(ped)
          SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
          SetEntityVelocity(ped, speed.x, speed.y, speed.z)
          blackout()
          Wait(1)
          SetPedToRagdoll(ped, 10000, 10000, 0, 0, 0, 0)
        end
      end

    elseif wasInCar then
      wasInCar = false
      beltOn = false
      if isUiOpen == true and not IsPlayerDead(PlayerId()) then
        SendNUIMessage({
          displayWindow = 'false'
        })
        isUiOpen = false
      end
    end

  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(100)
    if IsPlayerDead(PlayerId()) and isUiOpen == true then
      SendNUIMessage({
        displayWindow = 'false'
      })
      isUiOpen = false
    end

  end
end)
