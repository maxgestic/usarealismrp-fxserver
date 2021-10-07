function CreateDetector(detector)

    local detectorHash = GetHashKey('ch_prop_ch_metal_detector_01a')

    RequestModel(detectorHash)
    while not (HasModelLoaded(detectorHash)) do
        Wait(0)
    end

    local entityOld = GetClosestObjectOfType(detector.coords.x, detector.coords.y, detector.coords.z - 1.0, 10.0, detectorHash, false, false, false)
    while (entityOld == nil) do
        Wait(0)
    end

    if (entityOld ~= 0) then
        entityOld = DeleteObject()
        DebugPrint("^3DEBUG: ^0Deleted old detector " .. detector.info.id .. ".")
    end

    local entityNew = CreateObject(detectorHash, detector.coords.x, detector.coords.y, detector.coords.z - 1.0, false, false, false)
    while (entityNew == nil) do
        Wait(0)
    end
    
    if (entityNew ~= 0) then
        SetEntityHeading(entityNew, detector.entity.heading)
        SetEntityInvincible(entityNew, true)
        SetEntityCanBeDamaged(entityNew, false)
        SetEntityCollision(entityNew, true, false)
        FreezeEntityPosition(entityNew, true)
        DebugPrint("^3DEBUG: ^0Created new detector " .. detector.info.id .. ".")
    end

end

function DetectorScan(detector)

    if not (HasAccess(detector)) then
        TriggerServerEvent('DetectorAlarm', client.player.info.serverId, detector)
    end

end


function DetectorAlarm(detector)
    RequestScriptAudioBank('dlc_xm_iaa_player_facility_sounds', false)
    PlaySoundFromCoord(-1, 'scanner_alarm_os', detector.coords.x, detector.coords.y, detector.coords.z, 'dlc_xm_iaa_player_facility_sounds', false, detector.info.sound.range, false)
    DebugPrint("^3DEBUG: ^0Played alarm on detector " .. detector.info.id .. ".")
end

function DebugPrint(text)
    if (config.debug) then
        print(text)
    end
end