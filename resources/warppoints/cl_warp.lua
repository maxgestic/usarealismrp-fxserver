local INTERACTION_KEY = 86 -- "E"

local warp_locations = {
  ["the Hen House"] = {
      entrance = {
          x = -299.48,
          y = 6255.23,
          z = 30.53
      },
      exit = {
          x = -1387.47,
          y = -588.195,
          z = 29.3195
      },
      job_access = "civ"
  },
  ["the jail cells"] = {
    entrance = {
      x = -447.414,
      y = 6000.88,
      z = 30.7
    },
    exit = {
      x = 450.957,
      y = -986.462,
      z = 25.9
    },
    job_access = "emergency"
  },
  ["the courthouse"] = {
	entrance = {
      x = 317.283,
	  y = -1631.1505,
	  z = 31.59
    },
    exit = {
      x = 234.547,
      y = -413.567,
      z = -119.365
    },
    job_access = "civ"
  }
}

Citizen.CreateThread(function()
  while true do
    Wait(1)
    for locationName, locationCoords in pairs(warp_locations) do
      -- draw the markers
      if GetDistanceBetweenCoords(locationCoords.entrance.x, locationCoords.entrance.y, locationCoords.entrance.z,GetEntityCoords(GetPlayerPed(-1))) < 50 then
        DrawMarker(27, locationCoords.entrance.x, locationCoords.entrance.y, locationCoords.entrance.z, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
      elseif GetDistanceBetweenCoords(locationCoords.exit.x, locationCoords.exit.y, locationCoords.exit.z,GetEntityCoords(GetPlayerPed(-1))) < 50 then
        DrawMarker(27, locationCoords.exit.x, locationCoords.exit.y, locationCoords.exit.z, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
      end
      -- enter/exit
      if GetDistanceBetweenCoords(locationCoords.entrance.x, locationCoords.entrance.y, locationCoords.entrance.z,GetEntityCoords(GetPlayerPed(-1))) < 1.6 then
        DrawSpecialText("Press [ ~b~E~w~ ] to enter " .. locationName .. "!")
        if IsControlPressed(0, INTERACTION_KEY) then
          -- is location access restricted to certain jobs?
          if locationCoords.job_access == "civ" then
            print("job access: " ..locationCoords.job_access)
            Citizen.Wait(500)
            RequestCollisionAtCoord(locationCoords.exit.x+1.0, locationCoords.exit.y, locationCoords.exit.z)
            Citizen.Wait(1500)
            SetEntityCoords(GetPlayerPed(-1), locationCoords.exit.x+1.0, locationCoords.exit.y, locationCoords.exit.z)
          else
            --print("job access: " ..locationCoords.job_access)
            TriggerServerEvent("warp:checkJob", locationCoords)
          end
        end
      elseif GetDistanceBetweenCoords(locationCoords.exit.x, locationCoords.exit.y, locationCoords.exit.z,GetEntityCoords(GetPlayerPed(-1))) < 1.6 then
        DrawSpecialText("Press [ ~b~E~w~ ] to exit " .. locationName .. "!")
        if IsControlPressed(0, INTERACTION_KEY) then
          Citizen.Wait(500)
          RequestCollisionAtCoord(locationCoords.entrance.x+1.0, locationCoords.entrance.y, locationCoords.entrance.z)
          Citizen.Wait(1500)
          SetEntityCoords(GetPlayerPed(-1), locationCoords.entrance.x+1.0, locationCoords.entrance.y, locationCoords.entrance.z)
        end
      end
    end
  end
end)

RegisterNetEvent("warp:warpToPoint")
AddEventHandler("warp:warpToPoint", function(locationCoords)
  Citizen.Wait(500)
  RequestCollisionAtCoord(locationCoords.exit.x+1.0, locationCoords.exit.y, locationCoords.exit.z)
  Citizen.Wait(1500)
  SetEntityCoords(GetPlayerPed(-1), locationCoords.exit.x+1.0, locationCoords.exit.y, locationCoords.exit.z)
end)

function DrawSpecialText(m_text)
  ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end
