-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'lock', function(source, args, user)

	print("CALLING LOCK:LOCKDOOR")

	TriggerClientEvent("lock:lockDoor", source)

end)