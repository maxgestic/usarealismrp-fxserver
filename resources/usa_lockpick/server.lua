RegisterServerEvent('lockpick:removeBrokenPick')
AddEventHandler('lockpick:removeBrokenPick', function(item)
	local char = exports["usa-characters"]:GetCharacter(source)
	if math.random() > 0.85 then
		char.removeItem(item, 1)
		TriggerClientEvent('usa:notify', source, 'Your lockpick broke!')
	else
		TriggerClientEvent('usa:notify', source, 'Your lockpick took minor damage!')
	end
	TriggerClientEvent('lockpick:closehtml', source)
end)