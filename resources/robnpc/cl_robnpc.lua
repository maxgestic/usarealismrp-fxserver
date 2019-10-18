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
                        TaskPlayAnim(targetPed, emote.dict, emote.name, -8, 1, -1, 16, 0, 0, 0, 0)
                        while GetGameTimer() - beginTime < ROB_TIME and not canceled do
                            if not IsEntityPlayingAnim(targetPed, emote.dict, emote.name, 3) then
                                LoadAnimation()
                                TaskPlayAnim(targetPed, emote.dict, emote.name, -8, 1, -1, 16, 0, 0, 0, 0)
                            end
                            DrawTimer(beginTime, ROB_TIME, 1.42, 1.475, 'ROBBING')
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

-- prevent fleeing --
Citizen.CreateThread(function()
    while true do
        if robbing and targetPed and DoesEntityExist(targetPed) then
            TaskSetBlockingOfNonTemporaryEvents(targetPed, true)  
        end
        Wait(1)
    end
end)

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

function DrawTimer(beginTime, duration, x, y, text)
    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars')
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    if GetTimeDifference(GetGameTimer(), beginTime) < duration then
        w = (GetTimeDifference(GetGameTimer(), beginTime) * (0.085 / duration))
    end

    local correction = ((1.0 - math.floor(GetSafeZoneSize(), 2)) * 100) * 0.005
    x, y = x - correction, y - correction

    Set_2dLayer(0)
    DrawSprite('timerbars', 'all_black_bg', x, y, 0.15, 0.0325, 0.0, 255, 255,
               255, 180)

    Set_2dLayer(1)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 100, 0, 0, 180)

    Set_2dLayer(2)
    DrawRect(x - 0.015 + (w / 2), y, w, 0.0125, 150, 0, 0, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    Set_2dLayer(3)
    DrawText(x - 0.06, y - 0.012)
end

function LoadAnimation()
    RequestAnimDict(emote.dict)
    while not HasAnimDictLoaded(emote.dict) do
        Wait(1)
    end
end

--[[ timer snippet by mini:

local WAIT_TIME_SECONDS = 10
local beginTime = GetGameTimer()
while GetGameTimer() - beginTime < WAIT_TIME_SECONDS * 1000 do
    -- something for 10 seconds
    Wait(0)
end

--[[

-- new stuff for snippets.

-- Check for this variable in other parts of your code
-- to determine if the button has been held down for +/- 1 second.
--[[local pressed = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
-- Create a timer variable
        local timer = 0
-- Loop as long as the control is held down.
        while IsControlPressed(0, 38) do
            Citizen.Wait(0)
-- Add 1 to the timer
            timer = timer + 1
-- If the timer is 60 or more, stop the loop (60 ticks/frames = +/- 1second)
            if timer = 600 then
                pressed = true -- or just call a function to be executed here
                break -- Stop the loop
            end
        end
-- Now wait until the button is released (to avoid running the timer above
-- again and again if the player keeps holding down the button)
-- Remove this while not loop if you don't want to wait for the user to
-- let go of the button before re-running the task again.
        while not IsControlJustReleased(0, 38) do
            Citizen.Wait(0)
        end
-- Reset the pressed variable (remove this if you call a function instead)
        pressed = false
    end
end)--]]
