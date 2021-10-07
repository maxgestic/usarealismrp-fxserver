Citizen.CreateThread(function()

    client.player.info.id = PlayerId()
    client.player.info.serverId = GetPlayerServerId(client.player.info.id)

    for i,var0 in pairs(config.detectors) do
        table.insert(var0, { data = { distance = nil, enable = nil } })
        DebugPrint("^3DEBUG: ^0Inserted data table into detector " .. var0.info.id .. ".")
        if (var0.entity.enable) and (var0.entity.heading ~= nil) then
            CreateDetector(var0)
        end
    end

    while (true) do
        client.player.game.coords = GetEntityCoords(PlayerPedId())
        for i,var0 in pairs(config.detectors) do
            -- var0[1].data.distance = GetDistanceBetweenCoords(client.player.game.coords, var0.coords.x, var0.coords.y, var0.coords.z, true)
            var0[1].data.distance = Vdist2(client.player.game.coords, var0.coords.x, var0.coords.y, var0.coords.z)
            if (var0[1].data.distance < var0.coords.radius) then
                if not (var0[1].data.enable) then
                    TriggerServerEvent('DetectorAlarm', client.player.info.serverId, var0)
                    var0[1].data.enable = true
                end
            else
                if (var0[1].data.enable) then
                    var0[1].data.enable = false
                end
            end
        end
        Citizen.Wait(100)
    end
end)