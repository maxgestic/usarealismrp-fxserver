local JOBS = {
  ["Weed"] = {
    harvest = {x = 2224.04, y = 5577.28, z = 52.7, reward_item_name = "Weed Bud", time = 15},
    process = {x = 1442.84, y = 6332.9, z = 22.9, time = 30, reward_item_name = "Hash"},
    sell = {x = -57.3836, y = 6650.69, z = 28.79, heading = 10.0},
    peds = {
      {x = 2197.88, y = 5577.93, z = 52.88, heading = 270.0, hash = -264140789, scenario = "WORLD_HUMAN_SMOKING_POT", type="info", gives_directions_to = "process", name = "Gerard Mendoza"}, -- weed process info ped
      --{x = -57.3836, y = 6650.69, z = 28.79, heading = 10.0, hash = 653210662, scenario = "WORLD_HUMAN_SMOKING", type = "sale"}, -- weed buyer
      {x = 1441.86, y = 6338.78, z = 24.7478, heading = 10.0, hash = 1191548746, scenario = "WORLD_HUMAN_HANG_OUT_STREET", type = "info", gives_directions_to = "sale", name = "Uncle Liam"}
    }
  }
}

-------------------------------------------------------------------
-- todo: make it so the info peds give directions to the next point
-------------------------------------------------------------------

local KEY = 38 -- "E"
local SOUND_ENABLE = true

--------------------
-- Spawn job peds --
--------------------
-- S P A W N  J O B  P E D S
Citizen.CreateThread(function()
	for name, data in pairs(JOBS) do
		for i = 1, #data.peds do
      local hash = data.peds[i].hash
  		--local hash = GetHashKey(data.ped.model)
  		print("requesting hash...")
  		RequestModel(hash)
  		while not HasModelLoaded(hash) do
  			RequestModel(hash)
  			Citizen.Wait(0)
  		end
  		print("spawning ped, heading: " .. data.peds[i].heading)
  		print("hash: " .. hash)
  		local ped = CreatePed(4, hash, data.peds[i].x, data.peds[i].y, data.peds[i].z, data.peds[i].heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
      data.peds[i].handle = ped
      SetEntityCanBeDamaged(ped,false)
  		SetPedCanRagdollFromPlayerImpact(ped,false)
  		TaskSetBlockingOfNonTemporaryEvents(ped,true)
  		SetPedFleeAttributes(ped,0,0)
  		SetPedCombatAttributes(ped,17,1)
  		SetPedRandomComponentVariation(ped, true)
      TaskStartScenarioInPlace(ped, data.peds[i].scenario, 0, true);
    end
	end
end)

------------------------------------------------
-- See if player is close to any job location --
------------------------------------------------
Citizen.CreateThread(function()
  while true do
    local player_ped = GetPlayerPed(-1)
    local player_coords = GetEntityCoords(player_ped)
    for job, places in pairs(JOBS) do
      if Vdist(player_coords, places.harvest.x, places.harvest.y, places.harvest.z) < 9 then
        --print("player is close to harvest job location:  " .. job)
        drawTxt("Press ~g~E~w~ to harvest " .. job .. "!",0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1, KEY) then
          TriggerServerEvent("HPS:checkItem", job, places.harvest.time, "Harvest")
          Wait(places.harvest.time * 1000) -- prevent spamming
        end
      elseif Vdist(player_coords, places.process.x, places.process.y, places.process.z) < 3.5 then
        --print("player is close to process job location:  " .. job)
        drawTxt("Press ~g~E~w~ to process " .. job .. "!",0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1, KEY) then
          TriggerServerEvent("HPS:checkItem", job, places.process.time, "Process")
          Wait(places.process.time * 1000) -- prevent spamming
        end
		--[[
      elseif Vdist(player_coords, places.sell.x, places.sell.y, places.sell.z) < 2.0 then
        print("player is close to sell job location:  " .. job)
        drawTxt("Press ~g~E~w~ to sell " .. job .. "!",0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1, KEY) then
          TriggerServerEvent("HPS:checkItem", job, 0, "Sale")
          --Sell(job, places.harvest_time)
        end
      end
	  --]]
	  end
      -- check for info peds:
      for i = 1, # places.peds do
        if Vdist(player_coords, places.peds[i].x, places.peds[i].y, places.peds[i].z) < 3.0 then
          if places.peds[i].type == "info" then
            drawTxt("Press ~g~E~w~ to speak with " .. places.peds[i].name .. "!",0,1,0.5,0.8,0.6,255,255,255,255)
            if IsControlJustPressed(1, KEY) then
              ClearGpsPlayerWaypoint()
              if places.peds[i].gives_directions_to == "process" then
                TriggerEvent("usa:notify", "Here are directions to the place where you can process " .. places.harvest.reward_item_name .. "s")
                SetNewWaypoint(places.process.x, places.process.y)
              elseif places.peds[i].gives_directions_to == "sale" then
                TriggerEvent("usa:notify", "Here are directions to a place where you can sell " .. places.process.reward_item_name)
                SetNewWaypoint(places.sell.x, places.sell.y)
              end
              -- play ped sound:
              local sounds = {
                {sound = "Shout_Threaten_Ped", param = "Speech_Params_Force_Shouted_Critical"},
                {sound = "Shout_Threaten_Gang", param = "Speech_Params_Force_Shouted_Critical"},
                {sound = "Generic_Hi", param = "Speech_Params_Force"}
              }
              local random_sound = sounds[math.random(1, tonumber(#sounds))]
              PlayAmbientSpeech1(places.peds[i].handle, random_sound.sound, random_sound.param)
            end
          end
        end
      end
    end
    Wait(0)
  end
end)

------------------
-- Draw Markers --
--[[----------------
Citizen.CreateThread(function()
  while true do
    for job, places in pairs(JOBS) do
      DrawMarker(27, places.sell.x, places.sell.y, places.sell.z, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
    end
    Wait(0)
  end
end)
--]]

-------------------
-- CUSTOM EVENTS --
-------------------
RegisterNetEvent("HPS:continueHarvesting")
AddEventHandler("HPS:continueHarvesting", function(job_name, process_time)
  for job, things in pairs(JOBS) do
    if job == job_name then
      TriggerEvent("usa:notify", "~y~Harvesting: ~w~(x1) " .. things.harvest.reward_item_name)
      Harvest(job, things.harvest.time)
    end
  end
end)

RegisterNetEvent("HPS:continueProcessing")
AddEventHandler("HPS:continueProcessing", function(job_name, process_time)
  for job, things in pairs(JOBS) do
    if job == job_name then
      TriggerEvent("usa:notify", "~y~Processing: ~w~(x1) " .. things.process.reward_item_name)
      Process(job_name, things.process.time)
    end
  end
end)

------------------
-- HARVEST ITEM --
------------------
function Harvest(to_harvest_item_name, harvest_time)
  -- weed:
  if to_harvest_item_name == "Weed" then
    -- play animation:
    local anim = {
      dict = "anim@move_m@trash",
      name = "pickup"
    }
    --TriggerEvent("usa:playAnimation", anim.name, anim.dict, harvest_time)
    --TriggerEvent("usa:playAnimation", anim.dict, anim.name, 5, 1,  harvest_time * 1000, 31, 0, 0, 0, 0)
    TriggerEvent("usa:playAnimation", anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, harvest_time)
    -- play sound:
    if SOUND_ENABLE then TriggerServerEvent("InteractSound_SV:PlayOnSource", "trimming", 0.1) end
  end
  -- pause for time
  Wait(harvest_time * 1000)
  -- give item harvested item:
  TriggerServerEvent("HPS:rewardItem", to_harvest_item_name, "Harvest")
end

------------------
-- PROCESS ITEM --
------------------
function Process(to_process_item_name, process_time)
  -- weed:
  if to_process_item_name == "Weed" then
    -- play animation:
    local anim = {
      dict = "timetable@jimmy@ig_1@idle_a",
      name = "hydrotropic_bud_or_something"
    }
    --TriggerEvent("usa:playAnimation", anim.name, anim.dict, process_time)
    --TriggerEvent("usa:playAnimation", anim.dict, anim.name, 5, 1,  process_time * 1000, 31, 0, 0, 0, 0)
    TriggerEvent("usa:playAnimation", anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, process_time)
    -- play sound:
    if SOUND_ENABLE then TriggerServerEvent("InteractSound_SV:PlayOnSource", "weed-process", 0.105) end
  end
  -- pause for time
  Wait(process_time * 1000)
  -- give item harvested item:
  TriggerServerEvent("HPS:rewardItem", to_process_item_name, "Process")
end

----------------------
-- UTLITY FUNCTIONS --
----------------------
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
