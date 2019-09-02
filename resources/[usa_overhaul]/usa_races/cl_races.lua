local isMenuOpen = false

local currentRace = nil

RegisterNetEvent("races:confirmJoin")
AddEventHandler("races:confirmJoin", function(race, timeUntilString)
    currentRace = {
        info = race,
        stage = "joined"
    }
    TriggerEvent("usa:notify", "You have been enrolled in " .. currentRace.info.title .. "! Head to the waypoint!", "^0You have been enrolled in " .. currentRace.info.title .. "! Head to the waypoint! " .. timeUntilString)
    SetNewWaypoint(race.start.coords.x, race.start.coords.y)
end)

RegisterNetEvent("races:getNewRaceCoords")
AddEventHandler("races:getNewRaceCoords", function(bet, minutes, title)
    if not IsWaypointActive() then 
        exports.globals:notify("You must set a waypoint to start a race!")
        return
    end
    local me = PlayerPedId()
    local mycoords = GetEntityCoords(me)
    local waypointBlip = GetFirstBlipInfoId(8) -- 8 = Waypoint ID
    local endCoord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector())
    TriggerServerEvent("races:gotNewRaceCoords", {x = mycoords.x, y = mycoords.y, z = mycoords.z}, {x = endCoord.x, y = endCoord.y, z = endCoord.z}, bet, minutes, title)
end)

RegisterNetEvent("races:toggleMenu")
AddEventHandler("races:toggleMenu", function(doOpen, races)
    isMenuOpen = doOpen
    SendNUIMessage({
        type = "toggle",
        doOpen = isMenuOpen,
        races = races or {}
    })
    SetNuiFocus(isMenuOpen, isMenuOpen)
end)

RegisterNetEvent("races:startRace")
AddEventHandler("races:startRace", function()
    if currentRace then
        local me = PlayerPedId()
        local mycoords = GetEntityCoords(me)
        local startCoords = currentRace.info.start.coords
        local isAtStartCoords = GetDistanceBetweenCoords(mycoords.x, mycoords.y, mycoords.z, startCoords.x, startCoords.y, startCoords.z, false) < 25
        if isAtStartCoords then
            currentRace.stage = "racing"
            exports.globals:notify("Race ~g~started~w~! Go, go, go!", "^0Race ^2started^0! Go, go, go!")
        else 
            exports.globals:notify("Out of range! Disqualified!")
            currentRace = nil
            TriggerEvent("swayam:RemoveWayPoint")
        end
    end
end)

RegisterNetEvent("races:endRace")
AddEventHandler("races:endRace", function(reason)
    currentRace = nil
    TriggerEvent("swayam:RemoveWayPoint")
    local msg = "Race ended!"
    if reason then 
        msg = msg .. " " .. reason
    end
    exports.globals:notify(msg, "^0" .. msg)
end)

RegisterNetEvent("races:setWaypoint")
AddEventHandler("races:setWaypoint", function(coords, label)
    TriggerEvent("swayam:SetWayPointWithAutoDisable", coords.x, coords.y, coords.z, 280, 60, label)
end)

RegisterNUICallback("closeMenu", function(data, cb)
    TriggerEvent("races:toggleMenu", false)
end)

RegisterNUICallback("joinRace", function(data, cb)
    if not currentRace then
        TriggerServerEvent("races:joinRace", data.host)
    else 
        exports.globals:notify("You are already enrolled in a race!", "^0You are already enrolled in a race!")
    end
    TriggerEvent("races:toggleMenu", false)
end)

Citizen.CreateThread(function()
    while true do
        if currentRace then
            local me = PlayerPedId()
            local mycoords = GetEntityCoords(me)
            if currentRace.stage == "joined" then -- driving towards start
                local startCoords = currentRace.info.start.coords
                local isAtStartCoords = GetDistanceBetweenCoords(mycoords.x, mycoords.y, mycoords.z, startCoords.x, startCoords.y, startCoords.z, false) < 30
                if isAtStartCoords then 
                    TriggerServerEvent("races:askStartUntilTime", currentRace.info.host.source)
                    currentRace.stage = "waiting"
                end
            elseif currentRace.stage == "racing" then -- racing
                local endcoords = currentRace.info.finish.coords
                local isAtFinish = GetDistanceBetweenCoords(mycoords.x, mycoords.y, mycoords.z, endcoords.x, endcoords.y, endcoords.z, false) < 15
                if isAtFinish then
                    TriggerServerEvent("races:raceWon", currentRace.info.host.source)
                    currentRace = nil
                end
            end
        end
        Wait(5)
    end
end)