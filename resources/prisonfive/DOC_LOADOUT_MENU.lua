local weapons = {
  { name = "WEAPON_STUNGUN", display_name = "Stun Gun", rank = 1},
  { name = "WEAPON_NIGHTSTICK", display_name = "Nightstick", rank = 1},
  { name = "WEAPON_FLASHLIGHT", display_name = "Flashlight", rank = 1},
  { name = 1593441988, display_name = "Combat Pistol", rank = 2},
  { name = -1600701090, display_name = "BZ Gas", rank = 2},
  { name = -2084633992, display_name = "Carbine Rifle", rank = 3},
  { name = 100416529, display_name = "Marksman Rifle", rank = 3}
}

local vehicles = {
  { name = "CVPI", hash = GetHashKey("police7") },
  { name = "Cart", hash = GetHashKey("caddy") }
}

local uniforms = {
  males = {
    components = {
      [1] = {values = {-1, 121}, textures = {-1, 0, 1, 2}, name = "Earpiece", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- earpiece
      [3] = {values = {-1, 0, 11}, textures = {-1, 0}, name = "Arms/Hands", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- Arms/Hands
      [4] = {values = {-1, 47, 31}, textures = {0, 1, 2}, name = "Legs", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- legs
      [6] = {values = {-1, 25}, textures = {0, 1}, name = "Feet", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- feet
      [7] = {values = {-1, 125}, textures = {-1, 0}, name = "Badge", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- ties
      [8] = {values = {-1, 122}, textures = {-1, 0}, name = "Duty Belt", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- accessories
      [9] = {values = {-1, 23}, textures = {6, 9}, name = "Vest", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- vest
      [11] = {values = {-1, 13, 242}, textures = {0, 1, 2, 3}, name = "Torso", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0} -- torso
    },
    props = {
      [0] = {values = {-1, 58}, textures = {0, 1, 2, 3, 4, 5}, offset3 = 0, offset4 = 0, current_value = -1, current_texture = 1, name = "Hat"},
      [1] = {values = {-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25}, textures = {0, 1, 2, 3, 4, 5}, offset3 = 0, offset4 = 0, current_value = -1, current_texture = 1, name = "Glasses"}
    }
  },
  females = {
    components = {
        [1] = {values = {-1, 121}, textures = {-1, 0, 1, 2}, name = "Earpiece", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- earpiece
        [3] = {values = {0}, textures = {-1, 0}, name = "Arms/Hands", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- Arms/Hands
        [4] = {values = {-1, 49, 30}, textures = {0, 1, 2}, name = "Legs", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- legs
        [6] = {values = {-1, 25}, textures = {0, 1}, name = "Feet", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- feet
        [7] = {values = {-1, 95}, textures = {-1, 0}, name = "Badge", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- ties
        [8] = {values = {-1, 152}, textures = {-1, 0}, name = "Duty Belt", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}, -- accessories
        [9] = {values = {-1, 24}, textures = {6, 9}, name = "Vest", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0},
        [11] = {values = {-1, 27, 73, 250}, textures = {0, 1, 2, 3}, name = "Torso", offset1 = 0, offset2 = 0, current_value = 0, current_texture = 0}
    },
    props = {
      [0] = {values = {-1, 58}, textures = {0, 1, 2, 3, 4, 5}, offset3 = 0, offset4 = 0, current_value = -1, current_texture = 1, name = "Hat"},
      [1] = {values = {-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25}, textures = {0, 1, 2, 3, 4, 5}, offset3 = 0, offset4 = 0, current_value = -1, current_texture = 1, name = "Glasses"}
    }
  },
  peds = {
    { name = "S_M_M_PRISGUARD_01", display_name = "Prison Guard 1"},
    { name = "S_M_Y_Ranger_01", display_name = "Prison Guard 2 (Male)"},
    { name = "S_F_Y_Ranger_01", display_name = "Prison Guard 2 (Female)"}
  }
}

local mp_skins = {
  "mp_m_freemode_01",
  "mp_f_freemode_01"
}

---------------
-- ADD MENUS --
---------------
AddEventHandler("menu:setup", function()
  TriggerEvent("menu:registerModuleMenu", "DOC Menu", addSubmenus, nil)
end)

function addSubmenus(id)
  TriggerEvent("menu:addModuleSubMenu", id, "Uniforms", addUniforms, function(id)
    TriggerServerEvent("doc:forceDuty")
  end)
  TriggerEvent("menu:addModuleSubMenu", id, "Weapons", addWeapons, function(id)
    RemoveAllPedWeapons(GetPlayerPed(-1), false)
    TriggerServerEvent("doc:forceDuty")
  end)
  TriggerEvent("menu:addModuleSubMenu", id, "Vehicles", addVehicles, function(id)
    TriggerServerEvent("doc:forceDuty")
  end)
  TriggerEvent("menu:addModuleItem", id, "Armor", nil, false, function(id, state)
    SetEntityHealth(GetPlayerPed(-1), 200)
    SetPedArmour(GetPlayerPed(-1), 100)
  end)
  TriggerEvent("menu:addModuleItem", id, "Clock In", nil, false, function(id, state)
    RemoveAllPedWeapons(GetPlayerPed(-1), false)
    TriggerServerEvent("doc:forceDuty")
  end)
  TriggerEvent("menu:addModuleItem", id, "Clock Out", nil, false, function(id, state)
    TriggerServerEvent("doc:clockOut")
  end)
end

-----------------------------
-- SKIN / UNIFORM CHANGING --
-----------------------------
function addUniforms(id)
  ----------------------
  -- Show ped options --
  ----------------------
  for i = 1, #uniforms.peds do
    TriggerEvent("menu:addModuleItem", id, uniforms.peds[i].display_name, nil, false, function(id, state)
      print("changing into skin: " .. uniforms.peds[i].name)
      -- change into ped --
      ChangeSkin(uniforms.peds[i].name)
      -- make user job "corrections" --
      TriggerServerEvent("doc:clockIn")
    end)
  end
  ---------------------
  -- Show MP options --
  ---------------------
  TriggerEvent("menu:addModuleSubMenu", id, "Custom", addCustomUniformsGenderPick, nil)
end

function addCustomUniformsGenderPick(id)
  TriggerEvent("menu:addModuleSubMenu", id, "Male", addCustomUniformsMale, nil)
  TriggerEvent("menu:addModuleSubMenu", id, "Female", addCustomUniformsFemale, nil)
end

function addCustomUniformsMale(id)
  ----------------------------
  -- create components menu --
  ----------------------------
  for k, v in pairs(uniforms.males.components) do

      TriggerEvent("menu:addModuleSubMenu", id, v.name, function(id)

        TriggerEvent("menu:addModuleItem", id, "Component", nil, false, function(id, state)
          local newval = v.values[1 + v.offset1]
          SetPedComponentVariation(GetPlayerPed(-1), tonumber(k), newval, tonumber(v.current_texture), 2)
          v.offset1 = v.offset1 + 1
          if v.offset1 >= #v.values then
            v.offset1 = 0
          end
          v.current_value = newval
        end)

        TriggerEvent("menu:addModuleItem", id, "Texture", nil, false, function(id, state)
          local newval = v.textures[1 + v.offset2]
          SetPedComponentVariation(GetPlayerPed(-1), tonumber(k), tonumber(v.current_value), newval, 2)
          v.offset2 = v.offset2 + 1
          if v.offset2 >= #v.textures then
            v.offset2 = 0
          end
          v.current_texture = newval
        end)

      end, nil)

  end
  ----------------------
  -- create prop menu --
  ----------------------
  for k, v in pairs(uniforms.males.props) do
    TriggerEvent("menu:addModuleSubMenu", id, v.name, function(id)

      TriggerEvent("menu:addModuleItem", id, "Component", nil, false, function(id, state)
        ClearPedProp(GetPlayerPed(-1), tonumber(k))
        local newval = v.values[1 + v.offset3]
        print("k: " .. k)
        print("newval: " .. newval)
        if newval ~= -1 then
          SetPedPropIndex(GetPlayerPed(-1), tonumber(k), newval, v.current_texture, true)
        end
        v.offset3 = v.offset3 + 1
        if v.offset3 >= #v.values then
          v.offset3 = 0
        end
        v.current_value = newval
      end)

      TriggerEvent("menu:addModuleItem", id, "Texture", nil, false, function(id, state)
        local newval = v.textures[1 + v.offset4]
        SetPedPropIndex(GetPlayerPed(-1), tonumber(k), v.current_value, newval, true)
        v.offset4 = v.offset4 + 1
        if v.offset4 >= #v.textures then
          v.offset4 = 0
        end
        v.current_texture = newval
      end)

    end, nil)
  end
  ------------------
  -- load  button --
  ------------------
  --[[
  TriggerEvent("menu:addModuleItem", id, "Load", nil, false, function(id, state)
    print("Loading uniform...")
    TriggerServerEvent("doc:loadUniform")
  end)
  --]]
  -----------------
  -- save button --
  -----------------
  TriggerEvent("menu:addModuleItem", id, "Save", nil, false, function(id, state)
    print("Saving!")
    local uniform = {
      base_model = GetEntityModel(GetPlayerPed(-1)),
      components = {
        [1] = {uniforms.males.components[1].current_value, uniforms.males.components[1].current_texture},
        [3] = {uniforms.males.components[3].current_value, uniforms.males.components[3].current_texture},
        [4] = {uniforms.males.components[4].current_value, uniforms.males.components[4].current_texture},
        [6] = {uniforms.males.components[6].current_value, uniforms.males.components[6].current_texture},
        [7] = {uniforms.males.components[7].current_value, uniforms.males.components[7].current_texture},
        [8] = {uniforms.males.components[8].current_value, uniforms.males.components[8].current_texture},
        [9] = {uniforms.males.components[9].current_value, uniforms.males.components[9].current_texture},
        [11] = {uniforms.males.components[11].current_value, uniforms.males.components[11].current_texture}
      },
      props = {
        [0] = {uniforms.males.props[0].current_value, uniforms.males.props[0].current_texture},
        [1] = {uniforms.males.props[1].current_value, uniforms.males.props[1].current_texture}
      }
    }
    TriggerServerEvent("doc:saveUniform", uniform)
  end)
end

function addCustomUniformsFemale(id)
  ----------------------------
  -- create components menu --
  ----------------------------
  for k, v in pairs(uniforms.females.components) do

      TriggerEvent("menu:addModuleSubMenu", id, v.name, function(id)

        TriggerEvent("menu:addModuleItem", id, "Component", nil, false, function(id, state)
          local newval = v.values[1 + v.offset1]
          SetPedComponentVariation(GetPlayerPed(-1), tonumber(k), newval, tonumber(v.current_texture), 2)
          v.offset1 = v.offset1 + 1
          if v.offset1 >= #v.values then
            v.offset1 = 0
          end
          v.current_value = newval
        end)

        TriggerEvent("menu:addModuleItem", id, "Texture", nil, false, function(id, state)
          local newval = v.textures[1 + v.offset2]
          SetPedComponentVariation(GetPlayerPed(-1), tonumber(k), tonumber(v.current_value), newval, 2)
          v.offset2 = v.offset2 + 1
          if v.offset2 >= #v.textures then
            v.offset2 = 0
          end
          v.current_texture = newval
        end)

      end, nil)
  end
  ----------------------
  -- create prop menu --
  ----------------------
  for k, v in pairs(uniforms.females.props) do
    TriggerEvent("menu:addModuleSubMenu", id, v.name, function(id)

      TriggerEvent("menu:addModuleItem", id, "Component", nil, false, function(id, state)
        ClearPedProp(GetPlayerPed(-1), tonumber(k))
        local newval = v.values[1 + v.offset3]
        print("k: " .. k)
        print("newval: " .. newval)
        if newval ~= -1 then
          SetPedPropIndex(GetPlayerPed(-1), tonumber(k), newval, v.current_texture, true)
        end
        v.offset3 = v.offset3 + 1
        if v.offset3 >= #v.values then
          v.offset3 = 0
        end
        v.current_value = newval
      end)

      TriggerEvent("menu:addModuleItem", id, "Texture", nil, false, function(id, state)
        local newval = v.textures[1 + v.offset4]
        SetPedPropIndex(GetPlayerPed(-1), tonumber(k), v.current_value, newval, true)
        v.offset4 = v.offset4 + 1
        if v.offset4 >= #v.textures then
          v.offset4 = 0
        end
        v.current_texture = newval
      end)

    end, nil)
  end
  ------------------
  -- load  button --
  ------------------
  --[[
  TriggerEvent("menu:addModuleItem", id, "Load", nil, false, function(id, state)
    print("Loading uniform...")
    TriggerServerEvent("doc:loadUniform")
  end)
  --]]
  -----------------
  -- save button --
  -----------------
  TriggerEvent("menu:addModuleItem", id, "Save", nil, false, function(id, state)
    print("Saving!")
    local uniform = {
      base_model = GetEntityModel(GetPlayerPed(-1)),
      components = {
        [3] = {uniforms.females.components[3].current_value, uniforms.females.components[3].current_texture},
        [4] = {uniforms.females.components[4].current_value, uniforms.females.components[4].current_texture},
        [6] = {uniforms.females.components[6].current_value, uniforms.females.components[6].current_texture},
        [9] = {uniforms.females.components[9].current_value, uniforms.females.components[9].current_texture},
        [11] = {uniforms.females.components[11].current_value, uniforms.females.components[11].current_texture}
      },
      props = {
        [0] = {uniforms.females.props[0].current_value, uniforms.females.props[0].current_texture},
        [1] = {uniforms.females.props[1].current_value, uniforms.females.props[1].current_texture}
      }
    }
    TriggerServerEvent("doc:saveUniform", uniform)
  end)
end

RegisterNetEvent("doc:uniformLoaded")
AddEventHandler("doc:uniformLoaded", function(uniform)

  --[[
  if not IsPedModel(GetPlayerPed(-1), GetHashKey("mp_f_freemode_01")) and not IsPedModel(GetPlayerPed(-1), GetHashKey("mp_m_freemode_01")) then
    TriggerEvent("usa:notify", "Must be in MP model!")
    return
  end
  --]]

  if uniform then

    Citizen.CreateThread(function()
      ----------------
      -- components --
      ----------------
      for k, v in pairs(uniform.components) do
        SetPedComponentVariation(GetPlayerPed(-1), tonumber(k), v[1], v[2], 2) -- v[1] is component value, v[2] is texture value
      end
      ----------
      -- prop --
      ----------
      for k, v in pairs(uniform.props) do
        ClearPedProp(GetPlayerPed(-1), tonumber(k))
        if v[1] == -1 then
          ClearPedProp(GetPlayerPed(-1), tonumber(k))
          return
        end
        SetPedPropIndex(GetPlayerPed(-1), tonumber(k), v[1], v[2], true)
      end
      -------------------------
      -- give health / armor --
      -------------------------
      SetEntityHealth(GetPlayerPed(-1), 200)
      SetPedArmour(GetPlayerPed(-1), 100)
    end)

  else
    TriggerEvent("usa:notify", "No uniform saved!")
    --[[
    local modelhashed = GetHashKey(mp_skins[math.random(#mp_skins)])
    RequestModel(modelhashed)
    while not HasModelLoaded(modelhashed) do
      Citizen.Wait(1)
    end
    SetPlayerModel(PlayerId(), modelhashed)
    SetPedComponentVariation(GetPlayerPed(-1), 0, 1, 0, 2)
    SetModelAsNoLongerNeeded(modelhashed)
    SetEntityHealth(GetPlayerPed(-1), 200)
    SetPedArmour(GetPlayerPed(-1), 100)
    --]]
  end
end)

function ChangeSkin(skin)
  local modelhashed = GetHashKey(skin)
  RequestModel(modelhashed)
  while not HasModelLoaded(modelhashed) do
    Citizen.Wait(1)
  end
  SetPlayerModel(PlayerId(), modelhashed)
  SetPedRandomComponentVariation(GetPlayerPed(-1))
  SetModelAsNoLongerNeeded(modelhashed)
  SetEntityHealth(GetPlayerPed(-1), 200)
  SetPedArmour(GetPlayerPed(-1), 100)
end

----------------------
-- VEHICLE SPAWNING --
----------------------
function addVehicles(id)
  for i = 1, #vehicles do
    TriggerEvent("menu:addModuleItem", id, vehicles[i].name, nil, false, function(id, state)
      SpawnVehicle(vehicles[i].hash)
    end)
  end
end

function SpawnVehicle(model)
  Citizen.CreateThread(function()
    print("inside spawn vehicle, model: " .. model)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    RequestModel(model)
    while not HasModelLoaded(model) do
      Wait(100)
    end

    local veh = CreateVehicle(model, x + 2.5, y + 2.5, z + 1, 0.0, true, false)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetVehicleExplodesOnHighExplosionDamage(veh, false)
    SetVehicleLivery(veh, 3) -- DOC SKIN
  end)
end

---------------------
-- WEAPON SPAWNING --
---------------------
RegisterNetEvent("doc:equipWeapon")
AddEventHandler("doc:equipWeapon", function(weapon)
  GiveWeaponToPed(GetPlayerPed(-1), weapon.name, 1000, 0, false)
end)

function addWeapons(id)
  for i = 1, #weapons do
    TriggerEvent("menu:addModuleItem", id, weapons[i].display_name, nil, false, function(id, state)
      TriggerServerEvent("doc:checkRankForWeapon", weapons[i])
      --GiveWeapon(weapons[i].name)
      --TriggerEvent("chatMessage", "", {}, "^0Grabbed a: " .. weapons[i].display_name)
    end)
  end
end

function GiveLoadout()
  local weapons = { "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_FLASHLIGHT" }
  for i = 1, #weapons do
    GiveWeaponToPed(GetPlayerPed(-1), weapons[i], 1000, 0, false)
  end
end

function GiveWeapon(name)
  GiveWeaponToPed(GetPlayerPed(-1), name, 1000, 0, false)
end
