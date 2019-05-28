--# made by: minipunch
--# for: USA REALISM RP

local BARBER_FEE = 200

RegisterServerEvent("barber:checkout")
AddEventHandler("barber:checkout", function(customizations, property)
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("money") >= BARBER_FEE then
		char.removeMoney(BARBER_FEE)
		local appearance = char.get("appearance")
		appearance.head_customizations = customizations
		char.set("appearance", appearance)
		TriggerClientEvent("usa:notify", source, "~y~You paid: ~w~$" .. BARBER_FEE)
	else
		TriggerClientEvent("usa:notify", source, "You don't have enough money to pay the total: $" .. BARBER_FEE)
	end
end)

RegisterServerEvent("barber:getCustomizations")
AddEventHandler("barber:getCustomizations", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local appearance = char.get("appearance")
	TriggerClientEvent("barber:loadCustomizations", source, appearance.head_customizations, true)
end)
