TriggerEvent('es:addCommand', 'setspikes', function(source, args, user)
    local s = tonumber(source)
    local amount = tonumber(args[2])

    if type(amount) == "number" then
        if amount <= SpikeConfig.MaxSpikes then
          print("triggering spawnSpikes spikestrip client command event")
            TriggerClientEvent("Spikestrips:SpawnSpikes", s, {
                isRestricted = SpikeConfig.PedRestriction,
                pedList = SpikeConfig.PedsList,
            }, amount)
        else
            print("You can not spawn that many spike strips")
        end
    end
end, {
	help = "Place spike strip(s).",
	params = {
		{ name = "length", help = "Length from 1 to 3." }
	}
})

TriggerEvent('es:addCommand', 'deletespikes', function(source, args, user)
    local s = tonumber(source)
    TriggerClientEvent("Spikestrips:RemoveSpikes", s)
end, {help = "Remove spikestrips."})

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
