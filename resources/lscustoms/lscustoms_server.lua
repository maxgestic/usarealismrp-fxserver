local tbl = {
[1] = {locked = false},
[2] = {locked = false},
[3] = {locked = false},
[4] = {locked = false},
[5] = {locked = false},
[6] = {locked = false}
}
RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(b,garage)
	tbl[tonumber(garage)].locked = b
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)
RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
TriggerClientEvent('lockGarage',-1,tbl)
--print(json.encode(tbl))
end)

-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'unlockgarage', function(source, args, user)

	local userGroup = user.getGroup()

	if userGroup == "owner" or userGroup == "admin" or userGroup == "mod" then
		TriggerClientEvent("lsCustoms:garageUnlock", -1) -- unlock everyone's ls customs
		TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^2LS Customs has been unlocked, my niqqa!")
	else
		print("non admin/mod tried to unlock ls customs...")
	end

end)
