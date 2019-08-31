local WEBHOOK_URL = "https://discordapp.com/api/webhooks/614221706164174851/XDdCHqiWBQyGwBQNpmtQvUkZjXn26fiP5w06lHv6p6bB9yq1fSyZCcUFKe538pmFJ4EE"

local record = {}
local MAX_FREE_TIER_SCREENSHOTS = 2

local UNLIMITED_SCREENSHOTS_SKU = 15

TriggerEvent('es:addCommand', 'screenshot', function(source, args, char)
    local usource = source
    Citizen.CreateThread(function()
        local hasLinkedFiveMAcct = CanPlayerStartCommerceSession(usource)
        if hasLinkedFiveMAcct and not IsPlayerCommerceInfoLoaded(usource) then
            LoadPlayerCommerceData(usource)
        end
        while hasLinkedFiveMAcct and not IsPlayerCommerceInfoLoaded(usource) do 
            Wait(100)
        end
        local ident = GetPlayerIdentifiers(usource)[1]
        if not record[ident] then 
            record[ident] = 1
        end
        if hasLinkedFiveMAcct then
            if record[ident] >= MAX_FREE_TIER_SCREENSHOTS and not DoesPlayerOwnSku(usource, UNLIMITED_SCREENSHOTS_SKU) then
                TriggerClientEvent("usa:notify", usource, "You have reached the max number of screenshots for the FREE TIER.", "^0You have reached the max number of screenshots for the FREE TIER. Type ^3/store^0 to upgrade for unlimited screenshots!")
                return
            end
        else 
            if record[ident] >= MAX_FREE_TIER_SCREENSHOTS then
                TriggerClientEvent("usa:notify", usource, "You have reached the max number of screenshots for the FREE TIER.", "^0You have reached the max number of screenshots for the FREE TIER. Type ^3/store^0 to upgrade for unlimited screenshots!")
                return
            end
        end
        record[ident] = record[ident] + 1 -- TODO: test max free tier screenshots limit
        table.remove(args, 1)
        local caption = table.concat(args, " ")
        TriggerClientEvent("screenshots:takeForDiscord", usource, caption)
    end)
end, {
    help = "Take a screen shot and automatically post it to #screenshots",
    params = {
        { name = "caption", help = "A caption for the photo." }
    }
})

RegisterServerEvent("screenshots:sendToDiscord")
AddEventHandler("screenshots:sendToDiscord", function(url, caption)
    local discordIdent = GetDiscordIdentifier(source)
    local char = exports["usa-characters"]:GetCharacter(source)
    local msg = url .. " "
    if caption ~= "" then 
        msg = msg .. caption .. " "
    end
    msg = msg .. "(Photo by " .. char.getName()
    if discordIdent then 
        msg = msg .. " AKA <@" .. discordIdent .. ">"
    end
    msg = msg .. ")"
    exports["globals"]:SendDiscordLog(WEBHOOK_URL, msg)
end)

function GetDiscordIdentifier(src)
    local idents = GetPlayerIdentifiers(src)
    for i = 1, #idents do 
        if idents[i]:find("discord") then 
            return idents[i]:sub(9)
        end
    end
    return nil
end