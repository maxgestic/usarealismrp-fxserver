local MENU_KEY = 38 -- "E"

local weapons = {}

TriggerServerEvent("doc:getWeapons")

RegisterNetEvent("doc:getWeapons")
AddEventHandler("doc:getWeapons", function(weps)
    weapons = weps
    CreateWeaponsMenu(mainMenu)
end)

local vehicles = {
  { name = "Quad Bike", hash = GetHashKey("blazer") },
  { name = "CVPI", hash = GetHashKey("pdcvpi") },
  { name = "Charger", hash = GetHashKey("pdchgr") },
  { name = "Taurus", hash = GetHashKey("pdtau") },
  { name = "Explorer", hash = GetHashKey("pdexp") },
  { name = "Truck", hash = GetHashKey("sheriff2") },
  { name = "Riot", hash = GetHashKey("riot") },
  { name = "Motorcycle 1", hash = GetHashKey("policeb") },
  { name = "Motorcycle 2", hash = GetHashKey("1200RT") },
  { name = "Golf Cart", hash = GetHashKey("caddy") },
  { name = "Prison Bus", hash = GetHashKey("pbus") },
  { name = "Transport Van", hash = GetHashKey("policet") }
}

local PRISON_GUARD_SIGN_IN_LOCATIONS = {
	{x = 1690.71484375, y = 2591.3149414063, z = 45.914203643799, vehSpawn = vector3(1696.0581054688, 2599.6557617188, 45.56489944458)},
  {x = 1849.0, y = 2599.5, z = 45.8, vehSpawn = vector3(1854.4420166016, 2599.0654296875, 45.672290802002)}, -- front
  {x = 1778.3930664063,y = 2548.5463867188, z = 45.797786712646, vehSpawn = vector3(1854.4420166016, 2599.0654296875, 45.672290802002)}, -- inside prison locker room
  {x = 1840.5009765625, y = 3690.2153320313, z = 34.286655426025, vehSpawn = vector3(1872.4410400391, 3691.5651855469, 33.568901062012), vehSpawnHeading = 220.0}, -- Sandy SO
  {x = -449.33654785156, y = 6010.4638671875, z = 31.716360092163, vehSpawn = vector3(-462.80316162109, 6009.2587890625, 31.340545654297), vehSpawnHeading = 60.0} -- Paleto SO
  
}

local policeoutfitamount = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

local MAX_COMPONENT = 270
local MAX_COMPONENT_TEXTURE = 100
local MAX_PROP = 220
local MAX_PROP_TEXTURE = 100
local arrSkinGeneralCaptions = {"LSPD Male","LSPD Female","Motor Unit","SWAT","Sheriff Male","Sheriff Female","Traffic Warden","Custom Male","Custom Female","FBI 1","FBI 2","FBI 3","FBI 4","Detective Male","Detective Female","Ranger Male", "Ranger Female", "Tactical", "Pilot"}
local arrSkinGeneralValues = {"s_m_y_cop_01","s_f_y_cop_01","S_M_Y_HwayCop_01","S_M_Y_SWAT_01","S_M_Y_Sheriff_01","S_F_Y_Sheriff_01","ig_trafficwarden","mp_m_freemode_01","mp_f_freemode_01","mp_m_fibsec_01","ig_stevehains","ig_andreas","s_m_m_fiboffice_01","s_m_m_ciasec_01","ig_karen_daniels","S_M_Y_Ranger_01","S_F_Y_Ranger_01", "s_m_y_blackops_01", "s_m_m_pilot_02"}
local arrSkinHashes = {}
for i=1,#arrSkinGeneralValues do
  arrSkinHashes[i] = GetHashKey(arrSkinGeneralValues[i])
end
local components = {"Face","Head","Hair","Arms/Hands","Legs","Back","Feet","Ties","Shirt","Vests","Textures","Torso"}
local props = { "Head", "Glasses", "Ear Acessories", "Watch"}
local MENU_OPEN_KEY = 38
local closest_shop = nil

RegisterNetEvent("doc:setciv")
AddEventHandler("doc:setciv", function(character, playerWeapons)
    Citizen.CreateThread(function()
        local model
        if not character.hash then -- does not have any customizations saved
            model = -408329255 -- some random black dude with no shirt on, lawl
        else
            model = character.hash
        end
        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            Wait(100)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
        -- give model customizations if available
        if character.hash then
            for key, value in pairs(character["components"]) do
                --if tonumber(key) ~= 0 or tonumber(key) ~= 1 or tonumber(key) ~= 2 then -- emit barber shop features
                SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character["componentstexture"][key], 0)
                --end
            end
            for key, value in pairs(character["props"]) do
                SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character["propstexture"][key], true)
            end
        end
        -- add any tattoos if they have any --
        if character.tattoos then
            --print("applying tattoos!")
            for i = 1, #character.tattoos do
                ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(character.tattoos[i].category), GetHashKey(character.tattoos[i].hash_name))
            end
        end
        -- add any barber shop customizations if any --
        if character.head_customizations then
            --print("barber shop customizations existed!")
            local head = character.head_customizations
            local ped = GetPlayerPed(-1)
            SetPedHeadBlendData(ped, head.parent1, head.parent2, head.parent3, head.skin1, head.skin2, head.skin3, head.mix1, head.mix2, head.mix3, false)
            -- facial stuff like beards and ageing and what not --
            for i = 1, #head.other do
                SetPedHeadOverlay(ped, i - 1, head.other[i][2], 1.0)
                if head.other[i][2] ~= 255 then
                    if i == 2 or i == 3 or i == 11 then -- chest hair, facial hair, eyebrows
                        SetPedHeadOverlayColor(ped, i - 1, 1, head.other[i][4])
                    elseif i == 6 or i == 9 then -- blush, lipstick
                        SetPedHeadOverlayColor(ped, i - 1, 2, head.other[i][4])
                    elseif i == 14 then -- hair
                        --print("setting head to: " .. head.other[i][2] .. ", color: " .. head.other[i][4])
                        SetPedComponentVariation(ped, 2, head.other[i][2], 0, 1)
                        SetPedHairColor(ped, head.other[i][4], head.other[i][5] or 0)
                    end
                end
            end
            -- eye color --
            if head.eyeColor then
              SetPedEyeColor(ped, head.eyeColor)
            end
        end
        -- give weapons
        if playerWeapons then
            for i = 1, #playerWeapons do
                GiveWeaponToPed(GetPlayerPed(-1), playerWeapons[i].hash, 1000, false, false)
                if playerWeapons[i].components then
                    if #playerWeapons[i].components > 0 then
                        for x = 1, #playerWeapons[i].components do
                            GiveWeaponComponentToPed(GetPlayerPed(-1), playerWeapons[i].hash, GetHashKey(playerWeapons[i].components[x]))
                        end
                    end
                end
                if playerWeapons[i].tint then
                    SetPedWeaponTintIndex(GetPlayerPed(-1), playerWeapons[i].hash, playerWeapons[i].tint)
                end
            end
        end
    end)
end)

-- Functions --
function DrawText3D(x, y, z, distance, text)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < distance then
        local onScreen,_x,_y=World3dToScreen2d(x,y,z)
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

---------------------------
-- Set up main menu --
---------------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("BCSO", "~b~Blaine County Sheriff's Office", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

function CreateUniformMenu(menu)
  menu:Clear()

  local submenu2 = _menuPool:AddSubMenu(menu, "Outfits", "Save and load outfits", true)
  local selectedSaveSlot = 1
    local selectedLoadSlot = 1
    local saveslot = UIMenuListItem.New("Slot to Save", policeoutfitamount)
    local saveconfirm = UIMenuItem.New('Confirm Save', 'Save outfit into the above number')
    saveconfirm:SetRightBadge(BadgeStyle.Tick)
    local loadslot = UIMenuListItem.New("Slot to Load", policeoutfitamount)
    local loadconfirm = UIMenuItem.New('Load Outfit', 'Load outfit from above number')
    loadconfirm:SetRightBadge(BadgeStyle.Clothes)
    submenu2.SubMenu:AddItem(loadslot)
    submenu2.SubMenu:AddItem(loadconfirm)
    submenu2.SubMenu:AddItem(saveslot)
    submenu2.SubMenu:AddItem(saveconfirm)

    submenu2.SubMenu.OnListChange = function(sender, item, index)
        if item == saveslot then
            selectedSaveSlot = item:IndexToItem(index)
        elseif item == loadslot then
            selectedLoadSlot = item:IndexToItem(index)
        end
    end
    submenu2.SubMenu.OnItemSelect = function(sender, item, index)
        if item == saveconfirm then
            local character = {
      ["components"] = {},
      ["componentstexture"] = {},
      ["props"] = {},
      ["propstexture"] = {}
      }
      local ply = GetPlayerPed(-1)
      for i=0,2 do -- instead of 3?
        character.props[i] = GetPedPropIndex(ply, i)
        character.propstexture[i] = GetPedPropTextureIndex(ply, i)
      end
      for i=0,11 do
        character.components[i] = GetPedDrawableVariation(ply, i)
        character.componentstexture[i] = GetPedTextureVariation(ply, i)
      end
      TriggerServerEvent("doc:saveOutfit", character, selectedSaveSlot)
        elseif item == loadconfirm then
            DoScreenFadeOut(500)
            Citizen.Wait(500)
            TriggerServerEvent('doc:loadOutfit', selectedLoadSlot)
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1, 'zip-close', 1.0)
      Citizen.Wait(2000)
      DoScreenFadeIn(500)
            TriggerEvent("usa:playAnimation", 'clothingshirt', 'try_shirt_positive_d', -8, 1, -1, 48, 0, 0, 0, 0, 3)
        end
    end
  -- Components --
  local submenu = _menuPool:AddSubMenu(menu, "Components", "Modify components", true --[[KEEP POSITION]])
  for i = 1, #components do
    local selectedComponent = GetPedDrawableVariation(PlayerPedId(), i - 1)
    local selectedTexture = GetPedTextureVariation(PlayerPedId(), i - 1)
    --local maxComponent = GetNumberOfPedDrawableVariations(ped, i - 1)
    --local maxTexture = GetNumberOfPedTextureVariations(ped, i - 1, selectedComponent)
    local arr = {}
    for j = 0, MAX_COMPONENT + 1 do arr[j] = j - 1 end
    local listitem = UIMenuListItem.New(components[i], arr, selectedComponent)
    listitem.OnListChanged = function(sender, item, index)
      if item == listitem then
        --print("Selected ~b~" .. index .. "~w~...")
        selectedComponent = index - 1
        SetPedComponentVariation(PlayerPedId(), i - 1, selectedComponent, 0, 0)
        selectedTexture = 0
      end
    end
    submenu.SubMenu:AddItem(listitem)
    --if maxTexture > 1 then
      arr = {}
      for j = 0, MAX_COMPONENT_TEXTURE + 1 do arr[j] = j - 1 end
      local listitem = UIMenuListItem.New(components[i] .. " Texture", arr, selectedTexture)
      listitem.OnListChanged = function(sender, item, index)
        if item == listitem then
          selectedTexture = index - 1
          SetPedComponentVariation(PlayerPedId(), i - 1, selectedComponent, selectedTexture, 0)
        end
      end
      submenu.SubMenu:AddItem(listitem)
    --end
  end
  -- Props --
  local submenu = _menuPool:AddSubMenu(menu, "Props", "Modify props", true --[[KEEP POSITION]])
  for i = 1, 3 do
    local selectedProp = GetPedPropIndex(PlayerPedId(), i - 1)
    local selectedPropTexture = GetPedPropTextureIndex(PlayerPedId(), i - 1)
    --local maxProp = GetNumberOfPedPropDrawableVariations(ped, i - 1)
    --local maxPropTexture = GetNumberOfPedPropTextureVariations(ped, i - 1, selectedProp)
    local arr = {}
    for j = 0, MAX_PROP + 1 do arr[j] = j - 1 end
    local listitem = UIMenuListItem.New(props[i], arr, selectedProp)
    listitem.OnListChanged = function(sender, item, index)
      if item == listitem then
        --print("Selected ~b~" .. index .. "~w~...")
        selectedProp = index - 1
        if selectedProp > -1 then
          SetPedPropIndex(PlayerPedId(), i - 1, selectedProp, 0, true)
        else
          ClearPedProp(ped, i - 1)
        end
      end
    end
    submenu.SubMenu:AddItem(listitem)
    -- add texture variation --
    --if maxPropTexture > 1 and selectedProp > -1 then
      arr = {}
      for j = 0, MAX_PROP_TEXTURE do arr[j] = j - 1 end
      local listitem = UIMenuListItem.New(props[i] .. " Texture", arr, selectedPropTexture)
      listitem.OnListChanged = function(sender, item, index)
        if item == listitem then
          --print("Selected ~b~" .. index .. "~w~...")
          selectedPropTexture = index - 1
          SetPedPropIndex(PlayerPedId(), i - 1, selectedProp, selectedPropTexture, true)
        end
      end
      submenu.SubMenu:AddItem(listitem)
    --end
  end
  local item = NativeUI.CreateItem("Clear Props", "Reset props.")
  item.Activated = function(parentmenu, selected)
    ClearPedProp(PlayerPedId(), 0)
    ClearPedProp(PlayerPedId(), 1)
    ClearPedProp(PlayerPedId(), 2)
  end
  submenu.SubMenu:AddItem(item)
  -- Clock Out --
  local item = NativeUI.CreateItem("Clock Out", "Sign off duty")
  item:SetRightBadge(BadgeStyle.Lock)
  item.Activated = function(parentmenu, selected)
    TriggerServerEvent("doc:offduty")
    RemoveAllPedWeapons(PlayerPedId())
    TriggerEvent("interaction:setPlayersJob", "civ") -- set interaction menu javascript job variable to "civ"
    TriggerEvent("ptt:isEmergency", false)
  end
  menu:AddItem(item)
end

function CreateWeaponsMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Weapons", "Select speciality weapons", true --[[KEEP POSITION]])
     for i = 1, #weapons do
         local item = NativeUI.CreateItem(weapons[i].name, "")
         item.Activated = function(parentmenu, selected)
            TriggerServerEvent("doc:checkRankForWeapon", weapons[i])
         end
         submenu.SubMenu:AddItem(item)
     end
end

function CreateVehiclesMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Vehicles", "Deploy a vehicle", true --[[KEEP POSITION]])
    for i = 1, #vehicles do
        local item = NativeUI.CreateItem(vehicles[i].name, "")
        item.Activated = function(parentmenu, selected)
          TriggerServerEvent("doc:spawnVehicle", vehicles[i])
        end
        submenu.SubMenu:AddItem(item)
    end
end

----------------
-- add to GUI --
----------------
CreateUniformMenu(mainMenu)
CreateVehiclesMenu(mainMenu)
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
          DrawText3D(PRISON_GUARD_SIGN_IN_LOCATIONS[i].x, PRISON_GUARD_SIGN_IN_LOCATIONS[i].y, PRISON_GUARD_SIGN_IN_LOCATIONS[i].z, 5, '[E] - Locker Room')
        end
        if IsControlJustPressed(1, MENU_KEY) and not _menuPool:IsAnyMenuOpen() then
          for i = 1, #PRISON_GUARD_SIGN_IN_LOCATIONS do
            if Vdist(mycoords, PRISON_GUARD_SIGN_IN_LOCATIONS[i].x, PRISON_GUARD_SIGN_IN_LOCATIONS[i].y, PRISON_GUARD_SIGN_IN_LOCATIONS[i].z) < 2.0 then
              TriggerServerEvent("doc:checkWhitelist", PRISON_GUARD_SIGN_IN_LOCATIONS[i])
            end
          end
        end
        -- close menu when far away --
        if closest_location then
            if Vdist(mycoords.x, mycoords.y, mycoords.z, closest_location.x, closest_location.y, closest_location.z) > 1.3 then
                if _menuPool:IsAnyMenuOpen() then
                    closest_location = nil
                    _menuPool:CloseAllMenus()
                end
            end
        end
    end
end)

RegisterNetEvent("doc:spawnVehicle")
AddEventHandler("doc:spawnVehicle", function(veh)
  SpawnVehicle(veh)
end)

RegisterNetEvent("doc:open")
AddEventHandler("doc:open", function(loc)
    mainMenu:Visible(not mainMenu:Visible())
    closest_location = loc
end)

RegisterNetEvent("doc:uniformLoaded")
AddEventHandler("doc:uniformLoaded", function(uniform)

  if uniform then

    Citizen.CreateThread(function()
        for key, value in pairs(uniform["components"]) do
            SetPedComponentVariation(PlayerPedId(), tonumber(key), value, uniform["componentstexture"][key], 0)
        end
        for key, value in pairs(uniform["props"]) do
            SetPedPropIndex(PlayerPedId(), tonumber(key), value, uniform["propstexture"][key], true)
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
    _menuPool:CloseAllMenus()
end)

----------------------
-- VEHICLE SPAWNING --
----------------------
function addVehicles(id)
  for i = 1, #vehicles do
    TriggerEvent("menu:addModuleItem", id, vehicles[i].name, nil, false, function(id, state)
      SpawnVehicle(vehicles[i])
    end)
  end
end

function findClosestVehSpawn()
  local closest = {
    dist = nil,
    index = nil
  }
  local mycoords = GetEntityCoords(PlayerPedId(), true)
  for i = 1, #PRISON_GUARD_SIGN_IN_LOCATIONS do
    local loc = PRISON_GUARD_SIGN_IN_LOCATIONS[i]
    local dist = Vdist(mycoords, loc.vehSpawn)
    if not closest.index or dist < closest.dist then
      closest.index = i
      closest.dist = dist
    end
  end
  return PRISON_GUARD_SIGN_IN_LOCATIONS[closest.index]
end

function SpawnVehicle(vehInfo)
  local model = vehInfo.hash
  Citizen.CreateThread(function()
    RequestModel(model)
    while not HasModelLoaded(model) do
      Wait(100)
    end

    local closestLocation = findClosestVehSpawn()
    local spawnCoords = closestLocation.vehSpawn
    local veh = CreateVehicle(model, spawnCoords.x, spawnCoords.y, spawnCoords.z + 0.6, (closestLocation.vehSpawnHeading or 0.0), true, false)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetVehicleExplodesOnHighExplosionDamage(veh, false)
    SetVehicleLivery(veh, 2) -- DOC SKIN
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
    if vehInfo.name == "Motorcycle 2" then
      ModifyVehicleTopSpeed(veh, 0.0) -- reset first to avoid doubling up issue
      ModifyVehicleTopSpeed(veh, 30.0)
    end

    -- give key to owner
    local vehicle_key = {
      name = "Key -- " .. GetVehicleNumberPlateText(veh),
      quantity = 1,
      type = "key",
      owner = "GOVT",
      make = "GOVT",
      model = "GOVT",
      plate = GetVehicleNumberPlateText(veh)
    }
		TriggerServerEvent("garage:giveKey", vehicle_key)
  end)
end

---------------------
-- WEAPON SPAWNING --
---------------------
RegisterNetEvent("doc:equipWeapon")
AddEventHandler("doc:equipWeapon", function(weapon)
    TriggerEvent("mini:equipWeapon", weapon.hash, weapon.components)
    exports.globals:notify("Equipped: " .. weapon.name)
end)
