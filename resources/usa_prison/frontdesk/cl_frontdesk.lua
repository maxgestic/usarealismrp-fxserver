local ITEM_RETRIEVAL_COORDS = {
    vector3(1840.4655761719, 2579.3420410156, 46.014316558838)
}

local isAtLocation = nil

local NEARBY_DIST = 3

local E_KEY = 38

local function DrawText3D(x, y, z, text)
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

Citizen.CreateThread(function()
    while true do
        local wasNearAny = false
        local mycoords = GetEntityCoords(PlayerPedId())
        for i = 1, #ITEM_RETRIEVAL_COORDS do
            if Vdist(mycoords, ITEM_RETRIEVAL_COORDS[i]) < NEARBY_DIST then
                isAtLocation = ITEM_RETRIEVAL_COORDS[i]
                wasNearAny = true
                break
            end
        end
        if not wasNearAny then
            isAtLocation = nil
        end
        Wait(200)
    end
end)

Citizen.CreateThread(function()
    while true do
        if isAtLocation then
            DrawText3D(isAtLocation.x, isAtLocation.y, isAtLocation.z, "[E] - Retrieve items")
            if IsControlJustPressed(0, E_KEY) then
                TriggerServerEvent("prison:retrieveItems")
                Wait(200)
            end
        end
        Wait(1)
    end
end)