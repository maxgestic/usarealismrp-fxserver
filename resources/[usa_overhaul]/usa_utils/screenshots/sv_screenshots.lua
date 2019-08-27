local WEBHOOK_URL = "https://discordapp.com/api/webhooks/614221706164174851/XDdCHqiWBQyGwBQNpmtQvUkZjXn26fiP5w06lHv6p6bB9yq1fSyZCcUFKe538pmFJ4EE"

local record = {}
local MAX_FREE_TIER_SCREENSHOTS = 5

TriggerEvent('es:addCommand', 'screenshot', function(source, args, char)
    local ident = GetPlayerIdentifiers(source)[1]
    if record[ident] then 
        if record[ident] >= MAX_FREE_TIER_SCREENSHOTS then
            TriggerClientEvent("usa:notify", source, "You have reached the max number of screenshots for the FREE TIER.", "^0You have reached the max number of screenshots for the FREE TIER. Please upgrade to the PRO TIER for unlimited screenshots.")
            return
        end
    else 
        record[ident] = 0
    end    
    record[ident] = record[ident] + 1 -- TODO: test max free tier screenshots limit
    table.remove(args, 1)
    local caption = table.concat(args, " ")
    TriggerClientEvent("screenshots:takeForDiscord", source, caption)
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