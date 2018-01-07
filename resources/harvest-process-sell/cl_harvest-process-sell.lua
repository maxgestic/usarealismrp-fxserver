local JOBS = {
  ["Weed"] = {
    harvest = {x = 2224.04, y = 5577.28, z = 52.7, reward_item_name = "Raw Weed", time = 22},
    process = {x = 1442.84, y = 6332.9, z = 22.9, time = 25},
    sell = {x = -1134.04, y = 4948.84, z = 221.35}
  }
}

local KEY = 38 -- "E"
local SOUND_ENABLE = true

------------------------------------------------
-- See if player is close to any job location --
------------------------------------------------
Citizen.CreateThread(function()
  while true do
    local player_ped = GetPlayerPed(-1)
    local player_coords = GetEntityCoords(player_ped)
    for job, places in pairs(JOBS) do
      if Vdist(player_coords, places.harvest.x, places.harvest.y, places.harvest.z) < 9 then
        print("player is close to harvest job location:  " .. job)
        drawTxt("Press ~g~E~w~ to harvest " .. job .. "!",0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1, KEY) then
          TriggerEvent("usa:notify", "~y~Harvesting: ~w~(1x) " .. places.harvest.reward_item_name)
          Harvest(job, places.harvest.time)
        end
      elseif Vdist(player_coords, places.process.x, places.process.y, places.process.z) < 6.5 then
        print("player is close to process job location:  " .. job)
        drawTxt("Press ~g~E~w~ to process " .. job .. "!",0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1, KEY) then
          TriggerServerEvent("HPS:checkItem", job, places.process.time, "Process")
          Wait(places.process.time * 1000) -- prevent spamming
        end
      elseif Vdist(player_coords, places.sell.x, places.sell.y, places.sell.z) < 2.0 then
        print("player is close to sell job location:  " .. job)
        drawTxt("Press ~g~E~w~ to sell " .. job .. "!",0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1, KEY) then
          TriggerServerEvent("HPS:checkItem", job, 0, "Sale")
          --Sell(job, places.harvest_time)
        end
      end
    end
    Wait(0)
  end
end)

------------------
-- Draw Markers --
------------------
Citizen.CreateThread(function()
  while true do
    for job, places in pairs(JOBS) do
      DrawMarker(27, places.sell.x, places.sell.y, places.sell.z, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
    end
    Wait(0)
  end
end)

-------------------
-- CUSTOM EVENTS --
-------------------
RegisterNetEvent("HPS:continueProcessing")
AddEventHandler("HPS:continueProcessing", function(job_name, process_time)
  TriggerEvent("usa:notify", "~y~Processing: ~w~(1x) " .. string.lower(job_name))
  Process(job_name, process_time)
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
    TriggerEvent("usa:playAnimation", anim.name, anim.dict, harvest_time)
    -- play sound:
    if SOUND_ENABLE then TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 2.5, "trimming", 0.75) end
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
    TriggerEvent("usa:playAnimation", anim.name, anim.dict, process_time)
    -- play sound:
    if SOUND_ENABLE then TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 1.8, "weed-process", 1.0) end
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
