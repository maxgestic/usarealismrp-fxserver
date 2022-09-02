exports('addItem', function(source, item, amount)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.giveItem(item, amount)
end)

exports('removeItem', function(source, item, amount)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.removeItem(item, amount)
end)

exports('getItemAmount', function(source)
    local char = exports["usa-characters"]:GetCharacter(source)
    return char.getItem(item).quantity
end)

exports('getItem', function(source, item)
    local char = exports["usa-characters"]:GetCharacter(source)
    return char.getItem(item)
end)

exports('getAccountMoney', function(source, type)
    local char = exports["usa-characters"]:GetCharacter(source)
    return char.get(type)
end)

exports('addAccountMoney', function(source, type, amount)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.set(type, char.get(type) + amount)
end)

exports('removeAccountMoney', function(source, type, amount)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.set(type, char.get(type) - amount)
    return true
end)

exports('setAccountMoney', function(source, type, amount)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.set(type, amount)
end)

exports('getRoleplayName', function(source)
    local char = exports["usa-characters"]:GetCharacter(source)
    return char.getName()
end)

exports('getIdentifier', function(source)
    local char = exports["usa-characters"]:GetCharacter(source)
    return char.get("_id")
end)

exports('hasPermission', function(source, permissionGroup)
    local user = exports.essentialmode:getPlayerFromId(source)
    local ugroup = user.getGroup()
    local allowed = {"mod", "admin", "superadmin", "owner"}
    for i = 1, #allowed do
        if allowed[i] == ugroup then
            return true
        end
    end
    return false
end)

exports('notification', function(source, message)
    TriggerClientEvent("usa:notify", source, message)
end)