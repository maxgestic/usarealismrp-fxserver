exports('getPlayerChips', function(source)
    local char = exports["usa-characters"]:GetCharacter(source)
    return char.get("money")
end)

exports('givePlayerChips', function(source, amount)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.giveMoney(amount)
end)

exports('removePlayerChips', function(source, amount)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.removeMoney(amount)
end)

exports('getPlayerName', function(source)
    local char = exports["usa-characters"]:GetCharacter(source)
    return char.getName()
end)