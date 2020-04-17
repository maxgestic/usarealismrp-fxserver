local robbing = false
local canceled = false

local KEYS = {
    E = 38
}

local DISTANCE_FROM_PED = 7 -- 7 pos. from X, Y, or Z
local ROB_TIME = 10000 -- 7s
local CALL_DELAY = 7000 -- 7s

local previousPed = nil
local targetPed = nil

local emote = {
    dict = "random@mugging3",
    name = "handsup_standing_base"
}

local prohibitedWeapons = {}
prohibitedWeapons[`WEAPON_SNOWBALL`] = true

function ShowHelp(text, bleep)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, bleep, -1)
end

function canRobOtherPed(me, targetPed)
    -- valid other ped? --
    if not DoesEntityExist(targetPed) or not IsEntityAPed(targetPed) or IsPedInAnyVehicle(targetPed, true) or IsPedDeadOrDying(targetPed, true) or IsPedAPlayer(targetPed) then
        return false
    end
    
    -- is player robbing with a valid weapon? --
    local selectedPedWeapon = GetSelectedPedWeapon(me)
    if prohibitedWeapons[selectedPedWeapon] then
        return false
    else 
        return true
    end
end

Citizen.CreateThread(function()
    while true do
        ::top::
        if IsControlJustPressed(0, KEYS.E) and IsPedArmed(GetPlayerPed(-1), 7) then
            local me = PlayerPedId()
            local isInVeh = IsPedInAnyVehicle(me, true)
            aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
            if targetPed ~= previousPed and targetPed and not isInVeh then
                local mycoords = GetEntityCoords(me, true)
                local otherPedCoords = GetEntityCoords(targetPed, true)
                if canRobOtherPed(me, targetPed) and not robbing and isValidPedModel(targetPed) then
                    if GetDistanceBetweenCoords(mycoords.x, mycoords.y, mycoords.z, otherPedCoords.x, otherPedCoords.y, otherPedCoords.z, true) < DISTANCE_FROM_PED then
                        local fleeChance = math.random()
                        previousPed = targetPed
                        if fleeChance <= 0.15 then
                            TaskReactAndFleePed(targetPed, me)
                            goto top
                        end
                        ClearPedTasksImmediately(targetPed)
                        FreezeEntityPosition(targetPed, true)
                        robbing = true
                        local beginTime = GetGameTimer()
                        TaskPlayAnim(targetPed, emote.dict, emote.name, -8, 1, -1, 13, 0, 0, 0, 0)
                        while GetGameTimer() - beginTime < ROB_TIME and not canceled do
                            if not IsEntityPlayingAnim(targetPed, emote.dict, emote.name, 3) then
                                LoadAnimation()
                                TaskPlayAnim(targetPed, emote.dict, emote.name, -8, 1, -1, 13, 0, 0, 0, 0)
                            end
                            exports.globals:DrawTimerBar(beginTime, ROB_TIME, 1.42, 1.475, 'ROBBING')
                            Wait(0)
                        end
                        robbing = false
                        FreezeEntityPosition(targetPed, false)
                        StopAnimTask(targetPed, emote.dict, emote.name, 1.0)
                        ClearPedTasksImmediately(targetPed)
                        TaskSetBlockingOfNonTemporaryEvents(targetPed, false)
                        TaskReactAndFleePed(targetPed, me)
                        local x, y, z = table.unpack(mycoords)
                        local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
                        local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
                        TriggerServerEvent("911:MuggingNPC", x, y, z, lastStreetNAME)
                        if canceled then
                            canceled = false
                        else
                            TriggerServerEvent("Mugging:GiveReward")
                        end    
                    end
                end
            end
        end
        Wait(1)
    end
end)

function isValidPedModel(ped)
	return GetPedType(ped) ~= 28
end

-- make sure player holds E while robbing --
Citizen.CreateThread(function()
    while true do
        if robbing then
            if not IsControlPressed(0, KEYS.E) or not IsAimCamActive() then 
                canceled = true
            end
        end
        Wait(1)
    end
end)

function LoadAnimation()
    RequestAnimDict(emote.dict)
    while not HasAnimDictLoaded(emote.dict) do
        Wait(1)
    end
end