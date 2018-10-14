local hands_up = false
local hands_tied = false
local blindfolded = false

local bag = nil;

---------------
-- blindfold --
---------------
RegisterNetEvent("crim:blindfold")
AddEventHandler("crim:blindfold", function(on, dont_send_message)
  --SetNuiFocus(on, false)
  SendNUIMessage({
    type = "enableui",
    enable = on,
    blindfold = on
  })
  blindfolded = on
  if not dont_send_message then
    if on then
      TriggerEvent("usa:notify", "You have been blindfolded!")
      bag = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true) -- Create head bag object!
      AttachEntityToEntity(bag, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- Attach object to head
    else
      TriggerEvent("usa:notify", "Blindfold removed!")
      DeleteEntity(bag)
      SetEntityAsNoLongerNeeded(bag)
    end
  end
end)

RegisterNetEvent("crim:attemptToBlindfoldNearestPerson")
AddEventHandler("crim:attemptToBlindfoldNearestPerson", function(blindfold)
  TriggerEvent("usa:getClosestPlayer", 1.5, function(player)
    if player.id ~= 0 then
      TriggerServerEvent("crim:foundPlayerToBlindfold", player.id, blindfold)
    else
      TriggerEvent("usa:notify", "No person found to blindfold!")
    end
  end)
end)

RegisterNetEvent("crim:attemptToRobNearestPerson")
AddEventHandler("crim:attemptToRobNearestPerson", function()
  TriggerEvent("usa:getClosestPlayer", 1.5, function(player)
    if player.id ~= 0 then
      TriggerServerEvent("crim:foundPlayerToRob", player.id)
    else
      TriggerEvent("usa:notify", "No person found to rob!")
    end
  end)
end)

RegisterNetEvent("crim:attemptToTieNearestPerson")
AddEventHandler("crim:attemptToTieNearestPerson", function(tying_up)
  TriggerEvent("usa:getClosestPlayer", 1.5, function(player)
    if player.id ~= 0 then
      TriggerServerEvent("crim:foundPlayerToTie", player.id, tying_up)
    else
      TriggerEvent("usa:notify", "No person found to tie!")
    end
  end)
end)

RegisterNetEvent("crim:tieHands")
AddEventHandler("crim:tieHands", function()
  local close_enough = false
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    -- tie up hands:
    Citizen.CreateThread(function()
      RequestAnimDict("mp_arresting")
      while not HasAnimDictLoaded("mp_arresting") do
        Citizen.Wait(100)
      end
      print("ENTITY WAS NOT PLAYING TIED UP ANIM, RETRYING..")
      ClearPedSecondaryTask(lPed)
      TaskPlayAnim(lPed, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(lPed, true)
      -- FreezeEntityPosition(lPed, true)
      TriggerEvent("usa:notify", "Your hands have been ~r~tied together~w~.")
      hands_tied = true
      hands_up = false
    end)
  end
end)

RegisterNetEvent("crim:untieHands")
AddEventHandler("crim:untieHands", function(from_id)
  if hands_tied then
    local lPed = GetPlayerPed(-1)
    if DoesEntityExist(lPed) then
      if closeEnoughToPlayer(from_id) then
        print("ENTITY WAS ALREADY PLAYING TIED UP ANIM, RELEASING HANDS..")
        ClearPedSecondaryTask(lPed)
        SetEnableHandcuffs(lPed, false)
        --FreezeEntityPosition(lPed, false)
        TriggerEvent("usa:notify", "You have been ~g~released~w~.")
        hands_tied = false
      end
    end
  end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
		if hands_tied then
			--DisableControlAction(1, 245, true) 245 = 5 FOR TEXT CHAT
			DisableControlAction(1, 117, true)
			DisableControlAction(1, 73, true)
			DisableControlAction(1, 29, true)
			DisableControlAction(1, 322, true)

			--DisableControlAction(1, 18, true)
			DisableControlAction(1, 24, true)
			DisableControlAction(1, 69, true)
			DisableControlAction(1, 92, true)
			DisableControlAction(1, 106, true)
			DisableControlAction(1, 122, true)
			DisableControlAction(1, 135, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 144, true)
			--DisableControlAction(1, 176, true)
			DisableControlAction(1, 223, true)
			DisableControlAction(1, 229, true)
			DisableControlAction(1, 237, true)
			DisableControlAction(1, 257, true)
			DisableControlAction(1, 329, true)
			DisableControlAction(1, 80, true)
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 250, true)
			DisableControlAction(1, 263, true)
			DisableControlAction(1, 310, true)
			--DisableControlAction(0, 288, true) -- interaction menu (F1)

			DisableControlAction(1, 22, true)
			DisableControlAction(1, 55, true)
			DisableControlAction(1, 76, true)
			DisableControlAction(1, 102, true)
			DisableControlAction(1, 114, true)
			DisableControlAction(1, 143, true)
			DisableControlAction(1, 179, true)
			DisableControlAction(1, 193, true)
			DisableControlAction(1, 203, true)
			DisableControlAction(1, 216, true)
			DisableControlAction(1, 255, true)
			DisableControlAction(1, 298, true)
			DisableControlAction(1, 321, true)
			DisableControlAction(1, 328, true)
			DisableControlAction(1, 331, true)
			DisableControlAction(0, 63, false)
			DisableControlAction(0, 64, false)
			DisableControlAction(0, 59, false)
			DisableControlAction(0, 278, false)
			DisableControlAction(0, 279, false)
			DisableControlAction(0, 68, false)
			DisableControlAction(0, 69, false)
			DisableControlAction(0, 75, false)
			DisableControlAction(0, 76, false)
			DisableControlAction(0, 102, false)
			DisableControlAction(0, 81, false)
			DisableControlAction(0, 82, false)
			DisableControlAction(0, 83, false)
			DisableControlAction(0, 84, false)
			DisableControlAction(0, 85, false)
			DisableControlAction(0, 86, false)
			DisableControlAction(0, 106, false)
			DisableControlAction(0, 25, false)

			-- slow down while cuffed
			--SetEntityVelocity(GetPlayerPed(-1), 0.3, 0.3, 0.0)
			DisableControlAction(0, 21, true)

			if not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) then
				RequestAnimDict("mp_arresting")
				while not HasAnimDictLoaded("mp_arresting") do
					Wait(100)
				end
				TaskPlayAnim(GetPlayerPed(-1), "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
			end
		end
		-- remove blind folds if dead:
		if IsPedDeadOrDying(GetPlayerPed(-1), 1) and blindfolded then
			TriggerEvent("crim:blindfold", false, true)
			blindfolded = false
		end
	end
end)

-- hands up animation --
Citizen.CreateThread(function()
  while true do
    local lPed = GetPlayerPed(-1)
    -- toggle hands up when "X" is pressed
    if GetLastInputMethod(2) then
      if IsControlJustPressed(0, 73) then -- "X"
        --print("hands_up: " .. tostring(hands_up))
        if hands_up then
  				ClearPedSecondaryTask(lPed)
          hands_up = false
  			else
          --print("putting hands up.. ped: " .. lPed)
          RequestAnimDict("random@mugging3")
  				while not HasAnimDictLoaded("random@mugging3") do
  					Citizen.Wait(100)
  				end
          TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
          hands_up = true
  		  end
      end
    end
    -- make sure to always play hands up anim when they should be up
    if hands_up then
      if not IsEntityPlayingAnim(lPed, "random@mugging3", "handsup_standing_base", 3) then
        --print("hands_up was true but lped was not playing anim.. starting anim with lped: " .. lPed)
        TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
      end
      BlockWeaponWheelThisFrame()
    end
    Wait(2)
  end
end)

RegisterNetEvent("crim:areHandsUp")
AddEventHandler("crim:areHandsUp", function(from_source, to_source)
  print("inside crim:areHandsUp with handsUp = " .. tostring(hands_up))
  if hands_up == true and closeEnoughToPlayer(from_source) then
    -- hands were up, continue tying hands
    TriggerServerEvent("crim:continueBounding", true, from_source, to_source)
  else
    -- notify player that their target's hands were not up
    TriggerServerEvent("crim:continueBounding", false, from_source, to_source)
  end
end)

RegisterNetEvent("crim:areHandsTied")
AddEventHandler("crim:areHandsTied", function(from_source, to_source, action)
  print("inside crim:areHandsTied with hands_tied= " .. tostring(hands_tied))
  -- don't need to check distance (or can't cause ped is in vehicle):
  if action == "unseat" then
    if hands_tied == true then
      TriggerEvent("place:unseat", from_source)
      return
    end
  end
  -- need to check distance
  if hands_tied == true and closeEnoughToPlayer(from_source) then
    if action == "rob" then
      print("hands were tied, removing money..")
      -- hands were up, continue stealing cash
      TriggerServerEvent("crim:continueRobbing", true, from_source, to_source)
    elseif action == "blindfold" then
      print("hands were tied, blindfolding..")
      TriggerServerEvent("crim:continueBlindfolding", true, from_source, to_source)
    elseif action == "drag" then
      TriggerEvent("dr:drag", from_source)
    elseif action == "place" then
      TriggerEvent("place")
    end
  else
    -- notify player that their target's hands were tied
    TriggerServerEvent("crim:continueRobbing", false, from_source, to_source)
  end
end)

RegisterNetEvent("civ:changeWalkStyle")
AddEventHandler("civ:changeWalkStyle", function(style)
	if style ~= 0 then
		SetClipset(style)
	else
		ResetPedMovementClipset(GetPlayerPed(-1), 0 )
	end
end)

-- trading/selling vehicles --
RegisterNetEvent("vehicle:confirmSell")
AddEventHandler("vehicle:confirmSell", function(details)
    local responded = false
    local message = "~y~OFFER: ~w~$" .. details.price .. " for ~w~" .. details.veh_to_sell.make .. " " .. details.veh_to_sell.model .. " [" .. details.veh_to_sell.plate .. "]" .. "\nAccept? ~g~Y~w~/~r~Backspace"
    TriggerEvent("usa:notify", message)
    Citizen.CreateThread(function()
        while not responded do
            Wait(1)
            DrawSpecialText( "~y~OFFER: ~w~$" .. details.price .. " for ~w~" .. details.veh_to_sell.make .. " " .. details.veh_to_sell.model .. " [" .. details.veh_to_sell.plate .. "]" .. "\nAccept? ~g~Y~w~/~r~Backspace" )
            if IsControlJustPressed(1, 246) then -- Y key
                print("player wants to buy vehicle!")
                responded = true
                TriggerServerEvent("vehicle:confirmSell", details, true)
            elseif IsControlJustPressed(1, 177) then -- Backspace key
                print("player does not want to buy vehicle!")
                responded = true
                TriggerServerEvent("vehicle:confirmSell", details, false)
            end
        end
    end)
end)

function closeEnoughToPlayer(from_id)
  local lPed = GetPlayerPed(-1)
  -- see if close enough to target
  for id = 0, 64 do
    if NetworkIsPlayerActive(id) then
      if GetPlayerServerId(id) == tonumber(from_id) then
        local target_ped = GetPlayerPed(id)
        if Vdist(GetEntityCoords(lPed, 1), GetEntityCoords(target_ped, 1)) < 1.0 then
          return true
        else
          return false
        end
      end
    end
  end
  return false
end

function SetClipset(clipset)
  local ped = GetPlayerPed( -1 )
  if DoesEntityExist(ped) and not IsEntityDead(ped) then
    if not IsPauseMenuActive() then
      if not IsPedInAnyVehicle(ped, true) then
		ResetPedMovementClipset(ped, 0 )
        RequestAnimSet(clipset)
        while not HasAnimSetLoaded(clipset) do
            Citizen.Wait(1)
        end
        SetPedMovementClipset(ped, clipset, 0.25)
      end
    end
  end
end

---------------------------------------
-- Make vehicle radio louder / quiet --
---------------------------------------
local IS_VEHICLE_LOUD = false

RegisterNetEvent("civ:radioLoudToggle")
AddEventHandler("civ:radioLoudToggle", function()
  local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
  if veh ~= 0 then
    IS_VEHICLE_LOUD = not IS_VEHICLE_LOUD
    SetVehicleRadioLoud(veh, IS_VEHICLE_LOUD)
    if IS_VEHICLE_LOUD then
      exports.globals:notify("Radio: ~g~loud~w~!")
    else
      exports.globals:notify("Radio: ~y~normal~w~!")
    end
  else
    exports.globals:notify("Must be in a vehicle!")
  end
end)
