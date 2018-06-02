TriggerEvent('es:addJobCommand', 'saw', { "ems", "fire", "police", "sheriff" }, function(source, args, user)
	print("/saw used!")
	local src = source
	TriggerClientEvent("Saw:ToggleSaw", src)
end, {
	help = "Use the saw of life"
})

RegisterServerEvent("Saw:SyncStartParticles")
AddEventHandler("Saw:SyncStartParticles", function(sawid)
    TriggerClientEvent("Saw:StartParticles", -1, sawid)
end)

RegisterServerEvent("Saw:SyncStopParticles")
AddEventHandler("Saw:SyncStopParticles", function(sawid)
    TriggerClientEvent("Saw:StopParticles", -1, sawid)
end)