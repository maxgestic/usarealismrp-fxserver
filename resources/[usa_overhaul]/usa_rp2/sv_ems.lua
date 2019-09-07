local hospitalBeds = {
	{
		occupied = nil,
		objCoords  = {347.115, -590.426, 43.304},
		objModel = 2117668672
	},
	{
		occupied = nil,
		objCoords  = {350.86, -591.58, 43.39},
		objModel = 2117668672
	},
	{
		occupied = nil,
		objCoords  = {354.3, -592.75, 43.30},
		objModel = 2117668672
	},
	{
		occupied = nil,
		objCoords  = {357.44, -594.3, 43.30},
		objModel = 2117668672
	},
	{
		occupied = nil,
		objCoords  = {360.42636108398, -587.05645751953, 44.016368865967},
		objModel = -1091386327
	},
	{
		occupied = nil,
		objCoords  = {356.66, -586.01, 43.30},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {353.177, -584.93, 43.30},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {344.83355712891, -580.99639892578, 44.01636505127},
		objModel = -1091386327
	},
	{
		occupied = nil,
		objCoords  = {334.05288696289, -578.28857421875, 44.0090675354},
		objModel = -1091386327
	},
	{
		occupied = nil,
		objCoords  = {327.04379272461, -576.23944091797, 44.021656036377},
		objModel = -1091386327
	},
	{
		occupied = nil,
		objCoords  = {323.80679321289,y = -575.15704345703, z = 44.021686553955},
		objModel = -1091386327
	}
}


RegisterServerEvent('ems:resetBed')
AddEventHandler('ems:resetBed', function()
	for i = 1, #hospitalBeds do
		if hospitalBeds[i].occupied == source then
			hospitalBeds[i].occupied = nil
		end
	end
end)

RegisterServerEvent('injuries:getHospitalBeds')
AddEventHandler('injuries:getHospitalBeds', function(callback)
	callback(hospitalBeds)
end)

RegisterServerEvent('ems:occupyBed')
AddEventHandler('ems:occupyBed', function(index)
	hospitalBeds[index].occupied = source
end)

AddEventHandler('playerDropped', function()
	for i = 1, #hospitalBeds do
		if hospitalBeds[i].occupied == source then
			print('source was hospitalized, left and now bed is being freed!')
			hospitalBeds[i].occupied = nil
		end
	end
end)

-- /admit [id] [time] [reason]
TriggerEvent('es:addJobCommand', 'admit', { "ems", "fire", "police", "sheriff", "corrections", "doctor" }, function(source, args, char)
	local targetPlayerId = tonumber(args[2])
	local bed = nil
	table.remove(args, 1)
	table.remove(args, 1)
	local reasonForAdmission = table.concat(args, " ")
	if not reasonForAdmission or not GetPlayerName(targetPlayerId) then return end
	print("USARRP2: "..GetPlayerName(source)..'['..GetPlayerIdentifier(source)..'] has admitted '..GetPlayerName(targetPlayerId)..'['..GetPlayerIdentifier(targetPlayerId)..'] to hospital with reason['..reasonForAdmission..']')
	for i = 1, #hospitalBeds do
		if hospitalBeds[i].occupied == nil then
			hospitalBeds[i].occupied = targetPlayerId
			bed = {
				heading = hospitalBeds[i].heading,
				coords = hospitalBeds[i].objCoords,
				model = hospitalBeds[i].objModel
			}
			break
		end
	end
	-- get player's character name:
	local target_player = exports["usa-characters"]:GetCharacter(targetPlayerId)
	TriggerClientEvent("ems:admitMe", targetPlayerId, bed, reasonForAdmission)
	TriggerClientEvent('usa:notify', source, 'Person has been hospitalized.')
	--send to discord #ems-logs
	local url = 'https://discordapp.com/api/webhooks/618095236211802113/IaUzzsbJWD97IHModohSjbruGjOz6eBQ-xRrRTwcYhbdbG9MqEiL4SRuiCHPH_R6OXrH'
	PerformHttpRequest(url, function(err, text, headers)
		if text then
			print(text)
		end
	end, "POST", json.encode({
		embeds = {
			{
				description = "**Patient:** " .. target_player.getFullName() .. "\n**Details:** " .. reasonForAdmission .. "\n**Responder:** " .. char.getFullName() .."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
				color = 263172,
				author = {
					name = "Pillbox Medical Records"
				}
			}
		}
	}), { ["Content-Type"] = 'application/json' })
end, {
	help = "Admit someone to the hospital",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "reason", help = "Reason" }
	}
})

TriggerEvent('es:addCommand', 'bed', function(source, args, char)
	TriggerClientEvent('ems:getNearestBedIndex', source, hospitalBeds)
end, {
	help = "Enter a hospital bed",
})
