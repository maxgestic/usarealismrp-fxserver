local INTERACTION_KEY = 86 -- "E"
--GiveWeaponToPed(PlayerPedId(), 171789620, 1000, false, false)

-- enter: x = 1085.9984130859,y = 215.00494384766, z = -49.195377349854
-- exit: x = 979.99719238281,y = 57.005077362061, z = 116.16428375244

local warp_locations = {
  --[[
  ["Casino"] = {
    entrance = {
        coords = {928.15985107422, 44.713218688965, 81.095771789551},
        heading = 73.0
    },
    exit = {
      coords = {1089.9970703125, 207.00463867188, -48.996398925781},
      heading = 350.0
    },
    job_access = "civ",
    groundMarker = true,
    skipSound = true
  },
  ["Casino - Penthouse"] = {
    entrance = {
        coords = {1085.9984130859, 215.00494384766, -49.195377349854},
        heading = 180.0
    },
    exit = {
      coords = {979.99719238281, 57.005077362061, 116.16428375244},
      heading = 265.0
    },
    job_access = "civ",
    groundMarker = true,
    skipSound = true
  },
  --]]
  ["Upper Yacht"] = {
    entrance = {
        coords = {-2036.3878173828,-1033.9129638672, 5.8823575973511},
        heading = 180.0
    },
    exit = {
      coords = {-2045.3041992188,-1030.9090576172, 8.9714965820313},
      heading = 265.0
    },
    job_access = "civ"
  },
  ['24/7 - Innocence Blvd.'] = { -- 24/7 little soul
    entrance = {
      coords = {26.365692138672, -1315.4512939453, 29.622989654541},
      heading = 180.0
    },
    exit = {
      coords = {31.172891616821,-1340.5278320313,29.497024536133},
      heading = 180.0
    },
    job_access = 'civ'
  },
  ["24/7 - Paleto Back Door"] = { -- 24/7 paleto
  	entrance = {
      coords = {1741.41, 6419.52, 35.04},
      heading = 340.0
    },
    exit = {
      coords = {1736.7709960938, 6418.537109375, 35.037254333496},
      heading = 62.0
    },
  job_access = "civ"
  },
  ["24/7 - Sandy Back Door"] = { -- 24/7 sandy
  	entrance = {
      coords = {1963.75, 3749.59, 32.26},
      heading = 300.0
    },
    exit = {
      coords = {1962.3913574219, 3749.0971679688, 32.343746185303},
      heading = 125.0
    },
  job_access = "civ"
  },
  ['24/7 - Harmony Back Door'] = { -- 24/7 harmony
    entrance = {
      coords = {542.01, 2663.68, 42.17},
      heading = 100.0
    },
    exit = {
      coords = {543.06, 2663.99, 42.15},
      heading = 270.0
    },
  job_access = 'civ'
  },
  ['24/7 - Canyon Back Door'] = { -- 24/7 banham canyon
    entrance = {
      coords = {-3047.55, 589.93, 7.78},
      heading = 20.0
    },
    exit = {
      coords = {-3047.39, 589.11, 7.90},
      heading = 200.0
    },
  job_access = 'civ'
  },
  ['24/7 - Grove Back Door'] = { -- LTD grove st.
    entrance = {
      coords = {-40.98, -1747.79, 29.32},
      heading = 325.0
    },
    exit = {
      coords = {-41.73, -1748.90, 29.42},
      heading = 145.0
    },
  job_access = 'civ'
  },
  ['24/7 - LTD Back Door'] = { -- LTD mirror park
    entrance = {
      coords = {1160.71, -312.03, 69.277},
      heading = 8.0
    },
    exit = {
      coords = {1160.91, -313.11, 69.20},
      heading = 195.0
    },
  job_access = 'civ'
  },
  ['24/7 - LS Back Door'] = { -- 24/7 ls freeway
    entrance = {
      coords = {2546.47, 385.69, 108.61},
      heading = 80.0
    },
    exit = {
      coords = {2550.96, 387.99, 108.62},
      heading = 175.0
    },
  job_access = 'civ'
  },
  ["Pillbox Helipad"] = {
  	entrance = {
      coords = {327.24771118164, -603.35797119141, 43.284008026123},
      heading = 80.0
    },
    exit = {
      coords = {338.52, -583.87, 74.16},
      heading = 250.0
    },
  job_access = "emergency"
  },
  ['Pillbox Medical'] = {
    entrance = {
      coords = {355.49, -596.29, 28.77},
      heading = 260.0
    },
    exit = {
      coords = {332.22552490234, -595.58044433594, 43.284019470215},
      heading = 340.0
    },
  job_access = 'civ'
  },
  ['Nightclub'] = {
    entrance = {
      coords = {-337.23, 207.189, 88.57},
      heading = 338.0
    },
    exit = {
      coords = {-1569.32, -3017.59, -74.40},
      heading = 355.0
    },
  job_access = 'civ'
  },
  ['Morgue'] = {
    entrance = {
      coords = {241.06, -1378.98, 33.74},
      heading = 139.0
    },
    exit = {
      coords = {254.65, -1372.64, 24.53},
      heading = 48.0
    },
  job_access = 'emergency'
  },
  ['DA Office'] = {
    entrance = {
      coords = {-70.76, -801.21, 44.22},
      heading = 340.0
    },
    exit = {
      coords = {-80.55, -832.68, 243.38},
      heading = 248.5
    },
    job_access = 'da'
  },
  ['DA Garage'] = {
    entrance = {
      coords = {-67.7, -812.13, 243.38},
      heading = 250.0
    },
    exit = {
      coords = {-84.83, -824.43, 36.02},
      heading = 348.2,
    },
    job_access = 'da'
  },
  ['Vinewood Home 1'] = {
    entrance = {
      coords = {346.92343139648, 440.76049804688, 147.70223999023},
      heading = 111.0
    },
    exit = {
      coords = {341.6022644043, 437.49826049805, 149.39402770996},
      heading = 292.0
    },
    job_access = 'civ'
  },
  ['Life Invader - Office'] = {
    entrance = {
      coords = {-1048.4464111328, -238.31770324707, 44.021060943604},
      heading = 300.0
    },
    exit = {
      coords = {-1047.1091308594, -237.77569580078, 44.021022796631},
      heading = 120.0
    },
    job_access = 'civ'
  }
}

Citizen.CreateThread(function()
  while true do
    Wait(1)
    local ped = GetPlayerPed(-1)
    local entitycoords = GetEntityCoords(ped)
    for key, value in pairs(warp_locations) do
      local x, y, z = table.unpack(value.entrance.coords)
      local _x, _y, _z = table.unpack(value.exit.coords)
      local entranceDist = GetDistanceBetweenCoords(x, y, z, entitycoords, true)
      local exitDist = GetDistanceBetweenCoords(_x, _y, _z, entitycoords, true)
      -- ground marker
      if value.groundMarker then
        if entranceDist < 50.0 then 
          DrawMarker(27, x, y, z - 0.9, 0, 0, 0, 0, 0, 0, 0.71, 0.71, 0.71, 255 --[[r]], 150 --[[g]], 30 --[[b]], 90 --[[alpha]], 0, 0, 2, 0, 0, 0, 0)
        elseif exitDist < 50.0 then
          DrawMarker(27, _x, _y, _z - 0.9, 0, 0, 0, 0, 0, 0, 0.71, 0.71, 0.71, 60 --[[r]], 150 --[[g]], 30 --[[b]], 90 --[[alpha]], 0, 0, 2, 0, 0, 0, 0)
        end
      end
      -- enter/exit
      if entranceDist < 1.0 then
        DrawText3D(x, y, z, 4, '[E] - Enter '..key)
        if IsControlPressed(0, INTERACTION_KEY) then
          -- is location access restricted to certain jobs?
          if value.job_access == "civ" then
            DoorTransition(ped, _x, _y, _z, value.entrance.heading, value.skipSound)
          else
            --print("job access: " ..locationCoords.job_access)
            TriggerServerEvent("warp:checkJob", value.exit.coords, value.entrance.heading, value.job_access)
          end
        end
      elseif exitDist < 1.0 then
        DrawText3D(_x, _y, _z, 4, '[E] - Exit '..key)
        if IsControlPressed(0, INTERACTION_KEY) then
          DoorTransition(ped, x, y, z, value.exit.heading, value.skipSound)
        end
      end
    end
  end
end)

RegisterNetEvent("warp:warpToPoint")
AddEventHandler("warp:warpToPoint", function(x, y, z, locationHeading)
  DoorTransition(PlayerPedId(), x, y, z, locationHeading)
end)

function DrawText3D(x, y, z, distance, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
      SetTextScale(0.35, 0.35)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 215)
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
      local factor = (string.len(text)) / 370
      DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
  end
end

function PlayDoorAnimation()
    while ( not HasAnimDictLoaded( 'anim@mp_player_intmenu@key_fob@' ) ) do
        RequestAnimDict( 'anim@mp_player_intmenu@key_fob@' )
        Citizen.Wait( 0 )
  end
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, 1.0, -1, 48)
end

function DoorTransition(playerPed, x, y, z, heading, skipSound)
  PlayDoorAnimation()
  DoScreenFadeOut(500)
  Wait(500)
  RequestCollisionAtCoord(x, y, z)
  SetEntityCoordsNoOffset(playerPed, x, y, z, false, false, false, true)
  SetEntityHeading(playerPed, heading)
  while not HasCollisionLoadedAroundEntity(playerPed) do
      Citizen.Wait(100)
      SetEntityCoords(playerPed, x, y, z, 1, 0, 0, 1)
  end
  if not skipSound then
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'door-shut', 0.5)
  end
  Wait(2000)
  DoScreenFadeIn(500)
end
