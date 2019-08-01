RegisterServerEvent("bike:knockOff")
AddEventHandler("bike:knockOff", function(player, force, wasFall)
    TriggerClientEvent("bike:knockOff", player.id, force, wasFall)
end)