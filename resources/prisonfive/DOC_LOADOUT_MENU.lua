local MENU_KEY = 38 -- "E"

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
  { name = "Cart", hash = GetHashKey("caddy") },
  { name = "Bus", hash = GetHashKey("pbus") },
  { name = "Van", hash = GetHashKey("policet") }
}

local PRISON_GUARD_SIGN_IN_LOCATIONS = {
	{x = 1692.75, y = 2594.3, z = 45.6},
	{x = 1849.0, y = 2599.5, z = 45.8} -- front
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

local created_menus = {}

function IsAnyMenuVisible()
	for i = 1, #created_menus do
		if created_menus[i]:Visible() then
			return true
		end
	end
	return false
end

function CloseAllMenus()
	for i = 1, #created_menus do
		if created_menus[i]:Visible() then
			created_menus[i]:Visible(false)
		end
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

---------------------------
-- Set up main menu --
---------------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Welcome!", "~b~San Andreas Department of Corrections", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

table.insert(created_menus, mainMenu)

----------------------------------------
-- Construct GUI menu buttons --
----------------------------------------

function CreateUniformMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Uniforms", "Select your uniform.", true --[[KEEP POSITION]])
	table.insert(created_menus, submenu)
    ----------------------
    -- Show ped options --
    ----------------------
    for i = 1, #uniforms.peds do
        local item = NativeUI.CreateItem(uniforms.peds[i].display_name, "")
        item.Activated = function(parentmenu, selected)
            -- change into ped --
            ChangeSkin(uniforms.peds[i].name)
            -- make user job "corrections" --
            TriggerServerEvent("doc:clockIn")
        end
        ----------------------------------------
        -- add to sub menu created previously --
        ----------------------------------------
        submenu:AddItem(item)
    end
    ---------------------
    -- Show MP options --
    ---------------------
    local submenu2 = _menuPool:AddSubMenu(submenu, "Custom", "For use with MP model", true --[[KEEP POSITION]])
    table.insert(created_menus, submenu2)
    ------------
    -- male --
    ------------
    local submenu3 = _menuPool:AddSubMenu(submenu2, "Male", "For use with the male MP model", true --[[KEEP POSITION]])
    table.insert(created_menus, submenu3)
    ----------------------------
    -- create components menu --
    ----------------------------
    for k, v in pairs(uniforms.males.components) do
        local submenu5 = _menuPool:AddSubMenu(submenu3, v.name, "Select to change variations for " .. v.name, true --[[KEEP POSITION]])
        table.insert(created_menus, submenu5)
        local item = NativeUI.CreateItem("Component", "Change the component value")
        item.Activated = function(parentmenu, selected)
            local newval = v.values[1 + v.offset1]
            SetPedComponentVariation(GetPlayerPed(-1), tonumber(k), newval, tonumber(v.current_texture), 2)
            v.offset1 = v.offset1 + 1
            if v.offset1 >= #v.values then
              v.offset1 = 0
            end
            v.current_value = newval
        end
        ----------------------------------------
        -- add to sub menu created previously --
        ----------------------------------------
        submenu5:AddItem(item)
        local item2 = NativeUI.CreateItem("Texture", "Change the texture value")
        item2.Activated = function(parentmenu, selected)
            local newval = v.textures[1 + v.offset2]
            SetPedComponentVariation(GetPlayerPed(-1), tonumber(k), tonumber(v.current_value), newval, 2)
            v.offset2 = v.offset2 + 1
            if v.offset2 >= #v.textures then
              v.offset2 = 0
            end
            v.current_texture = newval
        end
        ----------------------------------------
        -- add to sub menu created previously --
        ----------------------------------------
        submenu5:AddItem(item2)
    end
    ----------------------
    -- create prop menu --
    ----------------------
      for k, v in pairs(uniforms.males.props) do
          local submenu5 = _menuPool:AddSubMenu(submenu3, v.name, "Select to change variations for " .. v.name, true --[[KEEP POSITION]])
          table.insert(created_menus, submenu5)
          local item = NativeUI.CreateItem("Component", "Change the component value")
          item.Activated = function(parentmenu, selected)
              ClearPedProp(GetPlayerPed(-1), tonumber(k))
              local newval = v.values[1 + v.offset3]
              if newval ~= -1 then
                SetPedPropIndex(GetPlayerPed(-1), tonumber(k), newval, v.current_texture, true)
              end
              v.offset3 = v.offset3 + 1
              if v.offset3 >= #v.values then
                v.offset3 = 0
              end
              v.current_value = newval
          end
          ----------------------------------------
          -- add to sub menu created previously --
          ----------------------------------------
          submenu5:AddItem(item)
          local item2 = NativeUI.CreateItem("Texture", "Change the texture value")
          item2.Activated = function(parentmenu, selected)
              local newval = v.textures[1 + v.offset4]
              SetPedPropIndex(GetPlayerPed(-1), tonumber(k), v.current_value, newval, true)
              v.offset4 = v.offset4 + 1
              if v.offset4 >= #v.textures then
                v.offset4 = 0
              end
              v.current_texture = newval
          end
          ----------------------------------------
          -- add to sub menu created previously --
          ----------------------------------------
          submenu5:AddItem(item2)
      end
      -- save button --
      local savebtn = NativeUI.CreateItem("Save", "Save your uniform")
      savebtn.Activated = function(parentmenu, selected)
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
      end
      ----------------------------------------
      -- add to sub menu created previously --
      ----------------------------------------
      submenu3:AddItem(savebtn)
      --------------
      -- female --
      --------------
      local fsubmenu3 = _menuPool:AddSubMenu(submenu2, "Female", "For use with the female MP model", true --[[KEEP POSITION]])
      table.insert(created_menus, fsubmenu3)
      ----------------------------
      -- create components menu --
      ----------------------------
      for k, v in pairs(uniforms.females.components) do
          local fsubmenu5 = _menuPool:AddSubMenu(fsubmenu3, v.name, "Select to change variations for " .. v.name, true --[[KEEP POSITION]])
          table.insert(created_menus, fsubmenu5)
          local item = NativeUI.CreateItem("Component", "Change the component value")
          item.Activated = function(parentmenu, selected)
              local newval = v.values[1 + v.offset1]
              SetPedComponentVariation(GetPlayerPed(-1), tonumber(k), newval, tonumber(v.current_texture), 2)
              v.offset1 = v.offset1 + 1
              if v.offset1 >= #v.values then
                v.offset1 = 0
              end
              v.current_value = newval
          end
          ----------------------------------------
          -- add to sub menu created previously --
          ----------------------------------------
          fsubmenu5:AddItem(item)
          local item2 = NativeUI.CreateItem("Texture", "Change the texture value")
          item2.Activated = function(parentmenu, selected)
              local newval = v.textures[1 + v.offset2]
              SetPedComponentVariation(GetPlayerPed(-1), tonumber(k), tonumber(v.current_value), newval, 2)
              v.offset2 = v.offset2 + 1
              if v.offset2 >= #v.textures then
                v.offset2 = 0
              end
              v.current_texture = newval
          end
          ----------------------------------------
          -- add to sub menu created previously --
          ----------------------------------------
          fsubmenu5:AddItem(item2)
      end
      ----------------------
      -- create prop menu --
      ----------------------
        for k, v in pairs(uniforms.females.props) do
            local fsubmenu5 = _menuPool:AddSubMenu(fsubmenu3, v.name, "Select to change variations for " .. v.name, true --[[KEEP POSITION]])
            table.insert(created_menus, fsubmenu5)
            local item = NativeUI.CreateItem("Component", "Change the component value")
            item.Activated = function(parentmenu, selected)
                ClearPedProp(GetPlayerPed(-1), tonumber(k))
                local newval = v.values[1 + v.offset3]
                if newval ~= -1 then
                  SetPedPropIndex(GetPlayerPed(-1), tonumber(k), newval, v.current_texture, true)
                end
                v.offset3 = v.offset3 + 1
                if v.offset3 >= #v.values then
                  v.offset3 = 0
                end
                v.current_value = newval
            end
            ----------------------------------------
            -- add to sub menu created previously --
            ----------------------------------------
            fsubmenu5:AddItem(item)
            local item2 = NativeUI.CreateItem("Texture", "Change the texture value")
            item2.Activated = function(parentmenu, selected)
                local newval = v.textures[1 + v.offset4]
                SetPedPropIndex(GetPlayerPed(-1), tonumber(k), v.current_value, newval, true)
                v.offset4 = v.offset4 + 1
                if v.offset4 >= #v.textures then
                  v.offset4 = 0
                end
                v.current_texture = newval
            end
            ----------------------------------------
            -- add to sub menu created previously --
            ----------------------------------------
            fsubmenu5:AddItem(item2)
        end
        -- save button --
        local savebtn = NativeUI.CreateItem("Save", "Save your uniform")
        savebtn.Activated = function(parentmenu, selected)
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
        end
        ----------------------------------------
        -- add to sub menu created previously --
        ----------------------------------------
        fsubmenu3:AddItem(savebtn)
        ------------------------
        -- add load button --
        ------------------------
        local loadbtn = NativeUI.CreateItem("Load", "Load your uniform")
        loadbtn.Activated = function(parentmenu, selected)
            TriggerServerEvent("doc:loadUniform")
        end
        submenu:AddItem(loadbtn)
end

function CreateWeaponsMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Weapons", "Select your loadout.", true --[[KEEP POSITION]])
    table.insert(created_menus, submenu)
     for i = 1, #weapons do
         local item = NativeUI.CreateItem(weapons[i].display_name, "")
         item.Activated = function(parentmenu, selected)
            TriggerServerEvent("doc:checkRankForWeapon", weapons[i])
         end
         submenu:AddItem(item)
     end
end

function CreateVehiclesMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Vehicles", "Choose a vehicle.", true --[[KEEP POSITION]])
    table.insert(created_menus, submenu)
    for i = 1, #vehicles do
        local item = NativeUI.CreateItem(vehicles[i].name, "")
        item.Activated = function(parentmenu, selected)
           SpawnVehicle(vehicles[i].hash)
        end
        submenu:AddItem(item)
    end
end

function CreateArmorButton(menu)
    local item = NativeUI.CreateItem("Armor", "")
    item.Activated = function(parentmenu, selected)
        SetEntityHealth(GetPlayerPed(-1), 200)
        SetPedArmour(GetPlayerPed(-1), 100)
    end
    menu:AddItem(item)
end

function CreateClockOutButton(menu)
    local item = NativeUI.CreateItem("Clock Out", "")
    item.Activated = function(parentmenu, selected)
        TriggerServerEvent("doc:clockOut")
    end
    menu:AddItem(item)
end

----------------
-- add to GUI --
----------------
CreateUniformMenu(mainMenu)
CreateWeaponsMenu(mainMenu)
CreateVehiclesMenu(mainMenu)
CreateArmorButton(mainMenu)
CreateClockOutButton(mainMenu)
_menuPool:RefreshIndex()

-------------------------------------------
-- open menu when near sign in location --
-------------------------------------------
Citizen.CreateThread(function()
    local menu_opened = false
    local closest_location = nil
    while true do
        Citizen.Wait(0)
        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        _menuPool:ProcessMenus()
        local mycoords = GetEntityCoords(GetPlayerPed(-1))
        -- see if close to any stores --
        for i = 1, #PRISON_GUARD_SIGN_IN_LOCATIONS do
            if Vdist(mycoords.x, mycoords.y, mycoords.z, PRISON_GUARD_SIGN_IN_LOCATIONS[i].x, PRISON_GUARD_SIGN_IN_LOCATIONS[i].y, PRISON_GUARD_SIGN_IN_LOCATIONS[i].z) < 50.0 then
                DrawMarker(27, PRISON_GUARD_SIGN_IN_LOCATIONS[i].x, PRISON_GUARD_SIGN_IN_LOCATIONS[i].y, PRISON_GUARD_SIGN_IN_LOCATIONS[i].z - 1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
                if Vdist(mycoords.x, mycoords.y, mycoords.z, PRISON_GUARD_SIGN_IN_LOCATIONS[i].x, PRISON_GUARD_SIGN_IN_LOCATIONS[i].y, PRISON_GUARD_SIGN_IN_LOCATIONS[i].z) < 1.3 then
                    drawTxt("Press [~y~E~w~] to open the DOC menu",7,1,0.5,0.8,0.5,255,255,255,255)
                    if IsControlJustPressed(1, MENU_KEY) and not IsAnyMenuVisible() then
                        TriggerServerEvent("doc:checkWhitelist", PRISON_GUARD_SIGN_IN_LOCATIONS[i])
                    end
                end
            end
        end
        -- close menu when far away --
        if closest_location then
            if Vdist(mycoords.x, mycoords.y, mycoords.z, closest_location.x, closest_location.y, closest_location.z) > 1.3 then
                if IsAnyMenuVisible() then
                    closest_location = nil
                    CloseAllMenus()
                end
            end
        end
    end
end)

RegisterNetEvent("doc:open")
AddEventHandler("doc:open", function(loc)
    print("opening!")
    mainMenu:Visible(not mainMenu:Visible())
    closest_location = loc
end)

RegisterNetEvent("doc:uniformLoaded")
AddEventHandler("doc:uniformLoaded", function(uniform)

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
    exports["globals"]:notify("No uniform saved!")
  end
end)

RegisterNetEvent("doc:close")
AddEventHandler("doc:close", function()
    print("closing menu!")
    mainMenu:Visible(false)
    CloseAllMenus()
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
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    RequestModel(model)
    while not HasModelLoaded(model) do
      Wait(100)
    end

    local veh = CreateVehicle(model, x + 2.5, y + 2.5, z + 1, 0.0, true, false)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetVehicleExplodesOnHighExplosionDamage(veh, false)
    SetVehicleLivery(veh, 1) -- DOC SKIN
  end)
end

---------------------
-- WEAPON SPAWNING --
---------------------
RegisterNetEvent("doc:equipWeapon")
AddEventHandler("doc:equipWeapon", function(weapon)
  GiveWeaponToPed(GetPlayerPed(-1), weapon.name, 1000, 0, false)
end)

function GiveLoadout()
  local weapons = { "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_FLASHLIGHT" }
  for i = 1, #weapons do
    GiveWeaponToPed(GetPlayerPed(-1), weapons[i], 1000, 0, false)
  end
end

function GiveWeapon(name)
  GiveWeaponToPed(GetPlayerPed(-1), name, 1000, 0, false)
end
