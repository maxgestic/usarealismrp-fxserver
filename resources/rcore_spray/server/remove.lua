if not Framework.STANDALONE then
    ESX.RegisterUsableItem("spray_remover", function(playerId)
        TriggerClientEvent('rcore_spray:removeClosestSpray', playerId)
    end)
end

RegisterNetEvent('rcore_spray:remove')
AddEventHandler('rcore_spray:remove', function(pos)
    local Source = source
    local c = exports["usa-characters"]:GetCharacter(Source)
    local paintRemoverItem = c.getItem("Paint Remover")
    if paintRemoverItem.remainingUses > 0 then
        c.modifyItemByUUID(paintRemoverItem.uuid, { remainingUses = paintRemoverItem.remainingUses - 1 })
        TriggerClientEvent("usa:notify", Source, "Remaining uses: " .. paintRemoverItem.remainingUses - 1)
    end
    RemoveSprayAtPosition(Source, pos)
end)