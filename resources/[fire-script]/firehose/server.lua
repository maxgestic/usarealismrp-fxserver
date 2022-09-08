RegisterServerEvent('fhose:RequestPermissions')
AddEventHandler('fhose:RequestPermissions', function()
    TriggerClientEvent('fhose:RequestPermissions', source, IsJobWhitelisted(source))
end)

function IsJobWhitelisted(source)
	local job = exports["usa-characters"]:GetCharacterField(source, "job")
  	if job == "ems" or job == "fire" then
		return true
	end
    return false
end