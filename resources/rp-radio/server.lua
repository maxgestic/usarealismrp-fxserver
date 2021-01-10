
--local radioItem = { name = "Radio", price = 350, type = "misc", quantity = 1, legality = "legal", weight = 7, objectModel = "prop_cs_hand_radio", blockedInPrison = true}
--exports["usa_stores"]:AddGeneralStoreItem("Misc", radioItem)

local EMERGENCY_JOBS = {
    sheriff = true,
    ems = true,
    corrections = true,
    doctor = true
}

RegisterServerEvent("rp-radio:checkForRadioItem")
AddEventHandler("rp-radio:checkForRadioItem", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local charJob = char.get("job")
    local hasAnyRadio = char.hasItem("Radio")
    if hasAnyRadio then
        if EMERGENCY_JOBS[charJob] then
            TriggerClientEvent("Radio.Set", source, true, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13})
            TriggerClientEvent("rp-radio:toggleEarpiece", source, true)
        else
            TriggerClientEvent("Radio.Set", source, true, {})
            TriggerClientEvent("rp-radio:toggleEarpiece", source, false)
        end
    else 
        TriggerClientEvent("Radio.Set", source, false, {})
        TriggerClientEvent("usa:notify", source, "You have no radio!")
    end
end)