AddEventHandler("rcore_lunapark_rollercoaster", function(src, price, cb)
    local char = exports["usa-characters"]:GetCharacter(src)
    if char.get("money") >= price then
        char.removeMoney(price)
        cb(true)
    else
        cb(false)
    end
end)

AddEventHandler("rcore_lunapark_freefall", function(src, price, cb)
    local char = exports["usa-characters"]:GetCharacter(src)
    if char.get("money") >= price then
        char.removeMoney(price)
        cb(true)
    else
        cb(false)
    end
end)

AddEventHandler("rcore_lunapark_ferriswheel", function(src, price, cb)
    local char = exports["usa-characters"]:GetCharacter(src)
    if char.get("money") >= price then
        char.removeMoney(price)
        cb(true)
    else
        cb(false)
    end
end)