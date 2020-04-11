Citizen.CreateThread(function()
    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(myCoords, 1787.91,2590.53,45.8, true ) < 200 then
            ClearAreaOfPeds(1787.91,2590.53,45.8, 200.0, 0)
        end
        Wait(1)
    end
end)