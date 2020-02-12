local Channels = {
    {id = 1, name = "OFF"},
    {id = 2, name = "DISPATCH"},
    {id = 3, name = "EMS"},
    {id = 4, name = "TAC 1"},
    {id = 5, name = "TAC 2"},
    {id = 6, name = "TAC 3"},
    {id = 7, name = "TAC 4"},
    {id = 8, name = "TAC 5"},
    {id = 9, name = "TAC 6"},
    {id = 10, name = "Tow Freq."},
    {id = 11, name = "CB CH. 1"},
    {id = 12, name = "CORRECTIONS"},
    {id = 13, name = "ATC"}
    --{id = 7, name = "CB CH. 2"},
    --{id = 8, name = "CB CH. 3"}
}

local Permissions = {
    ["sheriff"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
    ["corrections"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13},
    ["ems"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 , 12, 13},
    ["mechanic"] = { 1, 10, 11 },
    ["civ"] = { 1, 11 },
    ["doctor"] = { 1, 2, 3, 11 },
    ["pilot"] = { 1, 13}
}

local CAN_CIVS_USE = false

--local radioItem = { name = "Radio", price = 350, type = "misc", quantity = 1, legality = "legal", weight = 7, objectModel = "prop_cs_hand_radio", blockedInPrison = true}
--exports["usa_stores"]:AddGeneralStoreItem("Misc", radioItem)

RegisterServerEvent("radio:accessCheck")
AddEventHandler("radio:accessCheck", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local cjob = char.get("job")
    if not CAN_CIVS_USE and cjob == "civ" then
        TriggerClientEvent("usa:notify", source, "Only for public servants")
        return
    end
    local permittedChannels = GetPermittedChannelsForJob(cjob)
    TriggerClientEvent("radio:toggle", source, permittedChannels)
end)

function GetPermittedChannelsForJob(job)
    local chans = {}
    local allowedFreqs = {}
    if not Permissions[job] then 
        allowedFreqs = { 1, 6} -- default civ freqs
    else
        allowedFreqs = Permissions[job]
    end
    for i = 1, #allowedFreqs do
        local chanToInsert = Channels[allowedFreqs[i]]
        table.insert(chans, chanToInsert)
    end
    return chans
end