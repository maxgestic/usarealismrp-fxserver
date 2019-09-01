local isMenuOpen = false

local currentRace = nil

RegisterNetEvent("races:confirmJoin")
AddEventHandler("races:confirmJoin", function(race)
    currentRace = {
        info = race,
        stage = "joined"
    }
    TriggerEvent("usa:notify", "You have been enrolled in " .. currentRace.info.title .. "! Head to the waypoint!", "^0You have been enrolled in " .. currentRace.info.title .. "! Head to the waypoint! It starts in " .. GetMinutesUntilStartStr(currentRace))
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
    local registerTime = GetGameTimer()
    TriggerServerEvent("races:gotNewRaceCoords", {x = mycoords.x, y = mycoords.y, z = mycoords.z}, {x = endCoord.x, y = endCoord.y, z = endCoord.z}, bet, minutes, title, registerTime)
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

RegisterNUICallback("closeMenu", function(data, cb)
    TriggerEvent("races:toggleMenu", false)
end)

RegisterNUICallback("joinRace", function(data, cb)
    if not currentRace then
        TriggerServerEvent("races:joinRace", data.host)
    else 
        exports.globals:notify("You are already enrolled in a race!")
    end
    TriggerEvent("races:toggleMenu", false)
end)

Citizen.CreateThread(function()
    while true do
        if currentRace then
            local me = PlayerPedId()
            local mycoords = GetEntityCoords(me)
            print("curr stage: " .. currentRace.stage)
            if currentRace.stage == "joined" then -- driving towards start
                local startCoords = currentRace.info.start.coords
                local isAtStartCoords = Vdist(mycoords.x, mycoords.y, mycoords.z, startCoords.x, startCoords.y, startCoords.z) < 25
                if isAtStartCoords then 
                    exports.globals:notify("The race will start here in " .. GetMinutesUntilStartStr(currentRace))
                    currentRace.stage = "waiting"
                end
            elseif currentRace.stage == "waiting" then -- waiting for start of race
                local minutesUntilStart = GetMinutesUntilStart(currentRace, true)
                local secondsTillStart = minutesUntilStart * 60
                if secondsTillStart <= 10 then -- 10 seconds before start
                    local startCoords = currentRace.info.start.coords
                    local isAtStartCoords = Vdist(mycoords.x, mycoords.y, mycoords.z, startCoords.x, startCoords.y, startCoords.z) < 25
                    if not isAtStartCoords then 
                        exports.globals:notify("You have been disqualified from the race!", "^0You went too far from the start of the race and got DQ'd.")
                        TriggerServerEvent("races:removeParticipant", currentRace.host)
                        TriggerEvent("swayam:RemoveWayPoint")
                        currentRace = nil
                    else
                        -- set waypoint to finish
                        TriggerEvent("swayam:SetWayPointWithAutoDisable", currentRace.info.finish.coords.x, currentRace.info.finish.coords.y, currentRace.info.finish.coords.z, 280, 60, "Race Finish")
                        -- 10 seconds count down
                        TriggerEvent("chatMessage", "", {}, "Race starting in:")
                        local lastRecorded = math.floor(secondsTillStart)
                        while secondsTillStart <= 10 do
                            secondsTillStart = GetMinutesUntilStart(currentRace, true) * 60
                            -- display text
                            print(secondsTillStart .. " seconds until start!")
                            if math.floor(secondsTillStart) ~= lastRecorded then 
                                lastRecorded = math.floor(secondsTillStart)
                                TriggerEvent("chatMessage", "", {}, "^3" .. lastRecorded)
                            end
                            -- start race 
                            if minutesUntilStart <= 0 then 
                                currentRace.stage = "racing"
                                exports.globals:notify("Race ~g~started~w~!")
                            end
                            Wait(10)
                        end
                    end
                end
            end
        end
        Wait(5)
    end
end)

function GetMinutesUntilStartStr(race)
    local minsRegistered = (GetGameTimer() - race.info.registerTime) / 1000 / 60
    local minsUntilStart = math.floor(race.info.minutesUntilStart - minsRegistered)
    if minsUntilStart <= 0 then
        return "less than one minute!"
    else
        return minsUntilStart .. " minute(s)!"
    end
end

function GetMinutesUntilStart(race, float)
    local minsRegistered = (GetGameTimer() - race.info.registerTime) / 1000 / 60
    local minsUntilStart = -1
    if float then 
        minsUntilStart = race.info.minutesUntilStart - minsRegistered
    else
        minsUntilStart = math.floor(race.info.minutesUntilStart - minsRegistered)
    end
    if minsUntilStart <= 0 then
        return 0
    else
        return minsUntilStart
    end
end