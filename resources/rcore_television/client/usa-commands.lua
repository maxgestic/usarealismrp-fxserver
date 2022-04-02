RegisterNetEvent("tv:playlink")
AddEventHandler("tv:playlink", function(link)
    ExecuteCommand("playlink " .. link)
end)

RegisterNetEvent("tv:volume")
AddEventHandler("tv:volume", function(new)
    ExecuteCommand("tvvolume " .. new)
end)