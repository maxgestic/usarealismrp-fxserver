local NEARBY_DISTANCE = 3.0

RegisterServerEvent('trading-cards:use')
AddEventHandler('trading-cards:use',function(card)
    -- gather list of IDs that need sending to (self + nearby people)
    local toSendList = {source}
    local sourceCoords = GetEntityCoords(GetPlayerPed(source))
    local players = GetPlayers()
    for i = 1, #players do
        if tonumber(players[i]) ~= source then
            local otherPlayerCoords = GetEntityCoords(GetPlayerPed(players[i]))
            if #(sourceCoords - otherPlayerCoords) < NEARBY_DISTANCE then
                table.insert(toSendList, players[i])
            end
        end
    end
    print("sending to num players: " .. #toSendList)
    -- send
    for i = 1, #toSendList do
        TriggerClientEvent("gl-cards:drawNui", toSendList[i], card.src)
    end
end)
