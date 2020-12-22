BASE_CHECKIN_PRICE = 25 -- must be kept the same with one in cl_injury under check-in section

injuries = { -- ensure this is the same as sv_injury.lua
    [2725352035] = {type = 'blunt', bleed = 3600, string = 'Fists', treatableWithBandage = true, treatmentPrice = 50, dropEvidence = 0.5}, -- WEAPON_UNARMED
    [4194021054] = {type = 'laceration', bleed = 1500, string = 'Animal Attack', treatableWithBandage = true, treatmentPrice = 80, dropEvidence = 0.9}, -- WEAPON_ANIMAL
    [148160082] = {type = 'laceration', bleed = 900, string = 'Animal Attack', treatableWithBandage = false, treatmentPrice = 90, dropEvidence = 0.9}, -- WEAPON_COUGAR
    [2578778090] = {type = 'laceration', bleed = 480, string = 'Knife Puncture', treatableWithBandage = false, treatmentPrice = 90, dropEvidence = 1.0}, -- WEAPON_KNIFE
    [1737195953] = {type = 'blunt', bleed = 2400, string = 'Blunt Object', treatableWithBandage = true, treatmentPrice = 30, dropEvidence = 0.8}, -- WEAPON_NIGHTSTICK
    [1317494643] = {type = 'blunt', bleed = 1200, string = 'Concentrated Blunt Object', treatableWithBandage = true, treatmentPrice = 30, dropEvidence = 0.9}, -- WEAPON_HAMMER
    [2508868239] = {type = 'blunt', bleed = 900, string = 'Large Blunt Object', treatableWithBandage = false, treatmentPrice = 70, dropEvidence = 0.9}, -- WEAPON_BAT
    [1141786504] = {type = 'blunt', bleed = 1200, string = 'Large Blunt Object', treatableWithBandage = false, treatmentPrice = 10, dropEvidence = 0.6}, -- WEAPON_GOLFCLUB
    [2227010557] = {type = 'blunt', bleed = 900, string = 'Blunt Object', treatableWithBandage = false, treatmentPrice = 45, dropEvidence = 0.8}, -- WEAPON_CROWBAR
    [453432689] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 110, dropEvidence = 1.0}, -- WEAPON_PISTOL
    [1593441988] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 110, dropEvidence = 1.0}, -- WEAPON_COMBATPISTOL
    [2578377531] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 110, dropEvidence = 1.0}, -- WEAPON_PISTOL50
    [736523883] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 200}, dropEvidence = 1.0, -- WEAPON_SMG
    [2210333304] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 250, dropEvidence = 1.0}, -- WEAPON_CARBINERIFLE
    [487013001] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 150, dropEvidence = 1.0}, -- WEAPON_PUMPSHOTGUN
    [2640438543] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 150, dropEvidence = 1.0}, -- WEAPON_BULLPUPSHOTGUN
    [911657153] = {type = 'penetrating', bleed = 3600, string = 'Prongs', treatableWithBandage = true, treatmentPrice = 25, dropEvidence = 0.0}, -- WEAPON_STUNGUN
    [100416529] = {type = 'penetrating', bleed = 120, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 250, dropEvidence = 1.0}, -- WEAPON_SNIPERRIFLE
    [856002082] = {type = 'penetrating', bleed = 120, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 250, dropEvidence = 1.0}, -- WEAPON_REMOTESNIPER
    [2481070269] = {type = 'penetrating', bleed = 120, string = 'Shrapnel Wound', treatableWithBandage = false, treatmentPrice = 150, dropEvidence = 1.0}, -- WEAPON_GRENADE
    [615608432] = {type = 'burn', bleed = 600, string = 'Molotov Residue', treatableWithBandage = false, treatmentPrice = 80, dropEvidence = 1.0}, -- WEAPON_MOLOTOV
    [883325847] = {type = 'burn', beed = 600, string = 'Gasoline Residue', treatableWithBandage = false, treatmentPrice = 90, dropEvidence = 1.0}, -- WEAPON_PETROLCAN
    [1233104067] = {type = 'burn', bleed = 1800, string = 'Concentrated Heat', treatableWithBandage = true, treatmentPrice = 65, dropEvidence = 0.7}, -- WEAPON_FLARE
    [539292904] = {type = 'burn', bleed = 120, string = 'Explosion', treatableWithBandage = false, treatmentPrice = 90, dropEvidence = 1.0}, -- WEAPON_EXPLOSION
    [3452007600] = {type = 'blunt', bleed = 2700, string = 'Fall', treatableWithBandage = true, treatmentPrice = 30, dropEvidence = 0.2}, -- WEAPON_FALL
    [133987706] = {type = 'blunt', bleed = 1800, string = 'Vehicle Accident', treatableWithBandage = true, treatmentPrice = 50, dropEvidence = 0.0}, -- WEAPON_RAMMED_BY_CAR
    [2741846334] = {type = 'blunt', bleed = 1500, string = 'Vehicle Accident', treatableWithBandage = true, treatmentPrice = 50, dropEvidence = 0.4}, -- WEAPON_RUN_OVER_BY_CAR
    [3750660587] = {type = 'burn', bleed = 600, string = 'Fire', treatableWithBandage = false, treatmentPrice = 50, dropEvidence = 1.0}, -- WEAPON_FIRE
    [3218215474] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 110, dropEvidence = 1.0}, -- WEAPON_SNSPISTOL
    [4192643659] = {type = 'laceration', bleed = 600, string = 'Sharp Glass', treatableWithBandage = false, treatmentPrice = 40, dropEvidence = 1.0}, -- WEAPON_BOTTLE
    [3523564046] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 110, dropEvidence = 1.0}, -- WEAPON_HEAVYPISTOL
    [2460120199] = {type = 'laceration', bleed = 480, string = 'Knife Puncture', treatableWithBandage = false, treatmentPrice = 90, dropEvidence = 1.0}, -- WEAPON_DAGGER
    [137902532] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 110, dropEvidence = 1.0}, -- WEAPON_VINTAGEPISTOL
    [2828843422] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 110, dropEvidence = 1.0}, -- WEAPON_MUSKET
    [3342088282] = {type = 'penetrating', bleed = 240, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 250, dropEvidence = 1.0}, -- WEAPON_MARKSMANRIFLE
    [1198879012] = {type = 'burn', bleed = 1200, string = 'Concentrated Heat', treatableWithBandage = true, treatmentPrice = 80, dropEvidence = 1.0}, -- WEAPON_FLAREGUN
    [3696079510] = {type = 'penetrating', bleed = 120, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 250, dropEvidence = 1.0}, -- WEAPON_MARKSMANPISTOL
    [3638508604] = {type = 'blunt', bleed = 1200, string = 'Blunt Object', treatableWithBandage = true, treatmentPrice = 70, dropEvidence = 1.0}, -- WEAPON_KNUCKLE
    [4191993645] = {type = 'laceration', bleed = 360, string = 'Large Sharp Object', treatableWithBandage = false, treatmentPrice = 110, dropEvidence = 1.0}, -- WEAPON_HATCHET
    [3713923289] = {type = 'laceration', bleed = 360, string = 'Large Sharp Object', treatableWithBandage = false, treatmentPrice = 110, dropEvidence = 1.0}, -- WEAPON_MACHETE
    [3756226112] = {type = 'laceration', bleed = 480, string = 'Knife Puncture', treatableWithBandage = false, treatmentPrice = 70, dropEvidence = 1.0}, -- WEAPON_SWITCHBLADE
    [3249783761] = {type = 'penetrating', bleed = 120, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 150, dropEvidence = 1.0}, -- WEAPON_REVOLVER
    [3441901897] = {type = 'laceration', bleed = 240, string = 'Large Sharp Object', treatableWithBandage = false, treatmentPrice = 110, dropEvidence = 1.0}, -- WEAPON_BATTLEAXE
    [2484171525] = {type = 'blunt', bleed = 1800, string = 'Large Blunt Object', treatableWithBandage = false, treatmentPrice = 65, dropEvidence = 1.0}, -- WEAPON_POOLCUE
    [419712736] = {type = 'blunt', bleed = 900, string = 'Concentrated Blunt Object', treatableWithBandage = false, treatmentPrice = 80, dropEvidence = 1.0}, -- WEAPON_WRENCH
    [2343591895] = {type = 'blunt', bleed = 2700, string = 'Blunt Object', treatableWithBandage = true, treatmentPrice = 40, dropEvidence = 0.6}, -- WEAPON_FLASHLIGHT
    [3219281620] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 150, dropEvidence = 1.0}, -- WEAPON_PISTOL_MK2
    [4208062921] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 80, dropEvidence = 1.0}, -- WEAPON_CARBINERIFLE_MK2
	[1432025498] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 80, dropEvidence = 1.0}, -- WEAPON_PUMPSHOTGUN_MK2
	[GetHashKey("WEAPON_COMPACTRIFLE")] = {type = 'penetrating', bleed = 300, string = 'High-speed Projectile', treatableWithBandage = false, treatmentPrice = 80, dropEvidence = 1.0}
}

local WEBHOOK_URL = "https://discordapp.com/api/webhooks/618096654842593281/tz9hG-cD-2EqzMLr-4Z3KdRG1XHQyS8OhVLMWQLCIT6ebz6SGI6-iM0qgj-wXf8FBXBx"

TriggerEvent('es:addCommand', 'injuries' , function(source, args, char)
	TriggerClientEvent("injuries:showMyInjuries", source)
end, {
	help = "Inspect the nearest player's injuries or your own injuries"
})

TriggerEvent('es:addJobCommand', 'inspect', { "ems", "sheriff", "corrections", "doctor"}, function(source, args, char)
	local _source = source
	local targetSource = tonumber(args[2])
	if targetSource and GetPlayerName(targetSource) then
		TriggerEvent('injuries:getPlayerInjuries', targetSource, _source)
	else
		TriggerClientEvent("injuries:inspectNearestPed", _source, _source)
	end
end, {
	help = "Inspect the nearest player's injuries",
	params = {
		{ name = "id", help = "id of person (omit to treat nearest)" }
	}
})

TriggerEvent('es:addJobCommand', 'treat', {"doctor"}, function(source, args, char)
	local _source = source
	table.remove(args,1)
   	local boneToTreat = table.concat(args, " ")
	TriggerClientEvent("injuries:treatNearestPed", _source, boneToTreat)
end, {
	help = "Treat the nearest player's injuries",
	params = {
		{ name = "bone", help = "bone to treat" }
	}
})

TriggerEvent('es:addJobCommand', 'bandage', {'ems', 'doctor', 'sheriff', 'corrections'}, function(source, args, char)
	local _source = source
	local targetSource = tonumber(args[2])
	if targetSource and GetPlayerName(targetSource) then
		TriggerEvent('injuries:bandagePlayer', targetSource)
		TriggerClientEvent('usa:notify', _source, 'Patient\'s injuries have been bandaged.')
		exports.globals:sendLocalActionMessage(_source, "gives bandage", 5.0, 3500)
		TriggerClientEvent("usa:playAnimation", _source, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 3)
	else
		TriggerClientEvent('injuries:bandageNearestPed', _source)
	end
end, {
	help = 'Bandage the nearest player\'s injuries',
	params = {
		{ name = "id", help = "id of person (omit to bandage nearest)" }
	}
})

TriggerEvent('es:addJobCommand', 'newrecord', {'ems', 'doctor'}, function(source, args, char)
	local targetSource = tonumber(args[2])
	local payment = math.ceil(tonumber(args[3]))
	if payment > 5000 then
		TriggerClientEvent('usa:notify', source, 'Payment too high!')
		return
	end
	table.remove(args, 1)
	table.remove(args, 1)
	table.remove(args, 1)
	local details = table.concat(args, " ")
	if not details or not GetPlayerName(targetSource) then return end
	local target = exports["usa-characters"]:GetCharacter(targetSource)
	local targetBank = target.get('bank')
	local targetName = target.getFullName()
	local targetDOB = target.get('dateOfBirth')
	local userName = char.getFullName()
	target.removeBank(payment)
	TriggerClientEvent('usa:notify', targetSource, 'You have been charged ~y~$' .. payment .. '~s~ in medical fees, payment processed from bank.')
	TriggerClientEvent('usa:notify', source, 'Medical record has been created!')
	PerformHttpRequest(WEBHOOK_URL, function(err, text, headers)
		if text then
			print(text)
		end
	end, "POST", json.encode({
		embeds = {
			{
				description = "**Patient Name:** " .. targetName .. "\n**Patient DOB:** " .. targetDOB .. "\n**Payment:** $" .. payment .."\n**Details:** \n⠀"..details.."\n**Signature:** "..userName.."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
				color = 263172,
				author = {
					name = "New Medical Record"
				}
			}
		}
	}), { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end, {
	help = 'Sign off a new field on a patient\'s record',
	params = {
		{ name = "id", help = "id of person" },
		{ name = "payment", help = "payment for treatment" },
		{ name = "details", help = "treatment notes and details"}
	}
})

RegisterServerEvent('injuries:validateCheckin')
AddEventHandler('injuries:validateCheckin', function(playerInjuries, isPedDead, x, y, z, isMale)
	local treatmentTimeMinutes = 2
	local doctors = exports["usa-characters"]:GetNumCharactersWithJob("doctor")
	if isPedDead and (exports["usa-characters"]:GetNumCharactersWithJob("ems") > 0 or exports["usa-characters"]:GetNumCharactersWithJob("sheriff") > 3 or doctors > 0) then
		TriggerClientEvent('usa:notify', source, 'See a doctor or call emergency services instead.')
		return
	end
	local char = exports["usa-characters"]:GetCharacter(source)
	local userBank = char.get('bank')
	if doctors > 1 then
		TriggerClientEvent('usa:showHelp', source, true, 'Please see any available doctor instead.')
	else
		local totalPrice = BASE_CHECKIN_PRICE
		for bone, injuries in pairs(playerInjuries) do
			for injury, data in pairs(playerInjuries[bone]) do
				if injuries[injury].dropEvidence == 1.0 then
					TriggerEvent('911:SuspiciousHospitalInjuries', char.getFullName(), x, y, z)
				end
				totalPrice = totalPrice + injuries[injury].treatmentPrice
				if injuries[injury].string == "High-speed Projectile" then 
					treatmentTimeMinutes = treatmentTimeMinutes + 3
				elseif injuries[injury].string == "Knife Puncture" then 
					treatmentTimeMinutes = treatmentTimeMinutes + 2
				elseif injuries[injury].string == "Explosion" then 
					treatmentTimeMinutes = treatmentTimeMinutes + 3
				elseif injuries[injury].string == "Large Sharp Object" then 
					treatmentTimeMinutes = treatmentTimeMinutes + 2
				end
			end
		end
		if treatmentTimeMinutes > 10 then
			treatmentTimeMinutes = 10
		end
		TriggerEvent('injuries:getHospitalBeds', function(hospitalBeds)
			for i = 1, #hospitalBeds do
				if hospitalBeds[i].occupied == nil then
					hospitalBeds[i].occupied = targetPlayerId
					bed = {
						heading = hospitalBeds[i].heading,
						coords = hospitalBeds[i].objCoords,
						model = hospitalBeds[i].objModel
					}
					TriggerClientEvent('ems:hospitalize', source, treatmentTimeMinutes, bed, i)
					break
				end
			end
		end)
		TriggerClientEvent("chatMessage", source, '^3^*[HOSPITAL] ^r^7You have been admitted to the hospital, please wait while you are treated.')
		TriggerClientEvent('chatMessage', source, 'The payment has been deducted from your bank balance.')
		print('INJURIES: '..PlayerName(source) .. ' has checked-in to hospital and was charged amount['..totalPrice..']')
		if char.get('job') ~= 'sheriff' then
			char.removeBank(totalPrice)
		end
	end
end)

RegisterServerEvent('injuries:sendLog')
AddEventHandler('injuries:sendLog', function(log, payment)
	local char = exports["usa-characters"]:GetCharacter(source)
	local userName = char.getFullName()
	local userDOB = char.get('dateOfBirth')
	PerformHttpRequest(WEBHOOK_URL, function(err, text, headers)
		if text then
			print(text)
		end
	end, "POST", json.encode({
		embeds = {
			{
				description = "**Patient Name:** " .. userName .. "\n**Patient DOB:** " .. userDOB .. "\n**Payment:** $" .. payment .."\n**Details:** "..log.."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
				color = 263172,
				author = {
					name = "New Medical Record"
				}
			}
		}
	}), { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end)

RegisterServerEvent('injuries:chargeForInjuries')
AddEventHandler('injuries:chargeForInjuries', function(playerInjuries, multiplier, respawn)
	local char = exports["usa-characters"]:GetCharacter(source)
	local totalPrice = BASE_CHECKIN_PRICE
	for bone, injuries in pairs(playerInjuries) do
		for injury, data in pairs(playerInjuries[bone]) do
			totalPrice = totalPrice + injuries[injury].treatmentPrice
		end
	end
	if type(multiplier) == 'number' then
		totalPrice = totalPrice * multiplier
	end
	local job = char.get("job")
	if job == "sheriff" or job == "corrections" or job == "ems" then
		char.removeBank(math.floor(totalPrice * 0.50))
	else 
		char.removeBank(totalPrice)
	end
	print('INJURIES: '..PlayerName(source) .. ' has been charged amount['..totalPrice..'] in bank for hospital fees!')
	if respawn then
		TriggerClientEvent('chatMessage', source, '^3^*[HOSPITAL] ^r^7You have been charged ^3$'..totalPrice..'^0 in hospital fees.')
		char.set('injuries', {})
		TriggerClientEvent('injuries:updateInjuries', source, {})
	end
	TriggerClientEvent('chatMessage', source, 'The payment has been deducted from your bank balance.')
end)

RegisterServerEvent('injuries:toggleOnDuty')
AddEventHandler('injuries:toggleOnDuty', function()
	local JOB_NAME = "doctor"
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("job") ~= 'doctor' then
		if char.get('emsRank') >= 4 then
			TriggerClientEvent('usa:notify', source, 'You are now signed ~g~on-duty~s~ as a doctor.')
			char.set('job', 'doctor')
			TriggerEvent('job:sendNewLog', source, JOB_NAME, true)
		else
			TriggerClientEvent('usa:notify', source, '~y~You are not whitelisted for DOCTOR')
		end
	else
		TriggerClientEvent('usa:notify', source, 'You are now signed ~y~off-duty~s~ as a doctor.')
		char.set('job', 'civ')
		TriggerEvent('job:sendNewLog', source, JOB_NAME, false)
	end
end)

RegisterServerEvent('injuries:getPlayerInjuries')
AddEventHandler('injuries:getPlayerInjuries', function(sourceToGetInjuriesFrom, sourceToReturnInjuries)
	TriggerClientEvent('injuries:returnInjuries', sourceToGetInjuriesFrom, sourceToReturnInjuries)
end)

RegisterServerEvent('injuries:inspectMyInjuries')
AddEventHandler('injuries:inspectMyInjuries', function(sourceToReturnInjuries, injuries, myPed)
	local char = exports["usa-characters"]:GetCharacter(source)
	local fullName = char.getFullName()
	TriggerEvent('display:shareDisplayBySource', sourceToReturnInjuries, 'inspects injuries', 4, 470, 10, 4000, true)
	TriggerClientEvent('injuries:displayInspectedInjuries', sourceToReturnInjuries, injuries, fullName, myPed)
end)

RegisterServerEvent('injuries:treatPlayer')
AddEventHandler('injuries:treatPlayer', function(sourceToTreat, boneToTreat)
	TriggerClientEvent('injuries:treatMyInjuries', sourceToTreat, boneToTreat, source)
end)

RegisterServerEvent('injuries:bandagePlayer')
AddEventHandler('injuries:bandagePlayer', function(sourceToBandage)
	if source then
		TriggerClientEvent('usa:notify', source, 'Patient\'s injuries have been bandaged.')
	end
	TriggerClientEvent('injuries:bandageMyInjuries', sourceToBandage)
end)

RegisterServerEvent('injuries:notify')
AddEventHandler('injuries:notify', function(sourceToNotify, message)
	TriggerClientEvent('usa:notify', sourceToNotify, message)
end)

RegisterServerEvent('injuries:saveData')
AddEventHandler('injuries:saveData', function(playerInjuries)
	local char = exports["usa-characters"]:GetCharacter(source)
	if char then
		char.set('injuries', playerInjuries)
	end
end)

RegisterServerEvent('injuries:requestData')
AddEventHandler('injuries:requestData', function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local playerInjuries = char.get('injuries')
	if playerInjuries then
		TriggerClientEvent('injuries:updateInjuries', source, playerInjuries)
	else
    TriggerClientEvent("injuries:removeInjuries", source)
  end
end)

TriggerEvent('es:addGroupCommand', 'heal', 'mod', function(source, args, char)
	local targetSource = tonumber(args[2])
	if tonumber(args[2]) and GetPlayerName(args[2]) then
		local target = exports["usa-characters"]:GetCharacter(targetSource)
		target.set('injuries', {})
		TriggerClientEvent('death:allowRevive', targetSource)
		Citizen.Wait(100)
		TriggerClientEvent('injuries:updateInjuries', targetSource, {})
		TriggerClientEvent('usa:notify', source, 'Player has been healed.')
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(targetSource)..' ['..targetSource..'] ^0 has been healed by ^2'..GetPlayerName(source)..' ['..source..'] ^0.')
		TriggerClientEvent('chatMessage', targetSource, '^2^*[STAFF]^r^0 You have been healed by ^2'..GetPlayerName(source)..'^0.')
	end
end, {
	help = "Heal a player's injuries.",
	params = {
		{ name = "id", help = "id of person" }
	}
})

function PlayerName(source)
	return GetPlayerName(source)..'['..GetPlayerIdentifier(source)..']'
end
