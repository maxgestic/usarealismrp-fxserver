TriggerEvent('es:addCommand', 'info', function(source, args, char)
	TriggerClientEvent('info:open', source)
end, { help = "Rules & Server Information" })

RegisterServerEvent("info:acceptedRulesCheck")
AddEventHandler("info:acceptedRulesCheck", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if not char.get("hasAcceptedRules") then
		TriggerClientEvent('info:open', char.get("source"))
	end
end)

RegisterServerEvent("info:acceptedRulesConfirm")
AddEventHandler("info:acceptedRulesConfirm", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	char.set("hasAcceptedRules", true)
end)

-- todo: add list of hints with waypoints on how to get started with all legal jobs here...