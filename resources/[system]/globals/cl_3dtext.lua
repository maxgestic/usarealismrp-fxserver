local TEXT_3D_DRAW_DIST = 10

local targetLocations = {}
local nearbyLocations = {}

function register3dTextLocations(locations)
    for i = 1, #locations do
        table.insert(targetLocations, locations[i])
    end
end

-- recording nearby locations to draw text for
Citizen.CreateThread(function()
    while true do
        local lastCheck = GetGameTimer()
        while GetGameTimer() - lastCheck < 500 do
            Wait(1)
        end
        for i = 1, #targetLocations do
            local mycoords = GetEntityCoords(PlayerPedId())
            if #(mycoords - targetLocations[i].coords) <= TEXT_3D_DRAW_DIST then
                if not nearbyLocations[i] then
                    nearbyLocations[i] = targetLocations[i]
                end
            elseif nearbyLocations[i] then
                nearbyLocations[i] = nil
            end
        end
    end
end)

-- runs in tandem with above thread to draw 3d text for nearby spots, or remove if no longer nearby
Citizen.CreateThread(function()
    while true do
        for index, data in pairs(nearbyLocations) do
            DrawText3D(data.coords.x, data.coords.y, data.coords.z, data.text)
        end
        Wait(1)
    end
end)

exports("register3dTextLocations", register3dTextLocations)