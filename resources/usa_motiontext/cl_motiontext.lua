local allText = {}

local NEARBY_CHECK_INTERVAL_SECONDS = 1

local MAX_DELETE_DIST = 5

RegisterNetEvent("motiontext:new")
AddEventHandler("motiontext:new", function(data)
    table.insert(allText, data)
end)

RegisterNetEvent("motiontext:delete")
AddEventHandler("motiontext:delete", function()
    local mycoords = GetEntityCoords(PlayerPedId())
    local closestTextIndex = nil
    local closestTextDistance = 999999
    for i = 1, #allText do
        if allText[i] then
            local  textCoords = vector3(allText[i].xyz.x, allText[i].xyz.y, allText[i].xyz.z)
            local dist = Vdist(mycoords, textCoords)
            if not closestTextIndex or dist < closestTextDistance then
                closestTextIndex = i
                closestTextDistance = dist
            end
        end
    end
    if closestTextDistance > MAX_DELETE_DIST then
        exports.globals:notify("No sign found!")
        return
    end
    TriggerServerEvent("motiontext:delete", closestTextIndex)
end)

RegisterNetEvent("motiontext:remove")
AddEventHandler("motiontext:remove", function(index)
    allText[index] = nil
end)

CreateThread(function()
    TriggerServerEvent('motiontext:playerSpawned')
end)

RegisterNetEvent("motiontext:set")
AddEventHandler("motiontext:set", function(allTexts)
    allText = allTexts
end)

-- calculate distance to all text every so often:
CreateThread(function()
    local lastNearbyCheck = 0
    while true do
        if GetGameTimer() - lastNearbyCheck >= (NEARBY_CHECK_INTERVAL_SECONDS * 1000) then
            lastNearbyCheck = GetGameTimer()
            local mycoords = GetEntityCoords(PlayerPedId())
            for i = 1, #allText do
                if allText[i] then
                    local  textCoords = vector3(allText[i].xyz.x, allText[i].xyz.y, allText[i].xyz.z)
                    local dist = #(mycoords - textCoords)
                    allText[i].dist = dist
                end
            end
        end
        Wait(1)
    end
end)

-- draw nearby:
CreateThread(function()
    while true do
        for i = 1, #allText do
            if allText[i] then
                local data = allText[i]
                if data.dist then
                    if data.dist <= (data.radius / 2) then
                        Draw3DText({
                            xyz = data.xyz,
                            text={
                                content = data.text.content,
                                rgb = {data.text.rgb[1], data.text.rgb[2], data.text.rgb[3]},
                                textOutline = data.text.textOutline,
                                scaleMultiplier = data.text.scaleMultiplier,
                                font = data.text.font
                            },
                            perspectiveScale = data.perspectiveScale,
                            radius = data.radius,
                        })
                    else
                        allText[i].dist = nil
                    end
                end
            end
        end
        Wait(1)
    end
end)

function Draw3DText(params)
    if params == nil then params=default end
    if params.xyz == nil then params.xyz=default.xyz end
    if params.text.rgb == nil then params.text.rgb=default.text.rgb end
    if params.text.textOutline == nil then params.text.textOutline=default.text.textOutline end
    Citizen.CreateThread(function()
        local onScreen, _x, _y = World3dToScreen2d(params.xyz.x,params.xyz.y,params.xyz.z)
        local p = GetGameplayCamCoords()
        local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, params.xyz.x,params.xyz.y,params.xyz.z, 1)
        local scale = (1 / distance) * (params.perspectiveScale or default.perspectiveScale)
        local fov = (1 / GetGameplayCamFov()) * 75
        local scale = scale * fov
        if onScreen then
            SetTextScale(tonumber(params.text.scaleMultiplier*0.0), tonumber(0.35 * (params.text.scaleMultiplier or default.text.scaleMultiplier)))
            SetTextFont(params.text.font or default.text.font)
            SetTextProportional(true)
            SetTextColour(params.text.rgb[1], params.text.rgb[2], params.text.rgb[3], 255)
            --SetTextDropshadow(0, 0, 0, 0, 255)
            --SetTextEdge(2, 0, 0, 0, 150)
            if (params.text.textOutline) == true then SetTextOutline() end;
            SetTextEntry("STRING")
            SetTextCentre(true)
            AddTextComponentString(params.text.content or default.text.content)
            DrawText(_x,_y)
        end
    end)
end