-----------------------------------------------------------------------------------------------
--SCRIPT CREADO PARA EL SERVIDOR DE FIVEM DE PLATA O PLOMO COMUNIDAD GAMER.
--SCRIPT CREADO TOTALMENTE POR THEMAYKELLLL1 [ MIGUEL ANGEL LOPEZ REYES ].
--PLATA O PLOMO COMUNIDAD GAMER ACEPTA NO VENDER / REGALAR / PASAR ESTOS SCRIPTS A OTRAS PERSONAS O COMUNIDADES
--SIN PERMISOS DEL CREADOR DE EL SCRIPT.
-----------------------------------------------------------------------------------------------

RegisterServerEvent('pop_pizzero:propina')
AddEventHandler('pop_pizzero:propina',function(pay, property)
	TriggerEvent('es:getPlayerFromId',source, function(user)
		user.setActiveCharacterData("money", user.getActiveCharacterData("money") + pay)
		print("payed $" .. pay .. " for pizza delivery!")
		if property then 
			TriggerEvent("properties:addMoney", property.name, round(0.20 * pay, 0))
		end
	end)
end)

function round(num, numDecimalPlaces)
	local mult = 5^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end