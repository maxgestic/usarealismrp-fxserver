RegisterServerEvent('policelights:requestSpotlight')
AddEventHandler('policelights:requestSpotlight', function(netVeh, direction, r, g, b)
	TriggerClientEvent('policelights:setSpotlight', -1, netVeh, direction, r, g, b)
end)

RegisterServerEvent('policelights:requestHeadlightColor')
AddEventHandler('policelights:requestHeadlightColor', function(netVeh, value)
	TriggerClientEvent('policelights:setHeadlightColor', -1, netVeh, value)
end)

TriggerEvent('es:addJobCommand', 'uclights', {'sheriff', 'corrections'}, function(src, args, char)
	local job = char.get("job")
	if job == "sheriff" then -- SASP
		print("police rank: " .. char.get("policeRank"))
		if char.get("policeRank") >= 4 then
			TriggerClientEvent('policelights:enableLightsOnVehicle', src)
		else 
			TriggerClientEvent("usa:notify", src, "Must be rank 4+")
		end
	elseif job == "corrections" then -- BCSO
		exports.usa_prison:getBCSORank(src, function(rank)
			if rank then 
				if rank >= 6 then
					TriggerClientEvent('policelights:enableLightsOnVehicle', src)
				else
					TriggerClientEvent("usa:notify", src, "Must be rank 6+")
				end
			end
		end)
	end
end, {
	help = "Enable undercover lights on non-police vehicles",
})

