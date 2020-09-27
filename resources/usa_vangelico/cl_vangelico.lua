local MENU_LOCATIONS  = {
    { name = "Watches", x = -623.4, y = -233.1, z = 38.1},
    { name = "Bracelets", x = -624.6, y = -231.0, z = 38.1}
}

local me = GetPlayerPed(-1)

local ITEMS = {} -- loaded from server
TriggerServerEvent("vangelico:loadItems")

local MENU_OPEN_KEY = 38

local closest_section = nil

local cart = {}

local MENU_DISTANCE = 1.3

local storeIsOpen = false -- only available certain hours

Citizen.CreateThread(function()
    while true do
        if GetClockHours() >= 9 then
            storeIsOpen = true
        else
            storeIsOpen = false
        end
        Wait(30000)
    end
end)

_menuPool = NativeUI.CreatePool()
menu = NativeUI.CreateMenu("Vangelico", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(menu)

RegisterNetEvent("vangelico:loadItems")
AddEventHandler("vangelico:loadItems", function(items)
    ITEMS = items
end)

function CreateMenu(menu, gender, type)
    menu:Clear()

    for name, info in pairs(ITEMS[gender][type]) do
        local submenu = _menuPool:AddSubMenu(menu, "($" .. exports["globals"]:comma_value(info.price) .. ") " .. name, "See variations for " .. name .. " (" .. GetWristDisplayName(info.wrist) .. " wrist)", true)
        local tryOnBtn = NativeUI.CreateItem("Try on", "Try on the " .. name .. " (" .. GetWristDisplayName(info.wrist) .. " wrist)")
        tryOnBtn.Activated = function(pmenu, selected)
            ClearPedProp(me, info.wrist)
            SetPedPropIndex(me, info.wrist, info.propVal, 0, true)
            AddToCart(name, info, 0)
        end
        submenu.SubMenu:AddItem(tryOnBtn)
        local prop_texture_variations_total = GetTextureVariations(info.wrist, info.propVal)
        local textureSlider = NativeUI.CreateListItem("Variation:", prop_texture_variations_total, 1)
		textureSlider.OnListSelected = function(sender, item, index)
			if item == textureSlider then
                local val = item:IndexToItem(index)
                ClearPedProp(me, info.wrist)
                SetPedPropIndex(me, info.wrist, info.propVal, val, true)
                AddToCart(name, info, val)
			end
		end
        submenu.SubMenu:AddItem(textureSlider)
        menu:AddItem(submenu.SubMenu)
    end

    local checkout = NativeUI.CreateItem("Checkout", "Check out the items you are wearing.")
    checkout:SetRightBadge(BadgeStyle.Star)
    checkout.Activated = function(parentmenu, selected)
        if cart["left"] or cart["right"] then
            local business = exports["usa-businesses"]:GetClosestStore(15)
            TriggerServerEvent("vangelico:purchase", cart, business)
            cart = {}
        end
    end
    menu:AddItem(checkout)

    local removeLeftBtn = NativeUI.CreateItem("Remove Left", "Return the item you are wearing on your left wrist (NO REFUND!)")
    removeLeftBtn.Activated = function(pmenu, selected)
        ClearPedProp(me, 6)
        TriggerServerEvent("vangelico:clear", "6")
    end
    menu:AddItem(removeLeftBtn)

    local removeRightBtn = NativeUI.CreateItem("Remove Right", "Return the item you are wearing on your right wrist (NO REFUND!)")
    removeRightBtn.Activated = function(pmenu, selected)
        ClearPedProp(me, 7)
        TriggerServerEvent("vangelico:clear", "7")
    end
    menu:AddItem(removeRightBtn)

end

function DisplayMenu(menu, type)
    local gender = "undefined"
    if IsPedMaleModel(me) then
        gender = "male"
    else
        gender = "female"
    end
    CreateMenu(menu, gender, type)
    menu:Visible(true)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        me = GetPlayerPed(-1)

        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        _menuPool:ProcessMenus()

        if storeIsOpen then
            for i = 1, #MENU_LOCATIONS do
                DrawText3D(MENU_LOCATIONS[i].x, MENU_LOCATIONS[i].y, MENU_LOCATIONS[i].z, 4, '[E] - ' .. MENU_LOCATIONS[i].name)
            end

            if IsControlJustPressed(1, MENU_OPEN_KEY) then
                for i = 1, #MENU_LOCATIONS do
                    local playerCoords = GetEntityCoords(me, false)
                    if Vdist(playerCoords, MENU_LOCATIONS[i].x, MENU_LOCATIONS[i].y, MENU_LOCATIONS[i].z) < MENU_DISTANCE then
                        closest_section = MENU_LOCATIONS[i] --// set shop player is at
                        local menuName = MENU_LOCATIONS[i].name
                        DisplayMenu(menu, menuName:lower())
                        _menuPool:RefreshIndex()
                    end
                end
            end

            if closest_section then
                local playerCoords = GetEntityCoords(me, false)
                if Vdist(playerCoords, closest_section.x, closest_section.y, closest_section.z) > MENU_DISTANCE then
                    TriggerServerEvent("usa:loadPlayerComponents")
                    cart = {}
                    closest_section = nil
                    menu:Visible(false)
                end
            end
        end

    end
end)

function DrawText3D(x, y, z, distance, text)
  if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 470
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
  end
end

function IsPedMaleModel(ped)
    return IsPedModel(ped, GetHashKey("mp_m_freemode_01"))
end

function GetTextureVariations(wrist, val)
    local t = {}
    for i = 0, GetNumberOfPedPropTextureVariations(me, wrist, val) - 1 do table.insert(t, i) end
    return t
end

function GetWristDisplayName(wrist)
    if wrist == 6 then
        return "Left"
    elseif wrist == 7 then
        return "Right"
    else
        return "Undefined"
    end
end

function AddToCart(name, info, textureVal)
    local wrist = GetWristDisplayName(info.wrist):lower()
    cart[wrist] = info
    cart[wrist].name = name
    cart[wrist].textureVal = textureVal
end
