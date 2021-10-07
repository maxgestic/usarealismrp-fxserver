RegisterNetEvent('DetectorAlarm')
AddEventHandler('DetectorAlarm', function(source, detector)
    local target = exports["usa-characters"]:GetCharacter(source)
    if target.hasWeapons() then
        TriggerClientEvent('DetectorAlarm', -1, detector)
    end
end)