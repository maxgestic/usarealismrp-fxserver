RegisterNetEvent("character:setCoords")
AddEventHandler("character:setCoords", function(coords)
    if coords.x and coords.y and coords.z then
        local myped = PlayerPedId()
        SetEntityCoords(myped, coords.x, coords.y, coords.z, 0, 0, 0, 0)
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        Wait(10)
        SetEntityCoordsNoOffset(myped, coords.x, coords.y, coords.z, false, false, false, true)
        while not HasCollisionLoadedAroundEntity(myped) do
            Wait(100)
            SetEntityCoords(myped, coords.x, coords.y, coords.z, 1, 0, 0, 1)
        end
    end
end)