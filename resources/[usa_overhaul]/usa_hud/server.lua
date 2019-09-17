RegisterServerEvent('hud:getBelt')
AddEventHandler('hud:getBelt', function(bool)
	TriggerClientEvent('hud:setBelt', source, bool)
end)

TriggerEvent('es:addCommand','wallet', function(source, args, char)
	TriggerEvent('display:shareDisplayBySource', source, 'counts cash', 2, 370, 10, 3000, true)
	Citizen.Wait(200)
	TriggerClientEvent("es:setMoneyDisplay", source, 1, char.get("money"))
	Citizen.Wait(3000)
	TriggerClientEvent("es:setMoneyDisplay", source, 0)
end, {
	help = "Count the money in your wallet."
})

TriggerEvent('es:addCommand','cash', function(source, args, char)
	TriggerEvent('display:shareDisplayBySource', source, 'counts cash', 2, 370, 10, 3000, true)
	Citizen.Wait(200)
	local amount = char.get("money")
	if amount == 0 then amount = "0" end
	TriggerClientEvent("es:setMoneyDisplay", source, 1, amount)
	Citizen.Wait(3000)
	TriggerClientEvent("es:setMoneyDisplay", source, 0)
end, {
	help = "Count the money in your wallet."
})
