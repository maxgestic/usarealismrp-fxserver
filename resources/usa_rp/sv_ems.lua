-- /admit [id] [time] [reason]
TriggerEvent('es:addJobCommand', 'admit', { "ems", "fire", "police", "sheriff" }, function(source, args, user)
	local userSource = tonumber(source)
	local targetPlayerId = tonumber(args[2])
	local targetPlayerAdmissionTime = tonumber(args[3])
	table.remove(args, 1)
	table.remove(args, 1)
	table.remove(args, 1)
	local reasonForAdmission = table.concat(args, " ")
	if not targetPlayerAdmissionTime or not reasonForAdmission or not GetPlayerName(targetPlayerId) then return end
	print("admitting patient to hospital!")
	TriggerClientEvent("ems:admitPatient", targetPlayerId)
	TriggerClientEvent("ems:notifyHospitalized", targetPlayerId, targetPlayerAdmissionTime, reasonForAdmission)
	TriggerClientEvent("ems:notifyHospitalized", userSource, targetPlayerAdmissionTime, reasonForAdmission)
	SetTimeout(targetPlayerAdmissionTime*60000, function()
		TriggerClientEvent("ems:releasePatient", targetPlayerId)
	end)
	-- get player's character name:
	local target_player = exports["essentialmode"]:getPlayerFromId(targetPlayerId)
	-- send to discord #ems-logs
	local url = 'https://discordapp.com/api/webhooks/375425187014770699/i6quT1ZKnFoZgOC4rSpudTc2ucmvfXuAUQJXqDI0oeKoeqLGX0etu-GGMpIKbKuAqk70'
	PerformHttpRequest(url, function(err, text, headers)
		if text then
			print(text)
		end
	end, "POST", json.encode({
		embeds = {
			{
				description = "**Name:** " .. target_player.getActiveCharacterData("fullName") .. " \n**Time:** " .. targetPlayerAdmissionTime .. " hour(s)" .. " \n**Reason:** " .. reasonForAdmission .. "\n**Responder:** " .. user.getActiveCharacterData("fullName") .."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
				color = 263172,
				author = {
					name = "Pillbox Medical"
				}
			}
		}
	}), { ["Content-Type"] = 'application/json' })
end, {
	help = "Admit someone to the hospital",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "time", help = "Time in Minutes" },
		{ name = "reason", help = "Reason" },
	}
})

RegisterServerEvent("ems:checkPlayerMoney")
AddEventHandler("ems:checkPlayerMoney", function()
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user then
			if user.getActiveCharacterData("money") >= 500 then
				local user_money = user.getActiveCharacterData("money")
				user.setActiveCharacterData("money", user_money - 500)
				TriggerClientEvent("ems:healPlayer", userSource)
			end
		end
	end)
end)

--------------------------------------
-- inspect a downed player's wounds --
--------------------------------------
TriggerEvent('es:addJobCommand', 'inspect', { "ems", "fire", "police", "sheriff" }, function(source, args, user)
	if type(tonumber(args[2])) == "number" then
		TriggerClientEvent("EMS:inspect", tonumber(args[2]), source)
	end
end, {
	help = "Inspect a player's wounds",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

RegisterServerEvent("EMS:notifyResponderOfInjuries")
AddEventHandler("EMS:notifyResponderOfInjuries", function(responder_id, killer_entity_type, damage_type, death_cause)
	---------------
	-- variables --
	---------------
	local weapon_type = "undefined"
	local message = ""
	-------------------------------------------------------
	-- check for injuries caused by a vehicle or weapon  --
	-------------------------------------------------------
	if tonumber(killer_entity_type) == 2 then
		--message = message .. "Person has " .. injuries.vehicle[math.random(#injuries.vehicle)] .. " from blunt force trauma."\
		message = RandomInjuryMessage("vehicle")
	else
		if (damage_type == 0 or damage_type == 1) and not injured_by_vehicle then
			weapon_type = "unknown"
		elseif damage_type == 2 then -- melee 
			-- check melee weapon type:
			weapon_type = GetMeleeWeaponType(death_cause)
		elseif damage_type == 3 then -- bullet
			weapon_type = "bullet"
		elseif damage_type == 4 or damage_type == 8 then -- force ragdoll fall ?
			weapon_type = "fall"
		elseif damage_type == 5 then -- explosive 
			weapon_type = "explosion"
		elseif damage_type == 6 then 
			weapon_type = "fire"
		elseif damage_type == 13 then 
			weapon_type = "gas"
		end
		message = RandomInjuryMessage(weapon_type)
	end
	TriggerClientEvent("usa:notify", responder_id, message)
	TriggerClientEvent("chatMessage", responder_id, "", {255, 255, 255}, message)
end)

function RandomInjuryMessage(wep_type)
	local message = nil
	local injuries = {
		vehicle = {
			"broken bone(s) and cuts",
			"lacerations and scrapes",
			"burn marks and road rash"
		},
		fist = {
			"a small bruise and a cut on their face",
			"red marks and a cut"
		},
		blunt_object = {
			"a large bruise and is bleeding",
			"a broken bone",
			"a bleeding cranium",
			"large red marks and some blood"
		},
		knife = {
			"a large cut",
			"a deep cut",
			"a few small lacerations",
			"a stab wound"
		}
	}
	if wep_type == "vehicle" then
		message = "Person has " .. injuries.vehicle[math.random(#injuries.vehicle)] .. " from blunt force trauma."
	elseif wep_type == "fist" then
		message = "Person has " .. injuries.fist[math.random(#injuries.fist)] .. " from blunt force trauma."
	elseif wep_type == "blunt_object" then
		message = "Person has " .. injuries.blunt_object[math.random(#injuries.blunt_object)] .. " from blunt force trauma."
	elseif wep_type == "knife" then
		message = "Person has " .. injuries.knife[math.random(#injuries.knife)] .. " from a sharp object."
	elseif wep_type == "bullet" then
		message = "Person is bleeding from a gunshot wound."
	elseif wep_type == "fall" then 
		message = "Person has an injury from falling."
	elseif wep_type == "explosion" then 
		message = "Person has extremely severe 3rd degree burns all over their body from an explosion."
	elseif wep_type == "fire" then 
		message = "Person has severe burns from a fire."
	elseif wep_type == "gas" then
		message = "Person has been incapacitated by non-lethal gas."
	elseif wep_type == "unknown" then
		message = "Person has unknown injuries."
	end
	return message
end

function GetMeleeWeaponType(hash)
	if hash == -1569615261 then return "fist"
	elseif hash == -656458692 then return "fist" -- brass knuckles
	elseif hash == -1716189206 then return "knife" -- knife
	elseif hash == -1834847097 then return "knife" -- dagger
	elseif hash == -102973651 then return "knife" -- hatchet
	elseif hash == -581044007 then return "knife" -- machete
	elseif hash == -538741184 then return "knife" -- swtichblade
	elseif hash == 419712736 then return "knife" -- wrench
	elseif hash == 1737195953 then return "blunt_object" -- nightstick
	elseif hash == 1317494643 then return "blunt_object" -- hammer
	elseif hash == -1786099057 then return "blunt_object" -- bat
	elseif hash == -2067956739 then return "blunt_object" -- crowbar
	elseif hash == 1141786504 then return "blunt_object" -- golfclub
	elseif hash == -1951375401 then return "blunt_object" -- flashlight
	elseif hash == 419712736 then return "blunt_object" -- wrench
	end
end

-- maybe use GetEntityType(...) to see if it was a vehicle? not sure if it detects weapons
--[[
	Returns:
	0 = no entity
	1 = ped
	2 = vehicle
	3 = object
]]
--[[
    GetWeaponDamageType() return values:
    0=unknown (or incorrect weaponHash)
    1= no damage (flare,snowball, petrolcan)
    2=melee
    3=bullet
    4=force ragdoll fall
    5=explosive (RPG, Railgun, grenade)
    6=fire(molotov)
    8=fall(WEAPON_HELI_CRASH)
    10=electric
    11=barbed wire
    12=extinguisher
    13=gas
    14=water cannon(WEAPON_HIT_BY_WATER_CANNON)
]]

--TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, message)