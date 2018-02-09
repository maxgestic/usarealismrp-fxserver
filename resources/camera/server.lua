TriggerEvent('es:addCommand', 'selfie', function(source, args, user)
	TriggerEvent("usa:getPlayerItem", source, "Cell Phone", function(phone)
			if phone then
				TriggerClientEvent("camera:selfie", source)
			else
				TriggerClientEvent("usa:notify", source, "You need a cell phone to do that!")
			end
		end)
end, {help = "Take a selfie!"})