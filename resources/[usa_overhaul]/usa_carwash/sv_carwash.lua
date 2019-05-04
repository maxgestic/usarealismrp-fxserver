CARWASH_PRICE = 50


RegisterServerEvent('carwash:checkmoney')
AddEventHandler('carwash:checkmoney', function()
	local playerSource = source
	local user = exports["essentialmode"]:getPlayerFromId(playerSource)
	local userMoney = user.getActiveCharacterData("money")
	if userMoney >= CARWASH_PRICE then
		user.setActiveCharacterData("money", userMoney - CARWASH_PRICE)
		TriggerClientEvent('carwash:success', playerSource)
	else
		TriggerClientEvent('usa:notify', playerSource, '~y~You cannot afford this purchase.')
	end
end)