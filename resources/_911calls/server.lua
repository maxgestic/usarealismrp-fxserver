RegisterServerEvent('911:ShotsFired')
RegisterServerEvent('911:AttemptedVehicleTheft')
RegisterServerEvent('911:Carjacking')
RegisterServerEvent('911:PersonWithAGun')
RegisterServerEvent('911:PersonWithAKnife')
RegisterServerEvent('911:AssaultInProgress')
RegisterServerEvent('911:RecklessDriving')
RegisterServerEvent('911:VehicleTheft')
RegisterServerEvent('911:MVA')
RegisterServerEvent('911:ArmedCarjacking')
RegisterServerEvent('911:Narcotics')

recentcalls = {}

AddEventHandler('911:ShotsFired', function(x, y, z, street, isMale)
	if recentcalls[street] ~= 'ShotsFired' then
		recentcalls[street] = 'ShotsFired'
		local time = math.random(2000, 5000)
		Citizen.Wait(time)
		local string = 'Shots Fired: '..street..' ^*^1^*|^r^r Suspect: '..Gender(isMale) 
		Send911Notification('sheriff', string, x, y, z, 'Shots Fired')
		Citizen.Wait(30000)
		recentcalls[street] = 'nil'
	end
end)

AddEventHandler('911:AttemptedVehicleTheft', function(x, y, z, street, vehicle, plate, isMale, primaryColor, secondaryColor)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local inv = user.getActiveCharacterData("inventory")
	for i = 1, #inv do
	    local item = inv[i]
        if item and string.find(item.name, "Key") and item.plate then
            if not string.find(plate, item.plate) and recentcalls[street] ~= 'AttemptedVehicleTheft' then
				recentcalls[street] = 'AttemptedVehicleTheft'
				local time = math.random(3000, 7000)
				Citizen.Wait(time)
				local string = 'Attmpt. Vehicle Theft: '..street..' ^1^*|^r Vehicle: '..string.upper(vehicle)..' ^1^*|^r Plate: '..plate..' ^1^*|^r Color: '..secondaryColor..' on '..primaryColor.. ' ^1^*|^r Suspect: '..Gender(isMale)
				Send911Notification('sheriff', string, x, y, z, 'Attmpt. Vehicle Theft')
				Citizen.Wait(20000)
				recentcalls[street] = 'nil'
				break
			end
		end
	end
end)

AddEventHandler('911:Carjacking', function(x, y, z, street, vehicle, plate, isMale, primaryColor, secondaryColor)
	if recentcalls[street] ~= 'Carjacking' then
		recentcalls[street] = 'Carjacking'
		local time = math.random(1000, 6000)
		Citizen.Wait(time)
		local string = 'Carjacking: '..street..' ^1^*|^r Vehicle: '..string.upper(vehicle)..' ^1^*|^r Plate: '..plate..' ^1^*|^r Color: '..secondaryColor..' on '..primaryColor.. ' ^1^*|^r Suspect: '..Gender(isMale)
		Send911Notification('sheriff', string, x, y, z, 'Carjacking')
		Citizen.Wait(5000)
		recentcalls[street] = 'nil'
	end
end)

AddEventHandler('911:PersonWithAGun', function(x, y, z, street, area, isMale)
	if recentcalls[area] ~= 'PersonWithAGun' and recentcalls[street] ~= 'ShotsFired' and recentcalls[street] ~= 'ArmedCarjacking' then
		recentcalls[area] = 'PersonWithAGun'
		local time = math.random(2500, 8000)
		Citizen.Wait(time)
		local string = 'Person with Gun: '..street..' ^1^*|^r Suspect: '..Gender(isMale)
		Send911Notification('sheriff', string, x, y, z, 'Person with a Gun')
		recentcalls[street] = 'PersonWithAGun'
		Citizen.Wait(180000)
		recentcalls[area] = 'nil'
	end
end)

AddEventHandler('911:PersonWithAKnife', function(x, y, z, street, isMale)
	if recentcalls[street] ~= 'PersonWithAKnife' and recentcalls[street] ~= 'AssaultInProgress' then
		recentcalls[street] = 'PersonWithAKnife'
		local time = math.random(2500, 8000)
		Citizen.Wait(time)
		local string = 'Person with Knife: '..street..' ^1^*|^r Suspect: '..Gender(isMale)
		Send911Notification('sheriff', string, x, y, z, 'Person with a Knife')
		Citizen.Wait(120000)
		recentcalls[street] = 'nil'
	end
end)

AddEventHandler('911:AssaultInProgress', function(x, y, z, street, isMale)
	if recentcalls[street] ~= 'AssaultInProgress' then
		recentcalls[street] = 'AssaultInProgress'
		local time = math.random(4000, 9000)
		Citizen.Wait(time)
		local string = 'Assault: '..street..' ^1^*|^r Suspect: '..Gender(isMale)
		Send911Notification('sheriff', string, x, y, z, 'Assault')
		Citizen.Wait(30000)
		recentcalls[street] = 'nil'
	end
end)

AddEventHandler('911:RecklessDriving', function(x, y, z, street, area, vehicle, plate, primaryColor, secondaryColor)
	if recentcalls[area] ~= 'RecklessDriving' then
		recentcalls[area] = 'RecklessDriving'
		local time = math.random(1000, 3500)
		Citizen.Wait(time)
		local string = 'Reckless Driving: '..street..' ^1^*|^r Vehicle: '..string.upper(vehicle)..' ^1^*|^r Plate: '..plate..' ^1^*|^r Color: '..secondaryColor..' on '..primaryColor.. ' ^1^*|^r Suspect: '..Gender(isMale)
		Send911Notification('sheriff', string, x, y, z, 'Reckless Driving')
		Citizen.Wait(45000)
		recentcalls[area] = 'nil'
	end
end)	

AddEventHandler('911:VehicleTheft', function(x, y, z, street, vehicle, plate, isMale, primaryColor, secondaryColor)
	if recentcalls[street] ~= 'VehicleTheft' then
		recentcalls[street] = 'VehicleTheft'
		local time = math.random(1000, 5000)
		Citizen.Wait(time)
		local string = 'Vehicle Theft: '..street..' ^1^*|^r Vehicle: '..string.upper(vehicle)..' ^1^*|^r Plate: '..plate..' ^1^*|^r Color: '..secondaryColor..' on '..primaryColor.. ' ^1^*|^r Suspect: '..Gender(isMale)
		Send911Notification('sheriff', string, x, y, z, 'Vehicle Theft')
		Citizen.Wait(5000)
		recentcalls[street] = 'nil'
	end
end)

AddEventHandler('911:MVA', function(x, y, z, street, area, vehicle, plate, isMale, primaryColor, secondaryColor)
	if recentcalls[area] ~= 'MVA' then
		recentcalls[area] = 'MVA'
		local time = math.random(2000, 5000)
		Citizen.Wait(time)
		local string = 'MVA: '..street..' ^1^*|^r Vehicle: '..string.upper(vehicle)..' ^1^*|^r Plate: '..plate..' ^1^*|^r Color: '..secondaryColor..' on '..primaryColor.. ' ^1^*|^r Suspect: '..Gender(isMale)
		Send911Notification(false, string, x, y, z, 'Motor Vehicle Accident')
		Citizen.Wait(30000)
		recentcalls[area] = 'nil'
	end
end)

AddEventHandler('911:ArmedCarjacking', function(x, y, z, street, vehicle, plate, isMale, primaryColor, secondaryColor)
	if recentcalls[street] ~= 'ArmedCarjacking' then
		recentcalls[street] = 'ArmedCarjacking'
		local time = math.random(1000, 3000)
		Citizen.Wait(time)
		local string = 'Armed Carjacking: '..street..' ^1^*|^r Vehicle: '..string.upper(vehicle)..' ^1^*|^r Plate: '..plate..' ^1^*|^r Color: '..secondaryColor..' on '..primaryColor.. ' ^1^*|^r Suspect: '..Gender(isMale)
		Send911Notification('sheriff', string, x, y, z, 'Armed Carjacking')
		Citizen.Wait(5000)
		recentcalls[street] = 'nil'
	end
end)

AddEventHandler('911:Narcotics', function(x, y, z, street, isMale)
	if recentcalls[street] ~= 'Narcotics' then
		recentcalls[street] = 'Narcotics'
		local time = math.random(4000, 10000)
		Citizen.Wait(time)
		local string = 'Sale of Narcotics: '..street..' ^1^*|^r Suspect: '..Gender(isMale)
		Send911Notification('sheriff', string, x, y, z, 'Narcotics')
		Citizen.Wait(50000)
		recentcalls[street] = nil
	end
end)

RegisterServerEvent('carjack:playHandsUpOnAll')
AddEventHandler('carjack:playHandsUpOnAll', function(pedToPlay)
	TriggerClientEvent('carjack:playAnimOnPed', -1, pedToPlay)
end)

function Send911Notification(intendedEmergencyType, string, x, y, z, blipText)
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			local player_job = player.getActiveCharacterData("job")
			if intendedEmergencyType then
				if player_job == intendedEmergencyType then
					TriggerClientEvent('911:Notification', playerSource, string, x, y, z, blipText)
				end
			elseif player_job == "sheriff" or player_job == "ems" or player_job == "fire" then
				TriggerClientEvent('911:Notification', playerSource, string, x, y, z, blipText)
			end
		end
	end)
end

function Gender(isMale)
	isSuspectIdentified = math.random(1, 4)
	if isSuspectIdentified > 1 then
		if isMale then
			return 'MALE'
		else
			return 'FEMALE'
		end
	else
		return 'UNKNOWN'
	end
end

TriggerEvent('es:addJobCommand', 'mark911', { "police", "sheriff", "ems", "fire"}, function(source, args, user)
	local userSource = tonumber(source)
	TriggerClientEvent('911:mark911', userSource)
end, {
	help = "Mark the latest 911 call as your waypoint"})

TriggerEvent('es:addJobCommand', 'clear911', { "police", "sheriff", "ems", "fire"}, function(source, args, user)
	local userSource = tonumber(source)
	TriggerClientEvent('911:clear911', userSource)
end, {
	help = "Clear all your 911 calls on the map"})

TriggerEvent('es:addJobCommand', 'mute911', { "police", "sheriff", "ems", "fire"}, function(source, args, user)
	local userSource = tonumber(source)
	TriggerClientEvent('911:mute911', userSource)
end, {
	help = "Temporarily toggle receiving 911 calls"})