local WEBHOOK_URL = "https://discordapp.com/api/webhooks/614221706164174851/XDdCHqiWBQyGwBQNpmtQvUkZjXn26fiP5w06lHv6p6bB9yq1fSyZCcUFKe538pmFJ4EE"

TriggerEvent('es:addCommand', 'screenshot', function(source, args, char)
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
    local char = exports["usa-characters"]:GetCharacter(source)
    local msg = url .. " "
    if caption ~= "" then 
        msg = msg .. caption .. " "
    end
    msg = msg .. "(Photo by ``" .. char.getName() .. "``)"
    exports["globals"]:SendDiscordLog(WEBHOOK_URL, msg)
end)