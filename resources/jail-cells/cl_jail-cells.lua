local JAIL_CELLS = {
  ["1"] = {
    outside = {x = 462.539, y = -993.908, z = 24.91},
    inside = {x = 461.008, y = -993.646, z = 24.92}
  },
  ["2"] = {
    outside = {x = 462.809, y = -998.283, z = 24.92},
    inside = {x = 460.88, y = -998.539, z = 24.92}
  },
  ["3"] = {
    outside = {x = 462.752, y = -1002.26, z = 24.92},
    inside = {x = 460.843, y = -1002.05, z = 24.92}
  }
}

local LOCK_KEY = 38 -- "E"

RegisterNetEvent("jail:toggleDoorLock")
AddEventHandler("jail:toggleDoorLock", function(number, locked)
  local cell_to_lock = getDoorInDirection(JAIL_CELLS[number].outside, JAIL_CELLS[number].inside)
  SetEntityAsMissionEntity(cell_to_lock, true, true)
  FreezeEntityPosition(cell_to_lock, locked)
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
    local player_ped = GetPlayerPed(-1)
    local player_ped_coords = GetEntityCoords(player_ped, 1)
    for cell_number, data in pairs(JAIL_CELLS) do
      if Vdist(data.outside.x, data.outside.y, data.outside.z, player_ped_coords.x, player_ped_coords.y, player_ped_coords.z) < 1.0 then
        DrawSpecialText("Press ~g~E~w~ to toggle cell #" .. cell_number .. " lock")
        if IsControlJustPressed(1, LOCK_KEY) then
          print("attempting to lock or unlock cell #" .. cell_number)
          TriggerServerEvent("jail:checkDoorLock", cell_number)
        end
      end
    end
	end
end)

function getDoorInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 16, GetPlayerPed(-1), 0)
	local a, b, c, d, door = GetRaycastResult(rayHandle)
	return door
end

function DrawSpecialText(m_text)
  ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end
