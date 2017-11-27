--Settings--

enableprice = true -- true = carwash is paid, false = carwash is free

price = 100 -- you may edit this to your liking. if "enableprice = false" ignore this one

--DO-NOT-EDIT-BELLOW-THIS-LINE--

RegisterServerEvent('es_carwash:checkmoney')
AddEventHandler('es_carwash:checkmoney', function ()
	TriggerEvent('es:getPlayerFromId', source, function (user)
		if enableprice == true then
			userMoney = user.getActiveCharacterData("money")
			if userMoney >= price then
				user.setActiveCharacterData("money", userMoney - price)
				TriggerClientEvent('es_carwash:success', source, price)
			else
				moneyleft = price - userMoney
				TriggerClientEvent('es_carwash:notenoughmoney', source, moneyleft)
			end
		else
			TriggerClientEvent('es_carwash:free', source)
		end
	end)
end)
