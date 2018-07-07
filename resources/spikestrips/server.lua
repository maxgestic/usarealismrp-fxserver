TriggerEvent('es:addJobCommand', 'setspikes', {"sheriff", "corrections"}, function(source, args, user)
    local s = tonumber(source)
    local amount = tonumber(args[2])

    if type(amount) == "number" then
        if amount <= SpikeConfig.MaxSpikes then
          print("triggering spawnSpikes spikestrip client command event")
            TriggerClientEvent("Spikestrips:SpawnSpikes", s, {
                pedList = SpikeConfig.PedsList,
            }, amount)
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
    TriggerClientEvent("Spikestrips:RemoveSpikes", s)
end, {help = "Remove spikestrips."})
