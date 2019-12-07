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

local weapons = { "WEAPON_PISTOL", "WEAPON_KNIFE" }


local emote = {
    dict = "random@mugging3",
    name = "handsup_standing_base"
}

function ShowHelp(text, bleep)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, bleep, -1)
end

Citizen.CreateThread(function()
    while true do
        ::top::
        if IsControlJustPressed(0, KEYS.E) and IsPedArmed(GetPlayerPed(-1), 7) then
            aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
            if targetPed ~= previousPed and targetPed then
                local PID = GetPlayerPed(-1)
                local p = GetEntityCoords(PID, true)
                local t = GetEntityCoords(targetPed, true)
                local canContinue = DoesEntityExist(targetPed) and IsEntityAPed(targetPed) and not IsPedInAnyVehicle(targetPed, true) and not IsPedDeadOrDying(targetPed, true) and not IsPedAPlayer(targetPed)
                if canContinue and not robbing and isValidPedModel(targetPed) then
                    if GetDistanceBetweenCoords(p.x, p.y, p.z, t.x, t.y, t.z, true) < DISTANCE_FROM_PED then
                        local fleeChance = math.random()
                        --local attackChance = math.random()
                        previousPed = targetPed
                        if fleeChance <= 0.15 then
                            TaskReactAndFleePed(targetPed, PID)
                            goto top
                        end
                        --To come back to at a later date.  Fighting script.
                        --[[if attackChance >= 0.15 then
                            print("fighting")
                            SetPedFleeAttributes(targetPed, 46, true)
                            GiveWeaponToPed(targetPed, GetHashKey("WEAPON_KNIFE"), 1, false, true)
                            TaskCombatPed(targetPed, PID, 0, 16)
                            goto top
                        end--]]
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
                        TaskReactAndFleePed(targetPed, PID)
                        local playerPed = PlayerPedId()
                        local playerCoords = GetEntityCoords(playerPed)
                        local x, y, z = table.unpack(playerCoords)
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
            if not IsControlPressed(0, KEYS.E) then 
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