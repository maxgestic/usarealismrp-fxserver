
    --local radioItem = { name = "Radio", price = 350, type = "misc", quantity = 1, legality = "legal", weight = 7, objectModel = "prop_cs_hand_radio", blockedInPrison = true}
--exports["usa_stores"]:AddGeneralStoreItem("Misc", radioItem)

local EARPIECE_JOBS = {
    sheriff = true,
    ems = true,
    corrections = true
}

RegisterServerEvent("rp-radio:checkForRadioItem")
AddEventHandler("rp-radio:checkForRadioItem", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local charJob = char.get("job")
    local civRadio = char.hasItem("Radio")
    local policeRadio = char.hasItem("Police Radio")
    local emsRadio = char.hasItem("EMS Radio")
    if policeRadio or emsRadio then
        TriggerClientEvent("Radio.Set", source, true, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13})
        if canJobUseEarpiece(charJob) then
            TriggerClientEvent("rp-radio:toggleEarpiece", source, true)
        end
    elseif civRadio then
        TriggerClientEvent("Radio.Set", source, true, {})
    else
        TriggerClientEvent("Radio.Set", source, false, {})
        TriggerClientEvent("usa:notify", source, "You have no radio!")
    end
end)

function canJobUseEarpiece(job)
    if EARPIECE_JOBS[job] then
        return true
    else
        return false
    end
end