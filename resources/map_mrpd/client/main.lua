Citizen.CreateThread(function()
    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(myCoords, 975.76763916016,-120.56567382813,74.223541259766, true ) < 80 then
            ClearAreaOfPeds(975.76763916016,-120.56567382813,74.223541259766, 80.0, 0)
        elseif GetDistanceBetweenCoords(myCoords, 471.90618896484,-989.65802001953,24.914854049683, true ) < 20 then
            ClearAreaOfPeds(471.90618896484,-989.65802001953,24.914854049683, 80.0, 0)
        elseif GetDistanceBetweenCoords(myCoords, 243.72465515137,-1096.3624267578,29.30615234375, true ) < 30 then
            ClearAreaOfPeds(243.72465515137,-1096.3624267578,29.30615234375, 80.0, 0)
        elseif GetDistanceBetweenCoords(myCoords, 478.77, -1009.05, 35.93, true ) < 30 then
            ClearAreaOfPeds(478.77, -1009.05, 35.93, 80.0, 0)
        elseif GetDistanceBetweenCoords(myCoords, 445.8, -981.62, 26.67, true ) < 30 then
            ClearAreaOfPeds(445.8, -981.62, 26.67, 80.0, 0)
        end
        Wait(1)
    end
end)