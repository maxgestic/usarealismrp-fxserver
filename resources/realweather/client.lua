--Made by Jijamik, feel free to modify

RegisterNetEvent('meteo:actu')
AddEventHandler('meteo:actu', function(data, delay)
    if data then
        ClearWeatherTypePersist()
        SetWeatherTypeOverTime(data["Meteo"], (delay or 80.00))
        SetWind(1.0)
        SetWindSpeed(data["VitesseVent"]);
        SetWindDirection(data["DirVent"])
        if data["Meteo"] == "XMAS" then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

AddEventHandler('playerSpawned', function(spawn)
    TriggerServerEvent('meteo:sync', 0.0)
end)
