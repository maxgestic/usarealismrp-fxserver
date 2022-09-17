RegisterServerEvent('usa_dumpsters:server:giveDumpsterReward')
AddEventHandler('usa_dumpsters:server:giveDumpsterReward', function(securityToken)
    if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), source, securityToken) then
        return false
    end

    local char = exports["usa-characters"]:GetCharacter(source)
    local randomItem = Config.DumpsterSearchItems[math.random(1, #Config.DumpsterSearchItems)]
    if math.random(0, 100) <= Config.FindItemChance then
        if char.canHoldItem(randomItem, 1) then
            char.giveItem(randomItem, 1)
            TriggerClientEvent('usa:notify', source, "You found " ..randomItem.name..".")
        else
            TriggerClientEvent('usa:notify', source, "Item dropped on ground!")
            randomItem.coords = GetEntityCoords(GetPlayerPed(source))
            TriggerEvent("interaction:addDroppedItem", randomItem)
        end
    else
        TriggerClientEvent('usa:notify', source, "You found nothing of interest")
    end
end)