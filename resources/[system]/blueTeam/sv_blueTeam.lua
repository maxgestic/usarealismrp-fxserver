AddEventHandler("scrambler:injectionDetected", function(name, source, isServerEvent)

	local eventType = 'client'

	if isServerEvent then
	eventType = 'server'
	end

	print('Player id [' .. source .. '] attempted to use ' .. eventType .. ' event [' .. name .. ']')

end)
