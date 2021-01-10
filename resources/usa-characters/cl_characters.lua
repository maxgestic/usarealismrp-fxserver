RegisterNetEvent("character:setCoords")
AddEventHandler("character:setCoords", function(coords)
    if coords.x and coords.y and coords.z then
        local myped = PlayerPedId()
        SetEntityCoords(myped, coords.x, coords.y, coords.z, 0, 0, 0, 0)
    end
end)