local stores = {
	["paleto_tattoo"] = {
		position = { ['x'] = -292.211, ['y'] = 6200.350, ['z'] = 31.487 },
		reward = 3400,
		nameofstore = "Tattoo Shop (Dulouz Ave. & Paleto Blvd.)",
		lastrobbed = 0
	},
	["paleto_barber"] = {
		position = { ['x'] = -277.842, ['y'] = 6230.185, ['z'] = 31.696 },
		reward = 2500,
		nameofstore = "Herr Kutz Barbershop (Dulouz Ave. & Paleto Blvd.)",
		lastrobbed = 0
	},
	["paleto_twentyfourseven"] = {
		position = { ['x'] = 1728.77, ['y'] = 6417.61, ['z'] = 35.0372161865234 },
		reward = 5000,
		nameofstore = "24/7 (Paleto Bay)",
		lastrobbed = 0
	},
	["sandyshores_tattoo"] = {
		position = { ['x'] = 1862.851, ['y'] = 3748.209, ['z'] = 33.0 },
		reward = 3500,
		nameofstore = "Tattoo Shop (Sandy Shores)",
		lastrobbed = 0
	},
	["sandyshores_barber"] = {
		position = { ['x'] = 1930.556, ['y'] = 3728.216, ['z'] = 32.8 },
		reward = 3500,
		nameofstore = "O'Sheas Barber Shop (Alhambra Dr. & Niland Ave.)",
		lastrobbed = 0
	},
	["sandyshores_twentyfourseven"] = {
		position = { ['x'] = 1959.772, ['y'] = 3740.07, ['z'] = 32.344 },
		reward = 5000,
		nameofstore = "24/7 (Sandy Shores)",
		lastrobbed = 0
	},
	["bar_one"] = {
		position = { ['x'] = 1986.1240234375, ['y'] = 3053.8747558594, ['z'] = 47.215171813965 },
		reward = 5000,
		nameofstore = "Yellow Jack. (Sandy Shores)",
		lastrobbed = 0
	},
	["harmony_twentyfourseven"] = {
		position = { ['x'] = 549.563, ['y'] = 2669.187, ['z'] = 42.157 },
		reward = 2500,
		nameofstore = "24/7 (Route 68, Harmony)",
		lastrobbed = 0
	}
	--[[
	["littleseoul_twentyfourseven"] = {
		position = { ['x'] = -709.17022705078, ['y'] = -904.21722412109, ['z'] = 19.215591430664 },
		reward = 5000,
		nameofstore = "24/7 (Little Seoul)",
		lastrobbed = 0
	},
	-- custom
	["innocence_twentyfourseven"] = {
		position = { ['x'] = 30.1535, ['y'] = -1339.85, ['z'] = 29.497 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (Innocence Blvd)",
		lastrobbed = 0
	},
	["grove_twentyfourseven"] = {
		position = { ['x'] = -43.0506, ['y'] = -1749.41, ['z'] = 29.421 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (Grove St.)",
		lastrobbed = 0
	},
	["mirrorParkVespucci_twentyfourseven"] = {
		position = { ['x'] = 1130.58, ['y'] = -982.055, ['z'] = 46.4158 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (Mirror Park & Vespucci)",
		lastrobbed = 0
	},
	["sanAndreasBayCity_twentyfourseven"] = {
		position = { ['x'] = -1221.14, ['y'] = -912.147, ['z'] = 12.3263 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (San Andreas Ave. & Bay City Ave.)",
		lastrobbed = 0
	},
	["prosperityBlvdDelPerro_twentyfourseven"] = {
		position = { ['x'] = -1482.62, ['y'] = -376.534, ['z'] = 40.1634 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (Prosperity St. & Blvd Del Perro)",
		lastrobbed = 0
	},
	["clintonAve_twentyfourseven"] = {
		position = { ['x'] = 373.058, ['y'] = 329.096, ['z'] = 103.566 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (Clinton Ave.)",
		lastrobbed = 0
	}
	--]]
}

local robbers = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('es_holdup:toofar')
AddEventHandler('es_holdup:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. stores[robb].nameofstore)
	end
end)

RegisterServerEvent('es_holdup:rob')
AddEventHandler('es_holdup:rob', function(robb)
	if stores[robb] then
		local store = stores[robb]
		local robberyCooldown = 2100

		if (os.time() - store.lastrobbed) < robberyCooldown and store.lastrobbed ~= 0 then
			TriggerClientEvent('chatMessage', source, 'ROBBERY', {255, 0, 0}, "This has already been robbed recently. Please wait another: ^2" .. (1200 - (os.time() - store.lastrobbed)) .. "^0 seconds.")
			return
		end
		--TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery in progress at ^2" .. store.nameofstore)
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You started a robbery at: ^2" .. store.nameofstore .. "^0, do not get too far away from this point!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "The Alarm has been triggered!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Hold the fort for ^12 ^0minutes and the money is yours!")
		TriggerClientEvent('es_holdup:currentlyrobbing', source, robb)
		--sendMessageToEmsAndPolice("^1DISPATCH: ^0Robbery in progress at ^2" .. store.nameofstore)
		stores[robb].lastrobbed = os.time()
		robbers[source] = robb
		local savedSource = source
		SetTimeout(120000, function()
			if(robbers[savedSource])then
				TriggerClientEvent('es_holdup:robberycomplete', savedSource, job)
				TriggerEvent('es:getPlayerFromId', savedSource, function(target)
					if(target)then
						print("target existed...")
					--target:addDirty_Money(store.reward)
					print("adding stolen money amount of: " .. store.reward)
					local user_money = target.getActiveCharacterData("money")
					target.setActiveCharacterData("money", user_money  + store.reward)
					--TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery is over at: ^2" .. store.nameofstore)
					sendMessageToEmsAndPolice("^1DISPATCH: ^0Robbery is over at: ^2" .. store.nameofstore)
					end
				end)
			end
		end)
		sendMessageToEmsAndPolice("^1DISPATCH: ^0Robbery in progress at ^2" .. store.nameofstore)
	end
end)

function sendMessageToEmsAndPolice(msg)
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerJob = player.getActiveCharacterData("job")
					if playerJob == "sheriff" or playerJob == "police" or playerJob == "cop" or playerJob == "ems" then
						TriggerClientEvent("chatMessage", id, "", {}, msg)
					end
				end
			end
		end
	end)
end
