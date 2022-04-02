TriggerEvent('es:addCommand', 'playlink', function(source, args, char, location)
    local link = args[2]
    TriggerClientEvent("tv:playlink", source, link)
end, {
    help = "Play link on nearby TV",
    params = {
        { name = "link", help = "A YT or Twitch link to play" }
    }
})

TriggerEvent('es:addCommand', 'tvvolume', function(source, args, char, location)
    local new = args[2]
    TriggerClientEvent("tv:volume", source, new)
end, {
    help = "Adjust volume on a nearby TV (0 - 100)",
    params = {
        { name = "new", help = "New volume for speaker (0 - 100)" }
    }
})