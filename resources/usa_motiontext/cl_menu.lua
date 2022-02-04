
RegisterNetEvent("motiontext:toggleMenu")
AddEventHandler("motiontext:toggleMenu", function()
    SendNUIMessage({
        type = "toggle"
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("submit", function(data)
    local mycoords = GetEntityCoords(PlayerPedId())

    if IsPointOnRoad(mycoords.x, mycoords.y, mycoords.z, 0) then
        exports.globals:notify("Can't place on road!")
        return
    end

    data.verticalOffset = tonumber(data.verticalOffset)

    local actualCoords = {
        x = mycoords.x,
        y = mycoords.y,
        z = mycoords.z + (data.verticalOffset or 0.5)
    }

    data.font = tonumber(data.font)
    data.radius = tonumber(data.radius)
    data.perspectiveScale = tonumber(data.perspectiveScale)
    data.scaleMultiplier = tonumber(data.scaleMultiplier)
    data.outline = (not not data.outline)
    for i = 1, #data.color do
        data.color[i] = tonumber(data.color[i])
    end

    local info = {
        xyz = actualCoords,
        text={
            content = data.content,
            rgb = {data.color[1], data.color[2], data.color[3]},
            textOutline = data.outline,
            scaleMultiplier = data.scaleMultiplier,
            font = data.font
        },
        perspectiveScale = data.perspectiveScale,
        radius = data.radius,
    }
    TriggerServerEvent("motiontext:submit", info)
end)

RegisterNUICallback("close", function(data)
    SetNuiFocus(false, false)
end)