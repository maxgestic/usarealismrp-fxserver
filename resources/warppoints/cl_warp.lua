local INTERACTION_KEY = 86 -- "E"

local warp_locations = {
  ["Bahama Mama's"] = {
      entrance = {
          x = -1388.94,
          y = -585.919,
          z = 29.2195
      },
      exit = {
          x = -1387.47,
          y = -588.195,
          z = 29.3195
      }
  },
  ["the jail cells"] = {
    entrance = {
      x = -447.414,
      y = 6000.88,
      z = 30.6
    },
    exit = {
      x = 468.598,
      y = -1012.62,
      z = 25.3
    }
  }
}

Citizen.CreateThread(function()
  while true do
    Wait(1)
    for locationName, locationCoords in pairs(warp_locations) do
      -- draw the markers
      if GetDistanceBetweenCoords(locationCoords.entrance.x, locationCoords.entrance.y, locationCoords.entrance.z,GetEntityCoords(GetPlayerPed(-1))) < 50 then
        DrawMarker(1, locationCoords.entrance.x, locationCoords.entrance.y, locationCoords.entrance.z, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
      elseif GetDistanceBetweenCoords(locationCoords.exit.x, locationCoords.exit.y, locationCoords.exit.z,GetEntityCoords(GetPlayerPed(-1))) < 50 then
        DrawMarker(1, locationCoords.exit.x, locationCoords.exit.y, locationCoords.exit.z, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
      end
      -- enter/exit
      if GetDistanceBetweenCoords(locationCoords.entrance.x, locationCoords.entrance.y, locationCoords.entrance.z,GetEntityCoords(GetPlayerPed(-1))) < 1.6 then
        DrawSpecialText("Press [ ~b~E~w~ ] to enter " .. locationName .. "!")
        if IsControlPressed(0, INTERACTION_KEY) then
          Citizen.Wait(500)
          RequestCollisionAtCoord(locationCoords.exit.x+1.0, locationCoords.exit.y, locationCoords.exit.z)
          SetEntityCoords(GetPlayerPed(-1), locationCoords.exit.x+1.0, locationCoords.exit.y, locationCoords.exit.z)
        end
      elseif GetDistanceBetweenCoords(locationCoords.exit.x, locationCoords.exit.y, locationCoords.exit.z,GetEntityCoords(GetPlayerPed(-1))) < 1.6 then
        DrawSpecialText("Press [ ~b~E~w~ ] to exit " .. locationName .. "!")
        if IsControlPressed(0, INTERACTION_KEY) then
          Citizen.Wait(500)
          RequestCollisionAtCoord(locationCoords.entrance.x+1.0, locationCoords.entrance.y, locationCoords.entrance.z)
          SetEntityCoords(GetPlayerPed(-1), locationCoords.entrance.x+1.0, locationCoords.entrance.y, locationCoords.entrance.z)
        end
      end
    end
  end
end)

function DrawSpecialText(m_text)
  ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end
