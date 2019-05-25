local spikes = {}

TriggerEvent('es:addJobCommand', 'setspikes', {"sheriff", "corrections"}, function(source, args, user)
    local s = tonumber(source)
    local amount = tonumber(args[2])

    if type(amount) == "number" then
        if amount <= 3 then
          print("triggering spawnSpikes spikestrip client command event")
            TriggerClientEvent("stinger:spawnSpikes", s, amount)
        else
            print("You can not spawn that many spike strips")
        end
    end
end, {
	help = "Place spike strip(s).",
	params = {
		{ name = "length", help = "Length of spike strip from 1 to 3." }
	}
})

TriggerEvent('es:addJobCommand', 'deletespikes', {"sheriff", "corrections"}, function(source, args, user)
    local s = tonumber(source)
    TriggerClientEvent("stinger:deleteSpikes", s)
end, {help = "Remove spikestrips."})


RegisterServerEvent('stinger:spikesDeployed')
AddEventHandler('stinger:spikesDeployed', function(deployed)
    if not deployed then
        spikes[source] = nil
    else
        spikes[source] = true
    end

    for source, deployed in pairs(spikes) do
        if source and deployed then
            TriggerClientEvent('stinger:spikesDeployed', -1, true)
            return
        end
    end
    TriggerClientEvent('stinger:spikesDeployed', -1, false)
end)