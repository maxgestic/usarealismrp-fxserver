RegisterNetEvent("character:setCoords")
AddEventHandler("character:setCoords", function(coords)
    if coords.x and coords.y and coords.z then
        local myped = PlayerPedId()
        print("teleporting entity!")
SetEntityCoords(myped, coords.x, coords.y, coords.z, 0, 0, 0, 0)
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        Wait(10)
        print("teleporting entity!")
print("teleporting entity!")
SetEntityCoordsNoOffset(myped, coords.x, coords.y, coords.z, false, false, false, true)
        while not HasCollisionLoadedAroundEntity(myped) do
            Wait(100)
            print("teleporting entity!")
SetEntityCoords(myped, coords.x, coords.y, coords.z, 1, 0, 0, 1)
        end
    end
end)