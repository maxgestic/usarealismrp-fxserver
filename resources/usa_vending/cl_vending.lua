local ITEMS = {} -- loaded from server
TriggerServerEvent("vending:loadItems")

local vendingModels = {
    "prop_vend_soda_01",
    "prop_vend_soda_02",
    "prop_vend_snak_01",
    -1034034125,
    "prop_vend_coffe_01",
    "prop_vend_water_01"
}

local CHECK_RADIUS = 0.6

local MENU_OPEN_KEY = 38

local closest = nil

local createdMenus = {}

_menuPool = NativeUI.CreatePool()

foodMenu = NativeUI.CreateMenu("Vending Machine", "~b~Please select an item!", 0 --[[X COORD]], 320 --[[Y COORD]])
table.insert(createdMenus, { menu = foodMenu, category = "Food", model = "prop_vend_snak_01", model2 = -1034034125})
sodaMenu = NativeUI.CreateMenu("Vending Machine", "~b~Please select an item!", 0 --[[X COORD]], 320 --[[Y COORD]])
table.insert(createdMenus, { menu = sodaMenu, category = "Soda", model = "prop_vend_soda_01", model2 = "prop_vend_soda_02"})
waterMenu = NativeUI.CreateMenu("Vending Machine", "~b~Please select an item!", 0 --[[X COORD]], 320 --[[Y COORD]])
table.insert(createdMenus, { menu = waterMenu, category = "Water", model = "prop_vend_water_01"})
coffeeMenu = NativeUI.CreateMenu("Coffee Machine", "~b~Please select an item!", 0 --[[X COORD]], 320 --[[Y COORD]])
table.insert(createdMenus, { menu = coffeeMenu, category = "Coffee", model = "prop_vend_coffe_01"})

for i = 1, #createdMenus do
    _menuPool:Add(createdMenus[i].menu)
end

RegisterNetEvent("vending:loadItems")
AddEventHandler("vending:loadItems", function(items)
  ITEMS = items
  for i = 1, #createdMenus do
      CreateMenu(createdMenus[i].menu, createdMenus[i].category)
  end
  _menuPool:RefreshIndex()
end)

function CreateMenu(menu, category)
    for i = 1, #ITEMS[category] do
        local product = ITEMS[category][i]
        local item = NativeUI.CreateItem(product.name, "Purchase a " .. product.name .. " for $" .. exports["globals"]:comma_value(product.price) .. " " .. (product.caption or ""))
        item.Activated = function(parentmenu, selected)
          TriggerServerEvent("vending:purchase", category, i)
        end
        menu:AddItem(item)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local me = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(me, false)

        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        _menuPool:ProcessMenus()

        if IsControlJustPressed(1, MENU_OPEN_KEY) then
            for i = 1, #vendingModels do
                local hash = vendingModels[i]
                if type(hash) ~= "number" then
                    hash = GetHashKey(vendingModels[i])
                end
                local obj = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, CHECK_RADIUS, hash, false, false, false)
                if DoesEntityExist(obj) then
                    if _menuPool:IsAnyMenuOpen() then
                        _menuPool:CloseAllMenus()
                    end
                    for j = 1, #createdMenus do
                        if vendingModels[i] == createdMenus[j].model then
                            createdMenus[j].menu:Visible(true)
                        elseif createdMenus[j].model2 and vendingModels[i] == createdMenus[j].model2 then -- really ghetto
                            createdMenus[j].menu:Visible(true)
                        end
                    end
                    closest = playerCoords
                    break
                end
            end
        end

        if _menuPool:IsAnyMenuOpen() then -- close when far away
            if Vdist(playerCoords, closest.x, closest.y, closest.z) > CHECK_RADIUS then
                closest = nil
                _menuPool:CloseAllMenus()
            end
        end
    end
end)
