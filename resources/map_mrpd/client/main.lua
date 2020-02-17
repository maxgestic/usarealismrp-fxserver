Citizen.CreateThread(function()
	LoadInterior(GetInteriorAtCoords(440.84, -983.14, 30.69))
end)

--Citizen.CreateThread(function()
--    while (true) do
--        Citizen.Wait(1)
--
--        ClearAreaOfPeds(468.2, -984.65, 24.91, 600, 1)
--        Citizen.Wait(0)
--    end
--end)


Citizen.CreateThread(function()
    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(myCoords, 975.76763916016,-120.56567382813,74.223541259766, true ) < 80 then
            ClearAreaOfPeds(975.76763916016,-120.56567382813,74.223541259766, 58.0, 0)
        elseif GetDistanceBetweenCoords(myCoords, 471.90618896484,-989.65802001953,24.914854049683, true ) < 20 then
            ClearAreaOfPeds(471.90618896484,-989.65802001953,24.914854049683, 20.0, 0)
        elseif GetDistanceBetweenCoords(myCoords, 243.72465515137,-1096.3624267578,29.30615234375, true ) < 30 then
            ClearAreaOfPeds(243.72465515137,-1096.3624267578,29.30615234375, 20.0, 0)
        elseif GetDistanceBetweenCoords(myCoords, 445.8, -981.62, 26.67, true ) < 30 then
            ClearAreaOfPeds(445.8, -981.62, 26.67, 20.0, 0)
        end
        Wait(1)
    end
end)