-----------------------------------------------------------------------------------------------
--SCRIPT CREADO PARA EL SERVIDOR DE FIVEM DE PLATA O PLOMO COMUNIDAD GAMER.
--SCRIPT CREADO TOTALMENTE POR THEMAYKELLLL1 [ MIGUEL ANGEL LOPEZ REYES ].
--PLATA O PLOMO COMUNIDAD GAMER ACEPTA NO VENDER / REGALAR / PASAR ESTOS SCRIPTS A OTRAS PERSONAS O COMUNIDADES
--SIN PERMISOS DEL CREADOR DE EL SCRIPT.
-----------------------------------------------------------------------------------------------

RegisterServerEvent('pizzaJob:payForDelivery')
AddEventHandler('pizzaJob:payForDelivery',function(pay, property)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	--TriggerEvent('es:getPlayerFromId',source, function(user)
		user.setActiveCharacterData("money", user.getActiveCharacterData("money") + pay)
		print("payed $" .. pay .. " for pizza delivery!")
		if property then
			TriggerEvent("properties:addMoney", property.name, math.ceil(0.40 * pay))
		end
	--end)
end)
