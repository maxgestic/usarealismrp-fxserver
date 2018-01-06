local JOBS = {
  ["Weed"] = {
    harvest = {x = 2224.04, y = 5577.28, z = 52.7},
    process = {x = 0000.04, y = 0000.28, z = 00.7}.
    sell = {x = 0000.04, y = 0000.28, z = 00.7},
    harvest_time = 10
  }
}

local KEY = 38 -- "E"

------------------------------------------------
-- See if player is close to any job location --
------------------------------------------------
Citizen.CreateThread(function()
  while true do
    local player_ped = GetPlayerPed(-1)
    local player_coords = GetEntityCoords(ped)
    for job, places in pairs(JOBS) do
      if Vdist(player_coords, places.harvest.x, places.harvest.y, places.harvest.z) < 9 then
        print("player is close to job location:  " .. job)
        drawTxt("Press ~g~E~w~ to harvest " .. job .. "!",0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1, KEY) then
          Harvest(job, places.harvest_time)
        end
      elseif Vdist(player_coords, places.process.x, places.process.y, places.process.z) < 9 then
        print("player is close to job location:  " .. job)
        drawTxt("Press ~g~E~w~ to process " .. job .. "!",0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1, KEY) then
          --Process(job, places.harvest_time)
        end
      elseif Vdist(player_coords, places.sell.x, places.sell.y, places.sell.z) < 9 then
        print("player is close to job location:  " .. job)
        drawTxt("Press ~g~E~w~ to sell " .. job .. "!",0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1, KEY) then
          --Sell(job, places.harvest_time)
        end
      end
    end
    Wait(0)
  end
end)

------------------
-- HARVEST ITEM --
------------------
function Harvest(to_harvest_item_name, anim_play_time)
  -- weed:
  if to_harvest_item_name == "Weed" then
    -- play animation:
    local anim = {
      dict = "anim@move_m@trash",
      name = "pickup"
    }
    TriggerEvent("usa:playAnimation", anim.name, anim.dict, anim_play_time)
    --
  end
  -- pause for time
  Wait(anim_play_time * 1000)
  -- give item harvested item:
  TriggerServerEvent("HPS:rewardItem", to_harvest_item_name)
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
