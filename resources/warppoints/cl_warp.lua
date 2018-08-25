local INTERACTION_KEY = 86 -- "E"

local warp_locations = {
    ["the Comedy Club"] = {
        entrance = {
            x = -429.9,
            y = 261.6,
            z = 82.1
        },
        exit = {
            x = -458.4,
            y = 284.7,
            z = 77.6
        },
        job_access = "civ"
    },
  ["the Hen House"] = {
      entrance = {
          x = -299.48,
          y = 6255.23,
          z = 30.53
      },
      exit = {
          x = -302.9,
          y = 6257.8,
          z = 31.7
      },
      job_access = "civ"
  },
  --[[
  ["the jail cells"] = {
    entrance = {
      x = -447.414,
      y = 6000.88,
      z = 30.7
    },
    exit = {
      x = 451.9,
      y = -987.9,
      z = 25.75
    },
    job_access = "emergency"
  },
  ["the photo room"] = {
    entrance = {
     x = 446.8,
     y = -986.4,
     z = 25.75
    },
    exit = {
        x = 404.5,
        y = -984.4,
        z = -100.0
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
  },
  ["24/7 Paleto Back Door"] = {
  	entrance = {
      x = 1741.144,
      y = 6420.12,
      z = 34.044
    },
    exit = {
      x = 1736.67,
      y = 6419.22,
      z = 34.04
    },
    job_access = "civ"
  },
  ["24/7 Sandy Back Door"] = {
  	entrance = {
      x = 1963.97,
      y = 3750.105,
      z = 31.256
    },
    exit = {
      x = 1962.048,
      y = 3749.229,
      z = 31.34
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
      end
      if GetDistanceBetweenCoords(locationCoords.exit.x, locationCoords.exit.y, locationCoords.exit.z,GetEntityCoords(GetPlayerPed(-1))) < 50 then
        DrawMarker(27, locationCoords.exit.x, locationCoords.exit.y, locationCoords.exit.z, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
      end
      -- enter/exit
      if GetDistanceBetweenCoords(locationCoords.entrance.x, locationCoords.entrance.y, locationCoords.entrance.z,GetEntityCoords(GetPlayerPed(-1))) < 1.6 then
        DrawSpecialText("Press [ ~b~E~w~ ] to enter " .. locationName .. "!")
        if IsControlPressed(0, INTERACTION_KEY) then
          -- is location access restricted to certain jobs?
          if locationCoords.job_access == "civ" then
            print("job access: " ..locationCoords.job_access)
            DoScreenFadeOut(500)
            Citizen.Wait(500)
            RequestCollisionAtCoord(locationCoords.exit.x+1.0, locationCoords.exit.y, locationCoords.exit.z)
            Citizen.Wait(1500)
            DoScreenFadeIn(1500)
            SetEntityCoords(GetPlayerPed(-1), locationCoords.exit.x+1.0, locationCoords.exit.y, locationCoords.exit.z)
          else
            --print("job access: " ..locationCoords.job_access)
            TriggerServerEvent("warp:checkJob", locationCoords)
          end
        end
      elseif GetDistanceBetweenCoords(locationCoords.exit.x, locationCoords.exit.y, locationCoords.exit.z,GetEntityCoords(GetPlayerPed(-1))) < 1.6 then
        DrawSpecialText("Press [ ~b~E~w~ ] to exit " .. locationName .. "!")
        if IsControlPressed(0, INTERACTION_KEY) then
          DoScreenFadeOut(500)
          Citizen.Wait(500)
          RequestCollisionAtCoord(locationCoords.entrance.x+1.0, locationCoords.entrance.y, locationCoords.entrance.z)
          Citizen.Wait(1500)
          DoScreenFadeIn(1500)
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
