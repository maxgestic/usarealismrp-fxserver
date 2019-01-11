--# by: minipunch
--# for USA REALISM rp
--# This script allows players to sit down on chairs, benches, etc properly

local CHAIR_MODELS = {
  {hash = -1631057904, offset = 0.48},
  {hash = -171943901, offset = 0.04},
  {hash = 1805980844, offset = 0.5},
  {hash = -403891623, offset = 0.5},
  {hash = 437354449, offset = 0.5},
  {hash = 291348133, offset = 0.5},
  {hash = 146905321, offset = 0.5},
  {hash = -741944541, offset = 0.5},
  {hash = -1572018818, offset = 0.7},
  {hash = -1859912896, offset = 0.5},
  {hash = -1317098115, offset = 0.5},
  {hash = -628719744, offset = 0.5},
  {hash = -1736970383, offset = 0.5},
  {hash = -99500382, offset = 0.3},
  {hash = 725259233, offset = 0.5},
  {hash = -71417349, offset = 0.55},
  {hash = -784954167, offset = 0.0},
  {hash = -1521264200, offset = 0.0},
  {hash = -1829764702, offset = 0.8},
  {hash = 267626795, offset = 0.5},
  {hash = -294499241, offset = 0.5},
  {hash = 1028260687, offset = 0.0},
  {hash = 1071807406, offset = 0.0},
  {hash = 1281480215, offset = 0.0},
  {hash = 1404176808, offset = 0.53},
  {hash = 764848282, offset = 0.52},
  {hash = 525667351, offset = 0.52},
  {hash = -1889727927, offset = 0.5},
  {hash = 1482870357, offset = 0.5},
  {hash = 536071214, offset = 0.5},
  {hash = 1005957871, offset = -0.3},
  {hash = -171943901, offset = 0.5},
  {hash = 475561894, offset = 0.5},
  {hash = 2142033519, offset = 0.3}
}

local sitting_on = nil

local SIT_CANCEL_KEY = 71

function Sit(ped, obj, offset)
  local pedbone = 57597 -- spine root
  local heading = GetEntityHeading(obj)
  SetEntityHeading(ped, heading)
  TaskPlayAnim(ped, "amb@prop_human_seat_chair@male@generic@base", "base", 8.0, -8, -1, 7, 0, 0, 0, 0) -- sitting animation (looped)
  AttachEntityToEntity(ped, obj, pedbone, 0.0, 0.0, offset, 0.0, 0.0, -180.0, false, false, false, false, 2, true)
  sitting_on = obj
end

function FindNearest()
  local me = GetPlayerPed(-1)
  local mycoords = GetEntityCoords(me)
  for obj in exports.globals:EnumerateObjects() do
    for i = 1, #CHAIR_MODELS do
      if GetEntityModel(obj) == CHAIR_MODELS[i].hash then
        local objcoords = GetEntityCoords(obj)
        if Vdist(objcoords.x, objcoords.y, objcoords.z, mycoords.x, mycoords.y, mycoords.z) < 2.0 then
          Sit(me, obj, CHAIR_MODELS[i].offset)
          return
        end
      end
    end
  end
end

function GetUp()
  local ped = GetPlayerPed(-1)
  DetachEntity(ped, true, true)
  TaskPlayAnim(ped, "amb@prop_human_seat_chair@male@generic@exit", "exit_forward", 8.0, -8, -1, 8, 0, 0, 0, 0) -- sitting animation (looped)
  sitting_on = nil
end

RegisterNetEvent("sit:sitOnNearest")
AddEventHandler("sit:sitOnNearest", function()
  if not sitting_on then
    local ped = GetPlayerPed(-1)
    if not IsPedCuffed(ped) then
      FindNearest()
    end
  else
    GetUp()
  end
end)

Citizen.CreateThread(function()
	while true do
		if sitting_on then
			if IsControlJustPressed(1, SIT_CANCEL_KEY) then
        GetUp()
      end
		end
		Wait(1)
	end
end)
