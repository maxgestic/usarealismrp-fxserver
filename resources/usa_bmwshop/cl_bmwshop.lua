local myped = {
    handle = nil,
    coords = nil
}

local DISPLAY_VEHICLES = {} -- loaded from server

local DRAW_3D_TEXT_DIST = 3.5

local SHOP_VISIBLE_DISTANCE = 500
local SHOP_SPAWN_CHECK_DELAY = 3000

local PURCHASE_KEY = nil
local HOLD_TIME_BUY = 5000

local BUY_DISTANCE = 2.0

local KART_SPAWN = {
    COORDS = vector3(-1240.4705810547, -347.33734130859, 37.332828521729),
    HEADING = 340.0
}

local PREVIEW_TIME_MS = 25000

local beforePreviewCoords = nil

RegisterNetEvent("bmwshop:loadVehicles")
AddEventHandler("bmwshop:loadVehicles", function(VEHICLES)
    DISPLAY_VEHICLES = VEHICLES
end)

TriggerServerEvent("bmwshop:loadVehicles")

RegisterNetEvent("bmwshop:spawn")
AddEventHandler("bmwshop:spawn", function(veh)
    spawnVehicle(veh, false)
end)

local function PreviewVehicle(veh)
    TriggerEvent("hotwire:enableKeyEngineCheck", false)
    SetVehicleEngineOn(veh, true, true, false)
    SetVehRadioStation(veh, "OFF")
    beforePreviewCoords = GetEntityCoords((myped.handle or PlayerPedId()))
    SetPedIntoVehicle((myped.handle or PlayerPedId()), veh, -1)
    SetVehicleDoorsLocked(veh, 4)
end

local function EndPreview(veh)
    SetEntityCoords((myped.handle or PlayerPedId()), beforePreviewCoords)
    SetVehicleEngineOn(veh, false, false, false)
    SetVehicleDoorsLocked(veh, 10)
    TriggerEvent("hotwire:enableKeyEngineCheck", true)
end

function spawnVehicle(veh, forDisplay)
    if type(veh.HASH) ~= "number" then
        veh.HASH = GetHashKey(veh.HASH)
    end
    RequestModel(veh.HASH)
    while not HasModelLoaded(veh.HASH) do
        Wait(100)
    end
    local handle = nil
    if forDisplay then
        handle = CreateVehicle(veh.HASH, veh.COORDS.x, veh.COORDS.y, veh.COORDS.z, (veh.HEADING or 0.0) --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
        FreezeEntityPosition(handle, true)
        SetVehicleDoorsLocked(handle, 10)
        SetVehicleExplodesOnHighExplosionDamage(handle, false)
    else
        PlaySoundFrontend(-1,"Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
        handle = CreateVehicle(veh.HASH, KART_SPAWN.COORDS.x, KART_SPAWN.COORDS.y, KART_SPAWN.COORDS.z, (KART_SPAWN.HEADING or 0.0) --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
    end
    SetVehicleOnGroundProperly(handle)
    SetEntityAsMissionEntity(handle, true, true)
    if veh.plate then
        SetVehicleNumberPlateText(handle, veh.plate)
    end
    return handle
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
end

function comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

-- async thread to load key table from globals resource --
Citizen.CreateThread(function()
    while not exports.globals:GetKeys() do
        Wait(1000)
    end
    PURCHASE_KEY = exports.globals:GetKeys().E
    PREVIEW_KEY = exports.globals:GetKeys().Y
end)

-- handle purchasing / 3D text --
Citizen.CreateThread(function()
    while true do
        if myped.handle then
            for i = 1, #DISPLAY_VEHICLES do
                local dist = GetDistanceBetweenCoords(DISPLAY_VEHICLES[i].COORDS, myped.coords, false)
                if dist <= DRAW_3D_TEXT_DIST then
                    -- draw 3d text when close enough to any vehicle
                    local text = "UNDEFINED"
                    if not DISPLAY_VEHICLES[i].startBuyTime then
                        text = "[Hold E] - Buy " .. DISPLAY_VEHICLES[i].MODEL .. " | $" .. comma_value(DISPLAY_VEHICLES[i].PRICE)
                        text = text .. "\n"
                        text = text .. "[Y] - Preview"
                    else 
                        local timeleft = math.floor((HOLD_TIME_BUY / 1000) - ((GetGameTimer() - DISPLAY_VEHICLES[i].startBuyTime) / 1000))
                        text = "Buying in " .. timeleft .. " second(s)"
                    end
                    DrawText3D(DISPLAY_VEHICLES[i].COORDS.x, DISPLAY_VEHICLES[i].COORDS.y, DISPLAY_VEHICLES[i].COORDS.z + 1.0, text)
                    if dist <= BUY_DISTANCE then
                        -- BUYING
                        if IsControlJustPressed(0, PURCHASE_KEY) and GetLastInputMethod(0) then
                            DISPLAY_VEHICLES[i].startBuyTime = GetGameTimer()
                            Citizen.CreateThread(function()
                                while GetLastInputMethod(0) and IsControlPressed(0, PURCHASE_KEY) and GetGameTimer() - DISPLAY_VEHICLES[i].startBuyTime < HOLD_TIME_BUY do
                                    Wait(0)
                                end
                                if IsControlPressed(0, PURCHASE_KEY) and GetLastInputMethod(0) then
                                    TriggerServerEvent("bmwshop:buy", i)
                                end
                                DISPLAY_VEHICLES[i].startBuyTime = nil
                            end)
                        elseif IsControlJustPressed(0, PREVIEW_KEY) and GetLastInputMethod(0) then
                            local veh = exports.globals:getClosestVehicle(2.5)
                            PreviewVehicle(veh)
                            Wait(PREVIEW_TIME_MS)
                            EndPreview(veh)
                        end
                    end
                end
            end
        end
        Wait(1)
    end
end)

-- thread to update local ped handle and coords --
Citizen.CreateThread(function()
    while true do
        myped.handle = PlayerPedId()
        myped.coords = GetEntityCoords(myped.handle)
        Wait(1)
    end
end)

-- thread to manage shop display vehicles --
Citizen.CreateThread(function()
    while true do
        if myped.handle then
            for i = 1, #DISPLAY_VEHICLES do
                local dist = Vdist(myped.coords, DISPLAY_VEHICLES[i].COORDS)
                if dist < SHOP_VISIBLE_DISTANCE then
                    if not DISPLAY_VEHICLES[i].handle then
                        DISPLAY_VEHICLES[i].handle = spawnVehicle(DISPLAY_VEHICLES[i], true)
                    end
                else
                    if DISPLAY_VEHICLES[i].handle then
                        DeleteVehicle(DISPLAY_VEHICLES[i].handle)
                        DISPLAY_VEHICLES[i].handle = nil
                    end
                end
            end
        end
        Wait(SHOP_SPAWN_CHECK_DELAY)
    end
end)