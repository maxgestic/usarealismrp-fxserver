Citizen.CreateThread(function()
    while true do
        local lastSet = GetGameTimer()
        while GetGameTimer() - lastSet < 30000 do
            Wait(100)
        end
        SetPedSuffersCriticalHits(PlayerPedId(), false)
        lastSet = GetGameTimer()
    end
end)