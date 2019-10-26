local GOLF_FEE = 100

RegisterServerEvent("golf:checkMoney")
AddEventHandler("golf:checkMoney", function()
    print("inside golf:checkmoney")
    local char = exports["usa-characters"]:GetCharacter(source)
    local money = char.get("money")
    if money < GOLF_FEE then
        TriggerClientEvent("usa:notify", source, "You need $100 to golf!")
        return
    end
    char.removeMoney(GOLF_FEE)
    TriggerClientEvent("beginGolf", source)
end)