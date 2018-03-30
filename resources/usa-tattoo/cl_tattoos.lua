local SHOPS = {
  {x = -293.711, y = 6200.428, z = 31.487}, -- paleto
  {x = 1863.775, y = 3747.57, z = 33.03}, -- sandy shores
  {x = 323.947, y = 179.87, z = 103.586}, -- los santos, vinewood area
  {x = 1321.550, y = -1653.529, z = 52.27}, -- los santos, east side
  {x = -1155.323, y = -1426.81, z = 4.9} -- los santos, west side vespucci beach
}

-- business circle coords: x = -291.85, y = 6197.3, z = 31.48

local menu = {
  open = false,
  key = 38, -- "E",
  page = "home"
}

local purchased_tattoos = {}

local last_entered = nil

-----------------------------------------------------
-- tattoo list, separated into pages (2, 2, and 3) --
-----------------------------------------------------
local TATTOOS = {
	["mpbeach_overlays"] = { -- native store name
  {
		["Head Tattoo 1"] = {"MP_Bea_M_Head_000",500,""},
		["Head Tattoo 2"] = {"MP_Bea_M_Head_001",500,""},
		["Head Tattoo 3"] = {"MP_Bea_M_Head_002",500,""},
		["Neck Tattoo 1"] = {"MP_Bea_F_Neck_000",500,""},
		["Neck Tattoo 2"] = {"MP_Bea_M_Neck_000",500,""},
		["Neck Tattoo 3"] = {"MP_Bea_M_Neck_001",500,""},
		["Back Tattoo 1"] = {"MP_Bea_F_Back_000",500,""},
		["Back Tattoo 2"] = {"MP_Bea_F_Back_001",500,""},
		["Back Tattoo 3"] = {"MP_Bea_F_Back_002",500,""},
		["Back Tattoo 4"] = {"MP_Bea_M_Back_000",500,""},
		["Torso Tattoo 1"] = {"MP_Bea_F_Chest_000",500,""},
		["Torso Tattoo 2"] = {"MP_Bea_F_Chest_001",500,""},
		["Torso Tattoo 3"] = {"MP_Bea_F_Chest_002",500,""},
		["Torso Tattoo 4"] = {"MP_Bea_M_Chest_000",500,""},
		["Torso Tattoo 5"] = {"MP_Bea_M_Chest_001",500,""}
  },
  {
		["Torso Tattoo 6"] = {"MP_Bea_F_Stom_000",500,""},
		["Torso Tattoo 7"] = {"MP_Bea_F_Stom_001",500,""},
		["Torso Tattoo 8"] = {"MP_Bea_F_Stom_002",500,""},
		["Torso Tattoo 9"] = {"MP_Bea_M_Stom_000",500,""},
		["Torso Tattoo 10"] = {"MP_Bea_M_Stom_001",500,""},
		["Torso Tattoo 11"] = {"MP_Bea_F_RSide_000",500,""},
		["Torso Tattoo 12"] = {"MP_Bea_F_Should_000",500,""},
		["Torso Tattoo 13"] = {"MP_Bea_F_Should_001",500,""},
		["Right Arm Tattoo 1"] = {"MP_Bea_F_RArm_001",500,""},
		["Right Arm Tattoo 2"] = {"MP_Bea_M_RArm_001",500,""},
		["Right Arm Tattoo 3"] = {"MP_Bea_M_RArm_000",500,""},
		["Left Arm Tattoo 1"] = {"MP_Bea_F_LArm_000",500,""},
		["Left Arm Tattoo 2"] = {"MP_Bea_F_LArm_001",500,""},
		["Left Arm Tattoo 3"] = {"MP_Bea_M_LArm_000",500,""},
		["Left Leg Tattoo"] = {"MP_Bea_M_Lleg_000",500,""},
		["Right Leg Tattoo"] = {"MP_Bea_F_RLeg_000",500,""}
  }
	},
	["mpbusiness_overlays"] = {
    {
  		["Neck Tattoo 1"] = {"MP_Buis_M_Neck_000",500,""},
  		["Neck Tattoo 2"] = {"MP_Buis_M_Neck_001",500,""},
  		["Neck Tattoo 3"] = {"MP_Buis_M_Neck_002",500,""},
  		["Neck Tattoo 4"] = {"MP_Buis_M_Neck_003",500,""},
  		["Left Arm Tattoo 1"] = {"MP_Buis_M_LeftArm_000",500,""},
  		["Left Arm Tattoo 2"] = {"MP_Buis_M_LeftArm_001",500,""},
  		["Right Arm Tattoo 1"] = {"MP_Buis_M_RightArm_000",500,""},
  		["Right Arm Tattoo 2"] = {"MP_Buis_M_RightArm_001",500,""},
  		["Stomach Tattoo 1"] = {"MP_Buis_M_Stomach_000",500,""},
  		["Chest Tattoo 1"] = {"MP_Buis_M_Chest_000",500,""},
  		["Chest Tattoo 2"] = {"MP_Buis_M_Chest_001",500,""},
  		["Back Tattoo 1"] = {"MP_Buis_M_Back_000",500,""},
  		["Chest Tattoo 3"] = {"MP_Buis_F_Chest_000",500,""},
  		["Chest Tattoo 4"] = {"MP_Buis_F_Chest_001",500,""},
  		["Chest Tattoo 5"] = {"MP_Buis_F_Chest_002",500,""}
    },
    {
  		["Stomach Tattoo 2"] = {"MP_Buis_F_Stom_000",500,""},
  		["Stomach Tattoo 3"] = {"MP_Buis_F_Stom_001",500,""},
  		["Stomach Tattoo 4"] = {"MP_Buis_F_Stom_002",500,""},
  		["Back Tattoo 2"] = {"MP_Buis_F_Back_000",500,""},
  		["Back Tattoo 3"] = {"MP_Buis_F_Back_001",500,""},
  		["Neck Tattoo 5"] = {"MP_Buis_F_Neck_000",500,""},
  		["Neck Tattoo 6"] = {"MP_Buis_F_Neck_001",500,""},
  		["Right Arm Tattoo 3"] = {"MP_Buis_F_RArm_000",500,""},
  		["Left Arm Tattoo 3"] = {"MP_Buis_F_LArm_000",500,""},
  		["Left Leg Tattoo"] = {"MP_Buis_F_LLeg_000",500,""},
  		["Right Leg Tattoo"] = {"MP_Buis_F_RLeg_000",500,""}
    }
	},
	["mphipster_overlays"] = {
    {
  		["HipsterTattoo 1"] = {"FM_Hip_M_Tat_000",500,""},
  		["HipsterTattoo 2"] = {"FM_Hip_M_Tat_001",500,""},
  		["HipsterTattoo 3"] = {"FM_Hip_M_Tat_002",500,""},
  		["HipsterTattoo 4"] = {"FM_Hip_M_Tat_003",500,""},
  		["HipsterTattoo 5"] = {"FM_Hip_M_Tat_004",500,""},
  		["HipsterTattoo 6"] = {"FM_Hip_M_Tat_005",500,""},
  		["HipsterTattoo 7"] = {"FM_Hip_M_Tat_006",500,""},
  		["HipsterTattoo 8"] = {"FM_Hip_M_Tat_007",500,""},
  		["HipsterTattoo 9"] = {"FM_Hip_M_Tat_008",500,""},
  		["HipsterTattoo 10"] = {"FM_Hip_M_Tat_009",500,""},
  		["HipsterTattoo 11"] = {"FM_Hip_M_Tat_010",500,""},
  		["HipsterTattoo 12"] = {"FM_Hip_M_Tat_011",500,""},
  		["HipsterTattoo 13"] = {"FM_Hip_M_Tat_012",500,""},
  		["HipsterTattoo 14"] = {"FM_Hip_M_Tat_013",500,""},
  		["HipsterTattoo 15"] = {"FM_Hip_M_Tat_014",500,""},
  		["HipsterTattoo 16"] = {"FM_Hip_M_Tat_015",500,""},
  		["HipsterTattoo 17"] = {"FM_Hip_M_Tat_016",500,""}
    },
    {
  		["HipsterTattoo 18"] = {"FM_Hip_M_Tat_017",500,""},
  		["HipsterTattoo 19"] = {"FM_Hip_M_Tat_018",500,""},
  		["HipsterTattoo 20"] = {"FM_Hip_M_Tat_019",500,""},
  		["HipsterTattoo 21"] = {"FM_Hip_M_Tat_020",500,""},
  		["HipsterTattoo 22"] = {"FM_Hip_M_Tat_021",500,""},
  		["HipsterTattoo 23"] = {"FM_Hip_M_Tat_022",500,""},
  		["HipsterTattoo 24"] = {"FM_Hip_M_Tat_023",500,""},
  		["HipsterTattoo 25"] = {"FM_Hip_M_Tat_024",500,""},
  		["HipsterTattoo 26"] = {"FM_Hip_M_Tat_025",500,""},
  		["HipsterTattoo 27"] = {"FM_Hip_M_Tat_026",500,""},
  		["HipsterTattoo 28"] = {"FM_Hip_M_Tat_027",500,""},
  		["HipsterTattoo 29"] = {"FM_Hip_M_Tat_028",500,""},
  		["HipsterTattoo 30"] = {"FM_Hip_M_Tat_029",500,""},
  		["HipsterTattoo 31"] = {"FM_Hip_M_Tat_030",500,""},
  		["HipsterTattoo 32"] = {"FM_Hip_M_Tat_031",500,""},
  		["HipsterTattoo 33"] = {"FM_Hip_M_Tat_032",500,""}
    },
    {
  		["HipsterTattoo 34"] = {"FM_Hip_M_Tat_033",500,""},
  		["HipsterTattoo 35"] = {"FM_Hip_M_Tat_034",500,""},
  		["HipsterTattoo 36"] = {"FM_Hip_M_Tat_035",500,""},
  		["HipsterTattoo 37"] = {"FM_Hip_M_Tat_036",500,""},
  		["HipsterTattoo 38"] = {"FM_Hip_M_Tat_037",500,""},
  		["HipsterTattoo 39"] = {"FM_Hip_M_Tat_038",500,""},
  		["HipsterTattoo 40"] = {"FM_Hip_M_Tat_039",500,""},
  		["HipsterTattoo 41"] = {"FM_Hip_M_Tat_040",500,""},
  		["HipsterTattoo 42"] = {"FM_Hip_M_Tat_041",500,""},
  		["HipsterTattoo 43"] = {"FM_Hip_M_Tat_042",500,""},
  		["HipsterTattoo 44"] = {"FM_Hip_M_Tat_043",500,""},
  		["HipsterTattoo 45"] = {"FM_Hip_M_Tat_044",500,""},
  		["HipsterTattoo 46"] = {"FM_Hip_M_Tat_045",500,""},
  		["HipsterTattoo 47"] = {"FM_Hip_M_Tat_046",500,""},
  		["HipsterTattoo 48"] = {"FM_Hip_M_Tat_047",500,""},
  		["HipsterTattoo 49"] = {"FM_Hip_M_Tat_048",500,""}
    }
	}
}

function RemoveClothes()
  local me = GetPlayerPed(-1)
  -- remove clothing (to see tattoos) --
  if(GetEntityModel(me) == -1667301416) then -- female
    SetPedComponentVariation(me, 8, 34,0, 2)
    SetPedComponentVariation(me, 3, 15,0, 2)
    SetPedComponentVariation(me, 11, 101,1, 2)
    SetPedComponentVariation(me, 4, 16,0, 2)
  else -- male
    SetPedComponentVariation(me, 8, 15,0, 2)
    SetPedComponentVariation(me, 3, 15,0, 2)
    SetPedComponentVariation(me, 11, 91,0, 2)
    SetPedComponentVariation(me, 4, 14,0, 2)
  end
  -- remove weird black box on back/front? --
  SetPedComponentVariation(me, 10, 0, 0, 0)
end

-------------------------
-- SHOP DETECTION LOOP --
-------------------------
Citizen.CreateThread(function()
  addBlips()
  while true do
    local me = GetPlayerPed(-1)
    local player_coords = GetEntityCoords(GetPlayerPed(-1))
      for i = 1, #SHOPS do
        if not menu.open then
          if Vdist(player_coords.x, player_coords.y, player_coords.z, SHOPS[i].x, SHOPS[i].y, SHOPS[i].z) < 3.0 then
            last_entered = SHOPS[i]
            drawTxt("Press [~y~E~w~] to open the tattoo shop menu",0,1,0.5,0.8,0.6,255,255,255,255)
            if IsControlJustPressed(1,menu.key) then
              local playerCoords = GetEntityCoords(me, false)
              menu.open = true
              RemoveClothes()
              --ClearPedDecorations(me)
              purchased_tattoos = {}
            end
          end
        else
          if last_entered then
            if Vdist(player_coords.x, player_coords.y, player_coords.z, last_entered.x, last_entered.y, last_entered.z) >= 3.0 then
              last_entered = nil
              if menu.open == true then
                menu.page = "home"
                menu.open = false
                TriggerServerEvent("usa:loadPlayerComponents")
              end
            end
          end
        end
      end
    --drawMarkers()
    Wait(0)
  end
end)

---------------
-- MENU LOOP --
---------------
Citizen.CreateThread(function()
	while true do
    local me = GetPlayerPed(-1)
    if menu.open then
      TriggerEvent("GUI-tattoo:Title", "Sick Tats")
      if menu.page == "home" then
        -------------
        -- TATTOOS --
        -------------
        local total = #TATTOOS["mpbeach_overlays"] + #TATTOOS["mpbusiness_overlays"] + #TATTOOS["mphipster_overlays"]
        for x = 1, total do
          TriggerEvent("GUI-tattoo:Option", "Page " .. x, function(cb)
            if(cb) then
              menu.page = x
            end
          end)
        end
      elseif menu.page == 1 then
        for name, info in pairs(TATTOOS["mpbeach_overlays"][1]) do
          TriggerEvent("GUI-tattoo:Option", name, function(cb)
            if(cb) then
              if IsPedModel(me,"mp_m_freemode_01") or IsPedModel(me,"mp_f_freemode_01") then
                --print("applying overlay " .. name .. "!\n\nname: " .. GetHashKey(name))
                ApplyPedOverlay(me, GetHashKey("mpbeach_overlays"), GetHashKey(info[1]))
                table.insert(purchased_tattoos, {category = "mpbeach_overlays", human_readable_name = name, hash_name = info[1]})
              end
            end
          end)
        end
      elseif menu.page == 2 then
        for name, info in pairs(TATTOOS["mpbeach_overlays"][2]) do
          TriggerEvent("GUI-tattoo:Option", name, function(cb)
            if(cb) then
              if IsPedModel(me,"mp_m_freemode_01") or IsPedModel(me,"mp_f_freemode_01") then
                --print("applying overlay " .. name .. "!\n\nname: " .. GetHashKey(name))
                ApplyPedOverlay(me, GetHashKey("mpbeach_overlays"), GetHashKey(info[1]))
                table.insert(purchased_tattoos, {category = "mpbeach_overlays", human_readable_name = name, hash_name = info[1]})
              end
            end
          end)
        end
      elseif menu.page == 3 then
        for name, info in pairs(TATTOOS["mpbusiness_overlays"][1]) do
          TriggerEvent("GUI-tattoo:Option", name, function(cb)
            if(cb) then
              if IsPedModel(me,"mp_m_freemode_01") or IsPedModel(me,"mp_f_freemode_01") then
                --print("applying overlay " .. name .. "!\n\nname: " .. GetHashKey(name))
                ApplyPedOverlay(me, GetHashKey("mpbusiness_overlays"), GetHashKey(info[1]))
                table.insert(purchased_tattoos, {category = "mpbusiness_overlays", human_readable_name = name, hash_name = info[1]})
              end
            end
          end)
        end
      elseif menu.page == 4 then
        for name, info in pairs(TATTOOS["mpbusiness_overlays"][2]) do
          TriggerEvent("GUI-tattoo:Option", name, function(cb)
            if(cb) then
              if IsPedModel(me,"mp_m_freemode_01") or IsPedModel(me,"mp_f_freemode_01") then
                --print("applying overlay " .. name .. "!\n\nname: " .. GetHashKey(name))
                ApplyPedOverlay(me, GetHashKey("mpbusiness_overlays"), GetHashKey(info[1]))
                table.insert(purchased_tattoos, {category = "mpbusiness_overlays", human_readable_name = name, hash_name = info[1]})
              end
            end
          end)
        end
      elseif menu.page == 5 then
        for name, info in pairs(TATTOOS["mphipster_overlays"][1]) do
          TriggerEvent("GUI-tattoo:Option", name, function(cb)
            if(cb) then
              if IsPedModel(me,"mp_m_freemode_01") or IsPedModel(me,"mp_f_freemode_01") then
                --print("applying overlay " .. name .. "!\n\nname: " .. GetHashKey(name))
                ApplyPedOverlay(me, GetHashKey("mphipster_overlays"), GetHashKey(info[1]))
                table.insert(purchased_tattoos, {category = "mphipster_overlays", human_readable_name = name, hash_name = info[1]})
              end
            end
          end)
        end
      elseif menu.page == 6 then
        for name, info in pairs(TATTOOS["mphipster_overlays"][2]) do
          TriggerEvent("GUI-tattoo:Option", name, function(cb)
            if(cb) then
              if IsPedModel(me,"mp_m_freemode_01") or IsPedModel(me,"mp_f_freemode_01") then
                --print("applying overlay " .. name .. "!\n\nname: " .. GetHashKey(name))
                ApplyPedOverlay(me, GetHashKey("mphipster_overlays"), GetHashKey(info[1]))
                table.insert(purchased_tattoos, {category = "mphipster_overlays", human_readable_name = name, hash_name = info[1]})
              end
            end
          end)
        end
      elseif menu.page == 7 then
        for name, info in pairs(TATTOOS["mphipster_overlays"][3]) do
          TriggerEvent("GUI-tattoo:Option", name, function(cb)
            if(cb) then
              if IsPedModel(me,"mp_m_freemode_01") or IsPedModel(me,"mp_f_freemode_01") then
                --print("applying overlay " .. name .. "!\n\nname: " .. GetHashKey(name))
                ApplyPedOverlay(me, GetHashKey("mphipster_overlays"), GetHashKey(info[1]))
                table.insert(purchased_tattoos, {category = "mphipster_overlays", human_readable_name = name, hash_name = info[1]})
              end
            end
          end)
        end
      end
      if menu.page ~= "home" then
        TriggerEvent("GUI-tattoo:Option", "Back", function(cb)
          if(cb) then
            menu.page = "home"
          end
        end)
      else
        ----------------------------
        -- EXIT / PUT CLOTHING ON --
        ----------------------------
        TriggerEvent("GUI-tattoo:Option", "~y~Checkout", function(cb)
          if(cb) then
            menu.page = "home"
            menu.open = false
            if #purchased_tattoos > 0 then
              local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
      				TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
      					TriggerServerEvent("tattoo:checkout", purchased_tattoos, property)
      				end)
            else
              TriggerEvent("usa:notify", "No tattoos selected!")
            end
          end
        end)
        TriggerEvent("GUI-tattoo:Option", "~r~Remove Tattoos", function(cb)
          if(cb) then
            menu.page = "home"
            menu.open = false
            --TriggerServerEvent("usa:loadPlayerComponents")
            TriggerServerEvent("tattoo:removeTattoos")
          end
        end)
        TriggerEvent("GUI-tattoo:Option", "~y~Exit", function(cb)
          if(cb) then
            menu.page = "home"
            menu.open = false
            TriggerServerEvent("usa:loadPlayerComponents")
          end
        end)
      end
      ----------
      -- UPDATE --
      ----------
			TriggerEvent("GUI-tattoo:Update")
		end
		Wait(0)
	end
end)

RegisterNetEvent("tattoo:removeTattoos")
AddEventHandler("tattoo:removeTattoos", function()
  ClearPedDecorations(GetPlayerPed(-1))
end)

------------------------
--- utility functions --
------------------------
function addBlips()
	for i = 1, #SHOPS do
		local blip = AddBlipForCoord(SHOPS[i].x, SHOPS[i].y, SHOPS[i].z)
		SetBlipSprite(blip, 75)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Tattoo Shop")
		EndTextCommandSetBlipName(blip)
	end
end


function drawMarkers()
	for i = 1, #SHOPS do
		DrawMarker(27,SHOPS[i].x,SHOPS[i].y,SHOPS[i].z-0.9,0,0,0,0,0,0,3.001,3.0001,0.5001,0,155,255,200,0,0,0,0)
	end
end

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

----------------
-- MENU STUFF --
----------------
RegisterNetEvent("GUI-tattoo:Title")
AddEventHandler("GUI-tattoo:Title", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("GUI-tattoo:Option")
AddEventHandler("GUI-tattoo:Option", function(option, cb)
	cb(Menu.Option(option))
end)

RegisterNetEvent("GUI-tattoo:Bool")
AddEventHandler("GUI-tattoo:Bool", function(option, bool, cb)
	Menu.Bool(option, bool, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI-tattoo:Int")
AddEventHandler("GUI-tattoo:Int", function(option, int, min, max, cb)
	Menu.Int(option, int, min, max, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI-tattoo:StringArray")
AddEventHandler("GUI-tattoo:StringArray", function(option, array, position, cb)
	Menu.StringArray(option, array, position, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI-tattoo:Update")
AddEventHandler("GUI-tattoo:Update", function()
	Menu.updateSelection()
end)
