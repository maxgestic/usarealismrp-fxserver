--# Created by: minipunch
--# for USA REALISM rep
--# requres 'globals' resource to send notifications and usa_rp to change their model, check their jail time on join, and stuff like that

local releaseX, releaseY, releaseZ = 1847.086, 2585.990, 45.672
local lPed
local imprisoned = false
local assigned_cell = nil

-- start of NUI menu

local menuEnabled = false

function EnableGui(enable)
    SetNuiFocus(enable, enable)
    menuEnabled = enable
    SetPedCanSwitchWeapon(GetPlayerPed(-1), (not menuEnabled))

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

RegisterNetEvent("jail:notify")
AddEventHandler("jail:notify", function(msg)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end)

RegisterNetEvent("jail:openMenu")
AddEventHandler("jail:openMenu", function()
    EnableGui(true, true)
    SetPedCanSwitchWeapon(GetPlayerPed(-1), false)
    -- look at clipboard:
    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, 1)
end)

RegisterNUICallback('submit', function(data, cb)
	EnableGui(false, false) -- close form
    TriggerServerEvent("jail:jailPlayerFromMenu", data)
    cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
    EnableGui(false, false)
    cb('ok')
end)

Citizen.CreateThread(function()
  while true do
    -- jail menu check --
    if menuEnabled then
      DisableControlAction(29, 241, menuEnabled) -- scroll up
      DisableControlAction(29, 242, menuEnabled) -- scroll down
      DisableControlAction(0, 1, menuEnabled) -- LookLeftRight
      DisableControlAction(0, 2, menuEnabled) -- LookUpDown
      DisableControlAction(0, 142, menuEnabled) -- MeleeAttackAlternate
      DisableControlAction(0, 106, menuEnabled) -- VehicleMouseControlOverride
      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({
          type = "click"
        })
      end
    end
    -- escaping jail check --
    if assigned_cell then
      local mycoords = GetEntityCoords(GetPlayerPed(-1))
      if Vdist(mycoords.x, mycoords.y, mycoords.z, assigned_cell.x, assigned_cell.y, assigned_cell.z) > 350 then
        TriggerEvent("jail:escaped")
        assigned_cell = nil
      end
    end
    Citizen.Wait(0)
  end
end)

-- end of NUI menu stuff

RegisterNetEvent("jail:jail")
AddEventHandler("jail:jail", function(cell, gender)

  --print("x: " .. cell.x)
  --print("y: " .. cell.y)
  --print("z: " .. cell.z)

  if not cell then
    cell = {x = 1727.1, y = 2636.2, z = 45.6, occupant = nil}
  end

  local lPed = GetPlayerPed(-1)
  RequestCollisionAtCoord(cell.x, cell.y, cell.z)
  Wait(1000)
  SetEntityCoords(lPed, cell.x, cell.y, cell.z, 1, 0, 0, 1) -- tp to jail
  while not HasCollisionLoadedAroundEntity(lPed) do
      Citizen.Wait(100)
      SetEntityCoords(lPed, cell.x, cell.y, cell.z, 1, 0, 0, 1) -- tp to jail
  end
  assigned_cell = cell
  TriggerEvent("cuff:unCuff")
  imprisoned = true

  TriggerEvent("jail:changeClothes", gender)
  TriggerEvent("jail:removeWeapons")
  TriggerEvent("RPD:toggleJailed", true)

end)

RegisterNetEvent("jail:release")
AddEventHandler("jail:release", function(character)
  Citizen.CreateThread(function()
    local model
    SetEntityCoords(GetPlayerPed(-1), releaseX, releaseY, releaseZ, 1, 0, 0, 1) -- release from jail
    imprisoned = false
    if not character.hash then
      model = GetHashKey("a_m_y_skater_01")
      RequestModel(model)
      while not HasModelLoaded(model) do -- Wait for model to load
        Citizen.Wait(100)
      end
      SetPlayerModel(PlayerId(), model)
      SetModelAsNoLongerNeeded(model)
    else
      TriggerEvent("RPD:revivePerson")
      TriggerEvent("usa:setPlayerComponents", character)
    end
    TriggerServerEvent("jail:clearCell", assigned_cell, false)
    TriggerEvent("cuff:unCuff")
    assigned_cell = nil
    TriggerEvent("RPD:toggleJailed", false)
  end)
end)

RegisterNetEvent("jail:escaped")
AddEventHandler("jail:escaped", function()
  imprisoned = false
  TriggerServerEvent("jail:clearCell", assigned_cell, true)
  TriggerEvent("usa:notify", "You escaped prison!")
end)

RegisterNetEvent("jail:wrongPw")
AddEventHandler("jail:wrongPw", function()

	TriggerEvent("chatMessage", "SYSTEM", { 255,99,71 }, "^0WRONG JAIL PW")

end)

RegisterNetEvent("jail:removeWeapons")
AddEventHandler("jail:removeWeapons", function()

	RemoveAllPedWeapons(GetPlayerPed(-1), true) -- strip weapons

end)

RegisterNetEvent("jail:changeClothes")
AddEventHandler("jail:changeClothes", function(gender)

	-- only change clothes if male, since there is no female prisoner ped --
	if gender == "male" or gender == "undefined" or not gender then

    if not IsPedModel(GetPlayerPed(-1), GetHashKey("mp_m_freemode_01")) then

  		Citizen.CreateThread(function()
  			local model = GetHashKey("S_M_Y_Prisoner_01")

  			RequestModel(model)
  			while not HasModelLoaded(model) do -- Wait for model to load
  				Citizen.Wait(100)
  			end

  			SetPlayerModel(PlayerId(), model)
  			SetModelAsNoLongerNeeded(model)
  			SetPedRandomComponentVariation(GetPlayerPed(-1), false)

  		end)

    else

      --SetPedComponentVariation(me, 4, 7, 15, 0)
      SetPedComponentVariation(GetPlayerPed(-1), 4, 7, 15, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 6, 42, 2, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 11, 1, 0, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 8, 1, 0, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 2)

    end

	else

    if IsPedModel(GetPlayerPed(-1), GetHashKey("mp_f_freemode_01")) then

      SetPedComponentVariation(GetPlayerPed(-1), 4, 3, 15, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 4, 3, 15, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 0, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 11, 9, 1, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 15, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)
      SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)

    end

  end

end)

function getPlayerDistanceFromCoords(x,y,z)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,x,y,z,true)
end
