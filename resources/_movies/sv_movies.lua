local MOVIE_FEE = 70

RegisterServerEvent("movies:checkMoney")
AddEventHandler("movies:checkMoney", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local money = char.get("money")
    if money < MOVIE_FEE then
        TriggerClientEvent("usa:notify", source, "You need $" .. MOVIE_FEE .. " to watch a movie!")
        return
    end
    char.removeMoney(MOVIE_FEE)
    TriggerClientEvent("movies:enterTheatre", source)
end)