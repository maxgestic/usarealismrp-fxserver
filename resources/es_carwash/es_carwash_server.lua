--Settings--

enableprice = true -- true = carwash is paid, false = carwash is free

price = 50 -- you may edit this to your liking. if "enableprice = false" ignore this one

--DO-NOT-EDIT-BELLOW-THIS-LINE--

RegisterServerEvent('es_carwash:checkmoney')
AddEventHandler('es_carwash:checkmoney', function (property)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	--TriggerEvent('es:getPlayerFromId', source, function (user)
		if enableprice == true then
			userMoney = user.getActiveCharacterData("money")
			if userMoney >= price then
				user.setActiveCharacterData("money", userMoney - price)
				TriggerClientEvent('es_carwash:success', source, price)
				-- give money to gas station owner --
				if property then
                  TriggerEvent("properties:addMoney", property.name, round(0.30 * price, 0))
                end
			else
				moneyleft = price - userMoney
				TriggerClientEvent('es_carwash:notenoughmoney', source, moneyleft)
			end
		else
			TriggerClientEvent('es_carwash:free', source)
		end
	--end)
end)

function round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end
